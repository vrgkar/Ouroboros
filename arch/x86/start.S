.section .start
.code16gcc
.globl _start

_start:

    callw kmain

    .L1:
        hlt
        jmp .L1
