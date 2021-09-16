## README including tracks made from 14-09-2021. 
For previous tracks: see validation studies at UMCU genome diagnostics if applicable

#14-09-2021. Addition of BAIT file for Agilent SureSelect v7 enrichment design elidS31285117.

Requirements:
* Track files from Agilent SureSelect v7 elidS31285117, specifically the Covered.bed track. Files can be downloaded from the Agilent website.
* Dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict
* Picard software (tested v1.140 and above) 

```
grep -vE "browser|track" S31285117_Covered.bed | sed 's/^chr//g' | awk '{print $1,$2,$3,"SS_v7_S31285117"}' > S31285117_Covered_4kol_nochr.bed

java -jar -Xmx4G picard.jar BedToIntervalList I=S31285117_Covered_4kol_nochr.bed O=SureSelect_v7_elidS31285117_Covered.list SD=<path_to_reference_genome_dic> UNIQUE=true

rm S31285117_Covered_4kol_nochr.bed
```

#14-09-2021. Addition of Agilent SureSelect v7 specific targets to the calling target.

Requirements:
* Original target BED file (i.e. ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_100bpflank.bed ).
* Track files from Agilent SureSelect v7 elidS31285117 specifically the Padded.ped track. Files can be downloaded from the Agilent website.
* Dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict
* Bedtools software (tested v2.25.0) 
* Picard software (tested v1.140 and above)

```
grep -vE "browser|track" S31285117_Padded.bed | sed 's/^chr//g' | awk '{OFS ="\t"; print $1,$2,$3,"+","ssv7_target","ssv7_target","ssv7_target"}' > S31285117_Padded_nochr.bed

bedtools subtract -a S31285117_Padded_nochr.bed -b ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_100bpflank.bed > S31285117_Padded_nochr_unique.bed

cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_100bpflank.bed S31285117_Padded_nochr_unique.bed |sed 's/^MT/Z/g'| sort -k1,1V -nk2 -nk3 | sed 's/^Z/MT/g' > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed

cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed | cut -f1,2,3,5 > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank_tmp.bed

java -jar -Xmx4G picard.jar BedToIntervalList I=ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank_tmp.bed O=ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.interval_list SD=<path_to_reference_genome_dic> UNIQUE=true

rm S31285117_Padded_nochr.bed S31285117_Padded_nochr_unique.bed ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank_tmp.bed
```

