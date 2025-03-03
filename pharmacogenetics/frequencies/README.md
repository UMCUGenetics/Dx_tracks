# Frequencies

Pharmacogenomic frequency assets to perform quality control on structural variants on pharmacogenes.

The following types of files are available

- {gene}.csv - These files contain structural variant calls on samples from 1kgp for each pharmacogene
- {gene}_freqs.csv - These files contain structural variant frequencies based on the SV calls on 1kgp samples
- calculate_frequencies.R - Simple script to turn {gene}.csv into {gene}_freqs.csv
