process downloadFile {
    input:
    tuple val(fileName), val(bucketName)

    output:
    file data

    script:
    """
    oci os object get \
        -bn $bucketName \
        --auth instance_principal \
        --file data \
        --name $fileName
    """
}

process uploadFile {
    input:
    tuple val(fileName), val(bucketName)

    script:
    """
    oci os object put \
    -bn $bucketName \
    --auth instance_principal \
    --file $fileName
    """
}