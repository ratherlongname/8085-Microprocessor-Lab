
cpu "8085.tbl"
hof "int8"
RDKBD: EQU 03BAH
driver: equ 8450h
org 9000H
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
jmp 9000h
one:
    mvi b, 50h
    jmp start
two:
    mvi b, 25h
    jmp start
three:
    mvi b, 18h
    jmp start
four:
    mvi b, 10h
    jmp start
five:
    mvi b, 0cH
    jmp start

start:
    XRA A
L1:
    OUT 00H; 8C05
    OUT 01H
    CALL DELAY
    INR A
    CPI 0FFH
    JNZ L1
L2:
    OUT 00H; 8C0F
    OUT 01H
    CALL DELAY
    DCR A
    JNZ L2

    IN 41h
    cpi 00000001b
    jz start
    JMP driver

DELAY: 
    MOV C, B
LOOP:
    DCR C
    JNZ LOOP
    RET