using namespace miniaudio;
using std::Result;

public func main() : int {
    var wav : [52]u8 = [82u8, 73u8, 70u8, 70u8, 44u8, 0u8, 0u8, 0u8, 87u8, 65u8, 86u8, 69u8, 102u8, 109u8, 116u8, 32u8, 16u8, 0u8, 0u8, 0u8, 1u8, 0u8, 1u8, 0u8, 68u8, 172u8, 0u8, 0u8, 136u8, 88u8, 1u8, 0u8, 2u8, 0u8, 16u8, 0u8, 100u8, 97u8, 116u8, 97u8, 8u8, 0u8, 0u8, 0u8, 0u8, 0u8, 255u8, 127u8, 0u8, 128u8, 0u8, 32u8];

    var audio_res = decode_f32_from_memory(&wav[0], 52, 1u, 44100u);
    if(audio_res is Result.Err) {
        var Err(code) = audio_res else unreachable;
        printf("decode failed: %d (%s)\n", code, error_string(code).data());
        return 1;
    }

    var Ok(audio) = audio_res else unreachable;
    printf("miniaudio version: %s\n", version().data());
    printf("frames=%llu channels=%u sample_rate=%u format=%d samples=%llu\n", audio.frame_count as ulonglong, audio.channels, audio.sample_rate, audio.format as int, audio.sample_count() as ulonglong);
    if(audio.sample_count() >= 4) {
        printf("first samples: %.6f %.6f %.6f %.6f\n", audio.samples[0] as double, audio.samples[1] as double, audio.samples[2] as double, audio.samples[3] as double);
    }
    return 0;
}
