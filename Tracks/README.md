## README including tracks made from 14-09-2021. For previous tracks see validtion studies at UMCU genome diagnostics if applicable


## 14-09-2021. Addition of BAIT file for Agilent SureSelect v7 enrichment design elidS31285117.

Requirements:\
Track files from Agilent SureSelect v7 elidS31285117, specifically the Coverd.bed track. Files can be downloaded from the Agilent website.\
Dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict

```
cat S31285117_Covered.bed |grep -v browser |grep -v track | sed 's/^chr//g' | awk '{OFS ="\t"; print $1,$2+1,$3,"+","SS_v7_S31285117"}' > S31285117_Covered_nochr_5kol.list
cat {reference genome dictionairy} S31285117_Covered_nochr_5kol.list > SureSelect_v7_elidS31285117_Covered.list
rm S31285117_Covered_nochr_5kol.list
```

## 14-09-2021. Addition of Agilent SureSelect v7 specific targets to the calling target.

Requirements:\
Original target BED file (i.e. ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_100bpflank.bed ).\
Track files from Agilent SureSelect v7 elidS31285117 specifically the Padded.ped track. Files can be downloaded from the Agilent website.\
Dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict

```
cat S31285117_Padded.bed | grep -v track |grep -v browser |sed 's/^chr//g' | awk '{OFS="\t"; print $1,$2,$3,"+", "ssv7_target","ssv7_target","ssv7_target"}' > S31285117_Padded_nochr.bed
bedtools subtract -a S31285117_Padded_nochr.bed -b ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_100bpflank.bed > S31285117_Padded_nochr_unique.bed
cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_100bpflank.bed S31285117_Padded_nochr_unique.bed | sed 's/^MT/YYYYYYYY/g'| sort -k1,1V -nk2 -nk3 | sed 's/^YYYYYYYY/MT/g'  > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed
cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed |awk '{OFS="\t" ; print $1,$2+1,$3,$4,$5}' > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank_1based.bed
cat /hpc/diaggen/data/databases/ref_genomes/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.dict ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank_1based.bed > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.interval_list

rm S31285117_Padded_nochr.bed
rm S31285117_Padded_nochr_unique.bed
rm ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank_1based.bed
```

