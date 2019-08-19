cpu "8085.tbl"
hof "int8"

org 9000H
; PRINT Clock
MVI A, 00H			;A=0
MVI B, 00H			;B=0
LXI H, 8504H			;HL=8840
MVI M, 0CH			;[8840]=0C
LXI H, 8505H			;HL=8841
MVI M, 11H			;[8841]=11
LXI H, 8506H			;HL=8842
MVI M, 00H			;[8842]=00
LXI H, 8507H			;HL=8843
MVI M, 0CH			;[8843]=0C
LXI H, 8508H
MVI M, 2EH
LXI H, 8509H
MVI M, 00F3H
LXI H, 8504H			;HL=8840
CALL 0389H			;OUTPUT
MVI A, 01H
MVI B, 01H
LXI H, 8508H
CALL 0389H
CALL 9103H			;DELAY
CALL 9103H			;DELAY
CALL 02BEH			;CLEAR
; Initialize to 00:00
MVI A, 00H			;A=0
MVI B, 00H			;B=0
MOV H, 00H			;H=D
MOV L, 00H			;L=E
; MINS_SET:
; Write HL value to Addr. Display Mem Loc
SHLD 8FEFH			;CURAD
MVI A, 00H			;
; GOTO_NEXT_SECOND:
; Write A to Data Display Mem Loc
STA 8FF1H			;CURDT
; Display values on both displays
CALL 0440H			;UPDAD
CALL 044CH			;UPDDT
; Enable interrupt
MVI A,1BH
SIM
EI
MVI A, 00H
; Delay for 1s	
CALL 9103H			;DELAY
; Load secs into A
LDA 8FF1H			;CURDT
; Increment second
ADI 01H				;A++
DAA				;BCD(A)
CPI 60H				;
; if secs < 60 then GOTO_NEXT_SECOND is complete
JNZ 90CDH			;GOTO_NEXT_SECOND
; else secs == 60 so need to increment mins
; Load hours mins into HL
LHLD 8FEFH			;CURAD
; Increment mins
MOV A, L			;
ADI 01H				;
DAA				;
MOV L, A			;
CPI 60H				;
; if mins < 60 then GOTO_NEXT_SECOND is complete but mins need to be written to CURAD
JNZ 90C8H			;MINS_SET
; else mins == 60 so need to increment hours
MVI L, 00H			;
MOV A, H			;
ADI 01H				;
DAA				;
MOV H, A			;
; mins need to be written to CURAD
JMP 90C8H			;MINS_SET
; DELAY:			;
MVI C, 03H			;
; LOOP_ON_C:			;
LXI D, 0A685H			;
; LOOP_ON_D:			;
DCX D				;
MOV A, D			;
ORA E				;
JNZ 9108H			;LOOP_ON_D
DCR C				;
JNZ 9105H			;LOOP_ON_C
RST 5