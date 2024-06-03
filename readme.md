# Análise do PIB e IDH das UFs Brasileiras

## Introdução

Este repositório contém códigos em R para gerar mapas e gráficos relacionados ao Produto Interno Bruto (PIB) e ao Índice de Desenvolvimento Humano (IDH) das Unidades Federativas (UFs) brasileiras.

## Scripts

### script_analise

O código inicia com algumas configurações iniciais, como a limpeza do ambiente de trabalho e a importação de pacotes necessários. Além disso, é importado e tratado dados geoespaciais.

Os dados do PIB são obtidos da API do Sidra IBGE e tratados para gerar um mapa geoespacial do PIB por UF em 2021. O mapa mostra a distribuição do PIB em bilhões de reais e destaca as diferenças entre as UFs.

Já os dados do IDH são extraídos do site do IBGE e combinados com os dados geoespaciais para criar um mapa do IDH por UF em 2021. Esse mapa ilustra as disparidades no desenvolvimento humano entre as diferentes regiões do Brasil.

Por fim, o código apresenta um gráfico de dispersão que analisa a correlação entre o PIB e o IDH das UFs brasileiras em 2021. O gráfico mostra como essas duas variáveis econômicas estão relacionadas e fornece insights sobre as dinâmicas socioeconômicas do país.
