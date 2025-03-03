library(ggplot2)
library(dplyr)


Calc_frequencies <- function(gene) {
  data <- read.csv(paste0(gene,".csv"))

  data |>
    group_by_at(gene) |>
    summarise(Count = n()) |>
    mutate(Freq = Count/n()) |>
    write.csv2(paste0(gene,"_freqs.csv"), row.names = F, quote = F)

}


Calc_frequencies("CYP2D6")
Calc_frequencies("CYP2B6")
