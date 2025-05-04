# Photon Desk

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
  - **Potência radiante (W)**
  - **PPF / PF (μmol/s)**
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
- Conversões em tempo real na seção **Light Conversion**.
- Conversões baseadas em área na seção **Light Conversion per Area**.

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

## 📊 Exatidão

Os cálculos do Photon Desk foram comparados com relatórios de medições feitos por esferas integradoras profissionais. Os resultados obtidos mostram **boa concordância**, garantindo confiança nas análises feitas a partir dos dados espectrais.

---

## 🎞 Demonstração

Um GIF demonstrativo (em breve) mostrará a usabilidade do app: desde a escolha do espectro até o cálculo e visualização das métricas.

---

## 🛠 Instalação

Para usar o aplicativo:

1. Instale o **MATLAB Runtime** (disponível gratuitamente no site da MathWorks).
2. Baixe o instalador do aplicativo (disponível na seção de releases).
3. Siga as instruções de instalação. O runtime será instalado automaticamente, se necessário.

---

## 🚧 Melhorias Futuras

- Adicionar mais espectros à pasta `sample_spectra`, com anotações detalhadas.
- Migrar o app para **Python + PyQt** para ampliar compatibilidade e distribuição.
- Desenvolver uma ferramenta de **Inteligência Artificial** para extrair dados espectrais a partir de **imagens** (OCR + extração automática de curvas).

---

## 📜 Licença

Este projeto está sob a licença MIT. Consulte o arquivo `LICENSE` para mais informações.
