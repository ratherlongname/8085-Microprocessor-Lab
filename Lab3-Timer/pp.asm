cpu "8085.tbl"
hof "int8"
org 9200H
CALL 03BAH
LDA 8600H           ; Play / pause status is stored at [8600H]
CPI 00H
JZ SET_1
MVI A, 00H
STA 8600H
EI
JMP 9020H            ; jmp to main
SET_1:
MVI A, 01H
STA 8600H
EI
JMP 9020H            ; jmp to main