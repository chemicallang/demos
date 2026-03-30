public func main() : int {
    var zip_name = "test.zip"
    var zip_handle = zip::ffi::zip_open(zip_name, 6, 'w')
    
    if (zip_handle == null as *mut zip::zip_t) {
        printf("Failed to open zip file for writing\n")
        return 1
    }

    printf("Opened zip file for writing\n")

    if (zip::ffi::zip_entry_open(zip_handle, "hello.txt") != 0) {
        printf("Failed to open entry hello.txt\n")
        zip::ffi::zip_close(zip_handle)
        return 1
    }

    var content = std::string_view("Hello from Chemical!")
    if (zip::ffi::zip_entry_write(zip_handle, content.data(), content.size()) != 0) {
        printf("Failed to write to entry\n")
        zip::ffi::zip_entry_close(zip_handle)
        zip::ffi::zip_close(zip_handle)
        return 1
    }

    zip::ffi::zip_entry_close(zip_handle)
    zip::ffi::zip_close(zip_handle)
    printf("Created zip file with hello.txt\n")

    // Now read it back
    zip_handle = zip::ffi::zip_open(zip_name, 0, 'r')
    if (zip_handle == null as *mut zip::zip_t) {
        printf("Failed to open zip file for reading\n")
        return 1
    }

    if (zip::ffi::zip_entry_open(zip_handle, "hello.txt") != 0) {
        printf("Failed to open entry hello.txt for reading\n")
        zip::ffi::zip_close(zip_handle)
        return 1
    }

    var size = zip::ffi::zip_entry_size(zip_handle)
    printf("Entry size: ")
    printf("%d", size as int)
    printf("\n")

    var buf = malloc(size as usize + 1) as *mut char
    if (zip::ffi::zip_entry_noallocread(zip_handle, buf as *mut void, size as usize) < 0) {
        printf("Failed to read entry\n")
        free(buf as *mut void)
        zip::ffi::zip_entry_close(zip_handle)
        zip::ffi::zip_close(zip_handle)
        return 1
    }
    buf[size as usize] = '\0'

    printf("Read content: ")
    printf(buf)
    printf("\n")

    free(buf as *mut void)
    zip::ffi::zip_entry_close(zip_handle)
    zip::ffi::zip_close(zip_handle)

    printf("Success!\n")
    return 0
}
