#!/usr/bin/env nextflow
include {downloadFile} from './utils.nf'
include {processFile} from './utils.nf'
include {uploadFile} from './utils.nf'

params.bucket = "bucket-gds-team3"
params.file = "day02_result"

workflow {
    main:
        filePath1 = downloadFile(params.filePrefix1)
        filePath2 = downloadFile(params.filePrefix2)
        resultFile = processFile( tuple( filePath1, filePath2, params.file ))
        uploadFile(resultFile)
}