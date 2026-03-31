public func main() : int {
    var params = fontstash::FONSparams {
        width : 512,
        height : 512,
        flags : 1 as u8, // FONS_ZERO_TOPLEFT
        userPtr : null as *mut void,
        renderCreate : null as (uptr : *mut void, width : int, height : int) => int,
        renderResize : null as (uptr : *mut void, width : int, height : int) => int,
        renderUpdate : null as (uptr : *mut void, rect : *mut int, data : *u8) => void,
        renderDraw : null as (uptr : *mut void, verts : *float, tcoords : *float, colors : *uint, nverts : int) => void,
        renderDelete : null as (uptr : *mut void) => void
    }
    
    var fs = fontstash::ffi::fonsCreateInternal(&mut params)
    
    if (fs == null as *mut fontstash::FONScontext) {
        printf("Failed to create fontstash context\n")
        return 1
    }

    printf("Successfully created fontstash context!\n")
    
    fontstash::ffi::fonsDeleteInternal(fs)
    printf("fontstash Demo Success!\n")
    return 0
}
