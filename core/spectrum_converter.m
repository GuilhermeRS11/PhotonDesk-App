%% spectrum_converter.m
%
% Base code for light spectrum conversion.
% 
% Functionality:
% - Load a light spectrum file (.txt, .csv, or .mat)
% - Automatically adjust to spectrum limits and resolution
% - Interpolate if necessary to 1 nm step
% - Calculate PF (Photon Flux), PPF (Photosynthetic Photon Flux), Radiant Power
% - Calculate Luminous Flux (lm)
% - Calculate conversion ratios between physical quantities
% - Plot relevant curves for visual analysis
%
% Requirements:
% - Spectrum file must contain columns: Wavelength (nm), SPD (a.u.), Radiant Power (mW)

clc;
clear;
close all;

% USER INPUT
% -------------------------------------------------------------------------------------

% Force to project root if inside core/
currentFolder = pwd;
[~, folderName] = fileparts(currentFolder);

if strcmp(folderName, 'core')
    cd('..'); % Go up one level (to project root)
end

% Define the filename and path manually
filename = 'teste_grow.csv';
filepath = 'sample_spectra/';          

fullfile_path = fullfile(filepath, filename);

% LOAD DATA
% -------------------------------------------------------------------------------------

% Read file according to format
[~,~,ext] = fileparts(filename);

if strcmp(ext, '.txt')
    fileID = fopen(fullfile_path, 'r');
    fgetl(fileID); % Ignore header
    temp = textscan(fileID, '%f%f%f', 'Delimiter', '\t');
    fclose(fileID);
    WL = temp{1}';
    SPD = temp{2}';
    Wrad = temp{3}' / 1000; % Convert mW to W

elseif strcmp(ext, '.mat')
    data = load(fullfile_path);
    fields = fieldnames(data);
    SPD_mat = data.(fields{1});
    WL = SPD_mat(:,1)';
    SPD = SPD_mat(:,2)';
    % Note: Wrad not available in .mat by default here

elseif strcmp(ext, '.csv')
    data = readtable(fullfile_path, 'HeaderLines', 1);
    WL = data.Var1';
    SPD = data.Var2';
    Wrad = data.Var3';

else
    error('Unsupported file format. Please use .txt, .csv or .mat files.');
end

% Define initial and final wavelength limits
Wa = min(WL);
Wb = max(WL);

% Calculate mean step (delta lambda)
if length(WL) > 1
    delta_lambda = mean(diff(WL));
else
    delta_lambda = NaN;
end

fprintf('Loaded spectrum from %.1f nm to %.1f nm with an average step of %.2f nm.\n', Wa, Wb, delta_lambda);

% INTERPOLATE DATA TO 1 NM STEP (Optional)
% -------------------------------------------------------------------------------------

WL_interp = Wa:1:Wb;
SPD_interp = interp1(WL, SPD, WL_interp, 'linear', 0);

% DEFINE CIE 1978 PHOTOPIC CURVE
% -------------------------------------------------------------------------------------

CIE78 = [... % 420 elements
    0,0,0,0,0.0002,0.00039556,0.0008,0.0015457,0.0028,0.0046562,...
    0.0074,0.011779,0.0175,0.022678,0.0273,0.032584,0.0379,0.042391,0.0468,0.052122,...
    0.06,0.072942,0.09098,0.11284,0.13902,0.16987,0.20802,0.25808,0.323,0.4054,...
    0.503,0.60811,0.71,0.7951,0.862,0.91505,0.954,0.98004,0.99495,1.0,...
    0.995,0.97875,0.952,0.91558,0.87,0.81623,0.757,0.69483,0.631,0.56654,...
    0.503,0.44172,0.381,0.32052,0.265,0.21702,0.175,0.13812,0.107,0.081652,...
    0.061,0.044327,0.032,0.023454,0.017,0.011872,0.00821,0.0057723,0.004102,0.0029291,...
    0.002091,0.0014822,0.001047,0.00074015,0.00052,0.00036093,0.0002492,0.00017231,0.00012,8.462e-05,...
    6e-05,4.2446e-05,3e-05,2.121e-05,1.4989e-05,1.0584e-05,7.4656e-06,5.2592e-06,3.7028e-06,2.6076e-06,...
    1.8365e-06,1.295e-06,9.1092e-07,6.3564e-07];

WL78 = 360:5:825;

% Interpolate LEF for new wavelength grid
LEF = zeros(1,length(WL_interp));
for i = 1:length(WL_interp)
    LEF(i) = interp1(WL78, CIE78, WL_interp(i), 'linear', 0);
end

% Generate PAR curve
PAR_curve = zeros(size(WL_interp));
for i = 1:length(WL_interp)
    if WL_interp(i) >= 400 && WL_interp(i) <= 700
        PAR_curve(i) = 1;
    else
        PAR_curve(i) = 0;
    end
end

% PLOT SPECTRUM
% -------------------------------------------------------------------------------------

figure;
hold on;
plot(WL_interp, SPD_interp, 'b-', 'LineWidth', 2);       % Light SPD
plot(WL_interp, LEF, '--k', 'LineWidth', 1);            % Human Eye Photopic Curve
plot(WL_interp, PAR_curve, '--', 'Color', [0 0.7 0], 'LineWidth', 1);  % PAR curve
ylim([0 1.2]);
xlim([Wa Wb]);
legend('Light SPD', 'Human Eye Photopic Curve', 'PAR Curve');
xlabel('Wavelength (nm)');
ylabel('Relative Intensity / Arbitrary Units');
title('Normalized Spectrum');
grid on;
hold off;

% CALCULATIONS
% -------------------------------------------------------------------------------------

% Constant for photon flux calculation (u mol/s)
ConstPP = (1e-3) / (6.02214076e23 * 2.998e8 * 6.62607015e-34);

% Find indices for 400-700 nm range (photosynthetic range)
ind_inf = find(WL_interp >= 400, 1, 'first');
ind_sup = find(WL_interp <= 700, 1, 'last');

% Photon Flux (PF): considering all wavelengths
PF = sum(WL_interp .* SPD_interp) * ConstPP;

% Photosynthetic Photon Flux (PPF): considering 400-700nm range
PPF = sum(WL_interp(ind_inf:ind_sup) .* SPD_interp(ind_inf:ind_sup)) * ConstPP;

% Luminous Flux (lm)
FL = 683 * sum(SPD_interp .* LEF);

% Radiant Power (W)
RadiantPower = sum(SPD_interp);

% Relations
FL_PF = FL / PF;
FL_PPF = FL / PPF;
FL_Wrad = FL / RadiantPower;
Wrad_PPF = RadiantPower / PPF;
Wrad_PF = RadiantPower / PF;
PF_PPF = PF / PPF;

% DISPLAY RESULTS
% -------------------------------------------------------------------------------------

fprintf('RESULTS:\n');
fprintf('-------------------------------------\n');
fprintf('Photon Flux (PF): %.4f umol/s\n', PF);
fprintf('Photosynthetic Photon Flux (PPF): %.4f umol/s\n', PPF);
fprintf('Radiant Power: %.4f W\n', RadiantPower);
fprintf('Luminous Flux: %.2f lm\n', FL);
fprintf('\nCONVERSION RATIOS:\n');
fprintf('FL / PF: %.4f lm/(umol/s)\n', FL_PF);
fprintf('FL / PPF: %.4f lm/(umol/s)\n', FL_PPF);
fprintf('FL / Radiant Power: %.4f lm/W\n', FL_Wrad);
fprintf('Radiant Power / PPF: %.4f W/(umol/s)\n', Wrad_PPF);
fprintf('Radiant Power / PF: %.4f W/(umol/s)\n', Wrad_PF);
fprintf('PF / PPF: %.4f\n', PF_PPF);
