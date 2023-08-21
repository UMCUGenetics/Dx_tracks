## Description how to made the tracks (from 14-09-2021).
_Track made before 14-0-2021: see validation studies at UMCU genome diagnostics if applicable_

### __14-09-2021. Addition of BAIT file for Agilent SureSelect v7 enrichment design elidS31285117.__

Requirements:
* Track files from Agilent SureSelect v7 elidS31285117, specifically the Covered.bed track. Files can be downloaded from the Agilent website.
* Dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict
* Picard software (tested v1.140 and above) 

```
grep -vE "browser|track" S31285117_Covered.bed | sed 's/^chr//g' | awk '{print $1,$2,$3,"SS_v7_S31285117"}' > S31285117_Covered_4kol_nochr.bed

java -jar -Xmx4G picard.jar BedToIntervalList I=S31285117_Covered_4kol_nochr.bed O=SureSelect_v7_elidS31285117_Covered.list SD=<path_to_reference_genome_dic> UNIQUE=true

rm S31285117_Covered_4kol_nochr.bed
```

### __14-09-2021. Addition of Agilent SureSelect v7 specific targets to the calling target.__

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

### __25-05-2023. Addition of Agilent SureSelect CREv4 specific targets to the calling target.__

Requirements:
* Original target BED file (i.e. ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed ).
* Track files from Agilent SureSelect CREv4 elidS34226467 specifically the Padded.ped track. Files can be downloaded from the Agilent website. Make sure padded file has 100bp extensions. In case of CREv4 this is 50bp, so target needs to be extended.
* Dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict
* Image of Bedtools software (tested v2.25.0)
* Image of Picard software (tested v1.140 and above)

```
# Extend padded flanks to 100bp and merge overlapping targets. Fix negative values and longer than MT length.
# In addition extra regions have been included as requested by BvZ: file additional_regions.bed

grep -vE "^browser|^track" S34226467_Padded.bed | sed 's/^chr//g' | sed 's/^M/MT/g' | awk '{OFS ="\t"; print $1,$2-50,$3+50}' | awk '{OFS="\t"; if ($2 < 0) print $1, 0, $3 ; else print $0}' |awk '{OFS="\t"; if ($1 == "MT" && $3> 16569) print $1,$2,16569; else print $0}'  | sort -k 1V -k 2n -k 3n > S34226467_Padded_100bp.bed
singularity run -B /hpc/:/hpc/ -B $TMPDIR:$TMPDIR /hpc/diaggen/software/singularity_cache/quay.io-biocontainers-bedtools-2.25.0--he860b03_5.img
bedtools merge -i S34226467_Padded_100bp.bed | awk '{OFS ="\t"; print $1,$2,$3,"+","crev4_target","crev4_target","crev4_target"}' > S34226467_Padded_100bp_5kol.bed 
bedtools subtract -a S34226467_Padded_100bp_5kol.bed -b ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed > S34226467_Padded_unique.bed
exit

cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_100bpflank.bed S34226467_Padded_unique.bed |sed 's/^MT/Z/g'| sort -k1,1V -nk2 -nk3 | sed 's/^Z/MT/g' > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_100bpflank.bed

cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_100bpflank.bed additional_regions.bed | sed 's/^MT/Z/g'| sort -k1,1V -nk2 -nk3 | sed 's/^Z/MT/g' > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_add_100bpflank.bed



cat ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_add_100bpflank.bed | cut -f1,2,3,5 > ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_add_100bpflank_tmp.bed

singularity run -B /hpc/:/hpc/ -B $TMPDIR:$TMPDIR /hpc/diaggen/software/singularity_cache/quay.io-biocontainers-picard-3.0.0--hdfd78af_1.img
picard -Xmx4G  BedToIntervalList I=ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_add_100bpflank_tmp.bed O=ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_add_100bpflank.interval_list UNIQUE=true  SD=/hpc/diaggen/data/databases/ref_genomes/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.dict
exit

rm S34226467_Padded.bed S34226467_Padded_unique.bed S34226467_Padded_100bp_5kol.bed S34226467_Padded_100bp.bed ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_add_100bpflank_tmp.bed ENSEMBL_UCSC_merged_collapsed_sorted_v3_CREv2_SSv7_CREv4_100bpflank.bed
```

