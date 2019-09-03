cpu "8085.tbl"
hof "int8"
triangle: EQU 9000h
square: EQU 9100h
sawtooth: EQU 9200h
st_tr: EQU 9300h
st_st: EQU 9400h
org 8400h

MVI A, 8BH
OUT 43H

mvi A, 80H
out 03H

jmp loop

org 8450h
loop:
IN 41h

cpi 00000001b
jz triangle
cpi 00000010b
jz square
cpi 00000100b
jz sawtooth
cpi 00001000b
jz st_tr
cpi 00010000b
jz st_st
jmp loop