OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
  . = 0x80200000;

  .text : ALIGN(4K)
  {
    *(.text.boot)
    *(.text*)
  }

  .rodata : ALIGN(4K)
  {
    *(.rodata*)
  }

  .data : ALIGN(4K)
  {
    *(.data*)
  }

  .bss (NOLOAD) : ALIGN(4K)
  {
    *(.bss*)
    *(COMMON)
  }
}
