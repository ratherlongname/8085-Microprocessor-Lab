cpu "8085.tbl"
hof "int8"
RDKBD: EQU 03BAH
driver: equ 8450h
org 9100H
CALL RDKBD
cpi 1
jz one
cpi 2
jz two
cpi 3
jz three
cpi 4
jz four
cpi 5
jz five
jmp 9100h
one:
    mvi b, 55h
    jmp start
two:
    mvi b, 2Ah
    jmp start
three:
    mvi b, 1bh
    jmp start
four:
    mvi b, 15h
    jmp start
five:
    mvi b, 10H
    jmp start

start:
    XRA A
L3:
    mvi d, 255
L1:
    OUT 00H; 8C05
    OUT 01H
    CALL DELAY
    MVI A, 00H
    DCR D
    JNZ L1
    mvi d, 255
L2:
    OUT 00H; 8C0F
    OUT 01H
    CALL DELAY
    MVI A, 0FFH
    DCR D
    JNZ L2
    IN 41h
    cpi 00000010b
    jz start
    JMP driver

DELAY: 
    MOV C, B
LOOP:
    DCR C
    JNZ LOOP
    RET