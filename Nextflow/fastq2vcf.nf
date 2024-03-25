#!/usr/bin/env nextflow
params.single = false
params.read1 = ""
params.read2 = ""
params.prefix = "sample_name"

params.ref = ""
params.threads = 4
params.bqsr_vcf = ""
params.single_end = false
params.cram = false

// Define processes

process TrimReads {

    container 'biocontainers/trimmomatic:v0.38dfsg-1-deb_cv1'

    input:
        path read1
        path read2
        val prefix
    output:
        tuple path("${prefix}_1P.fastq"), path("${prefix}_2P.fastq")
    script:
    """
    if [ ${params.single} == true ]; then
        trimmomatic SE -phred33 $read1 -baseout ${prefix}.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
    else
        trimmomatic PE -phred33 $read1 $read2 -baseout ${prefix}.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
    fi
    """
}

// process MapReads {

//     container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1'

//     input:
//         path reads from trimmed_reads
//     output:
//         path "${params.prefix}.mkdup.bam" into mapped_reads
//     script:
//     """
//     bwa mem -t ${params.threads} -R "@RG\\tID:${params.prefix}\\tSM:${params.prefix}\\tPL:Illumina" ${params.ref} $reads \\
//         | samtools view -@ ${params.threads} -b - \\
//         | samtools fixmate -@ ${params.threads} -m - - \\
//         | samtools sort -@ ${params.threads} - \\
//         | samtools markdup -@ ${params.threads} - ${params.prefix}.mkdup.bam -
//     samtools index -@ ${params.threads} ${params.prefix}.mkdup.bam
//     """
// }

// /*
//  * Generate BAM index file
//  */
// process SAMTOOLS_INDEX {

//     container 'quay.io/biocontainers/samtools:1.19.2--h50ea8bc_1' 

//     input:
//         tuple val(id), path(input_bam)

//     output:
//         tuple val(id), path(input_bam), path("${input_bam}.bai")

//     """
//     samtools index '$input_bam'

//     """


// process VariantCalling {

//     container: 

//     input:
//         path bam from mapped_reads
//     output:
//         path "${params.prefix}.g.vcf.gz" into variants
//     script:
//     """
//     gatk HaplotypeCaller -I $bam -R ${params.ref} -O ${params.prefix}.g.vcf.gz -ERC GVCF
//     """
// }

// process ValidateVariants {
//     input:
//         path vcf from variants
//     output:
//         path "${params.prefix}.g.vcf.gz.validated" into validated_variants
//     script:
//     """
//     gatk ValidateVariants -V $vcf -gvcf -R ${params.ref}
//     """
// }

// // Optional: Process for converting BAM to CRAM
// process ConvertToCRAM {
//     input:
//         path bam from mapped_reads.collect()
//     output:
//         path "${params.prefix}.cram" into cram_files
//     script:
//     """
//     samtools view -@ ${params.threads} -C -o ${params.prefix}.cram -T ${params.ref} $bam
//     samtools index ${params.prefix}.cram
//     """
// }

// Optionally define other processes here...

// Workflow definition
workflow {
    read1 = Channel.of(params.read1)
    read2 = Channel.of(params.read2)
    prefix = Channel.of(params.prefix)
    ref = Channel.of(params.ref)
    threads = Channel.of(params.threads)
    bqsr_vcf = Channel.of(params.bqsr_vcf)
    single_end = Channel.of(params.single_end)
    cram = Channel.of(params.cram)

    TrimReads(read1, read2, prefix)

    // if (params.single_end) {
    //     // Adjust for single-end reads
    // } else {
    //     TrimReads(read1, read2)
    // }


    // MapReads(trimmed_reads)
    // VariantCalling(mapped_reads)
    // ValidateVariants(variants)
    // if (params.cram) {
    //     ConvertToCRAM(mapped_reads)
    }


// params.read1 = ""
// params.read2 = ""
// params.prefix = ""
// params.ref = ""
// params.threads = 4
// params.bqsr_vcf = ""
// params.single_end = false
// params.cram = false