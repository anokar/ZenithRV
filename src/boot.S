.section .text.boot
.globl _start
_start:
    # OpenSBI passes hartid in a0 for S-mode payloads.
    bnez a0, 1f

    la sp, _stack_top
    call kmain

1:
    wfi
    j 1b

.section .bss.stack, "aw", @nobits
.align 16
.globl _stack_bottom
_stack_bottom:
    .space 16384
.globl _stack_top
_stack_top:
