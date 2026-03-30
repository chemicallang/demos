using namespace stb_image;
using std::Result;

public func main() : int {
    var png : [70]u8 = [137u8, 80u8, 78u8, 71u8, 13u8, 10u8, 26u8, 10u8, 0u8, 0u8, 0u8, 13u8, 73u8, 72u8, 68u8, 82u8, 0u8, 0u8, 0u8, 1u8, 0u8, 0u8, 0u8, 1u8, 8u8, 6u8, 0u8, 0u8, 0u8, 31u8, 21u8, 196u8, 137u8, 0u8, 0u8, 0u8, 13u8, 73u8, 68u8, 65u8, 84u8, 120u8, 156u8, 99u8, 248u8, 207u8, 192u8, 240u8, 31u8, 0u8, 5u8, 0u8, 1u8, 255u8, 137u8, 153u8, 61u8, 29u8, 0u8, 0u8, 0u8, 0u8, 73u8, 69u8, 78u8, 68u8, 174u8, 66u8, 96u8, 130u8];
    const png_len = 70;

    var info_res = info_from_memory(&png[0], png_len);
    if(info_res is Result.Err) {
        var Err(error) = info_res else unreachable;
        printf("info failed: %s\n", error.data());
        return 1;
    }
    var Ok(info) = info_res else unreachable;

    var image_res = load_from_memory(&png[0], png_len, Channels.RGBA);
    if(image_res is Result.Err) {
        var Err(error) = image_res else unreachable;
        printf("load failed: %s\n", error.data());
        return 1;
    }
    var Ok(image) = image_res else unreachable;

    printf("stb_image header version: %d\n", HEADER_VERSION);
    printf("info: %d x %d, components=%d\n", info.width, info.height, info.components);
    printf("image: %d x %d, components=%d, bytes=%d\n", image.width, image.height, image.components, image.byte_len());
    printf("first pixel rgba = %u %u %u %u\n", image.pixels[0] as uint, image.pixels[1] as uint, image.pixels[2] as uint, image.pixels[3] as uint);
    return 0;
}
