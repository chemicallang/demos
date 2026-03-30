using namespace miniz;

public func main() : int {
    var text = "miniz binding smoke test for Chemical";
    var text_len = strlen(text) as mz_ulong;
    var compressed_cap = compress_bound(text_len);

    var compressed = std::vector<u8>();
    compressed.reserve(compressed_cap as size_t);

    var compressed_len = compressed_cap;
    var rc = compress_memory(compressed.data() as *mut u8, &mut compressed_len, text as *u8, text_len, CompressionLevel.DEFAULT);
    if(!is_ok(rc)) {
        printf("compress failed: %s (%d)\n", error_string(rc).data(), rc);
        return 1;
    }

    var restored : [256]u8;
    var restored_len = 256 as mz_ulong;
    rc = uncompress_memory(&mut restored[0], &mut restored_len, compressed.data() as *u8, compressed_len);
    if(!is_ok(rc)) {
        printf("uncompress failed: %s (%d)\n", error_string(rc).data(), rc);
        return 1;
    }

    restored[restored_len as int] = 0u8;

    printf("miniz version: %s\n", version().data());
    printf("source bytes: %lu\n", text_len);
    printf("compressed bytes: %lu\n", compressed_len);
    printf("adler32: %lu\n", adler32(text as *u8, text_len));
    printf("crc32: %lu\n", crc32(text as *u8, text_len));
    printf("restored: %s\n", (&restored[0]) as *char);
    return 0;
}
