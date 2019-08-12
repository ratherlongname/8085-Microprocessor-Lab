cpu "8085.tbl"
hof "int8"

org 9000H
MVI A, 00H					;A=0 to display in address field
MVI B, 00H					;B=0 no dot
LXI H, 8504H				;HL=8840
MVI M, 0CH					;[8840]=0C
LXI H, 8505H				;HL=8841
MVI M, 11H					;[8841]=11
LXI H, 8506H				;HL=8842
MVI M, 00H					;[8842]=00
LXI H, 8507H				;HL=8843
MVI M, 0CH					;[8843]=0C
LXI H, 8508H
MVI M, 2EH
LXI H, 8509H
MVI M, 00F3H
LXI H, 8504H				;HL=8840
CALL 0389H					;OUTPUT
MVI A, 01H                  ; to display in data field
MVI B, 01H                  ; yes dot
LXI H, 8508H
CALL 0389H                  ; output
CALL 912AH					;DELAY
CALL 912AH					;DELAY
CALL 02BEH					;CLEAR
MVI A, 00H					;A=0
MVI B, 00H					;B=0
CALL 030EH					;GTHEX
MOV H, D					;H=D
MOV L, E					;L=E
SHLD 8500H
MVI A, 00H					;A=0
MVI B, 01H					;B=1
CALL 030EH					;GTHEX
MOV A, E
STA 8502H



CALL 02BEH					;CLEAR
MVI A, 00H					;A=0
MVI B, 00H					;B=0
CALL 030EH					;GTHEX
MOV H, D					;H=D
MOV L, E					;L=E
SHLD 8510H

LHLD 8500H

; SET_MINS:					;
MOV A, L				;A=L
CPI 60H					;A==60
JC 906CH				;A<60 THEN GOTO SET_HRS
MVI L, 00H				;L=00
; SET_HRS:					;
MOV A, H				;A=H
CPI 24H					;A==24
JC 9081H				;A<24 THEN GOTO SET_SEC
CPI 24H					;//////////////////
JC 906DH				;SUBT_12///////////
MVI H, 00H				;
JMP 9081H				;SET_SEC
; SUBT_12:					;
SUI 12H					;`/////////
MOV H, A				;///////////
MVI A, 00H				;///////////
; SET_SEC:					;
SHLD 8FEFH				;CURAD
LDA 8502H
CPI 60H
JC 908EH                ; if sec < 60 jump to INC_SEC
MVI A, 00H				; else set sec = 0
; INC_SEC:					;
STA 8FF1H				;CURDT
CALL 0440H				;UPDAD
CALL 044CH				;UPDDT
CALL 912AH				;DELAY
LDA 8FF1H				;CURDT
ADI 01H					;A++
DAA						;BCD(A)
CPI 60H					;
JNZ 90DCH	;GOTO_NEXT_SECOND
LHLD 8FEFH				;CURAD
MOV A, L				;
ADI 01H					;
DAA						;
MOV L, A				;
CPI 60H					;
JNZ 90D7H			;MINS_SET
MVI L, 00H				;
MOV A, H				;
ADI 01H					;
DAA						;
MOV H, A				;
CPI 24H					;
JNZ 90D7H			;MINS_SET
LXI H, 0000H			;
JMP 90D7H			;MINS_SET
MOV A, L				;A=L
CPI 60H					;A==60
JC 90CCH			;A<60 THEN GOTO HRS_OVERFLOW
MVI L, 00H				;L=00
; HRS_OVERFLOW:				;
MOV A, H				;A=H
CPI 24H					;A==24
JC 90D7H				;A<24 THEN GOTO MINS_SET
MVI H, 00H				;
JMP 90D7H			;MINS_SET
; MINS_SET:					;
SHLD 8FEFH				;CURAD
MVI A, 00H				;
; GOTO_NEXT_SECOND:			;
STA 8FF1H				;CURDT

LHLD 8FEFH              ; LOAD CURR H, M INTO DE
MOV D, H
MOV E, L
LHLD 8510H              ; LOAD ALARM INTO HL
MOV A, H
CMP D                   ; CMP HOUR
JNZ 90F7H         ; INCORRECT HOUR SO JMP TO WRITE_TO_DISP
MOV A, L
CMP E                   ; CMP MIN
JNZ 90F7H         ; INCORRECT MIN SO JMP TO WRITE_TO_DISP
CALL 02BEH              ; CLEAR (TO MAKE DISPLAY BLINK)
JMP 90FAH               ;skip upddt
; WRITE_TO_DISP:
CALL 044CH				;UPDDT
CALL 0440H				;UPDAD
CALL 912AH				;DELAY
LDA 8FF1H				;CURDT
ADI 01H					;A++
DAA						;BCD(A)
CPI 60H					;
JNZ 90DCH	;GOTO_NEXT_SECOND
LHLD 8FEFH				;CURAD
MOV A, L				;
ADI 01H					;
DAA						;
MOV L, A				;
CPI 60H					;
JNZ 90D7H			;MINS_SET
MVI L, 00H				;
MOV A, H				;
ADI 01H					;
DAA						;
MOV H, A				;
CPI 24H					;
JNZ 90D7H			;MINS_SET
LXI H, 0000H			;
JMP 90D7H			;MINS_SET
; DELAY:						;
MVI C, 03H				;
; LOOP_ON_C:					;
LXI D, 0A685H			;
; LOOP_ON_D:					;
DCX D					;
MOV A, D				;
ORA E					;
JNZ 912FH			;LOOP_ON_D
DCR C					;
JNZ 912CH			;LOOP_ON_C
RET						;