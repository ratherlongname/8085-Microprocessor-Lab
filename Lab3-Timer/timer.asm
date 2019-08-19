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
; Initialize to timer val at [8500H]
MVI A, 00H			;A=0
MVI B, 00H			;B=0
LHLD 8500H			;HL = [8500H]
MINS_SET:
; Write HL value to Addr. Display Mem Loc
MOV A, L
DAA
MOV L, A
SHLD 8FEFH			;CURAD
MVI A, 59H			;
GOTO_NEXT_SECOND:
DAA
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
; Delay for 1sec
CALL DELAY			;DELAY
; Load secs into A
LDA 8FF1H			;CURDT
; Decrement second
SUI 01H				;A--
;DAA				    ;BCD(A)
CPI FFH				;
; if secs >= 00 then GOTO_NEXT_SECOND is complete
JNZ GOTO_NEXT_SECOND    ;GOTO_NEXT_SECOND
; else secs < 00 so need to decrement mins
; Load hours mins into HL
LHLD 8FEFH			;CURAD
; Decrement mins
MOV A, L			;
SUI 01H				;
;DAA				;
MOV L, A			;
CPI FFH				;
; if mins >= 00 then GOTO_NEXT_SECOND is complete but mins need to be written to CURAD
JNZ MINS_SET			;MINS_SET
; else mins < 00 so need to decrement hours
MVI L, 59H			;
MOV A, H			;
CPI 00H
; if hours == 00 then stop timer
JZ STOP_TIMER
; else decrement hours
SUI 01H				;
DAA			       	;
MOV H, A			;
; mins need to be written to CURAD
JMP MINS_SET	    ;MINS_SET
DELAY:			    ;
MVI C, 03H			;
LOOP_ON_C:			;
LXI D, 0A685H		;
LOOP_ON_D:			;
DCX D				;
MOV A, D			;
ORA E				;
JNZ LOOP_ON_D
DCR C				;
JNZ LOOP_ON_C
RET
STOP_TIMER:
MVI L, 00H
SHLD 8FEFH			;CURAD
MVI A, 00H			;
STA 8FF1H			;CURDT
; Display values on both displays
CALL 0440H			;UPDAD
CALL 044CH			;UPDDT
CALL DELAY
RST 5.5

org 9200H
LDA 8600H           ; Play / pause status is stored at [8600H]
CPI 00H
; if [8600H] != 00 then it was paused and needs to be played.
JNZ STOP_PAUSE
; else it was playing and needs to be paused
MVI A, 01H          ; update status at [8600H]
STA 8600H
JMP INF_DELAY       ; run infinite delay to pause

STOP_PAUSE:
MVI A, 00H          ; update status at [8600H]
STA 8600H
RET                 ; return to play timer

INF_DELAY:
MVI C, 03H			;
LOOP_ON_C:			;
LXI D, 0A685H		;
LOOP_ON_D:			;
DCX D				;
MOV A, D			;
ORA E				;
JNZ LOOP_ON_D
DCR C				;
JNZ LOOP_ON_C
JMP INF_DELAY