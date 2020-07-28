library(readr)
library(dplyr)
library(tidyr)
library(tibble)

a <- read_csv("data/whole.csv") %>%
  select(-`Gene Accession Number`) %>%
  #rownames_to_column() %>%
  pivot_longer(-`Gene Description`,"patient", "value") %>%
  pivot_wider(patient, `Gene Description`) %>%
  drop_na()

b <- read_csv("data/datasets_1868_3249_actual.csv") %>%
  mutate(patient = as.character(patient)) %>%
  left_join(a, by = "patient")

b <- as.data.frame(b)
colnames(b)
df <- apply(b, 2, as.character)
df <- as.data.frame(df)

save(df, file = "final.rdata")
write_tsv(df, path = "data/final.tsv", quote_escape = FALSE)


haah <- read_csv("data/final.csv",col_types = NULL)
