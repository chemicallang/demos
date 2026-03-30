using namespace nuklear;
using namespace sokol_app;
using namespace sokol_args;
using namespace sokol_audio;
using namespace sokol_fetch;
using namespace sokol_gfx;
using namespace sokol_glue;
using namespace sokol_log;
using namespace sokol_nuklear;
using namespace sokol_time;

var pass_action : sg_pass_action
var start_ticks : u64 = 0u64;
var last_frame_ticks : u64 = 0u64;

var slider_value : float = 0.35f;
var property_value : int = 24;
var progress_value : nk_size = 24u64;
var accent_index : int = 0;
var show_metrics : nk_bool = 1;
var cancel_quit : nk_bool = 0;
var selected_item : nk_bool = 1;
var radio_choice : int = 0;

var fetch_valid_now : bool = false;

func apply_theme(index : int) {
    accent_index = index;
    switch(index) {
        0 => {
            pass_action.colors[0].clear_value.r = 0.07f;
            pass_action.colors[0].clear_value.g = 0.10f;
            pass_action.colors[0].clear_value.b = 0.16f;
            pass_action.colors[0].clear_value.a = 1f;
        }
        1 => {
            pass_action.colors[0].clear_value.r = 0.17f;
            pass_action.colors[0].clear_value.g = 0.11f;
            pass_action.colors[0].clear_value.b = 0.05f;
            pass_action.colors[0].clear_value.a = 1f;
        }
        default => {
            pass_action.colors[0].clear_value.r = 0.05f;
            pass_action.colors[0].clear_value.g = 0.13f;
            pass_action.colors[0].clear_value.b = 0.09f;
            pass_action.colors[0].clear_value.a = 1f;
        }
    }
}

func accent_label() : std::string_view {
    switch(accent_index) {
        0 => return "Ocean"
        1 => return "Amber"
        default => return "Forest"
    }
}

func demo_init() {
    stm_setup();
    start_ticks = stm_now();
    last_frame_ticks = start_ticks;

    var gfx_desc = sokol_gfx::make_desc(sglue_environment(), slog_func as *mut void);
    sg_setup(&mut gfx_desc);

    var audio_desc = sokol_audio::make_desc();
    audio_desc.sample_rate = 44100;
    audio_desc.num_channels = 2;
    saudio_setup(&mut audio_desc);

    var fetch_desc = sokol_fetch::make_desc();
    fetch_desc.max_requests = 4u;
    fetch_desc.num_channels = 1u;
    fetch_desc.num_lanes = 1u;
    sfetch_setup(&mut fetch_desc);
    fetch_valid_now = sfetch_valid();

    var nuk_desc = sokol_nuklear::make_desc();
    var swapchain = sglue_swapchain();
    nuk_desc.color_format = swapchain.color_format;
    nuk_desc.depth_format = swapchain.depth_format;
    nuk_desc.sample_count = swapchain.sample_count;
    nuk_desc.dpi_scale = sapp_dpi_scale();
    nuk_desc.enable_set_mouse_cursor = true;
    snk_setup(&mut nuk_desc);

    pass_action = clear_action(0.07f, 0.10f, 0.16f, 1f);
    apply_theme(0);
}

func draw_overview(ctx : &mut Context) {
    ctx.layout_row_dynamic(28f, 1);
    ctx.label("Chemical + sokol bindings", TextAlignment.CENTERED);
    ctx.label_colored("One app exercises app, gfx, glue, log, args, time, audio, fetch and sokol_nuklear.", TextAlignment.LEFT, Color.make(200, 228, 255));

    ctx.layout_row_dynamic(30f, 2);
    if(ctx.button_label("Request quit")) {
        sapp_request_quit();
    }
    if(ctx.button_symbol_label(SymbolType.TRIANGLE_RIGHT, "Refresh status")) {
        fetch_valid_now = sfetch_valid();
    }

    ctx.layout_row_dynamic(26f, 1);
    ctx.checkbox_label("Cancel quit requests", &mut cancel_quit);
    ctx.checkbox_label("Show diagnostics", &mut show_metrics);
    ctx.selectable_label("Highlight this item", TextAlignment.LEFT, &mut selected_item);

    ctx.layout_row_dynamic(26f, 2);
    if(ctx.option_label("Mode A", radio_choice == 0)) {
        radio_choice = 0;
    }
    if(ctx.option_label("Mode B", radio_choice == 1)) {
        radio_choice = 1;
    }

    ctx.layout_row_dynamic(28f, 1);
    ctx.slider_float(0f, &mut slider_value, 1f, 0.05f);
    ctx.property_int("Progress", 0, &mut property_value, 100, 1, 1f);
    progress_value = property_value as nk_size;
    ctx.progress(&mut progress_value, 100u64, true);
    property_value = progress_value as int;
    ctx.value_float("Slider", slider_value);
    ctx.value_int("Progress", property_value);

    ctx.layout_row_dynamic(30f, 1);
    if(ctx.combo_begin_label(accent_label(), Vec2.make(220f, 120f))) {
        if(ctx.combo_item_label("Ocean")) {
            apply_theme(0);
        }
        if(ctx.combo_item_label("Amber")) {
            apply_theme(1);
        }
        if(ctx.combo_item_label("Forest")) {
            apply_theme(2);
        }
        ctx.combo_end();
    }
}

func draw_runtime(ctx : &mut Context) {
    ctx.layout_row_dynamic(150f, 2);

    if(ctx.group_begin("Runtime", WindowFlag.BORDER as int)) {
        var uptime_ms = stm_ms(stm_since(start_ticks)) as float;
        var frame_ms = stm_ms(stm_laptime(&mut last_frame_ticks)) as float;
        ctx.layout_row_dynamic(22f, 1);
        ctx.label("sokol_app + sokol_time", TextAlignment.LEFT);
        ctx.value_int("Frame", sapp_frame_count() as int);
        ctx.value_float("Uptime ms", uptime_ms);
        ctx.value_float("Frame ms", frame_ms);
        ctx.value_float("DPI scale", sapp_dpi_scale());
        ctx.value_int("Args", sargs_num_args());
        ctx.group_end();
    }

    if(ctx.group_begin("Audio", WindowFlag.BORDER as int)) {
        ctx.layout_row_dynamic(22f, 1);
        ctx.label("sokol_audio", TextAlignment.LEFT);
        ctx.value_int("Valid", if(saudio_isvalid()) 1 else 0);
        ctx.value_int("Sample rate", saudio_sample_rate());
        ctx.value_int("Channels", saudio_channels());
        ctx.value_int("Buffer frames", saudio_buffer_frames());
        ctx.value_int("Expect", saudio_expect());
        ctx.group_end();
    }

    ctx.layout_row_dynamic(170f, 2);

    if(ctx.group_begin("Fetch", WindowFlag.BORDER as int)) {
        ctx.layout_row_dynamic(22f, 1);
        ctx.label("sokol_fetch", TextAlignment.LEFT);
        ctx.value_int("Valid", if(fetch_valid_now) 1 else 0);
        ctx.value_int("Max path", sfetch_max_path());
        ctx.value_int("Max user data", sfetch_max_userdata_bytes());
        ctx.value_int("Desc channels", sfetch_desc().num_channels as int);
        ctx.value_int("Desc lanes", sfetch_desc().num_lanes as int);
        ctx.label_wrap("The module is imported and initialized here. Add request/callback coverage after the callback ABI is tightened further.");
        ctx.group_end();
    }

    if(ctx.group_begin("Renderer", WindowFlag.BORDER as int)) {
        var bounds = ctx.window_bounds();
        ctx.layout_row_dynamic(22f, 1);
        ctx.label("sokol_gfx + sokol_glue + sokol_log", TextAlignment.LEFT);
        ctx.value_int("sg valid", if(sg_isvalid()) 1 else 0);
        ctx.value_int("Accent index", accent_index);
        ctx.value_float("Window width", bounds.w);
        ctx.value_float("Window height", bounds.h);
        ctx.label_wrap("Logger callbacks are wired to slog_func for gfx, audio, fetch, app and nuklear.");
        ctx.group_end();
    }
}

func draw_diagnostics(ctx : &mut Context) {
    if(show_metrics == 0) {
        return;
    }
    ctx.layout_row_dynamic(140f, 1);
    if(ctx.group_begin("Diagnostics", WindowFlag.BORDER as int)) {
        ctx.layout_row_dynamic(22f, 1);
        ctx.label("sokol_args", TextAlignment.LEFT);
        ctx.value_int("Has --help", if(sargs_exists("help")) 1 else 0);
        ctx.value_int("Has --demo", if(sargs_exists("demo")) 1 else 0);
        ctx.value_int("Flag verbose", if(sargs_boolean("verbose")) 1 else 0);
        if(ctx.tree_push(TreeType.NODE, "Notes", CollapseState.MAXIMIZED)) {
            ctx.layout_row_dynamic(20f, 1);
            ctx.label_wrap("Use this demo as the smoke test module for all current sokol bindings.");
            ctx.label_wrap("The UI path is intentionally simple so binding issues show up in generated C immediately.");
            ctx.tree_pop();
        }
        ctx.group_end();
    }
}

func demo_frame() {
    fetch_valid_now = sfetch_valid();

    var raw = snk_new_frame();
    var ctx = Context.from_handle(raw, false);

    if(ctx.begin("Chemical Sokol Demo", Rect.make(24f, 24f, 900f, 640f), WindowFlag.BORDER | WindowFlag.MOVABLE | WindowFlag.TITLE | WindowFlag.MINIMIZABLE | WindowFlag.SCALABLE)) {
        draw_overview(ctx);
        draw_runtime(ctx);
        draw_diagnostics(ctx);
    }
    ctx.end();

    var pass = sg_make_pass_defaults();
    pass.action = pass_action;
    pass.swapchain = sglue_swapchain();
    sg_begin_pass(&mut pass);
    snk_render(sapp_width(), sapp_height());
    sg_end_pass();
    sg_commit();
}

func demo_cleanup() {
    sfetch_shutdown();
    saudio_shutdown();
    snk_shutdown();
    sg_shutdown();
    sargs_shutdown();
}

func demo_event(ev : *sapp_event) {
    snk_handle_event(ev);
    if(ev.type == sapp_event_type.QUIT_REQUESTED && cancel_quit != 0) {
        sapp_cancel_quit();
    }
}

public func main(argc : int, argv : **char) : int {
    var args_desc = sokol_args::make_desc(argc, argv);
    sargs_setup(&mut args_desc);

    var desc = sokol_app::make_desc("Chemical Sokol Demo", 960, 720);
    desc.init_cb = demo_init as *mut void;
    desc.frame_cb = demo_frame as *mut void;
    desc.cleanup_cb = demo_cleanup as *mut void;
    desc.event_cb = demo_event as *mut void;
    desc.win32.console_attach = true;
    desc.logger.func = slog_func as *mut void;
    sapp_run(&mut desc);
    return 0;
}
