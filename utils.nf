process downloadFile {
    input:
    val filePrefix

    output:
    path(filePrefix)

    script:
    namespace=params.namespace
    bucketName=params.bucket
    """
    oci os object bulk-download \
        -bn $bucketName \
        -ns $namespace \
        --overwrite \
        --dest-dir ./ \
        --prefix $filePrefix
    """
}

process processFile {
    input:
    tuple val(fileIn1), val(fileIn2), val(fileOut)

    output:
    file fileOut

    script:
    """
    process_data.py $fileIn1 $fileIn2 $fileOut
    """
}

process uploadFile {
    input:
    val filePrefix

    script:
    namespace=params.namespace
    bucketName=params.bucket
    """
    oci os object bulk-upload \
        -bn $bucketName \
        -ns $namespace \
        --overwrite \
        --src-dir ./ \
        --prefix $filePrefix
    """
}