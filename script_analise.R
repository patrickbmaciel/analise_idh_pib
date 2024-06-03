# 0) Configurações iniciais -----------------------------------------------

# 0.1) Limpando R
rm(list = ls())
cat("\014")

# 0.2) Importando pacotes
library(dplyr)
library(ggplot2)
library(plotly)
library(geobr)
library(sf)
library(rnaturalearth)

# 0.3) Obtendo e tratando dados geoespaciais
states <- 
  geobr::read_state(year = 2020) %>%
  dplyr::select(uf = name_state, abbrev_state, geom) %>% 
  dplyr::mutate(uf = tolower(uf),
                uf = ifelse(uf=="amazônas", "amazonas", uf))

# 1) PIB ------------------------------------------------------------------

# Fonte: Os dados utilizados nesta seção foram coletados a partir da API do 
# Sidra IBGE, na tabela 5938 (Produto interno bruto a preços correntes),
# referentes ao ano de 2021, presente em https://sidra.ibge.gov.br/Tabela/5938

# 1.1) Inserindo código da base de dados
code_sidra <- "/t/5938/n3/all/v/37/p/last%201/d/v37%200"

# 1.2) Gerando dataframe com as informações
df_pib <- sidrar::get_sidra(api = code_sidra)

# 1.3) Tratando dataframe
df_pib_final <- 
  df_pib[c(7, 5)] %>% 
  dplyr::mutate(pib_bi = Valor / 10^6) %>% 
  dplyr::select(uf = "Unidade da Federação", pib_bi) %>% 
  dplyr::mutate(uf = tolower(uf))

# 1.3.1) Visualizando dados
df_pib_final %>% 
  dplyr::arrange(desc(pib_bi)) %>% 
  View()

# 1.4) Combinando dados geoespaciais com os de PIB
states_pib <- 
  states %>% 
  dplyr::left_join(df_pib_final, by = "uf")

# 1.5) Gerando gráfico geoespacial
ggplot() +
  geom_sf(data = states_pib, aes(fill = pib_bi), color = "black", size = 3) +
  labs(
    title = "PIB das UFs brasileiras em 2021",
    fill = "PIB em bilhões de R$",
    caption = "Fonte: Elaboração própria a partir de dados do IBGE"
  ) +
  geom_sf_text(data = states_pib, aes(label = abbrev_state), size = 3, color = "black", fontface = "bold") +
  scale_fill_distiller(palette = "YlGnBu", direction = 1, breaks = c(100, 1000, 2000)) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    legend.position = "right",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    axis.title = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank(),
    plot.caption = element_text(hjust = 0.5, size = 10)
  )

# 2) IDH ------------------------------------------------------------------

# Fonte: Os dados utilizados nesta seção foram coletados a partir da API do 
# Sidra IBGE, na tabela 5938 (Produto interno bruto a preços correntes),
# referentes ao ano de 2021, presente em 
# https://cidades.ibge.gov.br/brasil/sp/pesquisa/37/30255

# 2.1) Obtendo dados
df_idh <- read.csv("C:/Users/patri/OneDrive/documentos/projetos/analise_idh_pib/input_dados_idh.csv")

# 2.2) Tratando dados
df_idh_final <- 
  df_idh %>% 
  dplyr::select(uf = Localidade, idh = X2021) %>% 
  dplyr::mutate(uf = tolower(uf))

# 2.2.1) Visualizando dados
df_idh_final %>% 
  dplyr::arrange(desc(idh)) %>% 
  View()

# 2.3) Combinando dados geoespaciais com os de IDH
states_idh <- 
  states %>% 
  dplyr::left_join(df_idh_final, by = "uf")

# 2.4) Gerando gráfico geoespacial
ggplot() +
  geom_sf(data = states_idh, aes(fill = idh), color = "black", size = 3) +
  labs(
    title = "IDH das UFs brasileiras em 2021",
    fill = "IDH",
    caption = "Fonte: Elaboração própria a partir de dados do IBGE"
  ) +
  geom_sf_text(data = states_idh, aes(label = abbrev_state), size = 3, color = "black", fontface = "bold") +
  scale_fill_distiller(palette = "YlGnBu", direction = 1) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 18, face = "bold"),
    legend.position = "right",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    axis.title = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank(),
    plot.caption = element_text(hjust = 0.5, size = 10)
  )

# 3) PIB x IDH ------------------------------------------------------------

# 3.1) Combinando os dados de PIB e IDH
pib_idh <- 
  df_pib_final %>%
  dplyr::left_join(df_idh_final, by = "uf")

# 3.2) Gerando gráfico de dispersão
ggplot(pib_idh, aes(x = pib_bi, y = idh)) +
  geom_point(size = 4, color = "black", alpha = 0.9) +
  geom_smooth(method = "lm", color = "#0a747c", se = FALSE, linetype = "dashed", size = 1.5) +
  labs(
    title = "Correlação entre PIB e IDH das UFs brasileiras em 2021",
    x = "PIB (em bilhões de R$)",
    y = "IDH"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold", margin = margin(b = 10)),
    axis.title = element_text(size = 16),
    axis.text = element_text(size = 12),
    plot.caption = element_text(hjust = 0.5, size = 10),
    panel.grid.major = element_line(color = "grey", size = 0.5),
    panel.grid.minor = element_blank()
  ) +
  scale_x_continuous(labels = scales::comma) +
  scale_y_continuous(labels = scales::comma)
