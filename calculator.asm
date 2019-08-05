; Calculator
; In A =
; 0 for addition
; 1 for subtraction
; 2 for multiplication
; 3 for division
; Result is stored in HL
cpu "8085.tbl"
hof "int8"

org 9000h

MAIN:	CPI 00H
	JZ ADD16
	CPI 01H
	JZ SUB16
	CPI 02H
	JZ MUL16
	CPI 03H
	JZ DIV16

ADD16:	DAD D
	JMP END

SUB16:

MUL16:

DIV16:

END:	RST 5