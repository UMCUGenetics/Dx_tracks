# RNA reference files
## gene bed
Used GTF2BED, Copyright (c) 2011 Erik Aronesty (erik@q32.com)
using perl v5.26.3

## refflat
```bash
singularity shell -B $TMPDIR:$TMPDIR -B /hpc:/hpc https://depot.galaxyproject.org/singularity/ucsc-gtftogenepred:357--1
gtfToGenePred -genePredExt -geneNameAsName2 -ignoreGroupsWithoutExons /hpc/diaggen/data/databases/ref_genomes/GRCh38_gencode_v22_CTAT_lib_Mar012021/GRCh38_gencode_v22_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/ref_annot.gtf /dev/stdout | awk 'BEGIN { OFS="\t"} {print $12, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10}' > /hpc/diaggen/data/databases/ref_genomes/GRCh38_gencode_v22_CTAT_lib_Mar012021/GRCh38_gencode_v22_CTAT_lib_Mar012021.ref_annot.gtf.refflat
```

## rRNA intervals
rRNA intervals are retreived from the RSeQC project.
> "We download these ribosome RNAs from UCSC table browser, we provide them here to facilitate users with NO WARRANTY in completeness."

https://sourceforge.net/projects/rseqc/files/BED/Human_Homo_sapiens/hg38_rRNA.bed.gz/download

> RSeQC: quality control of RNA-seq experiments
> _Bioinformatics_ 2012 Aug 15. doi: [10.1093/bioinformatics/bts356](https://dx.doi.org/10.1093/bioinformatics/bts356).

```bash
export NXF_JAVA_HOME="${git_clone_dir}/tools/java/jdk
singularity shell -B $TMPDIR:$TMPDIR -B /hpc:/hpc /hpc/diaggen/software/singularity_cache/broadinstitute-gatk-4.5.0.0.img

gatk CreateSequenceDictionary \
R=/hpc/diaggen/data/databases/ref_genomes/GRCh38_gencode_v22_CTAT_lib_Mar012021/GRCh38_gencode_v22_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir/ref_genome.fa \
O=/hpc/diaggen/data/databases/ref_genomes/GRCh38_gencode_v22_CTAT_lib_Mar012021/GRCh38_gencode_v22_CTAT_lib_Mar012021.ref_genome.dict
```
- Rename UCSC style to Genbank style; using https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/GCA_000001405.15_GRCh38_assembly_report+ucsc_names.txt
- Exclude all sites that are not included in the references, aka `ALT`, `random` and `chrUn`.

```bash
singularity shell -B $TMPDIR:$TMPDIR -B /hpc:/hpc /hpc/diaggen/software/singularity_cache/broadinstitute-gatk-4.5.0.0.img
gatk BedToIntervalList \
-I hg38_rRNA_genbank_removed_missing_dict.bed \
-O hg38_rRNA_genbank.interval_list \
-SD /hpc/diaggen/data/databases/ref_genomes/GRCh38_gencode_v22_CTAT_lib_Mar012021/GRCh38_gencode_v22_CTAT_lib_Mar012021.ref_genome.dict
```
