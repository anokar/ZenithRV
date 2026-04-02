# Contributing to ZenithRV

Thanks for helping build ZenithRV.

## Quick start

1. Fork the repo.
2. Create a branch (`feature/...` or `fix/...`).
3. Make focused changes.
4. Run local checks:
   - `zig build`
5. Open a pull request with:
   - What changed
   - Why it changed
   - How you tested

## Development notes

- Keep the kernel bootable on QEMU `virt` (riscv64).
- Prefer small, incremental commits.
- Avoid breaking existing shell commands.
- If you add a command, update `README.md`.

## Docker dev

You can build in a container for reproducibility:

```bash
docker build -t zenithrv-dev .
docker run --rm -it -v "$PWD:/workspace" zenithrv-dev
```

Inside container:

```bash
zig build
```
