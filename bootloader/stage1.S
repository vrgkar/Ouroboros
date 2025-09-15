.section .text
.code16gcc
.globl _stage1

_stage1:
    cli

    xorw %ax, %ax               # Set AX = 0
    movw %ax, %ds               # Set DS = 0
    movw %ax, %ss               # Set SS = 0
    movw %ax, %es               # Set ES = 0
    movw $0x7C00, %sp           # Set SP = 0x7C00

    movw $0x0202, %ax           # Read 2 sectors from disk
    movw $0x0002, %cx           # Start reading from sector 2
    xorb %dh, %dh               # Set head number to 0
    movw $0x7E00, %bx           # Load sectors to 0x7E00 in memory

    int $0x13
    jc error                    # If the sector wasn't able to be loaded, halt

    jmp 0x7E00                  # Jump to Stage 2

error:
    hlt
    jmp error

.org 510
.word 0xAA55
