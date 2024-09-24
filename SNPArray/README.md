## Make interval file from BED file

Requirements:  dictionary from reference genome (same hg version), i.e. Homo_sapiens.GRCh37.GATK.illumina.dict

```
cat {inputfile.bed} | grep -v track | awk '{OFS="\t" ;print $1,$2+1,$3,"+",$4}' |cat {reference genome dictionary} - > {outputfile.interval_list}
```
Note: in case of chr1 vs 1 issues include "| sed 's/^chr//g'"

Note: (manually) remove chromosome(s) in the header if not used in the original BED file
