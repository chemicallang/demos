public func main() : int {
    var input = std::string_view("Chemical Language")
    var output : [32]u8
    
    // Using one-shot sha256
    mbedtls::ffi::mbedtls_sha256(input.data() as *u8, input.size(), &mut output[0], 0)
    
    printf("SHA256 of '%s':\n", input.data())
    
    for (var i = 0; i < 32; i++) {
        var val = output[i] as int
        printf("%02x ", val)
    }
    printf("\n")

    printf("mbedtls Demo Success!\n")
    return 0
}
