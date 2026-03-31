public func main() : int {
    var root = cJSON::ffi::cJSON_CreateObject()
    cJSON::ffi::cJSON_AddItemToObject(root, "name", cJSON::ffi::cJSON_CreateString("Chemical"))
    cJSON::ffi::cJSON_AddItemToObject(root, "version", cJSON::ffi::cJSON_CreateNumber(1.0))

    var out = cJSON::ffi::cJSON_Print(root)
    printf("Generated JSON:\n")
    printf("%s\n", out)

    cJSON::ffi::cJSON_Delete(root)
    cJSON::ffi::cJSON_free(out as *void)

    var json_str = "{\"project\":\"Chemical\", \"active\":true}"
    var parsed = cJSON::ffi::cJSON_Parse(json_str)
    if (parsed != null as *mut cJSON::cJSON) {
        var item = cJSON::ffi::cJSON_GetObjectItem(parsed, "project")
        if (item != null as *mut cJSON::cJSON && cJSON::ffi::cJSON_IsString(item) != 0) {
            printf("Parsed project: %s\n", item.valuestring)
        }
        cJSON::ffi::cJSON_Delete(parsed)
    }

    printf("cJSON Demo Success!\n")
    return 0
}
