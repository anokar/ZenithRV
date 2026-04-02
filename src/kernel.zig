const UART0: usize = 0x1000_0000;
const UART_RBR: usize = UART0 + 0;
const UART_THR: usize = UART0 + 0;
const UART_LSR: usize = UART0 + 5;

const SCAUSE_INTERRUPT_BIT: usize = @as(usize, 1) << 63;
const SCAUSE_SUPERVISOR_TIMER: usize = SCAUSE_INTERRUPT_BIT | 5;
const SCAUSE_USER_ECALL: usize = 8;
const SCAUSE_ILLEGAL_INSTR: usize = 2;
const SCAUSE_BREAKPOINT: usize = 3;
const SCAUSE_INST_PAGE_FAULT: usize = 12;
const SCAUSE_LOAD_PAGE_FAULT: usize = 13;
const SCAUSE_STORE_PAGE_FAULT: usize = 15;

const SIE_STIE: usize = @as(usize, 1) << 5;
const SSTATUS_SIE: usize = @as(usize, 1) << 1;
const SBI_EXT_TIME: usize = 0x5449_4D45;
const SBI_EXT_SRST: usize = 0x5352_5354;
const SBI_SRST_RESET_TYPE_SHUTDOWN: usize = 0;
const SBI_SRST_RESET_REASON_NONE: usize = 0;
const TIMER_INTERVAL: u64 = 2_000_000;

const SYS_WRITE_CHAR: usize = 1;
const SYS_GET_TICKS: usize = 2;
const SYS_YIELD: usize = 3;
const SYS_EXIT: usize = 4;

const REG_A0: usize = 8;
const REG_A7: usize = 15;
const VIRTIO_MMIO_BASE_START: usize = 0x1000_1000;
const VIRTIO_MMIO_STRIDE: usize = 0x1000;
const VIRTIO_MMIO_SLOTS: usize = 8;
const VIRTIO_QUEUE_SIZE: u16 = 8;
const VIRTIO_INPUT_QUEUE_SIZE: u16 = 16;
const VIRTIO_INPUT_DEV_MAX: usize = 2;
const VIRTIO_GPU_QUEUE_SIZE: u16 = 8;
const VIRTIO_BLK_T_IN: u32 = 0;
const VIRTIO_BLK_T_OUT: u32 = 1;
const VIRTIO_F_VERSION_1: u32 = 1;
const VIRTIO_GPU_CMD_GET_DISPLAY_INFO: u32 = 0x0100;
const VIRTIO_GPU_CMD_RESOURCE_CREATE_2D: u32 = 0x0101;
const VIRTIO_GPU_CMD_SET_SCANOUT: u32 = 0x0103;
const VIRTIO_GPU_CMD_RESOURCE_FLUSH: u32 = 0x0104;
const VIRTIO_GPU_CMD_TRANSFER_TO_HOST_2D: u32 = 0x0105;
const VIRTIO_GPU_CMD_RESOURCE_ATTACH_BACKING: u32 = 0x0106;
const VIRTIO_GPU_RESP_OK_NODATA: u32 = 0x1100;
const VIRTIO_GPU_RESP_OK_DISPLAY_INFO: u32 = 0x1101;
const VIRTIO_GPU_FORMAT_B8G8R8X8_UNORM: u32 = 2;
const GFX_FB_MAX_W: u32 = 1024;
const GFX_FB_MAX_H: u32 = 768;
const GFX_FB_MAX_PIXELS: usize = GFX_FB_MAX_W * GFX_FB_MAX_H;
const FS_MAX_FILES: usize = 16;
const FS_NAME_MAX: usize = 24;
const FS_DATA_MAX: usize = 512;
const HISTORY_MAX: usize = 16;
const MINIFS_MAGIC: u32 = 0x4D46_5331; // "MFS1"
const MINIFS_VERSION: u16 = 1;
const MINIFS_SUPER_SECTOR: u64 = 2;
const MINIFS_META_START_SECTOR: u64 = MINIFS_SUPER_SECTOR + 1;
const MINIFS_DATA_START_SECTOR: u64 = MINIFS_META_START_SECTOR + FS_MAX_FILES;
const UX_SPACE_MAX: usize = 8;
const UX_SPACE_NAME_MAX: usize = 20;
const UX_ITEM_MAX: usize = 32;
const UX_ITEM_TITLE_MAX: usize = 28;
const UX_ITEM_TEXT_MAX: usize = 320;
const UX_ITEM_TAGS_MAX: usize = 96;
const UXFS_MAGIC: u32 = 0x5558_4631; // "UXF1"
const UXFS_VERSION: u16 = 1;
const UXFS_SUPER_SECTOR: u64 = 64;
const UXFS_SPACE_START: u64 = UXFS_SUPER_SECTOR + 1;
const UXFS_ITEM_START: u64 = UXFS_SPACE_START + UX_SPACE_MAX;
const INPUT_QUEUE_MAX: usize = 128;
const OS_NAME: []const u8 = "ZenithRV";
const SHELL_PROMPT: []const u8 = "zrv> ";
const FB_SHELL_TITLE: []const u8 = "ZENITHRV SHELL";
const FB_CONSOLE_MAX_LINES: usize = 80;
const FB_CONSOLE_LINE_MAX: usize = 140;
const MOUSE_CURSOR_SAVE_W: usize = 17;
const MOUSE_CURSOR_SAVE_H: usize = 17;

extern fn __trap_vector() void;
extern fn __enter_user_mode(user_pc: usize, user_sp: usize) callconv(.c) noreturn;
extern var _stack_top: u8;

const Task = struct {
    name: u8,
    stack: [2048]u8 align(16) = undefined,
    frame_ptr: usize = 0,
    sepc: usize = 0,
    started: bool = false,
    done: bool = false,
};

const RamFile = struct {
    used: bool = false,
    name_len: u8 = 0,
    data_len: usize = 0,
    name: [FS_NAME_MAX]u8 = [_]u8{0} ** FS_NAME_MAX,
    data: [FS_DATA_MAX]u8 = [_]u8{0} ** FS_DATA_MAX,
};

const FsWriteError = error{
    InvalidName,
    NoSpace,
    DataTooLarge,
};

const NameText = struct {
    name: []const u8,
    text: []const u8,
};

const Rgb = struct {
    r: u8,
    g: u8,
    b: u8,
};

const UxSpace = struct {
    used: bool = false,
    id: u16 = 0,
    name_len: u8 = 0,
    name: [UX_SPACE_NAME_MAX]u8 = [_]u8{0} ** UX_SPACE_NAME_MAX,
};

const UxItem = struct {
    used: bool = false,
    done: bool = false,
    id: u16 = 0,
    space_id: u16 = 0,
    title_len: u8 = 0,
    text_len: u16 = 0,
    tags_len: u8 = 0,
    title: [UX_ITEM_TITLE_MAX]u8 = [_]u8{0} ** UX_ITEM_TITLE_MAX,
    text: [UX_ITEM_TEXT_MAX]u8 = [_]u8{0} ** UX_ITEM_TEXT_MAX,
    tags: [UX_ITEM_TAGS_MAX]u8 = [_]u8{0} ** UX_ITEM_TAGS_MAX,
};

const ItemStatusFilter = enum {
    all,
    open,
    done,
};

const InputEventKind = enum {
    char,
    key,
};

const InputKey = enum(u8) {
    enter,
    backspace,
    escape,
    up,
    down,
    left,
    right,
    home,
    end,
    delete,
};

const InputEvent = struct {
    kind: InputEventKind,
    ch: u8 = 0,
    key: InputKey = .escape,
};

const VirtioInputEvent = extern struct {
    ev_type: u16,
    code: u16,
    value: u32,
};

const VirtioGpuCtrlHdr = extern struct {
    ctrl_type: u32,
    flags: u32,
    fence_id: u64,
    ctx_id: u32,
    padding: u32,
};

const VirtioGpuRect = extern struct {
    x: u32,
    y: u32,
    width: u32,
    height: u32,
};

const VirtioGpuDisplayOne = extern struct {
    rect: VirtioGpuRect,
    enabled: u32,
    flags: u32,
};

const VirtioGpuRespDisplayInfo = extern struct {
    hdr: VirtioGpuCtrlHdr,
    pmodes: [16]VirtioGpuDisplayOne,
};

const VirtioGpuResourceCreate2d = extern struct {
    hdr: VirtioGpuCtrlHdr,
    resource_id: u32,
    format: u32,
    width: u32,
    height: u32,
};

const VirtioGpuMemEntry = extern struct {
    addr: u64,
    length: u32,
    padding: u32,
};

const VirtioGpuResourceAttachBacking = extern struct {
    hdr: VirtioGpuCtrlHdr,
    resource_id: u32,
    nr_entries: u32,
    entry: VirtioGpuMemEntry,
};

const VirtioGpuSetScanout = extern struct {
    hdr: VirtioGpuCtrlHdr,
    rect: VirtioGpuRect,
    scanout_id: u32,
    resource_id: u32,
};

const VirtioGpuTransferToHost2d = extern struct {
    hdr: VirtioGpuCtrlHdr,
    rect: VirtioGpuRect,
    offset: u64,
    resource_id: u32,
    padding: u32,
};

const VirtioGpuResourceFlush = extern struct {
    hdr: VirtioGpuCtrlHdr,
    rect: VirtioGpuRect,
    resource_id: u32,
    padding: u32,
};

const VirtioGpuRespNoData = extern struct {
    hdr: VirtioGpuCtrlHdr,
};

const UxError = error{
    InvalidName,
    NoSpace,
    NotFound,
    InvalidText,
};

const VirtqDesc = extern struct {
    addr: u64,
    len: u32,
    flags: u16,
    next: u16,
};

const VirtqAvail = extern struct {
    flags: u16,
    idx: u16,
    ring: [VIRTIO_QUEUE_SIZE]u16,
    used_event: u16,
};

const VirtqUsedElem = extern struct {
    id: u32,
    len: u32,
};

const VirtqUsed = extern struct {
    flags: u16,
    idx: u16,
    ring: [VIRTIO_QUEUE_SIZE]VirtqUsedElem,
    avail_event: u16,
};

const VirtqAvailInput = extern struct {
    flags: u16,
    idx: u16,
    ring: [VIRTIO_INPUT_QUEUE_SIZE]u16,
    used_event: u16,
};

const VirtqUsedInput = extern struct {
    flags: u16,
    idx: u16,
    ring: [VIRTIO_INPUT_QUEUE_SIZE]VirtqUsedElem,
    avail_event: u16,
};

const VInputDevice = struct {
    ready: bool = false,
    base: usize = 0,
    desc: [VIRTIO_INPUT_QUEUE_SIZE]VirtqDesc align(16) = [_]VirtqDesc{.{ .addr = 0, .len = 0, .flags = 0, .next = 0 }} ** VIRTIO_INPUT_QUEUE_SIZE,
    avail: VirtqAvailInput align(2) = .{
        .flags = 0,
        .idx = 0,
        .ring = [_]u16{0} ** VIRTIO_INPUT_QUEUE_SIZE,
        .used_event = 0,
    },
    used: VirtqUsedInput align(4) = .{
        .flags = 0,
        .idx = 0,
        .ring = [_]VirtqUsedElem{.{ .id = 0, .len = 0 }} ** VIRTIO_INPUT_QUEUE_SIZE,
        .avail_event = 0,
    },
    events: [VIRTIO_INPUT_QUEUE_SIZE]VirtioInputEvent align(16) = [_]VirtioInputEvent{.{ .ev_type = 0, .code = 0, .value = 0 }} ** VIRTIO_INPUT_QUEUE_SIZE,
    last_used_idx: u16 = 0,
};

const VirtioBlkReq = extern struct {
    req_type: u32,
    reserved: u32,
    sector: u64,
};

var g_ticks: usize = 0;
var g_scheduler_active = false;
var g_current_task: usize = 0;
var g_rr_stop_requested = false;
var g_kernel_resume_frame: [32]usize align(16) = [_]usize{0} ** 32;
var g_fs_files: [FS_MAX_FILES]RamFile = [_]RamFile{.{}} ** FS_MAX_FILES;
var g_history_data: [HISTORY_MAX][128]u8 = [_][128]u8{[_]u8{0} ** 128} ** HISTORY_MAX;
var g_history_len: [HISTORY_MAX]u8 = [_]u8{0} ** HISTORY_MAX;
var g_history_count: usize = 0;
var g_history_next: usize = 0;
var g_virtio_ready = false;
var g_virtio_base: usize = 0;
var g_virtio_capacity_sectors: u64 = 0;
var g_vinput_count: usize = 0;
var g_vinput_devices: [VIRTIO_INPUT_DEV_MAX]VInputDevice = [_]VInputDevice{.{}} ** VIRTIO_INPUT_DEV_MAX;
var g_vgpu_ready = false;
var g_vgpu_base: usize = 0;
var g_vgpu_width: u32 = 0;
var g_vgpu_height: u32 = 0;
var g_vgpu_resource_id: u32 = 1;
var g_vgpu_shell_panel_h: u32 = 0;
var g_fb_console_line_count: usize = 1;
var g_fb_console_line_len: [FB_CONSOLE_MAX_LINES]u16 = [_]u16{0} ** FB_CONSOLE_MAX_LINES;
var g_fb_console_lines: [FB_CONSOLE_MAX_LINES][FB_CONSOLE_LINE_MAX]u8 = [_][FB_CONSOLE_LINE_MAX]u8{[_]u8{0} ** FB_CONSOLE_LINE_MAX} ** FB_CONSOLE_MAX_LINES;
var g_fb_console_ansi: bool = false;
var g_mouse_x: i32 = 0;
var g_mouse_y: i32 = 0;
var g_mouse_left_down: bool = false;
var g_mouse_click_count: u32 = 0;
var g_mouse_cursor_drawn: bool = false;
var g_mouse_cursor_saved_x: i32 = 0;
var g_mouse_cursor_saved_y: i32 = 0;
var g_mouse_cursor_saved_w: u8 = 0;
var g_mouse_cursor_saved_h: u8 = 0;
var g_mouse_cursor_saved: [MOUSE_CURSOR_SAVE_W * MOUSE_CURSOR_SAVE_H]u32 = [_]u32{0} ** (MOUSE_CURSOR_SAVE_W * MOUSE_CURSOR_SAVE_H);
var g_input_queue: [INPUT_QUEUE_MAX]InputEvent = [_]InputEvent{.{ .kind = .char, .ch = 0 }} ** INPUT_QUEUE_MAX;
var g_input_head: usize = 0;
var g_input_tail: usize = 0;
var g_input_esc_state: u8 = 0; // 0 none, 1 got ESC, 2 got ESC[
var g_input_esc_param: u8 = 0;
var g_ux_spaces: [UX_SPACE_MAX]UxSpace = [_]UxSpace{.{}} ** UX_SPACE_MAX;
var g_ux_items: [UX_ITEM_MAX]UxItem = [_]UxItem{.{}} ** UX_ITEM_MAX;
var g_ux_active_space_id: u16 = 0;
var g_ux_next_space_id: u16 = 1;
var g_ux_next_item_id: u16 = 1;
var g_virtio_desc: [VIRTIO_QUEUE_SIZE]VirtqDesc align(16) = [_]VirtqDesc{.{ .addr = 0, .len = 0, .flags = 0, .next = 0 }} ** VIRTIO_QUEUE_SIZE;
var g_virtio_avail: VirtqAvail align(2) = .{
    .flags = 0,
    .idx = 0,
    .ring = [_]u16{0} ** VIRTIO_QUEUE_SIZE,
    .used_event = 0,
};
var g_virtio_used: VirtqUsed align(4) = .{
    .flags = 0,
    .idx = 0,
    .ring = [_]VirtqUsedElem{.{ .id = 0, .len = 0 }} ** VIRTIO_QUEUE_SIZE,
    .avail_event = 0,
};
var g_virtio_req: VirtioBlkReq = .{ .req_type = 0, .reserved = 0, .sector = 0 };
var g_virtio_status: u8 align(1) = 0;
var g_virtio_data: [512]u8 align(16) = [_]u8{0} ** 512;
var g_virtio_last_used_idx: u16 = 0;
var g_vgpu_desc: [VIRTIO_GPU_QUEUE_SIZE]VirtqDesc align(16) = [_]VirtqDesc{.{ .addr = 0, .len = 0, .flags = 0, .next = 0 }} ** VIRTIO_GPU_QUEUE_SIZE;
var g_vgpu_avail: extern struct {
    flags: u16,
    idx: u16,
    ring: [VIRTIO_GPU_QUEUE_SIZE]u16,
    used_event: u16,
} align(2) = .{
    .flags = 0,
    .idx = 0,
    .ring = [_]u16{0} ** VIRTIO_GPU_QUEUE_SIZE,
    .used_event = 0,
};
var g_vgpu_used: extern struct {
    flags: u16,
    idx: u16,
    ring: [VIRTIO_GPU_QUEUE_SIZE]VirtqUsedElem,
    avail_event: u16,
} align(4) = .{
    .flags = 0,
    .idx = 0,
    .ring = [_]VirtqUsedElem{.{ .id = 0, .len = 0 }} ** VIRTIO_GPU_QUEUE_SIZE,
    .avail_event = 0,
};
var g_vgpu_last_used_idx: u16 = 0;
var g_vgpu_fb: [GFX_FB_MAX_PIXELS]u32 align(16) = [_]u32{0} ** GFX_FB_MAX_PIXELS;
var g_vgpu_req_display_info: VirtioGpuCtrlHdr = .{
    .ctrl_type = VIRTIO_GPU_CMD_GET_DISPLAY_INFO,
    .flags = 0,
    .fence_id = 0,
    .ctx_id = 0,
    .padding = 0,
};
var g_vgpu_resp_display_info: VirtioGpuRespDisplayInfo = .{
    .hdr = .{ .ctrl_type = 0, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
    .pmodes = [_]VirtioGpuDisplayOne{.{
        .rect = .{ .x = 0, .y = 0, .width = 0, .height = 0 },
        .enabled = 0,
        .flags = 0,
    }} ** 16,
};
var g_vgpu_req_create_2d: VirtioGpuResourceCreate2d = .{
    .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_RESOURCE_CREATE_2D, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
    .resource_id = 0,
    .format = VIRTIO_GPU_FORMAT_B8G8R8X8_UNORM,
    .width = 0,
    .height = 0,
};
var g_vgpu_req_attach: VirtioGpuResourceAttachBacking = .{
    .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_RESOURCE_ATTACH_BACKING, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
    .resource_id = 0,
    .nr_entries = 1,
    .entry = .{ .addr = 0, .length = 0, .padding = 0 },
};
var g_vgpu_req_set_scanout: VirtioGpuSetScanout = .{
    .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_SET_SCANOUT, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
    .rect = .{ .x = 0, .y = 0, .width = 0, .height = 0 },
    .scanout_id = 0,
    .resource_id = 0,
};
var g_vgpu_req_xfer: VirtioGpuTransferToHost2d = .{
    .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_TRANSFER_TO_HOST_2D, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
    .rect = .{ .x = 0, .y = 0, .width = 0, .height = 0 },
    .offset = 0,
    .resource_id = 0,
    .padding = 0,
};
var g_vgpu_req_flush: VirtioGpuResourceFlush = .{
    .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_RESOURCE_FLUSH, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
    .rect = .{ .x = 0, .y = 0, .width = 0, .height = 0 },
    .resource_id = 0,
    .padding = 0,
};
var g_vgpu_resp_nodata: VirtioGpuRespNoData = .{
    .hdr = .{ .ctrl_type = 0, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
};
var g_tasks = [_]Task{
    .{ .name = 'A' },
    .{ .name = 'B' },
};

pub export fn kmain() callconv(.c) noreturn {
    uartPrint(OS_NAME);
    uartPrint(" kernel (riscv64) booted in qemu\n");
    uartPrint("milestone 12: ZenithRV + framebuffer shell + mouse + uart mirror\n");
    uartPrint("type 'help' for commands\n");

    fsInit();
    uxInit();
    inputInit();
    setupTrapAndTimer();
    virtioBlkInit();
    if (g_virtio_ready) {
        uartPrint("virtio-blk init: ready\n");
    } else {
        uartPrint("virtio-blk init: not ready\n");
    }
    virtioInputInit();
    if (g_vinput_count > 0) {
        uartPrint("virtio-input init: ready devices=");
        uartPrintDec(g_vinput_count);
        uartPrint("\n");
    } else {
        uartPrint("virtio-input init: not ready (uart fallback)\n");
    }
    virtioGpuInit();
    if (g_vgpu_ready) {
        uartPrint("virtio-gpu init: ready ");
        uartPrintDec(g_vgpu_width);
        uartPrint("x");
        uartPrintDec(g_vgpu_height);
        uartPrint("\n");
    } else {
        uartPrint("virtio-gpu init: not ready\n");
    }
    shellLoop();
}

pub export fn trapHandler(scause: usize, sepc: usize, stval: usize, frame: *[32]usize) callconv(.c) *[32]usize {
    if (scause == SCAUSE_SUPERVISOR_TIMER) {
        g_ticks += 1;
        if (g_scheduler_active) {
            inputPollSources();
            while (inputTryPopChar()) |ch| {
                if (ch == 'q' or ch == 'Q') {
                    g_rr_stop_requested = true;
                }
            }
        }
        scheduleNextTimer();
        return frame;
    }

    if (scause == SCAUSE_USER_ECALL) {
        return handleUserEcall(frame, sepc);
    }

    reportException(scause, sepc, stval);
}

fn shellLoop() noreturn {
    var line_buf: [128]u8 = undefined;
    var line_len: usize = 0;

    printPrompt();
    gfxShellRenderInput(line_buf[0..line_len]);
    while (true) {
        var handled_any = false;
        inputPollSources();
        while (inputTryPopChar()) |ch| {
            handled_any = true;
            switch (ch) {
                '\r', '\n' => {
                    uartPrint("\n");
                    handleCommand(line_buf[0..line_len]);
                    line_len = 0;
                    printPrompt();
                    gfxShellRenderInput(line_buf[0..line_len]);
                },
                0x08, 0x7f => {
                    if (line_len > 0) {
                        line_len -= 1;
                        uartPrint("\x08 \x08");
                        gfxShellRenderInput(line_buf[0..line_len]);
                    }
                },
                else => {
                    if (ch >= 0x20 and ch < 0x7f) {
                        if (line_len < line_buf.len) {
                            line_buf[line_len] = ch;
                            line_len += 1;
                            uartPutc(ch);
                            gfxShellRenderInput(line_buf[0..line_len]);
                        } else {
                            uartPutc(0x07);
                        }
                    }
                },
            }
        }
        if (!handled_any) asm volatile ("wfi");
    }
}

fn handleCommand(line: []const u8) void {
    if (line.len == 0) return;

    if (strEq(line, "help")) {
        uartPrint("commands:\n");
        uartPrint("  help, ticks, echo <txt>, clear, panic, rrdemo, exit, shutdown\n");
        uartPrint("  ls, cat <name>, touch <name>, write <name> <txt>, append <name> <txt>, rm <name>\n");
        uartPrint("  blkprobe, blkread <sector>, blkwrite <sector> <txt>, blkdebug, mouse\n");
        uartPrint("  gfxprobe, gfxfill <r> <g> <b>, gfxclear, gfxlogo\n");
        uartPrint("  mkfs, fssave, fsload, fsstat\n");
        uartPrint("  space list|add <name>|use <name>|rm <name>\n");
        uartPrint("  item list|add <title> <text>|show <id>|tag <id> <tags>|rm <id>|find <text>|filter tag:<x>\n");
        uartPrint("  item edit <id> title|text|tags <value>, item move <id> <space>\n");
        uartPrint("  item done <id>, item reopen <id>, item clone <id>, item list status:open|done\n");
        uartPrint("  uxmkfs, uxsave, uxload, uxstat\n");
        return;
    }
    if (strEq(line, "ticks")) {
        uartPrint("ticks=");
        uartPrintDec(g_ticks);
        uartPrint("\n");
        return;
    }
    if (strEq(line, "clear")) {
        uartPrint("\x1b[2J\x1b[H");
        gfxConsoleReset();
        gfxConsoleRender();
        return;
    }
    if (startsWith(line, "echo ")) {
        uartPrint(line[5..]);
        uartPrint("\n");
        return;
    }
    if (strEq(line, "panic")) {
        asm volatile ("ebreak");
        return;
    }
    if (strEq(line, "rrdemo")) {
        startRoundRobinDemo();
    }
    if (strEq(line, "ls")) {
        fsList();
        return;
    }
    if (startsWith(line, "cat ")) {
        const name = trimSpaces(line[4..]);
        if (name.len == 0) {
            uartPrint("usage: cat <name>\n");
            return;
        }
        fsCat(name);
        return;
    }
    if (startsWith(line, "touch ")) {
        const name = trimSpaces(line[6..]);
        if (name.len == 0) {
            uartPrint("usage: touch <name>\n");
            return;
        }
        const res = fsWrite(name, "", false);
        reportFsWriteResult(res);
        return;
    }
    if (startsWith(line, "write ")) {
        const nt = parseNameText(line[6..]) orelse {
            uartPrint("usage: write <name> <txt>\n");
            return;
        };
        const res = fsWrite(nt.name, nt.text, false);
        reportFsWriteResult(res);
        return;
    }
    if (startsWith(line, "append ")) {
        const nt = parseNameText(line[7..]) orelse {
            uartPrint("usage: append <name> <txt>\n");
            return;
        };
        const res = fsWrite(nt.name, nt.text, true);
        reportFsWriteResult(res);
        return;
    }
    if (startsWith(line, "rm ")) {
        const name = trimSpaces(line[3..]);
        if (name.len == 0) {
            uartPrint("usage: rm <name>\n");
            return;
        }
        if (fsRemove(name)) {
            uartPrint("removed\n");
        } else {
            uartPrint("not found\n");
        }
        return;
    }
    if (strEq(line, "blkprobe")) {
        blkProbe();
        return;
    }
    if (startsWith(line, "blkread ")) {
        const arg = trimSpaces(line[8..]);
        const sector = parseU64(arg) orelse {
            uartPrint("usage: blkread <sector>\n");
            return;
        };
        blkReadCmd(sector);
        return;
    }
    if (startsWith(line, "blkwrite ")) {
        const nt = parseNameText(line[9..]) orelse {
            uartPrint("usage: blkwrite <sector> <txt>\n");
            return;
        };
        const sector = parseU64(nt.name) orelse {
            uartPrint("usage: blkwrite <sector> <txt>\n");
            return;
        };
        blkWriteCmd(sector, nt.text);
        return;
    }
    if (strEq(line, "blkdebug")) {
        blkDebug();
        return;
    }
    if (strEq(line, "mouse")) {
        mouseStatusCmd();
        return;
    }
    if (strEq(line, "gfxprobe")) {
        gfxProbeCmd();
        return;
    }
    if (strEq(line, "gfxclear")) {
        gfxFillCmd(0, 0, 0);
        return;
    }
    if (strEq(line, "gfxlogo")) {
        gfxLogoCmd();
        return;
    }
    if (startsWith(line, "gfxfill ")) {
        const rgb = parseRgbArgs(line[8..]) orelse {
            uartPrint("usage: gfxfill <r> <g> <b> (0..255)\n");
            return;
        };
        gfxFillCmd(rgb.r, rgb.g, rgb.b);
        return;
    }
    if (strEq(line, "mkfs")) {
        fsMkfsCmd();
        return;
    }
    if (strEq(line, "fssave")) {
        fsSaveCmd();
        return;
    }
    if (strEq(line, "fsload")) {
        fsLoadCmd();
        return;
    }
    if (strEq(line, "fsstat")) {
        fsStatCmd();
        return;
    }
    if (strEq(line, "space list")) {
        uxSpaceListCmd();
        return;
    }
    if (startsWith(line, "space add ")) {
        const arg = parseSingleArgMaybeQuoted(line[10..]) orelse {
            uartPrint("usage: space add <name>\n");
            uartPrint("   or: space add \"my space\"\n");
            return;
        };
        uxSpaceAddCmd(arg);
        return;
    }
    if (startsWith(line, "space use ")) {
        const arg = parseSingleArgMaybeQuoted(line[10..]) orelse {
            uartPrint("usage: space use <name>\n");
            uartPrint("   or: space use \"my space\"\n");
            return;
        };
        uxSpaceUseCmd(arg);
        return;
    }
    if (startsWith(line, "space rm ")) {
        const arg = parseSingleArgMaybeQuoted(line[9..]) orelse {
            uartPrint("usage: space rm <name>\n");
            uartPrint("   or: space rm \"my space\"\n");
            return;
        };
        uxSpaceRmCmd(arg);
        return;
    }
    if (strEq(line, "item list")) {
        uxItemListCmd(.all);
        return;
    }
    if (startsWith(line, "item list ")) {
        const f = parseItemListFilter(trimSpaces(line[10..])) orelse {
            uartPrint("usage: item list [status:open|status:done]\n");
            return;
        };
        uxItemListCmd(f);
        return;
    }
    if (startsWith(line, "item add ")) {
        const nt = parseItemAddArgs(line[9..]) orelse {
            uartPrint("usage: item add <title> <text>\n");
            uartPrint("   or: item add \"my title\" \"my longer text\"\n");
            return;
        };
        uxItemAddCmd(nt.name, nt.text);
        return;
    }
    if (startsWith(line, "item show ")) {
        const id = parseU64(trimSpaces(line[10..])) orelse {
            uartPrint("usage: item show <id>\n");
            return;
        };
        uxItemShowCmd(@intCast(id));
        return;
    }
    if (startsWith(line, "item tag ")) {
        const nt = parseIdTextArgs(line[9..]) orelse {
            uartPrint("usage: item tag <id> <tags>\n");
            uartPrint("   or: item tag <id> \"tags with spaces\"\n");
            return;
        };
        const id = parseU64(nt.name) orelse {
            uartPrint("usage: item tag <id> <tags>\n");
            return;
        };
        uxItemTagCmd(@intCast(id), nt.text);
        return;
    }
    if (startsWith(line, "item rm ")) {
        const id = parseU64(trimSpaces(line[8..])) orelse {
            uartPrint("usage: item rm <id>\n");
            return;
        };
        uxItemRmCmd(@intCast(id));
        return;
    }
    if (startsWith(line, "item done ")) {
        const id = parseU64(trimSpaces(line[10..])) orelse {
            uartPrint("usage: item done <id>\n");
            return;
        };
        uxItemSetDoneCmd(@intCast(id), true);
        return;
    }
    if (startsWith(line, "item reopen ")) {
        const id = parseU64(trimSpaces(line[12..])) orelse {
            uartPrint("usage: item reopen <id>\n");
            return;
        };
        uxItemSetDoneCmd(@intCast(id), false);
        return;
    }
    if (startsWith(line, "item clone ")) {
        const id = parseU64(trimSpaces(line[11..])) orelse {
            uartPrint("usage: item clone <id>\n");
            return;
        };
        uxItemCloneCmd(@intCast(id));
        return;
    }
    if (startsWith(line, "item edit ")) {
        const nt = parseNameText(line[10..]) orelse {
            uartPrint("usage: item edit <id> title|text|tags <value>\n");
            return;
        };
        const id = parseU64(nt.name) orelse {
            uartPrint("usage: item edit <id> title|text|tags <value>\n");
            return;
        };
        const kv = parseKeyValueMaybeQuoted(nt.text) orelse {
            uartPrint("usage: item edit <id> title|text|tags <value>\n");
            return;
        };
        uxItemEditCmd(@intCast(id), kv.name, kv.text);
        return;
    }
    if (startsWith(line, "item move ")) {
        const nt = parseNameText(line[10..]) orelse {
            uartPrint("usage: item move <id> <space>\n");
            return;
        };
        const id = parseU64(nt.name) orelse {
            uartPrint("usage: item move <id> <space>\n");
            return;
        };
        const space_name = parseSingleArgMaybeQuoted(nt.text) orelse {
            uartPrint("usage: item move <id> <space>\n");
            return;
        };
        uxItemMoveCmd(@intCast(id), space_name);
        return;
    }
    if (startsWith(line, "item find ")) {
        const query = parseSingleArgMaybeQuoted(line[10..]) orelse {
            uartPrint("usage: item find <text>\n");
            return;
        };
        uxItemFindCmd(query);
        return;
    }
    if (startsWith(line, "item filter ")) {
        const arg = trimSpaces(line[12..]);
        uxItemFilterCmd(arg);
        return;
    }
    if (strEq(line, "uxmkfs")) {
        uxMkfsCmd();
        return;
    }
    if (strEq(line, "uxsave")) {
        uxSaveCmd();
        return;
    }
    if (strEq(line, "uxload")) {
        uxLoadCmd();
        return;
    }
    if (strEq(line, "uxstat")) {
        uxStatCmd();
        return;
    }
    if (strEq(line, "exit") or strEq(line, "shutdown")) {
        shutdownSystem();
    }

    uartPrint("unknown command: ");
    uartPrint(line);
    uartPrint("\n");
}

fn startRoundRobinDemo() noreturn {
    uartPrint("starting round-robin user demo (A/B)...\n");
    uartPrint("press 'q' to stop demo and return to shell\n");

    g_scheduler_active = true;
    g_rr_stop_requested = false;
    initTask(&g_tasks[0], &userTaskA);
    initTask(&g_tasks[1], &userTaskB);
    g_current_task = 0;

    const first_sp = stackTop(&g_tasks[0]);
    __enter_user_mode(g_tasks[0].sepc, first_sp);
}

fn initTask(task: *Task, entry: *const fn () callconv(.c) noreturn) void {
    task.frame_ptr = 0;
    task.sepc = @intFromPtr(entry);
    task.started = false;
    task.done = false;
}

fn stackTop(task: *Task) usize {
    return @intFromPtr(&task.stack) + task.stack.len;
}

fn prepareFreshFrame(task: *Task) *[32]usize {
    const frame_addr = stackTop(task) - 256;
    const frame: *[32]usize = @ptrFromInt(frame_addr);
    var i: usize = 0;
    while (i < 32) : (i += 1) frame[i] = 0;
    task.frame_ptr = frame_addr;
    task.started = true;
    return frame;
}

fn handleUserEcall(frame: *[32]usize, sepc: usize) *[32]usize {
    const nr = frame[REG_A7];
    const arg0 = frame[REG_A0];

    switch (nr) {
        SYS_WRITE_CHAR => {
            uartPutc(@intCast(arg0 & 0xff));
            writeSepc(sepc + 4);
            return frame;
        },
        SYS_GET_TICKS => {
            frame[REG_A0] = g_ticks;
            writeSepc(sepc + 4);
            return frame;
        },
        SYS_YIELD => {
            if (!g_scheduler_active) {
                writeSepc(sepc + 4);
                return frame;
            }
            if (g_rr_stop_requested) {
                return returnToShellFromTrap();
            }
            return scheduleNextFromYield(frame, sepc);
        },
        SYS_EXIT => {
            if (!g_scheduler_active) {
                writeSepc(sepc + 4);
                return frame;
            }
            g_tasks[g_current_task].done = true;
            uartPrint("\n[user ");
            uartPutc(g_tasks[g_current_task].name);
            uartPrint("] exit\n");

            const maybe_next = pickNextRunnable(g_current_task);
            if (maybe_next == null) {
                uartPrint("all user tasks finished, halting\n");
                while (true) asm volatile ("wfi");
            }
            const next_idx = maybe_next.?;
            g_current_task = next_idx;
            var next_frame: *[32]usize = undefined;
            if (g_tasks[next_idx].started and g_tasks[next_idx].frame_ptr != 0) {
                next_frame = @ptrFromInt(g_tasks[next_idx].frame_ptr);
            } else {
                next_frame = prepareFreshFrame(&g_tasks[next_idx]);
            }
            writeSepc(g_tasks[next_idx].sepc);
            return next_frame;
        },
        else => {
            frame[REG_A0] = @as(usize, @bitCast(@as(isize, -1)));
            writeSepc(sepc + 4);
            return frame;
        },
    }
}

fn scheduleNextFromYield(frame: *[32]usize, sepc: usize) *[32]usize {
    var current = &g_tasks[g_current_task];
    current.frame_ptr = @intFromPtr(frame);
    current.sepc = sepc + 4;
    current.started = true;

    const maybe_next = pickNextRunnable(g_current_task);
    if (maybe_next == null) {
        writeSepc(current.sepc);
        return frame;
    }
    const next_idx = maybe_next.?;
    g_current_task = next_idx;
    var next_frame: *[32]usize = undefined;

    if (g_tasks[next_idx].started and g_tasks[next_idx].frame_ptr != 0) {
        next_frame = @ptrFromInt(g_tasks[next_idx].frame_ptr);
    } else {
        next_frame = prepareFreshFrame(&g_tasks[next_idx]);
    }

    writeSepc(g_tasks[next_idx].sepc);
    return next_frame;
}

fn returnToShellFromTrap() *[32]usize {
    g_scheduler_active = false;
    g_rr_stop_requested = false;

    setSppSupervisor();
    writeSepc(@intFromPtr(&resumeShellAfterDemo));
    return &g_kernel_resume_frame;
}

fn pickNextRunnable(current_idx: usize) ?usize {
    var i: usize = 1;
    while (i <= g_tasks.len) : (i += 1) {
        const idx = (current_idx + i) % g_tasks.len;
        if (!g_tasks[idx].done) return idx;
    }
    return null;
}

fn userTaskA() callconv(.c) noreturn {
    var n: usize = 0;
    while (true) : (n += 1) {
        _ = userSyscall1(SYS_WRITE_CHAR, 'A');
        if (n % 40 == 0) _ = userSyscall1(SYS_WRITE_CHAR, '\n');
        _ = userSyscall1(SYS_YIELD, 0);
    }
}

fn userTaskB() callconv(.c) noreturn {
    var n: usize = 0;
    while (true) : (n += 1) {
        _ = userSyscall1(SYS_WRITE_CHAR, 'b');
        if (n % 40 == 0) _ = userSyscall1(SYS_WRITE_CHAR, '\n');
        _ = userSyscall1(SYS_YIELD, 0);
    }
}

fn userSyscall1(nr: usize, arg0: usize) usize {
    var ret: usize = 0;
    asm volatile ("ecall"
        : [ret] "={a0}" (ret),
        : [arg0] "{a0}" (arg0),
          [nr] "{a7}" (nr),
    );
    return ret;
}

pub export fn resumeShellAfterDemo() callconv(.c) noreturn {
    const sp_top = @intFromPtr(&_stack_top);
    asm volatile ("mv sp, %[sp]"
        :
        : [sp] "r" (sp_top),
    );
    uartPrint("\n[rrdemo] stopped, back to shell\n");
    shellLoop();
}

fn printPrompt() void {
    uartPrint(SHELL_PROMPT);
}

fn shutdownSystem() noreturn {
    uartPrint("shutting down...\n");
    const ret = sbiCall(
        SBI_EXT_SRST,
        0,
        SBI_SRST_RESET_TYPE_SHUTDOWN,
        SBI_SRST_RESET_REASON_NONE,
        0,
        0,
        0,
        0,
    );
    if (ret.@"error" != 0) {
        uartPrint("shutdown not supported (sbi err=");
        uartPrintDec(ret.@"error");
        uartPrint("), halting\n");
    }
    while (true) {
        asm volatile ("wfi");
    }
}

fn setupTrapAndTimer() void {
    const trap_addr = @intFromPtr(&__trap_vector);
    asm volatile ("csrw stvec, %[addr]"
        :
        : [addr] "r" (trap_addr),
    );

    asm volatile ("csrs sie, %[bits]"
        :
        : [bits] "r" (SIE_STIE),
    );
    asm volatile ("csrs sstatus, %[bits]"
        :
        : [bits] "r" (SSTATUS_SIE),
    );

    scheduleNextTimer();
}

fn scheduleNextTimer() void {
    const next: u64 = readTime() + TIMER_INTERVAL;
    sbiSetTimer(next);
}

fn writeSepc(v: usize) void {
    asm volatile ("csrw sepc, %[v]"
        :
        : [v] "r" (v),
    );
}

fn setSppSupervisor() void {
    const spp_bit: usize = @as(usize, 1) << 8;
    asm volatile ("csrs sstatus, %[bits]"
        :
        : [bits] "r" (spp_bit),
    );
}

fn readTime() u64 {
    const t: usize = asm volatile ("csrr %[ret], time"
        : [ret] "=r" (-> usize),
    );
    return @intCast(t);
}

fn sbiSetTimer(stime: u64) void {
    const ret = sbiCall(
        SBI_EXT_TIME,
        0,
        @as(usize, @intCast(stime)),
        0,
        0,
        0,
        0,
        0,
    );
    if (ret.@"error" != 0) {
        uartPrint("SBI set_timer error=");
        uartPrintDec(ret.@"error");
        uartPrint("\n");
    }
}

const SbiRet = struct {
    @"error": usize,
    value: usize,
};

fn sbiCall(
    ext: usize,
    fid: usize,
    arg0: usize,
    arg1: usize,
    arg2: usize,
    arg3: usize,
    arg4: usize,
    arg5: usize,
) SbiRet {
    var err: usize = 0;
    var val: usize = 0;
    asm volatile ("ecall"
        : [err] "={a0}" (err),
          [val] "={a1}" (val),
        : [in0] "{a0}" (arg0),
          [in1] "{a1}" (arg1),
          [in2] "{a2}" (arg2),
          [in3] "{a3}" (arg3),
          [in4] "{a4}" (arg4),
          [in5] "{a5}" (arg5),
          [inf] "{a6}" (fid),
          [ine] "{a7}" (ext),
    );
    return .{ .@"error" = err, .value = val };
}

fn reportException(scause: usize, sepc: usize, stval: usize) noreturn {
    uartPrint("\nKERNEL EXCEPTION\n");
    uartPrint("scause=0x");
    uartPrintHex(scause);
    uartPrint(" sepc=0x");
    uartPrintHex(sepc);
    uartPrint(" stval=0x");
    uartPrintHex(stval);
    uartPrint("\n");

    switch (scause) {
        SCAUSE_ILLEGAL_INSTR => uartPrint("reason: illegal instruction\n"),
        SCAUSE_BREAKPOINT => uartPrint("reason: breakpoint (panic command)\n"),
        SCAUSE_INST_PAGE_FAULT => uartPrint("reason: instruction page fault\n"),
        SCAUSE_LOAD_PAGE_FAULT => uartPrint("reason: load page fault\n"),
        SCAUSE_STORE_PAGE_FAULT => uartPrint("reason: store page fault\n"),
        else => uartPrint("reason: unhandled\n"),
    }

    while (true) {
        asm volatile ("wfi");
    }
}

fn uartTryGetc() ?u8 {
    const lsr: *volatile u8 = @ptrFromInt(UART_LSR);
    if ((lsr.* & 0x01) == 0) return null;
    const rx: *volatile u8 = @ptrFromInt(UART_RBR);
    return rx.*;
}

fn inputInit() void {
    g_input_head = 0;
    g_input_tail = 0;
    g_input_esc_state = 0;
    g_input_esc_param = 0;
    g_mouse_click_count = 0;
    g_mouse_left_down = false;
    g_mouse_cursor_drawn = false;
}

fn inputPollSources() void {
    if (g_vinput_count > 0) {
        virtioInputPoll();
    }
    while (uartTryGetc()) |ch| {
        inputFeedByte(ch);
    }
}

fn inputFeedByte(ch: u8) void {
    if (g_input_esc_state != 0) {
        if (g_input_esc_state == 1) {
            if (ch == '[') {
                g_input_esc_state = 2;
                g_input_esc_param = 0;
            } else {
                inputPushEvent(.{ .kind = .key, .key = .escape });
                g_input_esc_state = 0;
                inputFeedByte(ch);
            }
            return;
        }

        if (ch >= '0' and ch <= '9') {
            g_input_esc_param = ch;
            return;
        }

        switch (ch) {
            'A' => inputPushEvent(.{ .kind = .key, .key = .up }),
            'B' => inputPushEvent(.{ .kind = .key, .key = .down }),
            'C' => inputPushEvent(.{ .kind = .key, .key = .right }),
            'D' => inputPushEvent(.{ .kind = .key, .key = .left }),
            'H' => inputPushEvent(.{ .kind = .key, .key = .home }),
            'F' => inputPushEvent(.{ .kind = .key, .key = .end }),
            '~' => if (g_input_esc_param == '3') {
                inputPushEvent(.{ .kind = .key, .key = .delete });
            },
            else => {},
        }
        g_input_esc_state = 0;
        g_input_esc_param = 0;
        return;
    }

    switch (ch) {
        0x1b => g_input_esc_state = 1,
        '\r', '\n' => inputPushEvent(.{ .kind = .key, .key = .enter }),
        0x08, 0x7f => inputPushEvent(.{ .kind = .key, .key = .backspace }),
        else => if (ch >= 0x20 and ch < 0x7f) {
            inputPushEvent(.{ .kind = .char, .ch = ch });
        },
    }
}

fn inputPushEvent(ev: InputEvent) void {
    const next = (g_input_tail + 1) % INPUT_QUEUE_MAX;
    if (next == g_input_head) {
        // Queue full: drop oldest to keep newest input responsive.
        g_input_head = (g_input_head + 1) % INPUT_QUEUE_MAX;
    }
    g_input_queue[g_input_tail] = ev;
    g_input_tail = next;
}

fn inputTryPopEvent() ?InputEvent {
    if (g_input_head == g_input_tail) return null;
    const ev = g_input_queue[g_input_head];
    g_input_head = (g_input_head + 1) % INPUT_QUEUE_MAX;
    return ev;
}

fn inputTryPopChar() ?u8 {
    while (inputTryPopEvent()) |ev| {
        switch (ev.kind) {
            .char => return ev.ch,
            .key => switch (ev.key) {
                .enter => return '\n',
                .backspace => return 0x08,
                else => {},
            },
        }
    }
    return null;
}

fn uartPrint(s: []const u8) void {
    for (s) |ch| uartPutc(ch);
}

fn uartPrintHex(value: usize) void {
    var shift: u6 = 60;
    while (true) {
        const nibble: u8 = @intCast((value >> shift) & 0xF);
        const ch: u8 = if (nibble < 10) ('0' + nibble) else ('a' + (nibble - 10));
        uartPutc(ch);
        if (shift == 0) break;
        shift -= 4;
    }
}

fn uartPrintDec(v: usize) void {
    var buf: [24]u8 = undefined;
    var i: usize = buf.len;
    var value = v;

    if (value == 0) {
        uartPutc('0');
        return;
    }

    while (value > 0) {
        i -= 1;
        buf[i] = @intCast('0' + (value % 10));
        value /= 10;
    }
    uartPrint(buf[i..]);
}

fn uartPutc(ch: u8) void {
    const tx: *volatile u8 = @ptrFromInt(UART_THR);
    tx.* = ch;
    gfxMirrorUartChar(ch);
}

fn strEq(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    var i: usize = 0;
    while (i < a.len) : (i += 1) {
        if (a[i] != b[i]) return false;
    }
    return true;
}

fn startsWith(s: []const u8, prefix: []const u8) bool {
    if (s.len < prefix.len) return false;
    var i: usize = 0;
    while (i < prefix.len) : (i += 1) {
        if (s[i] != prefix[i]) return false;
    }
    return true;
}

fn asciiLower(ch: u8) u8 {
    if (ch >= 'A' and ch <= 'Z') return ch + 32;
    return ch;
}

fn containsAsciiNoCase(hay: []const u8, needle: []const u8) bool {
    if (needle.len == 0) return true;
    if (hay.len < needle.len) return false;

    var i: usize = 0;
    while (i + needle.len <= hay.len) : (i += 1) {
        var j: usize = 0;
        while (j < needle.len and asciiLower(hay[i + j]) == asciiLower(needle[j])) : (j += 1) {}
        if (j == needle.len) return true;
    }
    return false;
}

fn redrawLine(line: []const u8, cursor: usize) void {
    uartPrint("\r\x1b[2K");
    printPrompt();
    uartPrint(line);
    if (line.len > cursor) {
        ansiMoveLeft(line.len - cursor);
    }
}

fn ansiMoveLeft(n: usize) void {
    if (n == 0) return;
    uartPrint("\x1b[");
    uartPrintDec(n);
    uartPrint("D");
}

fn historyAdd(line: []const u8) void {
    if (line.len == 0) return;
    if (g_history_count > 0) {
        const latest = historyGet(0);
        if (strEq(latest, line)) return;
    }

    const slot = g_history_next;
    g_history_len[slot] = @intCast(if (line.len > 128) 128 else line.len);
    copySlice(g_history_data[slot][0..], line[0..g_history_len[slot]]);

    g_history_next = (g_history_next + 1) % HISTORY_MAX;
    if (g_history_count < HISTORY_MAX) g_history_count += 1;
}

fn historyGet(nav: usize) []const u8 {
    const idx = (g_history_next + HISTORY_MAX - 1 - nav) % HISTORY_MAX;
    return g_history_data[idx][0..g_history_len[idx]];
}

fn blkProbe() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    uartPrint("virtio-blk: ready, capacity(sectors)=");
    uartPrintDec(@intCast(g_virtio_capacity_sectors));
    uartPrint(" bytes=");
    uartPrintDec(@intCast(g_virtio_capacity_sectors * 512));
    uartPrint("\n");
}

fn blkReadCmd(sector: u64) void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (sector >= g_virtio_capacity_sectors) {
        uartPrint("sector out of range\n");
        return;
    }

    var buf: [512]u8 = [_]u8{0} ** 512;
    if (!virtioBlkRw(sector, false, &buf)) {
        uartPrint("blk read failed\n");
        return;
    }
    uartPrint("sector ");
    uartPrintDec(@intCast(sector));
    uartPrint(": ");
    printPreview(&buf);
    uartPrint("\n");
}

fn blkWriteCmd(sector: u64, text: []const u8) void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (sector >= g_virtio_capacity_sectors) {
        uartPrint("sector out of range\n");
        return;
    }

    var buf: [512]u8 = [_]u8{0} ** 512;
    const n = if (text.len > 512) 512 else text.len;
    copySlice(buf[0..], text[0..n]);
    if (!virtioBlkRw(sector, true, &buf)) {
        uartPrint("blk write failed\n");
        return;
    }
    uartPrint("blk write ok\n");
}

fn printPreview(buf: *const [512]u8) void {
    var i: usize = 0;
    while (i < 64) : (i += 1) {
        const ch = buf[i];
        if (ch == 0) break;
        if (ch < 0x20 or ch > 0x7e) {
            uartPutc('.');
        } else {
            uartPutc(ch);
        }
    }
}

fn virtioBlkInit() void {
    const maybe_base = findVirtioBlkBase();
    if (maybe_base == null) return;
    g_virtio_base = maybe_base.?;
    const version = mmioRead32(0x004);
    if (version != 2) return;

    mmioWrite32(0x070, 0);
    mmioWrite32(0x070, 1);
    mmioWrite32(0x070, 1 | 2);

    mmioWrite32(0x014, 0);
    const dev_feat_lo = mmioRead32(0x010);
    mmioWrite32(0x014, 1);
    const dev_feat_hi = mmioRead32(0x010);

    const drv_feat_lo: u32 = 0;
    var drv_feat_hi: u32 = 0;
    _ = dev_feat_lo;
    if ((dev_feat_hi & VIRTIO_F_VERSION_1) == 0) return;
    drv_feat_hi |= VIRTIO_F_VERSION_1;

    mmioWrite32(0x024, 0);
    mmioWrite32(0x020, drv_feat_lo);
    mmioWrite32(0x024, 0);
    mmioWrite32(0x020, drv_feat_lo);
    mmioWrite32(0x024, 1);
    mmioWrite32(0x020, drv_feat_hi);

    mmioWrite32(0x070, 1 | 2 | 8);
    const status = mmioRead32(0x070);
    if ((status & 8) == 0) return;

    mmioWrite32(0x030, 0);
    const qmax = mmioRead32(0x034);
    if (qmax < VIRTIO_QUEUE_SIZE) return;

    mmioWrite32(0x038, VIRTIO_QUEUE_SIZE);

    const desc_addr = @intFromPtr(&g_virtio_desc);
    const avail_addr = @intFromPtr(&g_virtio_avail);
    const used_addr = @intFromPtr(&g_virtio_used);
    mmioWrite32(0x080, @intCast(desc_addr & 0xffff_ffff));
    mmioWrite32(0x084, @intCast(desc_addr >> 32));
    mmioWrite32(0x090, @intCast(avail_addr & 0xffff_ffff));
    mmioWrite32(0x094, @intCast(avail_addr >> 32));
    mmioWrite32(0x0a0, @intCast(used_addr & 0xffff_ffff));
    mmioWrite32(0x0a4, @intCast(used_addr >> 32));

    mmioWrite32(0x044, 1);
    mmioWrite32(0x070, 1 | 2 | 8 | 4);

    const cap_lo = mmioRead32(0x100);
    const cap_hi = mmioRead32(0x104);
    g_virtio_capacity_sectors = (@as(u64, cap_hi) << 32) | @as(u64, cap_lo);
    g_virtio_last_used_idx = g_virtio_used.idx;
    g_virtio_ready = true;
}

fn virtioBlkRw(sector: u64, write: bool, data: *[512]u8) bool {
    if (!g_virtio_ready) return false;

    g_virtio_req.req_type = if (write) VIRTIO_BLK_T_OUT else VIRTIO_BLK_T_IN;
    g_virtio_req.reserved = 0;
    g_virtio_req.sector = sector;
    g_virtio_status = 0xff;

    if (write) {
        copySlice(g_virtio_data[0..], data[0..]);
    }

    g_virtio_desc[0] = .{
        .addr = @intCast(@intFromPtr(&g_virtio_req)),
        .len = @sizeOf(VirtioBlkReq),
        .flags = 1,
        .next = 1,
    };
    g_virtio_desc[1] = .{
        .addr = @intCast(@intFromPtr(&g_virtio_data)),
        .len = 512,
        .flags = if (write) 1 else 1 | 2,
        .next = 2,
    };
    g_virtio_desc[2] = .{
        .addr = @intCast(@intFromPtr(&g_virtio_status)),
        .len = 1,
        .flags = 2,
        .next = 0,
    };

    const avail_idx: u16 = g_virtio_avail.idx;
    g_virtio_avail.ring[avail_idx % VIRTIO_QUEUE_SIZE] = 0;
    asm volatile ("fence rw, rw");
    g_virtio_avail.idx +%= 1;
    mmioWrite32(0x050, 0);

    var guard: usize = 0;
    while (g_virtio_used.idx == g_virtio_last_used_idx and guard < 2_000_000) : (guard += 1) {}
    if (g_virtio_used.idx == g_virtio_last_used_idx) return false;
    g_virtio_last_used_idx = g_virtio_used.idx;

    const isr = mmioRead32(0x060);
    if (isr != 0) mmioWrite32(0x064, isr);
    if (g_virtio_status != 0) return false;

    if (!write) {
        copySlice(data[0..], g_virtio_data[0..]);
    }
    return true;
}

fn virtioInputInit() void {
    g_vinput_count = 0;
    var i: usize = 0;
    while (i < g_vinput_devices.len) : (i += 1) {
        g_vinput_devices[i] = .{};
    }

    var slot: usize = 0;
    while (slot < VIRTIO_MMIO_SLOTS and g_vinput_count < VIRTIO_INPUT_DEV_MAX) : (slot += 1) {
        const base = VIRTIO_MMIO_BASE_START + (slot * VIRTIO_MMIO_STRIDE);
        if (mmioRead32At(base, 0x000) != 0x7472_6976) continue;
        if (mmioRead32At(base, 0x004) != 2) continue;
        if (mmioRead32At(base, 0x008) != 18) continue; // virtio-input

        if (virtioInputInitDevice(base, &g_vinput_devices[g_vinput_count])) {
            g_vinput_count += 1;
        }
    }
}

fn virtioInputPoll() void {
    var i: usize = 0;
    while (i < g_vinput_count) : (i += 1) {
        const dev = &g_vinput_devices[i];
        while (dev.used.idx != dev.last_used_idx) {
            const ring_idx: usize = dev.last_used_idx % VIRTIO_INPUT_QUEUE_SIZE;
            const elem = dev.used.ring[ring_idx];
            const id: usize = @intCast(elem.id);
            if (id < VIRTIO_INPUT_QUEUE_SIZE) {
                virtioInputProcessEvent(dev.events[id]);

                const aidx = dev.avail.idx;
                dev.avail.ring[aidx % VIRTIO_INPUT_QUEUE_SIZE] = @intCast(id);
                asm volatile ("fence rw, rw");
                dev.avail.idx +%= 1;
                mmioWrite32At(dev.base, 0x050, 0);
            }
            dev.last_used_idx +%= 1;
        }
    }
}

fn virtioInputInitDevice(base: usize, dev: *VInputDevice) bool {
    dev.* = .{};
    dev.base = base;
    if (mmioRead32At(base, 0x004) != 2) return false;

    mmioWrite32At(base, 0x070, 0);
    mmioWrite32At(base, 0x070, 1);
    mmioWrite32At(base, 0x070, 1 | 2);

    mmioWrite32At(base, 0x014, 0);
    _ = mmioRead32At(base, 0x010);
    mmioWrite32At(base, 0x014, 1);
    const dev_feat_hi = mmioRead32At(base, 0x010);
    if ((dev_feat_hi & VIRTIO_F_VERSION_1) == 0) return false;

    mmioWrite32At(base, 0x024, 0);
    mmioWrite32At(base, 0x020, 0);
    mmioWrite32At(base, 0x024, 1);
    mmioWrite32At(base, 0x020, VIRTIO_F_VERSION_1);

    mmioWrite32At(base, 0x070, 1 | 2 | 8);
    if ((mmioRead32At(base, 0x070) & 8) == 0) return false;

    mmioWrite32At(base, 0x030, 0);
    const qmax = mmioRead32At(base, 0x034);
    if (qmax < VIRTIO_INPUT_QUEUE_SIZE) return false;
    mmioWrite32At(base, 0x038, VIRTIO_INPUT_QUEUE_SIZE);

    const desc_addr = @intFromPtr(&dev.desc);
    const avail_addr = @intFromPtr(&dev.avail);
    const used_addr = @intFromPtr(&dev.used);
    mmioWrite32At(base, 0x080, @intCast(desc_addr & 0xffff_ffff));
    mmioWrite32At(base, 0x084, @intCast(desc_addr >> 32));
    mmioWrite32At(base, 0x090, @intCast(avail_addr & 0xffff_ffff));
    mmioWrite32At(base, 0x094, @intCast(avail_addr >> 32));
    mmioWrite32At(base, 0x0a0, @intCast(used_addr & 0xffff_ffff));
    mmioWrite32At(base, 0x0a4, @intCast(used_addr >> 32));

    var i: usize = 0;
    while (i < VIRTIO_INPUT_QUEUE_SIZE) : (i += 1) {
        dev.events[i] = .{ .ev_type = 0, .code = 0, .value = 0 };
        dev.desc[i] = .{
            .addr = @intCast(@intFromPtr(&dev.events[i])),
            .len = @sizeOf(VirtioInputEvent),
            .flags = 2,
            .next = 0,
        };
        dev.avail.ring[i] = @intCast(i);
    }
    dev.avail.idx = VIRTIO_INPUT_QUEUE_SIZE;
    dev.last_used_idx = dev.used.idx;

    mmioWrite32At(base, 0x044, 1);
    mmioWrite32At(base, 0x070, 1 | 2 | 8 | 4);
    mmioWrite32At(base, 0x050, 0);
    dev.ready = true;
    return true;
}

fn virtioInputProcessEvent(ev: VirtioInputEvent) void {
    // Linux input event types/codes used by virtio-input.
    const EV_KEY: u16 = 1;
    const EV_REL: u16 = 2;
    const BTN_LEFT: u16 = 272;
    const REL_X: u16 = 0;
    const REL_Y: u16 = 1;

    if (ev.ev_type == EV_REL and g_vgpu_width > 0 and g_vgpu_height > 0) {
        const delta: i32 = @bitCast(ev.value);
        if (ev.code == REL_X) {
            gfxMouseCursorMoveTo(g_mouse_x + delta, g_mouse_y);
        } else if (ev.code == REL_Y) {
            gfxMouseCursorMoveTo(g_mouse_x, g_mouse_y + delta);
        }
        return;
    }

    if (ev.ev_type != EV_KEY) return;

    if (ev.code == BTN_LEFT) {
        const pressed = ev.value != 0;
        if (pressed and !g_mouse_left_down) {
            g_mouse_left_down = true;
            g_mouse_click_count +%= 1;
            gfxMouseClickFlash(g_mouse_x, g_mouse_y);
        } else if (!pressed and g_mouse_left_down) {
            g_mouse_left_down = false;
        }
        return;
    }

    if (ev.value == 0) return; // ignore release for keyboard mapping
    if (ev.value != 1 and ev.value != 2) return; // press/repeat
    if (mapLinuxKeyToInput(ev.code)) |ie| inputPushEvent(ie);
}

fn mapLinuxKeyToInput(code: u16) ?InputEvent {
    return switch (code) {
        14 => .{ .kind = .key, .key = .backspace },
        28 => .{ .kind = .key, .key = .enter },
        1 => .{ .kind = .key, .key = .escape },
        103 => .{ .kind = .key, .key = .up },
        108 => .{ .kind = .key, .key = .down },
        105 => .{ .kind = .key, .key = .left },
        106 => .{ .kind = .key, .key = .right },
        102 => .{ .kind = .key, .key = .home },
        107 => .{ .kind = .key, .key = .end },
        111 => .{ .kind = .key, .key = .delete },
        57 => .{ .kind = .char, .ch = ' ' },
        2 => .{ .kind = .char, .ch = '1' },
        3 => .{ .kind = .char, .ch = '2' },
        4 => .{ .kind = .char, .ch = '3' },
        5 => .{ .kind = .char, .ch = '4' },
        6 => .{ .kind = .char, .ch = '5' },
        7 => .{ .kind = .char, .ch = '6' },
        8 => .{ .kind = .char, .ch = '7' },
        9 => .{ .kind = .char, .ch = '8' },
        10 => .{ .kind = .char, .ch = '9' },
        11 => .{ .kind = .char, .ch = '0' },
        12 => .{ .kind = .char, .ch = '-' },
        13 => .{ .kind = .char, .ch = '=' },
        15 => .{ .kind = .char, .ch = '\t' },
        16 => .{ .kind = .char, .ch = 'q' },
        17 => .{ .kind = .char, .ch = 'w' },
        18 => .{ .kind = .char, .ch = 'e' },
        19 => .{ .kind = .char, .ch = 'r' },
        20 => .{ .kind = .char, .ch = 't' },
        21 => .{ .kind = .char, .ch = 'y' },
        22 => .{ .kind = .char, .ch = 'u' },
        23 => .{ .kind = .char, .ch = 'i' },
        24 => .{ .kind = .char, .ch = 'o' },
        25 => .{ .kind = .char, .ch = 'p' },
        26 => .{ .kind = .char, .ch = '[' },
        27 => .{ .kind = .char, .ch = ']' },
        30 => .{ .kind = .char, .ch = 'a' },
        31 => .{ .kind = .char, .ch = 's' },
        32 => .{ .kind = .char, .ch = 'd' },
        33 => .{ .kind = .char, .ch = 'f' },
        34 => .{ .kind = .char, .ch = 'g' },
        35 => .{ .kind = .char, .ch = 'h' },
        36 => .{ .kind = .char, .ch = 'j' },
        37 => .{ .kind = .char, .ch = 'k' },
        38 => .{ .kind = .char, .ch = 'l' },
        39 => .{ .kind = .char, .ch = ';' },
        40 => .{ .kind = .char, .ch = '\'' },
        41 => .{ .kind = .char, .ch = '`' },
        43 => .{ .kind = .char, .ch = '\\' },
        44 => .{ .kind = .char, .ch = 'z' },
        45 => .{ .kind = .char, .ch = 'x' },
        46 => .{ .kind = .char, .ch = 'c' },
        47 => .{ .kind = .char, .ch = 'v' },
        48 => .{ .kind = .char, .ch = 'b' },
        49 => .{ .kind = .char, .ch = 'n' },
        50 => .{ .kind = .char, .ch = 'm' },
        51 => .{ .kind = .char, .ch = ',' },
        52 => .{ .kind = .char, .ch = '.' },
        53 => .{ .kind = .char, .ch = '/' },
        else => null,
    };
}

fn virtioGpuInit() void {
    g_vgpu_ready = false;

    const maybe_base = findVirtioGpuBase();
    if (maybe_base == null) return;
    g_vgpu_base = maybe_base.?;
    if (mmioRead32At(g_vgpu_base, 0x004) != 2) return;

    mmioWrite32At(g_vgpu_base, 0x070, 0);
    mmioWrite32At(g_vgpu_base, 0x070, 1);
    mmioWrite32At(g_vgpu_base, 0x070, 1 | 2);

    mmioWrite32At(g_vgpu_base, 0x014, 0);
    _ = mmioRead32At(g_vgpu_base, 0x010);
    mmioWrite32At(g_vgpu_base, 0x014, 1);
    const dev_feat_hi = mmioRead32At(g_vgpu_base, 0x010);
    if ((dev_feat_hi & VIRTIO_F_VERSION_1) == 0) return;

    mmioWrite32At(g_vgpu_base, 0x024, 0);
    mmioWrite32At(g_vgpu_base, 0x020, 0);
    mmioWrite32At(g_vgpu_base, 0x024, 1);
    mmioWrite32At(g_vgpu_base, 0x020, VIRTIO_F_VERSION_1);

    mmioWrite32At(g_vgpu_base, 0x070, 1 | 2 | 8);
    if ((mmioRead32At(g_vgpu_base, 0x070) & 8) == 0) return;

    mmioWrite32At(g_vgpu_base, 0x030, 0);
    const qmax = mmioRead32At(g_vgpu_base, 0x034);
    if (qmax < VIRTIO_GPU_QUEUE_SIZE) return;
    mmioWrite32At(g_vgpu_base, 0x038, VIRTIO_GPU_QUEUE_SIZE);

    const desc_addr = @intFromPtr(&g_vgpu_desc);
    const avail_addr = @intFromPtr(&g_vgpu_avail);
    const used_addr = @intFromPtr(&g_vgpu_used);
    mmioWrite32At(g_vgpu_base, 0x080, @intCast(desc_addr & 0xffff_ffff));
    mmioWrite32At(g_vgpu_base, 0x084, @intCast(desc_addr >> 32));
    mmioWrite32At(g_vgpu_base, 0x090, @intCast(avail_addr & 0xffff_ffff));
    mmioWrite32At(g_vgpu_base, 0x094, @intCast(avail_addr >> 32));
    mmioWrite32At(g_vgpu_base, 0x0a0, @intCast(used_addr & 0xffff_ffff));
    mmioWrite32At(g_vgpu_base, 0x0a4, @intCast(used_addr >> 32));

    g_vgpu_avail.flags = 0;
    g_vgpu_avail.idx = 0;
    g_vgpu_used.flags = 0;
    g_vgpu_used.idx = 0;
    g_vgpu_last_used_idx = 0;

    mmioWrite32At(g_vgpu_base, 0x044, 1);
    mmioWrite32At(g_vgpu_base, 0x070, 1 | 2 | 8 | 4);

    if (!virtioGpuReadDisplayInfo()) return;

    var width = g_vgpu_resp_display_info.pmodes[0].rect.width;
    var height = g_vgpu_resp_display_info.pmodes[0].rect.height;
    if (width == 0) width = 640;
    if (height == 0) height = 480;
    if (width > GFX_FB_MAX_W) width = GFX_FB_MAX_W;
    if (height > GFX_FB_MAX_H) height = GFX_FB_MAX_H;
    g_vgpu_width = width;
    g_vgpu_height = height;
    g_mouse_x = @intCast(g_vgpu_width / 2);
    g_mouse_y = @intCast(g_vgpu_height / 2);
    g_mouse_left_down = false;
    g_mouse_cursor_drawn = false;

    if (!virtioGpuSetupPrimaryResource()) return;
    if (!gfxRenderZenithBootScreen()) return;
    g_vgpu_ready = true;
    gfxConsoleReset();
    gfxShellRenderInput("");
    gfxConsoleRender();
}

fn virtioGpuReadDisplayInfo() bool {
    g_vgpu_req_display_info = .{
        .ctrl_type = VIRTIO_GPU_CMD_GET_DISPLAY_INFO,
        .flags = 0,
        .fence_id = 0,
        .ctx_id = 0,
        .padding = 0,
    };
    g_vgpu_resp_display_info.hdr.ctrl_type = 0;

    if (!virtioGpuExec(
        @intFromPtr(&g_vgpu_req_display_info),
        @sizeOf(VirtioGpuCtrlHdr),
        @intFromPtr(&g_vgpu_resp_display_info),
        @sizeOf(VirtioGpuRespDisplayInfo),
    )) return false;

    return g_vgpu_resp_display_info.hdr.ctrl_type == VIRTIO_GPU_RESP_OK_DISPLAY_INFO;
}

fn virtioGpuSetupPrimaryResource() bool {
    const fb_bytes_u64: u64 = @as(u64, g_vgpu_width) * @as(u64, g_vgpu_height) * 4;
    if (fb_bytes_u64 == 0 or fb_bytes_u64 > @as(u64, @sizeOf(@TypeOf(g_vgpu_fb)))) return false;
    const fb_bytes: u32 = @intCast(fb_bytes_u64);

    g_vgpu_req_create_2d = .{
        .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_RESOURCE_CREATE_2D, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
        .resource_id = g_vgpu_resource_id,
        .format = VIRTIO_GPU_FORMAT_B8G8R8X8_UNORM,
        .width = g_vgpu_width,
        .height = g_vgpu_height,
    };
    if (!virtioGpuExec(
        @intFromPtr(&g_vgpu_req_create_2d),
        @sizeOf(VirtioGpuResourceCreate2d),
        @intFromPtr(&g_vgpu_resp_nodata),
        @sizeOf(VirtioGpuRespNoData),
    )) return false;
    if (g_vgpu_resp_nodata.hdr.ctrl_type != VIRTIO_GPU_RESP_OK_NODATA) return false;

    g_vgpu_req_attach = .{
        .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_RESOURCE_ATTACH_BACKING, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
        .resource_id = g_vgpu_resource_id,
        .nr_entries = 1,
        .entry = .{
            .addr = @intCast(@intFromPtr(&g_vgpu_fb)),
            .length = fb_bytes,
            .padding = 0,
        },
    };
    if (!virtioGpuExec(
        @intFromPtr(&g_vgpu_req_attach),
        @sizeOf(VirtioGpuResourceAttachBacking),
        @intFromPtr(&g_vgpu_resp_nodata),
        @sizeOf(VirtioGpuRespNoData),
    )) return false;
    if (g_vgpu_resp_nodata.hdr.ctrl_type != VIRTIO_GPU_RESP_OK_NODATA) return false;

    g_vgpu_req_set_scanout = .{
        .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_SET_SCANOUT, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
        .rect = .{ .x = 0, .y = 0, .width = g_vgpu_width, .height = g_vgpu_height },
        .scanout_id = 0,
        .resource_id = g_vgpu_resource_id,
    };
    if (!virtioGpuExec(
        @intFromPtr(&g_vgpu_req_set_scanout),
        @sizeOf(VirtioGpuSetScanout),
        @intFromPtr(&g_vgpu_resp_nodata),
        @sizeOf(VirtioGpuRespNoData),
    )) return false;
    return g_vgpu_resp_nodata.hdr.ctrl_type == VIRTIO_GPU_RESP_OK_NODATA;
}

fn colorRgb(r: u8, g: u8, b: u8) u32 {
    return @as(u32, b) | (@as(u32, g) << 8) | (@as(u32, r) << 16);
}

fn iabs(v: i32) i32 {
    return if (v < 0) -v else v;
}

fn imax(a: i32, b: i32) i32 {
    return if (a > b) a else b;
}

fn clampi32(v: i32, lo: i32, hi: i32) i32 {
    if (v < lo) return lo;
    if (v > hi) return hi;
    return v;
}

fn fbSetPixel(x: i32, y: i32, px: u32) void {
    if (x < 0 or y < 0) return;
    const ux: usize = @intCast(x);
    const uy: usize = @intCast(y);
    const w: usize = @intCast(g_vgpu_width);
    const h: usize = @intCast(g_vgpu_height);
    if (ux >= w or uy >= h) return;
    const idx = uy * w + ux;
    if (idx < g_vgpu_fb.len) g_vgpu_fb[idx] = px;
}

fn gfxMouseCursorRestore() void {
    if (!g_mouse_cursor_drawn) return;
    const sx = g_mouse_cursor_saved_x;
    const sy = g_mouse_cursor_saved_y;
    const sw: i32 = @intCast(g_mouse_cursor_saved_w);
    const sh: i32 = @intCast(g_mouse_cursor_saved_h);
    if (sw <= 0 or sh <= 0) {
        g_mouse_cursor_drawn = false;
        return;
    }

    var y: i32 = 0;
    while (y < sh) : (y += 1) {
        var x: i32 = 0;
        while (x < sw) : (x += 1) {
            const src_idx: usize = @intCast(y * @as(i32, MOUSE_CURSOR_SAVE_W) + x);
            fbSetPixel(sx + x, sy + y, g_mouse_cursor_saved[src_idx]);
        }
    }
    _ = gfxFlushRect(@intCast(sx), @intCast(sy), @intCast(sw), @intCast(sh));
    g_mouse_cursor_drawn = false;
}

fn gfxMouseCursorDraw() void {
    if (!g_vgpu_ready) return;
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return;

    const half_w: i32 = @divTrunc(@as(i32, MOUSE_CURSOR_SAVE_W), 2);
    const half_h: i32 = @divTrunc(@as(i32, MOUSE_CURSOR_SAVE_H), 2);
    var x0 = g_mouse_x - half_w;
    var y0 = g_mouse_y - half_h;
    var x1 = x0 + @as(i32, MOUSE_CURSOR_SAVE_W);
    var y1 = y0 + @as(i32, MOUSE_CURSOR_SAVE_H);
    const fbw: i32 = @intCast(g_vgpu_width);
    const fbh: i32 = @intCast(g_vgpu_height);
    if (x0 < 0) x0 = 0;
    if (y0 < 0) y0 = 0;
    if (x1 > fbw) x1 = fbw;
    if (y1 > fbh) y1 = fbh;
    if (x0 >= x1 or y0 >= y1) return;

    const sw: i32 = x1 - x0;
    const sh: i32 = y1 - y0;
    g_mouse_cursor_saved_x = x0;
    g_mouse_cursor_saved_y = y0;
    g_mouse_cursor_saved_w = @intCast(sw);
    g_mouse_cursor_saved_h = @intCast(sh);

    var y: i32 = 0;
    while (y < sh) : (y += 1) {
        var x: i32 = 0;
        while (x < sw) : (x += 1) {
            const ux: usize = @intCast(x0 + x);
            const uy: usize = @intCast(y0 + y);
            const fb_idx = uy * @as(usize, @intCast(g_vgpu_width)) + ux;
            const dst_idx: usize = @intCast(y * @as(i32, MOUSE_CURSOR_SAVE_W) + x);
            g_mouse_cursor_saved[dst_idx] = g_vgpu_fb[fb_idx];
        }
    }

    const col_main = colorRgb(250, 250, 250);
    const col_accent = colorRgb(255, 176, 48);
    var d: i32 = -6;
    while (d <= 6) : (d += 1) {
        fbSetPixel(g_mouse_x + d, g_mouse_y, col_main);
        fbSetPixel(g_mouse_x, g_mouse_y + d, col_main);
    }
    fbSetPixel(g_mouse_x, g_mouse_y, col_accent);
    fbSetPixel(g_mouse_x - 1, g_mouse_y, col_accent);
    fbSetPixel(g_mouse_x + 1, g_mouse_y, col_accent);
    fbSetPixel(g_mouse_x, g_mouse_y - 1, col_accent);
    fbSetPixel(g_mouse_x, g_mouse_y + 1, col_accent);

    _ = gfxFlushRect(@intCast(x0), @intCast(y0), @intCast(sw), @intCast(sh));
    g_mouse_cursor_drawn = true;
}

fn gfxMouseCursorMoveTo(x: i32, y: i32) void {
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return;
    gfxMouseCursorRestore();
    g_mouse_x = clampi32(x, 0, @as(i32, @intCast(g_vgpu_width - 1)));
    g_mouse_y = clampi32(y, 0, @as(i32, @intCast(g_vgpu_height - 1)));
    gfxMouseCursorDraw();
}

fn gfxMouseCursorRebuild() void {
    if (!g_vgpu_ready) return;
    g_mouse_cursor_drawn = false;
    gfxMouseCursorDraw();
}

fn gfxMouseCursorRedrawIfOverlap(y0: i32, h: i32) void {
    if (!g_vgpu_ready or !g_mouse_cursor_drawn) return;
    if (h <= 0) return;
    const half: i32 = @divTrunc(@as(i32, MOUSE_CURSOR_SAVE_H), 2);
    const y1 = y0 + h;
    if (g_mouse_y + half < y0 or g_mouse_y - half >= y1) return;
    g_mouse_cursor_drawn = false;
    gfxMouseCursorDraw();
}

fn gfxMouseClickFlash(x: i32, y: i32) void {
    if (!g_vgpu_ready) return;
    gfxMouseCursorRestore();
    const col = colorRgb(255, 184, 64);
    fbFillRect(x - 4, y - 4, 9, 9, col);
    _ = gfxFlushRect(@intCast(if (x > 8) x - 8 else 0), @intCast(if (y > 8) y - 8 else 0), 18, 18);
    gfxMouseCursorDraw();
}

fn fbFillRect(x: i32, y: i32, w: i32, h: i32, px: u32) void {
    if (w <= 0 or h <= 0) return;
    const fbw: i32 = @intCast(g_vgpu_width);
    const fbh: i32 = @intCast(g_vgpu_height);

    var x0 = x;
    var y0 = y;
    var x1 = x + w;
    var y1 = y + h;

    if (x0 < 0) x0 = 0;
    if (y0 < 0) y0 = 0;
    if (x1 > fbw) x1 = fbw;
    if (y1 > fbh) y1 = fbh;
    if (x0 >= x1 or y0 >= y1) return;

    var yy = y0;
    while (yy < y1) : (yy += 1) {
        var xx = x0;
        while (xx < x1) : (xx += 1) {
            fbSetPixel(xx, yy, px);
        }
    }
}

fn fbDrawDisc(cx: i32, cy: i32, r: i32, px: u32) void {
    if (r <= 0) {
        fbSetPixel(cx, cy, px);
        return;
    }
    var dy = -r;
    while (dy <= r) : (dy += 1) {
        var dx = -r;
        while (dx <= r) : (dx += 1) {
            if (dx * dx + dy * dy <= r * r) {
                fbSetPixel(cx + dx, cy + dy, px);
            }
        }
    }
}

fn fbDrawLineThick(x0: i32, y0: i32, x1: i32, y1: i32, thickness: i32, px: u32) void {
    const radius = if (thickness <= 1) 0 else @divTrunc(thickness, 2);

    var x = x0;
    var y = y0;
    const dx = iabs(x1 - x0);
    const sx: i32 = if (x0 < x1) 1 else -1;
    const dy = -iabs(y1 - y0);
    const sy: i32 = if (y0 < y1) 1 else -1;
    var err = dx + dy;

    while (true) {
        fbDrawDisc(x, y, radius, px);
        if (x == x1 and y == y1) break;
        const e2 = 2 * err;
        if (e2 >= dy) {
            err += dy;
            x += sx;
        }
        if (e2 <= dx) {
            err += dx;
            y += sy;
        }
    }
}

fn glyph5x7(ch: u8) [7]u8 {
    return switch (ch) {
        'A' => [_]u8{ 0b01110, 0b10001, 0b10001, 0b11111, 0b10001, 0b10001, 0b10001 },
        'B' => [_]u8{ 0b11110, 0b10001, 0b10001, 0b11110, 0b10001, 0b10001, 0b11110 },
        'C' => [_]u8{ 0b01111, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b01111 },
        'D' => [_]u8{ 0b11110, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b11110 },
        'Z' => [_]u8{ 0b11111, 0b00001, 0b00010, 0b00100, 0b01000, 0b10000, 0b11111 },
        'E' => [_]u8{ 0b11111, 0b10000, 0b11110, 0b10000, 0b10000, 0b10000, 0b11111 },
        'F' => [_]u8{ 0b11111, 0b10000, 0b11110, 0b10000, 0b10000, 0b10000, 0b10000 },
        'G' => [_]u8{ 0b01111, 0b10000, 0b10000, 0b10011, 0b10001, 0b10001, 0b01110 },
        'N' => [_]u8{ 0b10001, 0b11001, 0b10101, 0b10011, 0b10001, 0b10001, 0b10001 },
        'I' => [_]u8{ 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b11111 },
        'J' => [_]u8{ 0b00001, 0b00001, 0b00001, 0b00001, 0b10001, 0b10001, 0b01110 },
        'K' => [_]u8{ 0b10001, 0b10010, 0b10100, 0b11000, 0b10100, 0b10010, 0b10001 },
        'L' => [_]u8{ 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b11111 },
        'M' => [_]u8{ 0b10001, 0b11011, 0b10101, 0b10101, 0b10001, 0b10001, 0b10001 },
        'T' => [_]u8{ 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100 },
        'H' => [_]u8{ 0b10001, 0b10001, 0b11111, 0b10001, 0b10001, 0b10001, 0b10001 },
        'O' => [_]u8{ 0b01110, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01110 },
        'P' => [_]u8{ 0b11110, 0b10001, 0b10001, 0b11110, 0b10000, 0b10000, 0b10000 },
        'Q' => [_]u8{ 0b01110, 0b10001, 0b10001, 0b10001, 0b10101, 0b10010, 0b01101 },
        'R' => [_]u8{ 0b11110, 0b10001, 0b10001, 0b11110, 0b10100, 0b10010, 0b10001 },
        'S' => [_]u8{ 0b01111, 0b10000, 0b10000, 0b01110, 0b00001, 0b00001, 0b11110 },
        'U' => [_]u8{ 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b10001, 0b01110 },
        'V' => [_]u8{ 0b10001, 0b10001, 0b10001, 0b10001, 0b01010, 0b01010, 0b00100 },
        'W' => [_]u8{ 0b10001, 0b10001, 0b10001, 0b10101, 0b10101, 0b10101, 0b01010 },
        'X' => [_]u8{ 0b10001, 0b10001, 0b01010, 0b00100, 0b01010, 0b10001, 0b10001 },
        'Y' => [_]u8{ 0b10001, 0b10001, 0b01010, 0b00100, 0b00100, 0b00100, 0b00100 },
        '0' => [_]u8{ 0b01110, 0b10001, 0b10011, 0b10101, 0b11001, 0b10001, 0b01110 },
        '1' => [_]u8{ 0b00100, 0b01100, 0b00100, 0b00100, 0b00100, 0b00100, 0b01110 },
        '2' => [_]u8{ 0b01110, 0b10001, 0b00001, 0b00010, 0b00100, 0b01000, 0b11111 },
        '3' => [_]u8{ 0b11110, 0b00001, 0b00001, 0b01110, 0b00001, 0b00001, 0b11110 },
        '4' => [_]u8{ 0b00010, 0b00110, 0b01010, 0b10010, 0b11111, 0b00010, 0b00010 },
        '5' => [_]u8{ 0b11111, 0b10000, 0b10000, 0b11110, 0b00001, 0b00001, 0b11110 },
        '6' => [_]u8{ 0b01110, 0b10000, 0b10000, 0b11110, 0b10001, 0b10001, 0b01110 },
        '7' => [_]u8{ 0b11111, 0b00001, 0b00010, 0b00100, 0b01000, 0b01000, 0b01000 },
        '8' => [_]u8{ 0b01110, 0b10001, 0b10001, 0b01110, 0b10001, 0b10001, 0b01110 },
        '9' => [_]u8{ 0b01110, 0b10001, 0b10001, 0b01111, 0b00001, 0b00001, 0b01110 },
        '-' => [_]u8{ 0b00000, 0b00000, 0b00000, 0b11111, 0b00000, 0b00000, 0b00000 },
        '_' => [_]u8{ 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b11111 },
        '=' => [_]u8{ 0b00000, 0b11111, 0b00000, 0b00000, 0b11111, 0b00000, 0b00000 },
        '.' => [_]u8{ 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00110, 0b00110 },
        ',' => [_]u8{ 0b00000, 0b00000, 0b00000, 0b00000, 0b00110, 0b00100, 0b01000 },
        ':' => [_]u8{ 0b00000, 0b00100, 0b00100, 0b00000, 0b00100, 0b00100, 0b00000 },
        '/' => [_]u8{ 0b00001, 0b00001, 0b00010, 0b00100, 0b01000, 0b10000, 0b10000 },
        '>' => [_]u8{ 0b10000, 0b01000, 0b00100, 0b00010, 0b00100, 0b01000, 0b10000 },
        '<' => [_]u8{ 0b00001, 0b00010, 0b00100, 0b01000, 0b00100, 0b00010, 0b00001 },
        '?' => [_]u8{ 0b01110, 0b10001, 0b00001, 0b00010, 0b00100, 0b00000, 0b00100 },
        '[' => [_]u8{ 0b01110, 0b01000, 0b01000, 0b01000, 0b01000, 0b01000, 0b01110 },
        ']' => [_]u8{ 0b01110, 0b00010, 0b00010, 0b00010, 0b00010, 0b00010, 0b01110 },
        '(' => [_]u8{ 0b00010, 0b00100, 0b01000, 0b01000, 0b01000, 0b00100, 0b00010 },
        ')' => [_]u8{ 0b01000, 0b00100, 0b00010, 0b00010, 0b00010, 0b00100, 0b01000 },
        ' ' => [_]u8{ 0, 0, 0, 0, 0, 0, 0 },
        else => [_]u8{ 0, 0, 0, 0, 0, 0, 0 },
    };
}

fn fbDrawGlyph5x7(x: i32, y: i32, raw_ch: u8, scale: i32, px: u32) void {
    var ch = raw_ch;
    if (ch >= 'a' and ch <= 'z') ch -%= 32;
    const rows = glyph5x7(ch);

    var row: usize = 0;
    while (row < 7) : (row += 1) {
        var col: usize = 0;
        while (col < 5) : (col += 1) {
            const shift: u3 = @intCast(4 - col);
            if (((rows[row] >> shift) & 1) == 1) {
                const px_x = x + @as(i32, @intCast(col)) * scale;
                const px_y = y + @as(i32, @intCast(row)) * scale;
                fbFillRect(px_x, px_y, scale, scale, px);
            }
        }
    }
}

fn fbDrawText5x7(x: i32, y: i32, text: []const u8, scale: i32, spacing: i32, px: u32) void {
    var pen_x = x;
    for (text) |ch| {
        fbDrawGlyph5x7(pen_x, y, ch, scale, px);
        pen_x += 5 * scale + spacing;
    }
}

fn gfxShellPanelHeight() u32 {
    var panel_h = g_vgpu_height / 6;
    if (panel_h < 58) panel_h = 58;
    if (panel_h > 90) panel_h = 90;
    return panel_h;
}

fn gfxShellRenderInput(line: []const u8) void {
    if (!g_vgpu_ready) return;
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return;

    var panel_h = g_vgpu_shell_panel_h;
    if (panel_h == 0) panel_h = gfxShellPanelHeight();
    g_vgpu_shell_panel_h = panel_h;

    const panel_h_i: i32 = @intCast(panel_h);
    const w_i: i32 = @intCast(g_vgpu_width);

    const bg = colorRgb(8, 8, 14);
    const border = colorRgb(220, 96, 26);
    const title_col = colorRgb(255, 170, 64);
    const text_col = colorRgb(238, 232, 224);
    const cursor_col = colorRgb(255, 214, 102);

    fbFillRect(0, 0, w_i, panel_h_i, bg);
    fbFillRect(0, panel_h_i - 2, w_i, 2, border);

    const title_scale: i32 = 2;
    const title_y: i32 = 8;
    fbDrawText5x7(12, title_y, FB_SHELL_TITLE, title_scale, 2, title_col);

    const line_scale: i32 = 2;
    const line_y: i32 = 34;
    const char_w: i32 = 5 * line_scale + 1;
    fbDrawText5x7(12, line_y, SHELL_PROMPT, line_scale, 1, text_col);

    const prompt_chars: i32 = @intCast(SHELL_PROMPT.len);
    const input_x = 12 + prompt_chars * char_w + 6;
    const panel_right = w_i - 12;
    var max_chars = @divTrunc(panel_right - input_x, char_w);
    if (max_chars < 0) max_chars = 0;

    var visible = line;
    if (@as(usize, @intCast(max_chars)) < visible.len) {
        visible = visible[visible.len - @as(usize, @intCast(max_chars)) ..];
    }

    fbDrawText5x7(input_x, line_y, visible, line_scale, 1, text_col);
    const vis_len_i: i32 = @intCast(visible.len);
    const cx = input_x + vis_len_i * char_w;
    fbFillRect(cx, line_y + 1, 2, 12, cursor_col);

    _ = gfxFlushRect(0, 0, g_vgpu_width, panel_h);
    gfxMouseCursorRedrawIfOverlap(0, @intCast(panel_h));
}

fn gfxConsoleReset() void {
    g_fb_console_line_count = 1;
    g_fb_console_ansi = false;
    var i: usize = 0;
    while (i < FB_CONSOLE_MAX_LINES) : (i += 1) {
        g_fb_console_line_len[i] = 0;
    }
}

fn gfxConsoleNewLine() void {
    if (g_fb_console_line_count < FB_CONSOLE_MAX_LINES) {
        g_fb_console_line_count += 1;
        g_fb_console_line_len[g_fb_console_line_count - 1] = 0;
        return;
    }

    var i: usize = 1;
    while (i < FB_CONSOLE_MAX_LINES) : (i += 1) {
        g_fb_console_line_len[i - 1] = g_fb_console_line_len[i];
        const n: usize = g_fb_console_line_len[i];
        if (n > 0) copySlice(g_fb_console_lines[i - 1][0..], g_fb_console_lines[i][0..n]);
    }
    g_fb_console_line_len[FB_CONSOLE_MAX_LINES - 1] = 0;
}

fn gfxConsolePushPrintable(ch: u8) void {
    if (g_fb_console_line_count == 0) g_fb_console_line_count = 1;
    const idx = g_fb_console_line_count - 1;
    var len: usize = g_fb_console_line_len[idx];
    if (len >= FB_CONSOLE_LINE_MAX) {
        gfxConsoleNewLine();
        len = 0;
    }
    const dst = g_fb_console_line_count - 1;
    g_fb_console_lines[dst][len] = ch;
    g_fb_console_line_len[dst] = @intCast(len + 1);
}

fn gfxConsoleBackspace() void {
    if (g_fb_console_line_count == 0) return;
    const idx = g_fb_console_line_count - 1;
    if (g_fb_console_line_len[idx] > 0) g_fb_console_line_len[idx] -= 1;
}

fn gfxConsoleRender() void {
    if (!g_vgpu_ready) return;
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return;

    var panel_h = g_vgpu_shell_panel_h;
    if (panel_h == 0) panel_h = gfxShellPanelHeight();
    g_vgpu_shell_panel_h = panel_h;

    const y0: i32 = @intCast(panel_h + 2);
    const w_i: i32 = @intCast(g_vgpu_width);
    const h_i: i32 = @intCast(g_vgpu_height);
    const area_h = h_i - y0;
    if (area_h <= 0) return;

    const bg = colorRgb(9, 11, 18);
    const fg = colorRgb(235, 230, 220);
    fbFillRect(0, y0, w_i, area_h, bg);

    const scale: i32 = if (g_vgpu_width >= 1000) 2 else 1;
    const line_h: i32 = 7 * scale + 2;
    var visible: usize = @intCast(@divTrunc(area_h - 6, line_h));
    if (visible == 0) visible = 1;

    var start: usize = 0;
    if (g_fb_console_line_count > visible) {
        start = g_fb_console_line_count - visible;
    }

    var row: usize = 0;
    while (start + row < g_fb_console_line_count) : (row += 1) {
        const idx = start + row;
        const line_len: usize = g_fb_console_line_len[idx];
        if (line_len == 0) continue;
        const y: i32 = y0 + 4 + @as(i32, @intCast(row)) * line_h;
        fbDrawText5x7(8, y, g_fb_console_lines[idx][0..line_len], scale, 1, fg);
    }

    _ = gfxFlushRect(0, @intCast(y0), g_vgpu_width, @intCast(area_h));
    gfxMouseCursorRedrawIfOverlap(y0, area_h);
}

fn gfxMirrorUartChar(ch: u8) void {
    if (!g_vgpu_ready) return;

    if (g_fb_console_ansi) {
        if ((ch >= 'A' and ch <= 'Z') or (ch >= 'a' and ch <= 'z')) g_fb_console_ansi = false;
        return;
    }

    var needs_render = false;
    switch (ch) {
        0x1b => {
            g_fb_console_ansi = true;
            return;
        },
        '\r' => return,
        '\n' => {
            gfxConsoleNewLine();
            needs_render = true;
        },
        0x08 => {
            gfxConsoleBackspace();
            needs_render = true;
        },
        else => {
            if (ch >= 0x20 and ch < 0x7f) {
                gfxConsolePushPrintable(ch);
                needs_render = true;
            }
        },
    }

    if (needs_render) gfxConsoleRender();
}

fn gfxRenderZenithBootScreen() bool {
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return false;

    const w: usize = @intCast(g_vgpu_width);
    const h: usize = @intCast(g_vgpu_height);
    if (w == 0 or h == 0) return false;

    // Background gradient.
    var y: usize = 0;
    while (y < h) : (y += 1) {
        const y_u32: u32 = @intCast(y);
        const h_u32: u32 = @intCast(h);
        const r: u8 = @intCast(10 + (y_u32 * 10) / h_u32);
        const g: u8 = @intCast(8 + (y_u32 * 8) / h_u32);
        const b: u8 = @intCast(20 + (y_u32 * 26) / h_u32);
        const row_px = colorRgb(r, g, b);
        const row_off = y * w;
        var x: usize = 0;
        while (x < w) : (x += 1) {
            g_vgpu_fb[row_off + x] = row_px;
        }
    }

    const w_i: i32 = @intCast(g_vgpu_width);
    const h_i: i32 = @intCast(g_vgpu_height);

    // Reserve top strip for future framebuffer-shell overlay.
    const panel_h_u32: u32 = gfxShellPanelHeight();
    g_vgpu_shell_panel_h = panel_h_u32;
    const panel_h: i32 = @intCast(panel_h_u32);
    fbFillRect(0, 0, w_i, panel_h, colorRgb(8, 8, 14));
    fbFillRect(0, panel_h - 2, w_i, 2, colorRgb(220, 96, 26));

    // Stylized "Z" inspired by your dragon logo.
    const cx = @divTrunc(w_i, 2);
    const logo_w = @divTrunc(w_i * 55, 100);
    const logo_h = @divTrunc(h_i * 45, 100);
    const left = cx - @divTrunc(logo_w, 2);
    const right = cx + @divTrunc(logo_w, 2);
    const top = panel_h + 30;
    const bottom = top + logo_h;
    const t = imax(14, @divTrunc(logo_w, 28));

    const c_main = colorRgb(255, 86, 18);
    const c_bright = colorRgb(255, 170, 60);
    const c_dark = colorRgb(120, 25, 8);
    const c_eye = colorRgb(215, 255, 84);

    fbDrawLineThick(left + 12, top + 16, right - 24, top + 2, t, c_main);
    fbDrawLineThick(right - 24, top + 8, left + 36, bottom - 12, t, c_main);
    fbDrawLineThick(left + 32, bottom - 10, right - 42, bottom - 14, t, c_main);

    fbDrawLineThick(left + 16, top + 10, right - 32, top - 2, imax(3, @divTrunc(t, 4)), c_bright);
    fbDrawLineThick(right - 18, top + 18, left + 42, bottom - 2, imax(3, @divTrunc(t, 4)), c_bright);
    fbDrawLineThick(left + 28, bottom - 2, right - 52, bottom - 6, imax(3, @divTrunc(t, 4)), c_bright);

    fbDrawLineThick(left + 26, top + 26, right - 34, top + 12, imax(4, @divTrunc(t, 5)), c_dark);
    fbDrawLineThick(right - 34, top + 16, left + 44, bottom - 22, imax(4, @divTrunc(t, 5)), c_dark);
    fbDrawLineThick(left + 44, bottom - 22, right - 54, bottom - 24, imax(4, @divTrunc(t, 5)), c_dark);

    // Dragon head accent near top-left.
    const hx = left + @divTrunc(logo_w, 5);
    const hy = top - 6;
    const hs = imax(10, @divTrunc(t * 3, 2));
    fbDrawLineThick(hx + 8, hy + 8, hx + 48, hy + 22, hs, c_main);
    fbDrawLineThick(hx + 12, hy + 12, hx - 10, hy + 28, hs, c_main);
    fbDrawLineThick(hx + 22, hy - 2, hx + 54, hy + 12, imax(4, @divTrunc(hs, 3)), c_bright);
    fbDrawDisc(hx + 22, hy + 12, imax(2, @divTrunc(hs, 6)), c_eye);
    fbDrawLineThick(right - 70, bottom - 28, right - 20, bottom - 46, imax(4, @divTrunc(t, 3)), c_bright);

    // OS name below logo.
    const scale = imax(2, @divTrunc(w_i, 240));
    const spacing = imax(2, scale);
    const name_len_i: i32 = @intCast(OS_NAME.len);
    const name_px_w = name_len_i * (5 * scale) + (name_len_i - 1) * spacing;
    const name_x = cx - @divTrunc(name_px_w, 2);
    const name_y = bottom + 28;
    fbDrawText5x7(name_x, name_y, OS_NAME, scale, spacing, colorRgb(255, 182, 72));

    const ok = gfxFlushAll();
    if (ok and g_vgpu_ready) gfxMouseCursorRebuild();
    return ok;
}

fn gfxFill(r: u8, g: u8, b: u8) bool {
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return false;
    const pixel_count: usize = @intCast(@as(u64, g_vgpu_width) * @as(u64, g_vgpu_height));
    if (pixel_count > g_vgpu_fb.len) return false;

    const px: u32 = (@as(u32, b)) |
        (@as(u32, g) << 8) |
        (@as(u32, r) << 16);
    var i: usize = 0;
    while (i < pixel_count) : (i += 1) {
        g_vgpu_fb[i] = px;
    }
    const ok = gfxFlushAll();
    if (ok) gfxMouseCursorRebuild();
    return ok;
}

fn gfxFlushAll() bool {
    return gfxFlushRect(0, 0, g_vgpu_width, g_vgpu_height);
}

fn gfxFlushRect(x: u32, y: u32, w: u32, h: u32) bool {
    if (g_vgpu_width == 0 or g_vgpu_height == 0) return false;
    if (w == 0 or h == 0) return true;
    if (x >= g_vgpu_width or y >= g_vgpu_height) return true;

    var x2 = x + w;
    var y2 = y + h;
    if (x2 > g_vgpu_width) x2 = g_vgpu_width;
    if (y2 > g_vgpu_height) y2 = g_vgpu_height;
    const rw = x2 - x;
    const rh = y2 - y;
    if (rw == 0 or rh == 0) return true;

    const offset: u64 = (@as(u64, y) * @as(u64, g_vgpu_width) + @as(u64, x)) * 4;

    g_vgpu_req_xfer = .{
        .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_TRANSFER_TO_HOST_2D, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
        .rect = .{ .x = x, .y = y, .width = rw, .height = rh },
        .offset = offset,
        .resource_id = g_vgpu_resource_id,
        .padding = 0,
    };
    if (!virtioGpuExec(
        @intFromPtr(&g_vgpu_req_xfer),
        @sizeOf(VirtioGpuTransferToHost2d),
        @intFromPtr(&g_vgpu_resp_nodata),
        @sizeOf(VirtioGpuRespNoData),
    )) return false;
    if (g_vgpu_resp_nodata.hdr.ctrl_type != VIRTIO_GPU_RESP_OK_NODATA) return false;

    g_vgpu_req_flush = .{
        .hdr = .{ .ctrl_type = VIRTIO_GPU_CMD_RESOURCE_FLUSH, .flags = 0, .fence_id = 0, .ctx_id = 0, .padding = 0 },
        .rect = .{ .x = x, .y = y, .width = rw, .height = rh },
        .resource_id = g_vgpu_resource_id,
        .padding = 0,
    };
    if (!virtioGpuExec(
        @intFromPtr(&g_vgpu_req_flush),
        @sizeOf(VirtioGpuResourceFlush),
        @intFromPtr(&g_vgpu_resp_nodata),
        @sizeOf(VirtioGpuRespNoData),
    )) return false;
    return g_vgpu_resp_nodata.hdr.ctrl_type == VIRTIO_GPU_RESP_OK_NODATA;
}

fn virtioGpuExec(req_ptr: usize, req_len: usize, resp_ptr: usize, resp_len: usize) bool {
    g_vgpu_desc[0] = .{
        .addr = @intCast(req_ptr),
        .len = @intCast(req_len),
        .flags = 1,
        .next = 1,
    };
    g_vgpu_desc[1] = .{
        .addr = @intCast(resp_ptr),
        .len = @intCast(resp_len),
        .flags = 2,
        .next = 0,
    };

    const avail_idx: u16 = g_vgpu_avail.idx;
    g_vgpu_avail.ring[avail_idx % VIRTIO_GPU_QUEUE_SIZE] = 0;
    asm volatile ("fence rw, rw");
    g_vgpu_avail.idx +%= 1;
    mmioWrite32At(g_vgpu_base, 0x050, 0);

    var guard: usize = 0;
    while (g_vgpu_used.idx == g_vgpu_last_used_idx and guard < 5_000_000) : (guard += 1) {}
    if (g_vgpu_used.idx == g_vgpu_last_used_idx) return false;
    g_vgpu_last_used_idx = g_vgpu_used.idx;

    const isr = mmioRead32At(g_vgpu_base, 0x060);
    if (isr != 0) mmioWrite32At(g_vgpu_base, 0x064, isr);
    return true;
}

fn mmioRead32(off: usize) u32 {
    const p: *volatile u32 = @ptrFromInt(g_virtio_base + off);
    return p.*;
}

fn mmioWrite32(off: usize, v: u32) void {
    const p: *volatile u32 = @ptrFromInt(g_virtio_base + off);
    p.* = v;
}

fn findVirtioBlkBase() ?usize {
    var i: usize = 0;
    while (i < VIRTIO_MMIO_SLOTS) : (i += 1) {
        const base = VIRTIO_MMIO_BASE_START + (i * VIRTIO_MMIO_STRIDE);
        if (mmioRead32At(base, 0x000) != 0x7472_6976) continue;
        if (mmioRead32At(base, 0x004) != 2) continue;
        if (mmioRead32At(base, 0x008) != 2) continue;
        return base;
    }
    return null;
}

fn findVirtioGpuBase() ?usize {
    var i: usize = 0;
    while (i < VIRTIO_MMIO_SLOTS) : (i += 1) {
        const base = VIRTIO_MMIO_BASE_START + (i * VIRTIO_MMIO_STRIDE);
        if (mmioRead32At(base, 0x000) != 0x7472_6976) continue;
        if (mmioRead32At(base, 0x004) != 2) continue;
        if (mmioRead32At(base, 0x008) != 16) continue; // virtio-gpu
        return base;
    }
    return null;
}

fn mmioRead32At(base: usize, off: usize) u32 {
    const p: *volatile u32 = @ptrFromInt(base + off);
    return p.*;
}

fn mmioWrite32At(base: usize, off: usize, v: u32) void {
    const p: *volatile u32 = @ptrFromInt(base + off);
    p.* = v;
}

fn parseU64(s: []const u8) ?u64 {
    if (s.len == 0) return null;
    var v: u64 = 0;
    for (s) |ch| {
        if (ch < '0' or ch > '9') return null;
        v = v * 10 + @as(u64, ch - '0');
    }
    return v;
}

fn parseRgbArgs(args: []const u8) ?Rgb {
    const first = parseNameText(args) orelse return null;
    const second = parseNameText(first.text) orelse return null;
    const third = trimSpaces(second.text);

    const r64 = parseU64(first.name) orelse return null;
    const g64 = parseU64(second.name) orelse return null;
    const b64 = parseU64(third) orelse return null;
    if (r64 > 255 or g64 > 255 or b64 > 255) return null;
    return .{
        .r = @intCast(r64),
        .g = @intCast(g64),
        .b = @intCast(b64),
    };
}

fn blkDebug() void {
    uartPrint("virtio mmio scan:\n");
    var i: usize = 0;
    while (i < VIRTIO_MMIO_SLOTS) : (i += 1) {
        const base = VIRTIO_MMIO_BASE_START + (i * VIRTIO_MMIO_STRIDE);
        const magic = mmioRead32At(base, 0x000);
        const version = mmioRead32At(base, 0x004);
        const dev = mmioRead32At(base, 0x008);
        const vendor = mmioRead32At(base, 0x00c);
        if (magic == 0 and version == 0 and dev == 0 and vendor == 0) continue;
        uartPrint("slot ");
        uartPrintDec(i);
        uartPrint(" base=0x");
        uartPrintHex(base);
        uartPrint(" magic=0x");
        uartPrintHex(magic);
        uartPrint(" ver=");
        uartPrintDec(version);
        uartPrint(" dev=");
        uartPrintDec(dev);
        uartPrint(" ven=0x");
        uartPrintHex(vendor);
        uartPrint("\n");
    }
}

fn gfxProbeCmd() void {
    if (!g_vgpu_ready) {
        uartPrint("virtio-gpu: not ready\n");
        return;
    }
    uartPrint("virtio-gpu: ready ");
    uartPrintDec(g_vgpu_width);
    uartPrint("x");
    uartPrintDec(g_vgpu_height);
    uartPrint(" resource=");
    uartPrintDec(g_vgpu_resource_id);
    uartPrint("\n");
}

fn gfxFillCmd(r: u8, g: u8, b: u8) void {
    if (!g_vgpu_ready) {
        uartPrint("virtio-gpu: not ready\n");
        return;
    }
    if (!gfxFill(r, g, b)) {
        uartPrint("gfxfill: failed\n");
        return;
    }
    uartPrint("gfxfill: ok rgb(");
    uartPrintDec(r);
    uartPrint(",");
    uartPrintDec(g);
    uartPrint(",");
    uartPrintDec(b);
    uartPrint(")\n");
}

fn gfxLogoCmd() void {
    if (!g_vgpu_ready) {
        uartPrint("virtio-gpu: not ready\n");
        return;
    }
    if (gfxRenderZenithBootScreen()) {
        uartPrint("gfxlogo: ok\n");
    } else {
        uartPrint("gfxlogo: failed\n");
    }
}

fn mouseStatusCmd() void {
    uartPrint("input-devices=");
    uartPrintDec(g_vinput_count);
    uartPrint(" ");
    uartPrint("mouse x=");
    uartPrintDec(@intCast(if (g_mouse_x < 0) 0 else g_mouse_x));
    uartPrint(" y=");
    uartPrintDec(@intCast(if (g_mouse_y < 0) 0 else g_mouse_y));
    uartPrint(" left=");
    uartPrint(if (g_mouse_left_down) "down" else "up");
    uartPrint(" clicks=");
    uartPrintDec(g_mouse_click_count);
    uartPrint("\n");
}

fn fsMkfsCmd() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (miniFsFormat()) {
        uartPrint("mkfs: ok\n");
    } else {
        uartPrint("mkfs: failed\n");
    }
}

fn fsSaveCmd() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (!miniFsIsFormatted()) {
        uartPrint("MiniFS not formatted. run: mkfs\n");
        return;
    }
    if (miniFsSaveFromRamFs()) {
        uartPrint("fssave: ok\n");
    } else {
        uartPrint("fssave: failed\n");
    }
}

fn fsLoadCmd() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (!miniFsIsFormatted()) {
        uartPrint("MiniFS not formatted. run: mkfs\n");
        return;
    }
    if (miniFsLoadToRamFs()) {
        uartPrint("fsload: ok\n");
    } else {
        uartPrint("fsload: failed\n");
    }
}

fn fsStatCmd() void {
    uartPrint("ramfs files=");
    uartPrintDec(fsUsedFileCount());
    uartPrint(" bytes=");
    uartPrintDec(fsUsedBytes());
    uartPrint("\n");

    if (!g_virtio_ready) {
        uartPrint("minifs: disk not ready\n");
        return;
    }
    uartPrint("minifs sectors: super=");
    uartPrintDec(MINIFS_SUPER_SECTOR);
    uartPrint(" meta_start=");
    uartPrintDec(MINIFS_META_START_SECTOR);
    uartPrint(" data_start=");
    uartPrintDec(MINIFS_DATA_START_SECTOR);
    uartPrint(" formatted=");
    uartPrint(if (miniFsIsFormatted()) "yes\n" else "no\n");
}

fn miniFsFormat() bool {
    var super: [512]u8 = [_]u8{0} ** 512;
    lePut32(super[0..], 0, MINIFS_MAGIC);
    lePut16(super[0..], 4, MINIFS_VERSION);
    lePut16(super[0..], 6, FS_MAX_FILES);
    lePut64(super[0..], 8, MINIFS_META_START_SECTOR);
    lePut64(super[0..], 16, MINIFS_DATA_START_SECTOR);
    lePut64(super[0..], 24, FS_DATA_MAX);
    if (!blkWriteRaw(MINIFS_SUPER_SECTOR, &super)) return false;

    var zero: [512]u8 = [_]u8{0} ** 512;
    var i: usize = 0;
    while (i < FS_MAX_FILES) : (i += 1) {
        if (!blkWriteRaw(MINIFS_META_START_SECTOR + i, &zero)) return false;
        if (!blkWriteRaw(MINIFS_DATA_START_SECTOR + i, &zero)) return false;
    }
    return true;
}

fn miniFsIsFormatted() bool {
    var super: [512]u8 = [_]u8{0} ** 512;
    if (!blkReadRaw(MINIFS_SUPER_SECTOR, &super)) return false;
    if (leGet32(super[0..], 0) != MINIFS_MAGIC) return false;
    if (leGet16(super[0..], 4) != MINIFS_VERSION) return false;
    if (leGet16(super[0..], 6) != FS_MAX_FILES) return false;
    return true;
}

fn miniFsSaveFromRamFs() bool {
    var i: usize = 0;
    while (i < FS_MAX_FILES) : (i += 1) {
        const f = &g_fs_files[i];
        var meta: [512]u8 = [_]u8{0} ** 512;
        var data: [512]u8 = [_]u8{0} ** 512;

        if (f.used) {
            meta[0] = 1;
            meta[1] = f.name_len;
            lePut16(meta[0..], 2, @intCast(f.data_len));
            copySlice(meta[4 .. 4 + FS_NAME_MAX], f.name[0..f.name_len]);
            copySlice(data[0..], f.data[0..f.data_len]);
        }

        if (!blkWriteRaw(MINIFS_META_START_SECTOR + i, &meta)) return false;
        if (!blkWriteRaw(MINIFS_DATA_START_SECTOR + i, &data)) return false;
    }
    return true;
}

fn miniFsLoadToRamFs() bool {
    var i: usize = 0;
    while (i < FS_MAX_FILES) : (i += 1) {
        g_fs_files[i] = .{};
    }

    i = 0;
    while (i < FS_MAX_FILES) : (i += 1) {
        var meta: [512]u8 = [_]u8{0} ** 512;
        var data: [512]u8 = [_]u8{0} ** 512;
        if (!blkReadRaw(MINIFS_META_START_SECTOR + i, &meta)) return false;
        if (!blkReadRaw(MINIFS_DATA_START_SECTOR + i, &data)) return false;

        if (meta[0] == 0) continue;
        const name_len: usize = meta[1];
        const data_len: usize = leGet16(meta[0..], 2);
        if (name_len == 0 or name_len > FS_NAME_MAX) continue;
        if (data_len > FS_DATA_MAX) continue;

        var f = &g_fs_files[i];
        f.used = true;
        f.name_len = @intCast(name_len);
        f.data_len = data_len;
        copySlice(f.name[0..], meta[4 .. 4 + name_len]);
        copySlice(f.data[0..], data[0..data_len]);
    }
    return true;
}

fn fsUsedFileCount() usize {
    var count: usize = 0;
    for (g_fs_files) |f| {
        if (f.used) count += 1;
    }
    return count;
}

fn fsUsedBytes() usize {
    var total: usize = 0;
    for (g_fs_files) |f| {
        if (f.used) total += f.data_len;
    }
    return total;
}

fn blkReadRaw(sector: u64, buf: *[512]u8) bool {
    if (!g_virtio_ready) return false;
    if (sector >= g_virtio_capacity_sectors) return false;
    return virtioBlkRw(sector, false, buf);
}

fn blkWriteRaw(sector: u64, buf: *[512]u8) bool {
    if (!g_virtio_ready) return false;
    if (sector >= g_virtio_capacity_sectors) return false;
    return virtioBlkRw(sector, true, buf);
}

fn lePut16(buf: []u8, off: usize, value: u16) void {
    buf[off + 0] = @intCast(value & 0xff);
    buf[off + 1] = @intCast((value >> 8) & 0xff);
}

fn lePut32(buf: []u8, off: usize, value: u32) void {
    buf[off + 0] = @intCast(value & 0xff);
    buf[off + 1] = @intCast((value >> 8) & 0xff);
    buf[off + 2] = @intCast((value >> 16) & 0xff);
    buf[off + 3] = @intCast((value >> 24) & 0xff);
}

fn lePut64(buf: []u8, off: usize, value: u64) void {
    var i: usize = 0;
    while (i < 8) : (i += 1) {
        buf[off + i] = @intCast((value >> @intCast(i * 8)) & 0xff);
    }
}

fn leGet16(buf: []const u8, off: usize) u16 {
    return @as(u16, buf[off]) | (@as(u16, buf[off + 1]) << 8);
}

fn leGet32(buf: []const u8, off: usize) u32 {
    return @as(u32, buf[off]) |
        (@as(u32, buf[off + 1]) << 8) |
        (@as(u32, buf[off + 2]) << 16) |
        (@as(u32, buf[off + 3]) << 24);
}

fn uxInit() void {
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) g_ux_spaces[i] = .{};
    i = 0;
    while (i < UX_ITEM_MAX) : (i += 1) g_ux_items[i] = .{};
    g_ux_next_space_id = 1;
    g_ux_next_item_id = 1;
    g_ux_active_space_id = 0;

    const sid = uxCreateSpaceInternal("inbox") catch 0;
    g_ux_active_space_id = sid;
}

fn uxSpaceListCmd() void {
    uartPrint("spaces:\n");
    var any = false;
    for (g_ux_spaces) |s| {
        if (!s.used) continue;
        any = true;
        uartPrint(if (s.id == g_ux_active_space_id) "* " else "  ");
        uartPrint(s.name[0..s.name_len]);
        uartPrint(" (id=");
        uartPrintDec(s.id);
        uartPrint(")\n");
    }
    if (!any) uartPrint("(none)\n");
}

fn uxSpaceAddCmd(name: []const u8) void {
    const clean = trimSpaces(name);
    if (clean.len == 0) {
        uartPrint("usage: space add <name>\n");
        return;
    }
    const sid = uxCreateSpaceInternal(clean) catch |err| {
        uxReportError(err);
        return;
    };
    uartPrint("space created id=");
    uartPrintDec(sid);
    uartPrint("\n");
}

fn uxSpaceUseCmd(name: []const u8) void {
    const clean = trimSpaces(name);
    if (clean.len == 0) {
        uartPrint("usage: space use <name>\n");
        return;
    }
    const idx = uxFindSpaceByName(clean) orelse {
        uartPrint("space not found\n");
        return;
    };
    g_ux_active_space_id = g_ux_spaces[idx].id;
    uartPrint("active space: ");
    uartPrint(g_ux_spaces[idx].name[0..g_ux_spaces[idx].name_len]);
    uartPrint("\n");
}

fn uxSpaceRmCmd(name: []const u8) void {
    const clean = trimSpaces(name);
    if (clean.len == 0) {
        uartPrint("usage: space rm <name>\n");
        return;
    }
    const idx = uxFindSpaceByName(clean) orelse {
        uartPrint("space not found\n");
        return;
    };
    const sid = g_ux_spaces[idx].id;
    if (sid == g_ux_active_space_id) {
        uartPrint("cannot remove active space\n");
        return;
    }
    if (uxSpaceHasItems(sid)) {
        uartPrint("space not empty\n");
        return;
    }
    g_ux_spaces[idx] = .{};
    uartPrint("space removed\n");
}

fn uxItemAddCmd(title: []const u8, text: []const u8) void {
    const clean_title = trimSpaces(title);
    if (clean_title.len == 0 or clean_title.len > UX_ITEM_TITLE_MAX) {
        uartPrint("invalid title\n");
        return;
    }
    if (text.len > UX_ITEM_TEXT_MAX) {
        uartPrint("text too large\n");
        return;
    }
    if (g_ux_active_space_id == 0) {
        uartPrint("no active space\n");
        return;
    }
    const idx = uxAllocItemSlot() orelse {
        uartPrint("item capacity reached\n");
        return;
    };
    const it = &g_ux_items[idx];
    it.used = true;
    it.id = g_ux_next_item_id;
    g_ux_next_item_id +%= 1;
    it.space_id = g_ux_active_space_id;
    it.title_len = @intCast(clean_title.len);
    it.text_len = @intCast(text.len);
    it.tags_len = 0;
    copySlice(it.title[0..], clean_title);
    copySlice(it.text[0..], text);
    uartPrint("item added id=");
    uartPrintDec(it.id);
    uartPrint("\n");
}

fn uxItemListCmd(filter: ItemStatusFilter) void {
    if (g_ux_active_space_id == 0) {
        uartPrint("no active space\n");
        return;
    }
    var any = false;
    for (g_ux_items) |it| {
        if (!it.used or it.space_id != g_ux_active_space_id) continue;
        if (filter == .open and it.done) continue;
        if (filter == .done and !it.done) continue;
        any = true;
        uartPrint("- id=");
        uartPrintDec(it.id);
        uartPrint(if (it.done) " [done]" else " [open]");
        uartPrint(" title=");
        uartPrint(it.title[0..it.title_len]);
        if (it.tags_len > 0) {
            uartPrint(" tags=");
            uartPrint(it.tags[0..it.tags_len]);
        }
        uartPrint("\n");
    }
    if (!any) uartPrint("(no items)\n");
}

fn uxItemShowCmd(id: u16) void {
    const idx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    const it = &g_ux_items[idx];
    const sidx = uxFindSpaceById(it.space_id) orelse {
        uartPrint("item has missing space\n");
        return;
    };
    uartPrint("id=");
    uartPrintDec(it.id);
    uartPrint(" space=");
    uartPrint(g_ux_spaces[sidx].name[0..g_ux_spaces[sidx].name_len]);
    uartPrint("\n");
    uartPrint("title: ");
    uartPrint(it.title[0..it.title_len]);
    uartPrint("\n");
    uartPrint("status: ");
    uartPrint(if (it.done) "done\n" else "open\n");
    if (it.tags_len > 0) {
        uartPrint("tags: ");
        uartPrint(it.tags[0..it.tags_len]);
        uartPrint("\n");
    }
    uartPrint("text: ");
    uartPrint(it.text[0..it.text_len]);
    uartPrint("\n");
}

fn uxItemTagCmd(id: u16, tags: []const u8) void {
    const idx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    const clean = trimSpaces(tags);
    if (clean.len > UX_ITEM_TAGS_MAX) {
        uartPrint("tags too long\n");
        return;
    }
    const it = &g_ux_items[idx];
    it.tags_len = @intCast(clean.len);
    if (clean.len > 0) copySlice(it.tags[0..], clean);
    uartPrint("tags updated\n");
}

fn uxItemRmCmd(id: u16) void {
    const idx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    g_ux_items[idx] = .{};
    uartPrint("item removed\n");
}

fn uxItemSetDoneCmd(id: u16, done: bool) void {
    const idx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    g_ux_items[idx].done = done;
    uartPrint(if (done) "item marked done\n" else "item reopened\n");
}

fn uxItemCloneCmd(id: u16) void {
    const src_idx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    const dst_idx = uxAllocItemSlot() orelse {
        uartPrint("item capacity reached\n");
        return;
    };
    const src = &g_ux_items[src_idx];
    const dst = &g_ux_items[dst_idx];
    dst.* = src.*;
    dst.id = g_ux_next_item_id;
    g_ux_next_item_id +%= 1;
    dst.done = false;

    const suffix = " (copy)";
    if (src.title_len + suffix.len <= UX_ITEM_TITLE_MAX) {
        copySlice(dst.title[0..], src.title[0..src.title_len]);
        copySlice(dst.title[src.title_len..], suffix);
        dst.title_len = @intCast(src.title_len + suffix.len);
    }

    uartPrint("item cloned id=");
    uartPrintDec(dst.id);
    uartPrint("\n");
}

fn uxItemEditCmd(id: u16, field: []const u8, value: []const u8) void {
    const idx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    const it = &g_ux_items[idx];

    if (strEq(field, "title")) {
        const v = trimSpaces(value);
        if (v.len == 0 or v.len > UX_ITEM_TITLE_MAX) {
            uartPrint("invalid title\n");
            return;
        }
        it.title_len = @intCast(v.len);
        copySlice(it.title[0..], v);
        uartPrint("item title updated\n");
        return;
    }
    if (strEq(field, "text")) {
        const v = value;
        if (v.len > UX_ITEM_TEXT_MAX) {
            uartPrint("text too large\n");
            return;
        }
        it.text_len = @intCast(v.len);
        copySlice(it.text[0..], v);
        uartPrint("item text updated\n");
        return;
    }
    if (strEq(field, "tags")) {
        const v = trimSpaces(value);
        if (v.len > UX_ITEM_TAGS_MAX) {
            uartPrint("tags too long\n");
            return;
        }
        it.tags_len = @intCast(v.len);
        if (v.len > 0) copySlice(it.tags[0..], v);
        uartPrint("item tags updated\n");
        return;
    }

    uartPrint("unknown field, use: title|text|tags\n");
}

fn uxItemMoveCmd(id: u16, space_name: []const u8) void {
    const iidx = uxFindItemById(id) orelse {
        uartPrint("item not found\n");
        return;
    };
    const clean = trimSpaces(space_name);
    if (clean.len == 0) {
        uartPrint("space name required\n");
        return;
    }
    const sidx = uxFindSpaceByName(clean) orelse {
        uartPrint("space not found\n");
        return;
    };
    g_ux_items[iidx].space_id = g_ux_spaces[sidx].id;
    uartPrint("item moved to space: ");
    uartPrint(g_ux_spaces[sidx].name[0..g_ux_spaces[sidx].name_len]);
    uartPrint("\n");
}

fn uxItemFindCmd(query: []const u8) void {
    const clean = trimSpaces(query);
    if (clean.len == 0) {
        uartPrint("usage: item find <text>\n");
        return;
    }
    if (g_ux_active_space_id == 0) {
        uartPrint("no active space\n");
        return;
    }

    var any = false;
    for (g_ux_items) |it| {
        if (!it.used or it.space_id != g_ux_active_space_id) continue;
        if (!containsAsciiNoCase(it.title[0..it.title_len], clean) and
            !containsAsciiNoCase(it.text[0..it.text_len], clean) and
            !containsAsciiNoCase(it.tags[0..it.tags_len], clean))
        {
            continue;
        }

        any = true;
        uartPrint("- id=");
        uartPrintDec(it.id);
        uartPrint(" title=");
        uartPrint(it.title[0..it.title_len]);
        if (it.tags_len > 0) {
            uartPrint(" tags=");
            uartPrint(it.tags[0..it.tags_len]);
        }
        uartPrint("\n");
    }
    if (!any) uartPrint("(no match)\n");
}

fn uxItemFilterCmd(arg: []const u8) void {
    const clean = trimSpaces(arg);
    if (!startsWith(clean, "tag:")) {
        uartPrint("usage: item filter tag:<x>\n");
        return;
    }
    const tagq = trimSpaces(clean[4..]);
    if (tagq.len == 0) {
        uartPrint("usage: item filter tag:<x>\n");
        return;
    }
    if (g_ux_active_space_id == 0) {
        uartPrint("no active space\n");
        return;
    }

    var any = false;
    for (g_ux_items) |it| {
        if (!it.used or it.space_id != g_ux_active_space_id) continue;
        if (!containsAsciiNoCase(it.tags[0..it.tags_len], tagq)) continue;

        any = true;
        uartPrint("- id=");
        uartPrintDec(it.id);
        uartPrint(" title=");
        uartPrint(it.title[0..it.title_len]);
        uartPrint(" tags=");
        uartPrint(it.tags[0..it.tags_len]);
        uartPrint("\n");
    }
    if (!any) uartPrint("(no match)\n");
}

fn uxMkfsCmd() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (uxFsFormatDisk()) {
        uartPrint("uxmkfs: ok\n");
    } else {
        uartPrint("uxmkfs: failed\n");
    }
}

fn uxSaveCmd() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (!uxFsIsFormatted()) {
        uartPrint("UXFS not formatted. run: uxmkfs\n");
        return;
    }
    if (uxFsSave()) {
        uartPrint("uxsave: ok\n");
    } else {
        uartPrint("uxsave: failed\n");
    }
}

fn uxLoadCmd() void {
    if (!g_virtio_ready) {
        uartPrint("virtio-blk: not ready\n");
        return;
    }
    if (!uxFsIsFormatted()) {
        uartPrint("UXFS not formatted. run: uxmkfs\n");
        return;
    }
    if (uxFsLoad()) {
        uartPrint("uxload: ok\n");
    } else {
        uartPrint("uxload: failed\n");
    }
}

fn uxStatCmd() void {
    uartPrint("ux active space id=");
    uartPrintDec(g_ux_active_space_id);
    uartPrint(" spaces=");
    uartPrintDec(uxSpaceCount());
    uartPrint(" items=");
    uartPrintDec(uxItemCount());
    uartPrint("\n");
    if (!g_virtio_ready) {
        uartPrint("uxfs: disk not ready\n");
        return;
    }
    uartPrint("uxfs formatted=");
    uartPrint(if (uxFsIsFormatted()) "yes\n" else "no\n");
}

fn uxFsFormatDisk() bool {
    var super: [512]u8 = [_]u8{0} ** 512;
    lePut32(super[0..], 0, UXFS_MAGIC);
    lePut16(super[0..], 4, UXFS_VERSION);
    lePut16(super[0..], 6, UX_SPACE_MAX);
    lePut16(super[0..], 8, UX_ITEM_MAX);
    if (!blkWriteRaw(UXFS_SUPER_SECTOR, &super)) return false;

    var zero: [512]u8 = [_]u8{0} ** 512;
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) {
        if (!blkWriteRaw(UXFS_SPACE_START + i, &zero)) return false;
    }
    i = 0;
    while (i < UX_ITEM_MAX) : (i += 1) {
        if (!blkWriteRaw(UXFS_ITEM_START + i, &zero)) return false;
    }
    return true;
}

fn uxFsIsFormatted() bool {
    var super: [512]u8 = [_]u8{0} ** 512;
    if (!blkReadRaw(UXFS_SUPER_SECTOR, &super)) return false;
    return leGet32(super[0..], 0) == UXFS_MAGIC and leGet16(super[0..], 4) == UXFS_VERSION;
}

fn uxFsSave() bool {
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) {
        var sec: [512]u8 = [_]u8{0} ** 512;
        const s = &g_ux_spaces[i];
        if (s.used) {
            sec[0] = 1;
            lePut16(sec[0..], 1, s.id);
            sec[3] = s.name_len;
            copySlice(sec[4 .. 4 + s.name_len], s.name[0..s.name_len]);
        }
        if (!blkWriteRaw(UXFS_SPACE_START + i, &sec)) return false;
    }

    i = 0;
    while (i < UX_ITEM_MAX) : (i += 1) {
        var sec: [512]u8 = [_]u8{0} ** 512;
        const it = &g_ux_items[i];
        if (it.used) {
            sec[0] = 1;
            lePut16(sec[0..], 1, it.id);
            lePut16(sec[0..], 3, it.space_id);
            sec[5] = it.title_len;
            lePut16(sec[0..], 6, it.text_len);
            sec[8] = it.tags_len;
            sec[9] = if (it.done) 1 else 0;
            copySlice(sec[16 .. 16 + it.title_len], it.title[0..it.title_len]);
            copySlice(sec[16 + UX_ITEM_TITLE_MAX .. 16 + UX_ITEM_TITLE_MAX + it.text_len], it.text[0..it.text_len]);
            copySlice(sec[16 + UX_ITEM_TITLE_MAX + UX_ITEM_TEXT_MAX .. 16 + UX_ITEM_TITLE_MAX + UX_ITEM_TEXT_MAX + it.tags_len], it.tags[0..it.tags_len]);
        }
        if (!blkWriteRaw(UXFS_ITEM_START + i, &sec)) return false;
    }

    var meta: [512]u8 = [_]u8{0} ** 512;
    lePut16(meta[0..], 0, g_ux_active_space_id);
    lePut16(meta[0..], 2, g_ux_next_space_id);
    lePut16(meta[0..], 4, g_ux_next_item_id);
    if (!blkWriteRaw(UXFS_SUPER_SECTOR + 1, &meta)) return false;
    return true;
}

fn uxFsLoad() bool {
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) g_ux_spaces[i] = .{};
    i = 0;
    while (i < UX_ITEM_MAX) : (i += 1) g_ux_items[i] = .{};

    i = 0;
    while (i < UX_SPACE_MAX) : (i += 1) {
        var sec: [512]u8 = [_]u8{0} ** 512;
        if (!blkReadRaw(UXFS_SPACE_START + i, &sec)) return false;
        if (sec[0] == 0) continue;
        const name_len: usize = sec[3];
        if (name_len == 0 or name_len > UX_SPACE_NAME_MAX) continue;
        g_ux_spaces[i].used = true;
        g_ux_spaces[i].id = leGet16(sec[0..], 1);
        g_ux_spaces[i].name_len = @intCast(name_len);
        copySlice(g_ux_spaces[i].name[0..], sec[4 .. 4 + name_len]);
    }

    i = 0;
    while (i < UX_ITEM_MAX) : (i += 1) {
        var sec: [512]u8 = [_]u8{0} ** 512;
        if (!blkReadRaw(UXFS_ITEM_START + i, &sec)) return false;
        if (sec[0] == 0) continue;
        const title_len: usize = sec[5];
        const text_len: usize = leGet16(sec[0..], 6);
        const tags_len: usize = sec[8];
        if (title_len == 0 or title_len > UX_ITEM_TITLE_MAX) continue;
        if (text_len > UX_ITEM_TEXT_MAX or tags_len > UX_ITEM_TAGS_MAX) continue;
        var it = &g_ux_items[i];
        it.used = true;
        it.id = leGet16(sec[0..], 1);
        it.space_id = leGet16(sec[0..], 3);
        it.title_len = @intCast(title_len);
        it.text_len = @intCast(text_len);
        it.tags_len = @intCast(tags_len);
        it.done = (sec[9] != 0);
        copySlice(it.title[0..], sec[16 .. 16 + title_len]);
        copySlice(it.text[0..], sec[16 + UX_ITEM_TITLE_MAX .. 16 + UX_ITEM_TITLE_MAX + text_len]);
        copySlice(it.tags[0..], sec[16 + UX_ITEM_TITLE_MAX + UX_ITEM_TEXT_MAX .. 16 + UX_ITEM_TITLE_MAX + UX_ITEM_TEXT_MAX + tags_len]);
    }

    var meta: [512]u8 = [_]u8{0} ** 512;
    if (!blkReadRaw(UXFS_SUPER_SECTOR + 1, &meta)) return false;
    g_ux_active_space_id = leGet16(meta[0..], 0);
    g_ux_next_space_id = leGet16(meta[0..], 2);
    g_ux_next_item_id = leGet16(meta[0..], 4);
    if (g_ux_active_space_id == 0 or uxFindSpaceById(g_ux_active_space_id) == null) {
        if (uxFirstSpaceId()) |sid| g_ux_active_space_id = sid;
    }
    if (g_ux_next_space_id == 0) g_ux_next_space_id = uxMaxSpaceId() + 1;
    if (g_ux_next_item_id == 0) g_ux_next_item_id = uxMaxItemId() + 1;
    return true;
}

fn uxCreateSpaceInternal(name: []const u8) UxError!u16 {
    const clean = trimSpaces(name);
    if (!uxValidSpaceName(clean)) return UxError.InvalidName;
    if (uxFindSpaceByName(clean) != null) return UxError.InvalidName;
    const idx = uxAllocSpaceSlot() orelse return UxError.NoSpace;
    var s = &g_ux_spaces[idx];
    s.used = true;
    s.id = g_ux_next_space_id;
    g_ux_next_space_id +%= 1;
    s.name_len = @intCast(clean.len);
    copySlice(s.name[0..], clean);
    return s.id;
}

fn uxValidSpaceName(name: []const u8) bool {
    if (name.len == 0 or name.len > UX_SPACE_NAME_MAX) return false;
    for (name) |ch| {
        if (ch == '\t') return false;
        if (ch < 0x20 or ch > 0x7e) return false;
    }
    return true;
}

fn uxFindSpaceByName(name: []const u8) ?usize {
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) {
        const s = &g_ux_spaces[i];
        if (!s.used) continue;
        if (strEq(s.name[0..s.name_len], name)) return i;
    }
    return null;
}

fn uxFindSpaceById(id: u16) ?usize {
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) {
        if (g_ux_spaces[i].used and g_ux_spaces[i].id == id) return i;
    }
    return null;
}

fn uxFindItemById(id: u16) ?usize {
    var i: usize = 0;
    while (i < UX_ITEM_MAX) : (i += 1) {
        if (g_ux_items[i].used and g_ux_items[i].id == id) return i;
    }
    return null;
}

fn uxAllocSpaceSlot() ?usize {
    var i: usize = 0;
    while (i < UX_SPACE_MAX) : (i += 1) if (!g_ux_spaces[i].used) return i;
    return null;
}

fn uxAllocItemSlot() ?usize {
    var i: usize = 0;
    while (i < UX_ITEM_MAX) : (i += 1) if (!g_ux_items[i].used) return i;
    return null;
}

fn uxSpaceHasItems(space_id: u16) bool {
    for (g_ux_items) |it| {
        if (it.used and it.space_id == space_id) return true;
    }
    return false;
}

fn uxSpaceCount() usize {
    var c: usize = 0;
    for (g_ux_spaces) |s| {
        if (s.used) c += 1;
    }
    return c;
}

fn uxItemCount() usize {
    var c: usize = 0;
    for (g_ux_items) |it| {
        if (it.used) c += 1;
    }
    return c;
}

fn uxFirstSpaceId() ?u16 {
    for (g_ux_spaces) |s| {
        if (s.used) return s.id;
    }
    return null;
}

fn uxMaxSpaceId() u16 {
    var m: u16 = 0;
    for (g_ux_spaces) |s| {
        if (s.used and s.id > m) m = s.id;
    }
    return m;
}

fn uxMaxItemId() u16 {
    var m: u16 = 0;
    for (g_ux_items) |it| {
        if (it.used and it.id > m) m = it.id;
    }
    return m;
}

fn uxReportError(err: UxError) void {
    switch (err) {
        error.InvalidName => uartPrint("invalid or duplicate name\n"),
        error.NoSpace => uartPrint("capacity reached\n"),
        error.NotFound => uartPrint("not found\n"),
        error.InvalidText => uartPrint("invalid text\n"),
    }
}

fn fsInit() void {
    var i: usize = 0;
    while (i < g_fs_files.len) : (i += 1) {
        g_fs_files[i] = .{};
    }
    fsWrite("readme.txt", "welcome to ZenithRV ramfs", false) catch {};
}

fn fsList() void {
    var any = false;
    var i: usize = 0;
    while (i < g_fs_files.len) : (i += 1) {
        const f = &g_fs_files[i];
        if (!f.used) continue;
        any = true;
        uartPrint("- ");
        uartPrint(f.name[0..f.name_len]);
        uartPrint(" (");
        uartPrintDec(f.data_len);
        uartPrint(" bytes)\n");
    }
    if (!any) uartPrint("(empty)\n");
}

fn fsCat(name: []const u8) void {
    const idx = fsFind(name) orelse {
        uartPrint("not found\n");
        return;
    };
    const f = &g_fs_files[idx];
    uartPrint(f.data[0..f.data_len]);
    uartPrint("\n");
}

fn fsRemove(name: []const u8) bool {
    const idx = fsFind(name) orelse return false;
    g_fs_files[idx] = .{};
    return true;
}

fn fsWrite(name: []const u8, text: []const u8, append: bool) FsWriteError!void {
    const clean_name = trimSpaces(name);
    if (!fsIsValidName(clean_name)) return FsWriteError.InvalidName;

    var idx = fsFind(clean_name);
    if (idx == null) {
        idx = fsAllocSlot() orelse return FsWriteError.NoSpace;
        const f = &g_fs_files[idx.?];
        f.used = true;
        f.name_len = @intCast(clean_name.len);
        copySlice(f.name[0..], clean_name);
        f.data_len = 0;
    }

    const f = &g_fs_files[idx.?];
    if (!append) {
        if (text.len > FS_DATA_MAX) return FsWriteError.DataTooLarge;
        f.data_len = text.len;
        copySlice(f.data[0..], text);
        return;
    }

    if (f.data_len + text.len > FS_DATA_MAX) return FsWriteError.DataTooLarge;
    copySlice(f.data[f.data_len..], text);
    f.data_len += text.len;
}

fn fsFind(name: []const u8) ?usize {
    var i: usize = 0;
    while (i < g_fs_files.len) : (i += 1) {
        const f = &g_fs_files[i];
        if (!f.used) continue;
        if (strEq(f.name[0..f.name_len], name)) return i;
    }
    return null;
}

fn fsAllocSlot() ?usize {
    var i: usize = 0;
    while (i < g_fs_files.len) : (i += 1) {
        if (!g_fs_files[i].used) return i;
    }
    return null;
}

fn fsIsValidName(name: []const u8) bool {
    if (name.len == 0 or name.len > FS_NAME_MAX) return false;
    for (name) |ch| {
        if (ch == ' ' or ch == '\t') return false;
        if (ch < 0x21 or ch > 0x7e) return false;
    }
    return true;
}

fn parseNameText(args: []const u8) ?NameText {
    const trimmed = trimSpaces(args);
    if (trimmed.len == 0) return null;

    var split: usize = 0;
    while (split < trimmed.len and trimmed[split] != ' ') : (split += 1) {}
    if (split == 0) return null;

    const name = trimmed[0..split];
    if (split >= trimmed.len) return .{ .name = name, .text = "" };
    const text = trimSpaces(trimmed[split + 1 ..]);
    return .{ .name = name, .text = text };
}

const Quoted = struct {
    text: []const u8,
    next: usize,
};

fn parseItemAddArgs(args: []const u8) ?NameText {
    const trimmed = trimSpaces(args);
    if (trimmed.len == 0) return null;

    // Backward-compatible: item add <title> <text>
    if (trimmed[0] != '"') return parseNameText(trimmed);

    // New mode: item add "title with spaces" "text with spaces"
    const q1 = parseQuoted(trimmed, 0) orelse return null;
    const pos = skipSpaces(trimmed, q1.next);
    if (pos >= trimmed.len) return .{ .name = q1.text, .text = "" };

    if (trimmed[pos] == '"') {
        const q2 = parseQuoted(trimmed, pos) orelse return null;
        return .{ .name = q1.text, .text = q2.text };
    }

    return .{ .name = q1.text, .text = trimSpaces(trimmed[pos..]) };
}

fn parseSingleArgMaybeQuoted(args: []const u8) ?[]const u8 {
    const trimmed = trimSpaces(args);
    if (trimmed.len == 0) return null;
    if (trimmed[0] == '"') {
        const q = parseQuoted(trimmed, 0) orelse return null;
        return q.text;
    }
    return trimmed;
}

fn parseIdTextArgs(args: []const u8) ?NameText {
    const trimmed = trimSpaces(args);
    if (trimmed.len == 0) return null;

    var split: usize = 0;
    while (split < trimmed.len and trimmed[split] != ' ') : (split += 1) {}
    if (split == 0) return null;

    const id = trimmed[0..split];
    if (split >= trimmed.len) return .{ .name = id, .text = "" };
    const rest = trimSpaces(trimmed[split + 1 ..]);
    if (rest.len == 0) return .{ .name = id, .text = "" };
    if (rest[0] == '"') {
        const q = parseQuoted(rest, 0) orelse return null;
        return .{ .name = id, .text = q.text };
    }
    return .{ .name = id, .text = rest };
}

fn parseKeyValueMaybeQuoted(args: []const u8) ?NameText {
    const trimmed = trimSpaces(args);
    if (trimmed.len == 0) return null;

    var split: usize = 0;
    while (split < trimmed.len and trimmed[split] != ' ') : (split += 1) {}
    if (split == 0) return null;

    const key = trimmed[0..split];
    if (split >= trimmed.len) return .{ .name = key, .text = "" };
    const rest = trimSpaces(trimmed[split + 1 ..]);
    if (rest.len == 0) return .{ .name = key, .text = "" };
    if (rest[0] == '"') {
        const q = parseQuoted(rest, 0) orelse return null;
        return .{ .name = key, .text = q.text };
    }
    return .{ .name = key, .text = rest };
}

fn parseItemListFilter(arg: []const u8) ?ItemStatusFilter {
    const clean = trimSpaces(arg);
    if (clean.len == 0) return .all;
    if (strEq(clean, "status:open")) return .open;
    if (strEq(clean, "status:done")) return .done;
    return null;
}

fn parseQuoted(s: []const u8, start: usize) ?Quoted {
    if (start >= s.len or s[start] != '"') return null;
    var i = start + 1;
    const begin = i;
    while (i < s.len and s[i] != '"') : (i += 1) {}
    if (i >= s.len) return null;
    return .{ .text = s[begin..i], .next = i + 1 };
}

fn skipSpaces(s: []const u8, pos: usize) usize {
    var i = pos;
    while (i < s.len and (s[i] == ' ' or s[i] == '\t')) : (i += 1) {}
    return i;
}

fn trimSpaces(s: []const u8) []const u8 {
    var start: usize = 0;
    var end: usize = s.len;
    while (start < end and (s[start] == ' ' or s[start] == '\t')) : (start += 1) {}
    while (end > start and (s[end - 1] == ' ' or s[end - 1] == '\t')) : (end -= 1) {}
    return s[start..end];
}

fn copySlice(dst: []u8, src: []const u8) void {
    var i: usize = 0;
    while (i < src.len and i < dst.len) : (i += 1) {
        dst[i] = src[i];
    }
}

fn reportFsWriteResult(res: FsWriteError!void) void {
    if (res) {
        uartPrint("ok\n");
    } else |err| switch (err) {
        error.InvalidName => uartPrint("invalid name\n"),
        error.NoSpace => uartPrint("no free file slots\n"),
        error.DataTooLarge => uartPrint("file too large\n"),
    }
}
