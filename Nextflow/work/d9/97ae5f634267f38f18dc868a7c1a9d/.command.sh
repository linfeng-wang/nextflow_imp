#!/bin/bash -ue
if [ false == true ]; then
    trimmomatic SE -phred33 ERR6634978_1.fastq.gz -baseout ERR6634978.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
else
    trimmomatic PE -phred33 ERR6634978_1.fastq.gz ERR6634978_2.fastq.gz -baseout ERR6634978.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
fi
