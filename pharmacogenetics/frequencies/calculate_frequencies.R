library(dplyr)

## This script calculates Structural variant frequencies based on 1kgp data.
## Currently only SVs of CYP2D6 are considered. The calculated frequencies are
## Used in DxNextflowPG as  quality control step.


Calc_frequencies <- function(gene) {
  data <- read.csv(paste0(gene,".csv"))

  data |>
    group_by_at(gene) |>
    summarise(Count = n()) |>
    mutate(Freq = Count/n()) |>
    write.csv2(paste0(gene,"_freqs.csv"), row.names = F, quote = F)

}

Calc_frequencies("CYP2D6")
