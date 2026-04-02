const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const target_query: std.Target.Query = .{
        .cpu_arch = .riscv64,
        .os_tag = .freestanding,
        .abi = .none,
    };
    const target = b.resolveTargetQuery(target_query);

    const kernel = b.addExecutable(.{
        .name = "kernel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/kernel.zig"),
            .target = target,
            .optimize = optimize,
            .code_model = .medium,
        }),
    });

    kernel.root_module.addAssemblyFile(b.path("src/boot.S"));
    kernel.root_module.addAssemblyFile(b.path("src/trap.S"));
    kernel.setLinkerScript(b.path("linker.ld"));
    kernel.entry = .disabled;
    kernel.pie = false;
    kernel.root_module.red_zone = false;
    kernel.root_module.omit_frame_pointer = false;
    kernel.root_module.single_threaded = true;

    b.installArtifact(kernel);

    const qemu_bin = b.option(
        []const u8,
        "qemu_bin",
        "Path to qemu-system-riscv64 binary",
    ) orelse "qemu-system-riscv64";
    const bios = b.option(
        []const u8,
        "qemu_bios",
        "Path to OpenSBI firmware (or 'default')",
    ) orelse
        if (builtin.os.tag == .windows)
            "C:\\msys64\\ucrt64\\share\\qemu\\opensbi-riscv64-generic-fw_dynamic.bin"
        else
            "default";

    const run_step = b.step("run", "Boot kernel in QEMU (riscv64 virt)");
    const qemu = b.addSystemCommand(&.{qemu_bin});
    qemu.addArgs(&.{
        "-accel",
        "tcg,tb-size=32",
        "-machine",
        "virt",
        "-global",
        "virtio-mmio.force-legacy=false",
        "-cpu",
        "rv64",
        "-m",
        "128M",
        "-nographic",
        "-chardev",
        "stdio,id=char0,signal=off",
        "-serial",
        "chardev:char0",
        "-monitor",
        "none",
        "-drive",
        "file=disk.img,if=none,id=vd0,format=raw",
        "-device",
        "virtio-blk-device,drive=vd0",
        "-device",
        "virtio-keyboard-device",
    });
    qemu.addArg("-bios");
    qemu.addArg(bios);
    qemu.addArg("-kernel");
    qemu.addArtifactArg(kernel);
    run_step.dependOn(&qemu.step);
    qemu.step.dependOn(b.getInstallStep());

    const run_gfx_step = b.step("run-gfx", "Boot kernel in QEMU with virtio-gpu window");
    const qemu_gfx = b.addSystemCommand(&.{qemu_bin});
    qemu_gfx.addArgs(&.{
        "-accel",
        "tcg,tb-size=32",
        "-machine",
        "virt",
        "-global",
        "virtio-mmio.force-legacy=false",
        "-cpu",
        "rv64",
        "-m",
        "128M",
        "-chardev",
        "stdio,id=char0,signal=off",
        "-serial",
        "chardev:char0",
        "-monitor",
        "none",
        "-drive",
        "file=disk.img,if=none,id=vd0,format=raw",
        "-device",
        "virtio-blk-device,drive=vd0",
        "-device",
        "virtio-gpu-device",
        "-device",
        "virtio-mouse-device",
        "-device",
        "virtio-keyboard-device",
    });
    qemu_gfx.addArg("-bios");
    qemu_gfx.addArg(bios);
    qemu_gfx.addArg("-kernel");
    qemu_gfx.addArtifactArg(kernel);
    run_gfx_step.dependOn(&qemu_gfx.step);
    qemu_gfx.step.dependOn(b.getInstallStep());
}
