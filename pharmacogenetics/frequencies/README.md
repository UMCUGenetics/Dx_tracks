# Frequencies

Pharmacogenomic frequency assets to perform quality control on structural variants on pharmacogenes.

The following files are available

- CYP2D6.csv - Contains structural variant calls on samples from the 1kgp 
- CYP2D6_freqs.csv - Contains structural variant frequencies based on the SV calls on 1kgp samples


Frequencies were calculated as follows:

``` R
library(dplyr)

Calc_frequencies <- function(SV_file, gene) {
  data <- read.csv(SV_file)

  data |>
    group_by_at(gene) |>
    summarise(Count = n()) |>
    mutate(Freq = Count/n()) |>
    write.csv2(
      paste0(gene,"_freqs.csv"), 
      row.names=F, 
      quote=F
    )

}

Calc_frequencies("CYP2D6.csv", "CYP2D6")

```




