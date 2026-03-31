public func main() : int {
    var input = std::string_view("Chemical is a modern systems programming language.")
    var src_size = input.size()
    var dst_capacity = zstd::ffi::ZSTD_compressBound(src_size)
    
    var compressed_buf = malloc(dst_capacity)
    var compressed_size = zstd::ffi::ZSTD_compress(compressed_buf, dst_capacity, input.data() as *void, src_size, 3)
    
    if (zstd::ffi::ZSTD_isError(compressed_size) != 0) {
        printf("Compression failed: %s\n", zstd::ffi::ZSTD_getErrorName(compressed_size))
        free(compressed_buf)
        return 1
    }

    printf("Original size: %d\n", src_size as int)
    printf("Compressed size: %d\n", compressed_size as int)

    var decompressed_buf = malloc(src_size + 1) as *mut char
    var decompressed_size = zstd::ffi::ZSTD_decompress(decompressed_buf, src_size, compressed_buf, compressed_size)
    
    if (zstd::ffi::ZSTD_isError(decompressed_size) != 0) {
        printf("Decompression failed\n")
        free(compressed_buf)
        free(decompressed_buf)
        return 1
    }
    
    decompressed_buf[src_size] = '\0'
    printf("Decompressed content: %s\n", decompressed_buf as *mut char)

    free(compressed_buf)
    free(decompressed_buf)
    printf("zstd Demo Success!\n")
    return 0
}
