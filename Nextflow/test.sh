trimmomatic PE ERR6634978_1.fastq.gz ERR6634978_2.fastq.gz -baseout sample1.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36


nextflow run fastq2vcf.nf \
--single false \
--read1 /mnt/storage10/lwang/Projects/Nextflow/data/ERR6634978_1.fastq.gz \
--read2 /mnt/storage10/lwang/Projects/Nextflow/data/ERR6634978_2.fastq.gz \
--prefix 'ERR6634978' \
--ref /mnt/storage10/lwang/Projects/Nextflow/data/MTB-h37rv_asm19595v2-eg18.fa