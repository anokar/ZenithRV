Needs to by fixet, testet
 
# ZenithRV (zig-kernel-riscv-qemu)
mit ki und humans gemacht!!
Milestone 12: ZenithRV mit Input-Layer, Round-Robin-Demo, RAMFS/UXFS, virtio-blk, Boot-Logo und erster Framebuffer-Shellzeile.

LOGO Fiele: 62505d4d-1779-4096-a951-3da39fff350a.png

## Was jetzt funktioniert

- Bare-Metal Boot auf QEMU `virt` (RISC-V 64)
- Trap-Vector in ASM
- Timer-Interrupt-Ticks
- Exception-Ausgabe (`scause`, `sepc`, `stval`)
- Shell-Prompt auf UART: `zrv> `
- Bei `run-gfx`: Eingabezeile (Prompt + Text + Cursor) auch im Framebuffer-Panel
- UART-Ausgabe wird in den unteren Framebuffer-Consolebereich gespiegelt
- Maus-Klicks im QEMU-Fenster erzeugen sichtbare Marker
- `exit` / `shutdown`
- User-Mode Syscalls (`ecall`)
- Zwei User-Tasks mit Round-Robin (`rrdemo`)

## Build und Start

```powershell
cd C:\Users\(user)\zig-kernel-riscv-qemu
zig build
zig build run
```

Mit `Ctrl+C` QEMU beenden.

Fuer Grafik-Test (QEMU-Fenster + serielle Shell):

```powershell
zig build run-gfx
```

QEMU ist jetzt plattform-neutral per Build-Optionen konfigurierbar:

- `-Dqemu_bin` (default: `qemu-system-riscv64`)
- `-Dqemu_bios` (default: `default`, unter Windows fallback auf MSYS2 OpenSBI-Pfad)

Beispiel (PowerShell):

```powershell
zig build run-gfx -Dqemu_bin="qemu-system-riscv64" -Dqemu_bios="default"
```

Hinweis zu Eingabe im Fenster:
- Einmal ins QEMU-Fenster klicken, damit Maus/Keyboard-Fokus dort aktiv ist.
- Mit `mouse` kannst du im Shell-Output sehen, ob Maus-Events ankommen (`clicks=` Zaehler).

## Docker (reproduzierbar)

Image bauen:

```powershell
docker build -t zenithrv-dev .
```

Container starten:

```powershell
docker run --rm -it `
  -v ${PWD}:/workspace `
  -v zig-local-cache:/zig-local-cache `
  -v zig-global-cache:/zig-global-cache `
  -e ZIG_LOCAL_CACHE_DIR=/zig-local-cache `
  -e ZIG_GLOBAL_CACHE_DIR=/zig-global-cache `
  zenithrv-dev

```

Im Container:

```bash
zig build
```



CI ist vorbereitet in `.github/workflows/ci.yml` und baut bei Push/PR automatisch mit `zig build`.

## Shell-Kommandos

- `help` - Befehle anzeigen
- `ticks` - aktuellen Tick-Zaehler zeigen
- `echo <text>` - Text ausgeben
- `clear` - ANSI clear
- `panic` - Breakpoint-Exception ausloesen
- `rrdemo` - startet User-Mode Round-Robin Demo (`A`/`b`)
- `exit` - System beenden (wie `shutdown`)
- `shutdown` - System beenden
- `ls` - Dateien im RAMFS listen
- `cat <name>` - Datei anzeigen
- `touch <name>` - leere Datei anlegen
- `write <name> <txt>` - Datei ueberschreiben
- `append <name> <txt>` - an Datei anhaengen
- `rm <name>` - Datei loeschen
- `blkprobe` - virtio-blk Status und Kapazitaet anzeigen
- `blkread <sector>` - liest einen 512-Byte Sektor (Preview)
- `blkwrite <sector> <txt>` - schreibt Text in einen 512-Byte Sektor
- `mouse` - zeigt Mausstatus und Klickzaehler
- `gfxprobe` - zeigt virtio-gpu Status + Aufloesung
- `gfxfill <r> <g> <b>` - fuellt den Framebuffer mit einer Farbe (0..255)
- `gfxclear` - schwarzer Bildschirm
- `gfxlogo` - zeichnet den ZenithRV-Bootscreen (Logo + Name) neu
- `mkfs` - initialisiert MiniFS auf der virtuellen Platte
- `fssave` - speichert aktuelles RAMFS ins MiniFS
- `fsload` - laedt MiniFS in RAMFS
- `fsstat` - zeigt RAMFS/MiniFS Status
- `space list|add <name>|use <name>|rm <name>` - Spaces verwalten
- `item list [status:open|status:done]|add <title> <text>|show <id>|tag <id> <tags>|rm <id>|find <text>|filter tag:<x>|edit <id> title|text|tags <v>|move <id> <space>|done <id>|reopen <id>|clone <id>` - Items verwalten
- `uxmkfs` - initialisiert UXFS auf der virtuellen Platte
- `uxsave` - speichert Spaces/Items
- `uxload` - laedt Spaces/Items
- `uxstat` - zeigt UXFS Status

Quote-Beispiele:
- `space add "Project Alpha"`
- `space use "Project Alpha"`
- `item add "Sprint Plan" "Treiber fertigstellen und testen"`
- `item tag 1 "kernel,drivers,urgent"`

## Hinweis zu `rrdemo`

`rrdemo` springt in die User-Task-Demo.
Mit `q` kommst du sauber zur Shell zurueck.
`Ctrl+C` im Host beendet weiterhin QEMU komplett.

## Virtuelle Platte

Beim `zig build run` wird automatisch `disk.img` als `virtio-blk` eingebunden.
Die Datei liegt im Projektordner und kann jederzeit geloescht/neu erzeugt werden.
