.code16gcc

.section .start
.globl _start

_start:

    callw kmain

    .L1:
        hlt
        jmp .L1
