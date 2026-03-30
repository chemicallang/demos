# miniaudio demo

Build the demo with:

```powershell
cmake-build-debug/TCCCompiler.exe lang/compiled/miniaudio_demo/chemical.mod -o lang/compiled/miniaudio_demo/build.exe --no-cache --emit-c
```

The demo decodes a tiny WAV file from memory with the static `miniaudio` binding and prints the decoded metadata and first sample values.
