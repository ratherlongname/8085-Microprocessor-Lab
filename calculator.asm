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

MAIN:
		CPI 00H
		JZ ADD_16_BY_16
		CPI 01H
		JZ SUB_16_BY_16
		CPI 02H
		JZ MUL_8_BY_8
		CPI 03H
		JZ DIV_16_BY_16

ADD_16_BY_16:
		; DE = DE + HL
		DAD D	; HL = HL+DE, CY=CARRY
		JMP END

SUB_16_BY_16:
		;HL = DE-HL
		MOV A, E   	; A = E
		SUB L   	; A = A-L, CY=BORROW
		MOV L, A   	; L = A
		MOV A, D   	; A = D
		SBB H   	; A = A-H-CY
		MOV H, A   	; H = A
		JMP END

MUL_8_BY_8:
		;HL = D*E
		MOV C, D			; C = D
		MVI D 00			; D = 0
		LXI H 0000			; HL = 0
	TEMP_MUL_8_BY_8:		; Temp label
		DAD D				; HL = HL+E
		DCR C				; C--
		JNZ TEMP_MUL_8_BY_8	; LOOP
		JMP END

DIV_16_BY_16:
		;BC = HL/DE
		;HL = HL%DE
		MVI B, 00H
		MVI C, 00H
	TEMP_DIV_16_BY_16:
		MOV A, L					; A = L
		SUB E						; A = A-E, CY=BORROW
		MOV L, A					; L = A
		MOV A, H					; A = H
		SBB D						; A = H-D-CY, CY=BORROW
		MOV H, A					; H = A
		JC TEMP2_DIV_16_BY_16		; CAN NOT SUBTRACT ANYMORE, FINISH SUBROUTINE
		INX B						; BC = BC+1
		JMP TEMP_DIV_16_BY_16		; SUBTRACT AGAIN
	TEMP2_DIV_16_BY_16:
		DAD D						; HL WAS SUBTRACTED 1 EXTRA TIME(THAT IS WHY BORROW = 1, AND YOU JUMPED HERE). SO, ADD DE ONCE TO GET HL=REMAINDER
		JMP END
END:
		RST 5