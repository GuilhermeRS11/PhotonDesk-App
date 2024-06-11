cla(app.UIAxes)
            [filename,path]=uigetfile({'*.txt;*.mat;*.csv'});
            app.NomedoarquivoEditField.Value = filename;
            figure(app.UIFigure);
            file = append(path,filename);
            
            WL = zeros(1, 420); % Valor 420 pontos com base na esfera do GEDRE que tem esse numero.
            SPD = WL;
            Wrad = WL;
            LEF = WL;
            
            % Limites de importação de SPD entre 

            % Verifica se o arquivo inserido é do tipo .txt, .csv ou .mat                       
            if strfind(filename,'txt') > 0
               
                file = fopen(file,'r');
                IgnorarLinha = fgetl(file);     
                
                i = 1;
                while ~feof(file)       % Le valores do arquivo e armazena no vetor SPD
                    
                    string_SPD = regexp(fgetl(file),'\t','split');  
                    WL(i) = str2double(string_SPD(1));
                    SPD(i) = str2double(string_SPD(2));
                    Wrad(i) = str2double(string_SPD(3))/1000;
                    i = i + 1;
                end
                
                fclose(file);
                
            elseif strfind(filename,'mat') > 0
                
                data = load(file);
                fn = fieldnames(data);
                SPD_mat = data.(fn{1});
                
                SPD = SPD_mat(:,2)';                    
                WL = SPD_mat(:,1)';
            
            else 
                display(file);
                data = readtable(file, 'HeaderLines', 1);

                WL = data.Var1';
                SPD = data.Var2';
                Wrad = data.Var3';
                                            
            end
                
            Wa = WL(1);
            Wb = WL(end);
            
            CIE78 = [0	0	0	0	0.000200000000000000	0.000395560000000000	0.000800000000000000	0.00154570000000000	0.00280000000000000	0.00465620000000000	0.00740000000000000	0.0117790000000000	0.0175000000000000	0.0226780000000000	0.0273000000000000	0.0325840000000000	0.0379000000000000	0.0423910000000000	0.0468000000000000	0.0521220000000000	0.0600000000000000	0.0729420000000000	0.0909800000000000	0.112840000000000	0.139020000000000	0.169870000000000	0.208020000000000	0.258080000000000	0.323000000000000	0.405400000000000	0.503000000000000	0.608110000000000	0.710000000000000	0.795100000000000	0.862000000000000	0.915050000000000	0.954000000000000	0.980040000000000	0.994950000000000	1	0.995000000000000	0.978750000000000	0.952000000000000	0.915580000000000	0.870000000000000	0.816230000000000	0.757000000000000	0.694830000000000	0.631000000000000	0.566540000000000	0.503000000000000	0.441720000000000	0.381000000000000	0.320520000000000	0.265000000000000	0.217020000000000	0.175000000000000	0.138120000000000	0.107000000000000	0.0816520000000000	0.0610000000000000	0.0443270000000000	0.0320000000000000	0.0234540000000000	0.0170000000000000	0.0118720000000000	0.00821000000000000	0.00577230000000000	0.00410200000000000	0.00292910000000000	0.00209100000000000	0.00148220000000000	0.00104700000000000	0.000740150000000000	0.000520000000000000	0.000360930000000000	0.000249200000000000	0.000172310000000000	0.000120000000000000	8.46200000000000e-05	6.00000000000000e-05	4.24460000000000e-05	3.00000000000000e-05	2.12100000000000e-05	1.49890000000000e-05	1.05840000000000e-05	7.46560000000000e-06	5.25920000000000e-06	3.70280000000000e-06	2.60760000000000e-06	1.83650000000000e-06	1.29500000000000e-06	9.10920000000000e-07	6.35640000000000e-07]';
            WL78 = [360	365	370	375	380	385	390	395	400	405	410	415	420	425	430	435	440	445	450	455	460	465	470	475	480	485	490	495	500	505	510	515	520	525	530	535	540	545	550	555	560	565	570	575	580	585	590	595	600	605	610	615	620	625	630	635	640	645	650	655	660	665	670	675	680	685	690	695	700	705	710	715	720	725	730	735	740	745	750	755	760	765	770	775	780	785	790	795	800	805	810	815	820	825]';
                
            for i = 1:length(WL)
    
                LEF(i) = interp1(WL78,CIE78,WL(i));
    
            end
                        
            VWdelta = LEF.*SPD; 
              
            hold(app.UIAxes,'on')
            plot(app.UIAxes,WL,SPD,'b','linew',2);
            plot(app.UIAxes,WL,LEF,'--k');
            plot(app.UIAxes,WL,VWdelta,'r');
            ylim(app.UIAxes,[0 1]);
            xlim(app.UIAxes,[Wa Wb]);
            legend(app.UIAxes,'SPD do LED','Curva fotópica do olho humano','Efeito da curva fotópica na SPD')
            hold(app.UIAxes,'off')
            
%              filter = {'*.jpg';'*.png'};
%              [filename,filepath] = uiputfile(filter);
%              dimencoesImg = [0, 0, 1000, 1000];
%              Img = getframe(app.UIAxes, dimencoesImg);
%              Img = Img.cdata;
%              imwrite(Img,append(filepath, filename),'Quality',100);
                                                         
            % Calcula PF, PPF, lm, Wrad e a relação entre as variaveis
            
            ConstPP = (1e-3)/(6.02214076e23*2.998e8*6.62607015e-34);
            ind_sup = 0;
            ind_inf = 0;
            
            % Encontra os indices dos valores mais próximos a 400nm e 700nm
            % a fim de calcular o PPF
            
            for i=1:length(WL)
                if(ge(WL(i),400))
                    ind_inf = i;
                    break
                end
            end
            for i=flip(1:length(WL))
                if(le(WL(i),700))
                    ind_sup = i;
                    break
                end
            end
            
            PF = (sum(WL.*(SPD)))*ConstPP; % [u mols/s]       
            % Photon Flux (levando em conta todos os comprimentos de onda disponíveis)
            PPF = (sum(WL(ind_inf:ind_sup).*(SPD(ind_inf:ind_sup))))*ConstPP; % [u mols/s] 
            % Photossintetic Photon Flux (leva em conta a faixa de 400 a 700 nm) 
            
            %FL = 683*(sum(SPD(ind_inf:ind_sup).*LEF(ind_inf:ind_sup)));
            FL = 683*(sum(SPD.*LEF));   % Calculo do fluxo usando toda o espectro ensaiado
            
            FL_PF = FL / PF;
            FL_PPF = FL / PPF;
            FL_Wrad = FL / sum(SPD);
            Wrad_PPF = sum(SPD) / PPF;
            Wrad_PF = sum(SPD) / PF;
            PF_PPF = PF / PPF;
            
            % Exporta as variáveis de saida para fora da função
            
            app.FL_PF_g = FL_PF;
            app.FL_PPF_g = FL_PPF;
            app.FL_Wrad_g = FL_Wrad;
            app.Wrad_PF_g = Wrad_PF;
            app.Wrad_PPF_g = Wrad_PPF;
            app.PF_PPF_g = PF_PPF;
            app.WL_aux= WL;
            app.SPD_aux = SPD;
            app.LEF_aux = LEF;
            app.VWdelta_aux = VWdelta;