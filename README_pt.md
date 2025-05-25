# Photon Desk

![Photon Desk Cover](docs/logo_app_100.png)

**Photon Desk** é um aplicativo de análise e conversão de luz baseado no espectro fornecido. Ele permite importar espectros de diferentes fontes de luz, visualizar as curvas espectrais e obter métricas fotométricas, radiométricas e colorimétricas de forma automática e precisa.

## 📂 Estrutura do Projeto

O repositório está organizado em três pastas principais:

- `core/`: Código-fonte em MATLAB (`.m`) com as funções base, podendo ser executado manualmente.
- `app/`: Contém o arquivo `.mlapp` com o aplicativo gráfico desenvolvido no MATLAB App Designer.
- `sample_spectra/`: Conjunto de espectros amostrados de diferentes fontes de luz, coletados por meio de uma esfera integradora.

---

## 🧪 Funcionalidades

- Importação de arquivos `.txt`, `.csv` e `.mat` contendo dados espectrais.
- Geração de gráfico do espectro normalizado.
- Cálculo automático de:
  - **Fluxo luminoso (lm)**
  - **FWHM (largura espectral a meia altura)**
  - **CCT (temperatura de cor correlata)**
  - **Coordenadas cromáticas (x, y, u, u′, v, v′)**
  - **Relação RGB**
  - **Comprimento de onda dominante**
- Conversão entre unidades de luz (lm, W, PPF, PF)
- Conversão de luz por área (lux, PPFD, PFD)

---

## 🖼 Interface

A interface principal inclui:

- Seleção de arquivos individuais ou pastas com múltiplos espectros.
- Gráfico espectral com curvas de referência (olho humano, PAR).
- Seção **Spectral and Color Metrics** com as principais métricas de cor e qualidade da luz.
- Conversões de luz total erradia na seção **Light Conversion**.
- Conversões baseadas em área na seção **Light Conversion per Area**.

![GUI demonstrarion](docs/GUI_example.png)

---

## 📁 Formato dos Arquivos

O aplicativo aceita arquivos `.txt`, `.csv` ou `.mat` com **2 ou 3 colunas**. A primeira linha deve ser o cabeçalho indicando as variáveis.

**Requisitos mínimos**:
- Primeira coluna: Comprimento de onda (nm)
- Segunda coluna: SPD normalizado ou potência espectral
- Terceira coluna (opcional): Potência espectral **não normalizada** (W/nm ou mW/nm)

**Exemplos de cabeçalhos válidos**:

- `"Wavelength(nm)","SPD","Radiant Power(W/nm)"`
- `WL(nm)    SPD    Power(mW/nm)`

O aplicativo identifica se os dados estão em mW ou W com base no cabeçalho. Caso a unidade não esteja especificada, assume que os dados estão em Watts e exibe um aviso.

---

## 🎞 Demonstração

O GIF abaixo apresenta um exemplo de uso do Photon Desk:  
mostra a seleção de um arquivo espectral, a inserção de valores para conversão e o acionamento do botão de cálculo.  
Com isso, o app realiza a conversão de unidades fotométricas e exibe as métricas espectrais e cromáticas na interface.

![Demo](docs/demo.gif)

---

## 🛠 Instalação

Para usar o Photon Desk, siga os passos abaixo:

1. Acesse a seção de [Releases](https://github.com/GuilhermeRS11/PhotonDesk-App/releases) e baixe:
   - `PhotonDeskApp.exe`: instalador do aplicativo.
   - `sample_spectra.zip`: conjunto de espectros de exemplo (opcional).

2. Execute o arquivo `PhotonDeskApp.exe` com dois cliques.

3. O instalador fará todo o processo automaticamente, incluindo:
   - Baixar e instalar o **MATLAB Runtime** (caso você ainda não o tenha).
   - Instalar o aplicativo Photon Desk.

4. (Opcional) Extraia o conteúdo do arquivo `sample_spectra.zip` para utilizar os espectros de exemplo fornecidos. Eles podem ser carregados diretamente no app via a opção "Open Folder".

> ⚠️ O MATLAB Runtime é necessário para rodar o aplicativo, mas não requer uma licença do MATLAB.


---

## 📊 Exatidão

Os gráficos a seguir comparam os resultados obtidos pelo Photon Desk (à esquerda) com os relatórios gerados por uma esfera integradora profissional **Inventfine CMS-5000** (à direita).  

Essa comparação valida a precisão dos cálculos do aplicativo, evidenciando a **boa concordância** entre os valores extraídos via software e os obtidos por instrumentação de laboratório.

Além disso, as conversões entre unidades fotométricas, radiométricas e fotossintéticas (como **PPF** e **PPFD**) foram implementadas com base nas definições e fórmulas do artigo:

> [Photometry and Photosynthesis: From Photometry to PPFD (Revised)](https://www.researchgate.net/publication/284157299_Photometry_and_Photosynthesis_From_Photometry_to_PPFD_Revised)

Esse artigo serviu de referência técnica para garantir que os cálculos de equivalência entre luz visível e luz fotossintética sigam fundamentos científicos atualizados.

![Results comparison 1](docs/results_comparison_1.png)

![Results comparison 2](docs/results_comparison_2.png)

---

## 🚧 Melhorias Futuras

- Adicionar mais espectros à pasta `sample_spectra`, com anotações detalhadas.
- Migrar o app para **Python + PyQt** para ampliar compatibilidade e distribuição.
- Desenvolver uma ferramenta de **Inteligência Artificial** para extrair dados espectrais a partir de **imagens** (OCR + extração automática de curvas).

---

## 📜 Licença

Este projeto está sob a licença GPL-3.0. Consulte o arquivo `LICENSE` para mais informações.
