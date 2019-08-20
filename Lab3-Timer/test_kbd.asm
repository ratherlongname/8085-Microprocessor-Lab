cpu "8085.tbl"
hof "int8"
org 9000H
; DISP_TIME: equ 9034H
; DELAY: equ 903BH
; LOOP_ON_C: equ 903DH
; LOOP_ON_D: equ 9040H
; SUB_6: equ 904BH
; DECR_SEC: equ 9050H
; DECR_MIN: equ 906BH
; DECR_HOUR: equ 9091H
; STOP_TIMER: equ 90BEH
; Put timer value at CURAD and CURDT
MVI A, 00H					;A=0
MVI B, 00H					;B=0
CALL 030EH					;GTHEX
MOV H, D					;H=D
MOV L, E					;L=E
SHLD 8FEFH			; Update hour, min in CURAD
MVI A, 00H					;A=0
MVI B, 01H					;B=1
CALL 030EH					;GTHEX
MOV A, E
STA 8FF1H			; Update secs in CURDT
MVI A, 00H
STA 8600H
MVI A, 0BH
SIM
EI
; MAIN:
CALL 9031H          ; CALL DISP_TIME
CALL 9038H          ; CALL DELAY
LDA 8600H
CPI 01H
JZ 9020H            ; jmp MAIN
JMP 904DH            ; JMP DECR_SEC ; DECR_SEC always ends in JMP MAIN or JMP STOP_TIMER
; DISP_TIME:        ;
; Display values on both displays
CALL 0440H			;UPDAD
CALL 044CH			;UPDDT
RET
; DELAY:            ;
MVI C, 03H			;
; LOOP_ON_C:		;
LXI D, 0A685H		;
; LOOP_ON_D:		;
DCX D				;
MOV A, D			;
ORA E				;
JNZ 903DH           ; JNZ LOOP_ON_D
DCR C				;
JNZ 903AH           ; JNZ LOOP_ON_C
RET
; SUB_6:              ;
MOV A, B
SUI 06H
MOV B, A
RET
; DECR_SEC:         ; 903FH
LDA 8FF1H           ; Load A from CURDT
CPI 00H             ; if sec == 0
JZ 9068H            ; JZ DECR_MIN ; then go to decr min
MOV B, A            ; store A into B
ANI 0FH             ; 
CZ 9048H            ; SUB_6 if sec%10 == 0 then sub 6 from B
MOV A, B
SUI 01H             ; else sec--
MVI B, 00H          ; reset AC
INR B
DAA                 ; BCD(sec)
STA 8FF1H			; Update secs in CURDT; LHLD 8FEFH			; Load hours,mins from CURAD
JMP 9020H           ; back to MAIN
; DECR_MIN:         ;
LHLD 8FEFH			; Load hours,mins from CURAD
MOV A, L            ; Load mins into A
CPI 00H             ; if min == 0
JZ 908EH            ; JZ DECR_HOUR  then go to decr hour
MOV B, A            ; store A into B
ANI 0FH             ; 
CZ 9048H            ; SUB_6 if sec%10 == 0 then sub 6 from B
MOV A, B
SUI 01H             ; else min--
MVI B, 00H          ; reset AC
INR B
DAA                 ; BCD(min)
MOV L, A            ; Set new mins value
SHLD 8FEFH			; Update hour, min in CURAD
MVI A, 59H          ; set sec = 59
MVI B, 00H          ; reset AC
INR B
DAA
STA 8FF1H			; Update secs in CURDT
JMP 9020H           ; back to MAIN
; DECR_HOUR:        ;
LHLD 8FEFH			; Load hours,mins from CURAD
MOV A, H            ; Load hours into A
CPI 00H             ; if hour == 0
JZ 90BBH       ; JZ STOP_TIMER  then stop timer
MOV B, A            ; store A into B
ANI 0FH             ; 
CZ 9048H            ; SUB_6 if sec%10 == 0 then sub 6 from B
MOV A, B
SUI 01H             ; else do hour--
MVI B, 00H          ; reset AC
INR B
DAA                 ; BCD(hour)
MOV H, A            ; Set new hours value
MVI A, 59H          ; set min = 59
MVI B, 00H          ; reset AC
INR B
DAA
MOV L, A            ; set min = 59
SHLD 8FEFH			; Update hour, min in CURAD
MVI A, 59H          ; set sec = 59
MVI B, 00H          ; reset AC
INR B
DAA
STA 8FF1H			; Update secs in CURDT
JMP 9020H            ; back to MAIN
; STOP_TIMER:       ;
RST 5