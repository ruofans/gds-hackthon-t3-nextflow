#!/usr/bin/env nextflow

params.bucket = "bucket-gds-team3"
params.file = "day02_result"

process downloadFile {
    input:
    val params.file
    val params.bucket

    output:
    file data

    script:
    """
    oci os object get \
        -bn ${params.bucket} \
        --auth instance_principal \
        --file data \
        --name ${params.file}
    """
}

process uploadFile {
    input:
    file data
    val params.bucket

    script:
    """
    oci os object put \
    -bn ${params.bucket} \
    --auth instance_principal \
    --file ${data} 
    """
}