#!/usr/bin/env nextflow

// Run calling module
process callFusionTranscriptsAR {
    publishDir "${params.output_dir}/${sampleName}", mode: 'copy'
    container "${params.container__arriba}"
    containerOptions "-e \"MHF_HOST_UID=\$(id -u)\" -e \"MHF_HOST_GID=\$(id -g)\" --name arriba-ftcall -v ${params.arriba_db}:/work/libs -v ${params.input_dir}:/work/data -v \$(pwd):/work/nf_work -v ${params.bin_dir}:/work/scripts"
    
    input:
        tuple val(sampleName), path(readFiles)

    output:
        tuple val(sampleName), path("${sampleName}_arr.tsv"), emit: arriba_fusion_tuple

    script:
    """
    echo "Path to input read file 1: ${readFiles[0]}"
    echo "Path to input read file 2: ${readFiles[1]}"
    if bash /work/scripts/arriba-nf.sh ${readFiles[0]} ${readFiles[1]} 16; then
        echo "Arriba has finished running on ${sampleName}. Copying main output file..."
        cp ${sampleName}-arriba-fusions.tsv ${sampleName}_arr.tsv
    fi
    """
}