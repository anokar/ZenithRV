![ZenithRV Logo](62505d4d-1779-4096-a951-3da39fff350a.png)

# ZenithRV (zig-kernel-riscv-qemu)

Built by humans and AI.

**Milestone 12:** ZenithRV with input layer, round-robin demo, RAMFS/UXFS, virtio-blk, boot logo, and first framebuffer shell line.

---

## 🚧 Status

Needs fixing and testing.

---

## 🚀 Features (What Works So Far)

- Bare-metal boot on QEMU `virt` (RISC-V 64)
- Trap vector in assembly
- Timer interrupt ticks
- Exception output (`scause`, `sepc`, `stval`)
- UART shell prompt: `zrv> `
- With `run-gfx`: input line (prompt + text + cursor) rendered in framebuffer
- UART output mirrored into framebuffer console area
- Mouse clicks in QEMU window create visible markers
- `exit` / `shutdown`
- User-mode syscalls (`ecall`)
- Two user tasks with round-robin scheduling (`rrdemo`)

---

## 🛠️ Build & Run

```powershell
cd C:\Users\(user)\zig-kernel-riscv-qemu
zig build
zig build run

Stop QEMU with Ctrl+C.

Graphics Mode (QEMU window + serial shell)
zig build run-gfx
⚙️ QEMU Configuration

QEMU is configurable via build options:

-Dqemu_bin (default: qemu-system-riscv64)
-Dqemu_bios (default: default, Windows fallback to MSYS2 OpenSBI path)

Example:

zig build run-gfx -Dqemu_bin="qemu-system-riscv64" -Dqemu_bios="default"
Input Notes
Click inside the QEMU window to focus mouse/keyboard input.
Use mouse command to verify input events (clicks= counter).
🐳 Docker (Reproducible Setup)

Build image:

docker build -t zenithrv-dev .

Run container:

docker run --rm -it `
  -v ${PWD}:/workspace `
  -v zig-local-cache:/zig-local-cache `
  -v zig-global-cache:/zig-global-cache `
  -e ZIG_LOCAL_CACHE_DIR=/zig-local-cache `
  -e ZIG_GLOBAL_CACHE_DIR=/zig-global-cache `
  zenithrv-dev

Inside container:

zig build
🔄 CI

CI is preconfigured in .github/workflows/ci.yml and automatically builds on push/PR using:

zig build
💻 Shell Commands
General
help — list commands
ticks — show current tick counter
echo <text> — print text
clear — ANSI clear screen
panic — trigger breakpoint exception
System
exit — exit system (same as shutdown)
shutdown — shut down system
Tasks
rrdemo — start round-robin user-mode demo (A / b)
File System (RAMFS)
ls — list files
cat <name> — show file
touch <name> — create empty file
write <name> <txt> — overwrite file
append <name> <txt> — append to file
rm <name> — delete file
Block Device (virtio-blk)
blkprobe — show device status and capacity
blkread <sector> — read 512-byte sector (preview)
blkwrite <sector> <txt> — write text to sector
Graphics / Input
mouse — show mouse status and click counter
gfxprobe — show GPU status and resolution
gfxfill <r> <g> <b> — fill framebuffer (0–255)
gfxclear — clear screen (black)
gfxlogo — redraw ZenithRV boot screen
Filesystem Persistence
mkfs — initialize MiniFS on disk
fssave — save RAMFS to MiniFS
fsload — load MiniFS into RAMFS
fsstat — show FS status
UXFS (Spaces & Items)
uxmkfs — initialize UXFS
uxsave — save spaces/items
uxload — load spaces/items
uxstat — show UXFS status
Spaces
space list
space add <name>
space use <name>
space rm <name>
Items
item list [status:open|status:done]
item add <title> <text>
item show <id>
item tag <id> <tags>
item rm <id>
item find <text>
item filter tag:<x>
item edit <id> title|text|tags <value>
item move <id> <space>
item done <id>
item reopen <id>
item clone <id>
✍️ Example Usage
space add "Project Alpha"
space use "Project Alpha"
item add "Sprint Plan" "Finish and test drivers"
item tag 1 "kernel,drivers,urgent"
🔁 Round-Robin Demo

Run:

rrdemo
Press q to return cleanly to the shell
Ctrl+C (host) still exits QEMU completely
💾 Virtual Disk
disk.img is automatically attached as virtio-blk
Located in the project directory
Can be deleted/recreated at any time