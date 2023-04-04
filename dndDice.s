.global _start
_start:
LDR R0, =0xFF200020 //7 Segment display base address
LDR R1, =HEXTABLE //Lookup table for hex digits
LDR R2, =0xFFFEC600 //Private timer base address
LDR R3, =0xFF200050 //Push button base address
LDR R4, =#0xff200040 //Switch Base
BL TIMERSETUP //Timer Setup subroutine
ADD R6, R0, #4 //digit 2
MOV R7, #0 //Button Flag
MAINLOOP:
LDR R10, [R3, #0xC] //Read edge capture Register
CMP R10, #0
MOVNE R7, #1 //Activate the flag if button is pressed
STRNE R10, [R3, #0xC] //Clear the key edge
CMP R7, #0
BEQ MAINLOOP
MOV R7, #0 //reset flag
MOV R8, #10 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R4]
//LSR R10, #21 //clearing unused bits
SWITCHLOOP:
AND R11, R10, #1
LSR R10, #1
CMP R11, #1
ADDEQ R9, R9, #1
//CMP R10, #0
SUBS R8, R8, #1
BGT SWITCHLOOP
CMP R9, #1
BEQ DFOUR
CMP R9, #2
BEQ DSIX
CMP R9, #3
BEQ DEIGHT
CMP R9, #4
BEQ DTEN
CMP R9, #5
BEQ DTWELVE
CMP R9, #6
BEQ DTWENTY
B MAINLOOP
DFOUR:
PUSH {R4, R5, R8, R9, R10, R11, LR}
MOV R8, #3 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R2, #4] //load timer current value
AND R10, R10, #0b1111
LOOP4:
SUBS R10, R10, #4
BGT LOOP4
CMP R10, #0
ADDNE R10, R10, #4
ADD R9, R10, #1
LDRB R5, [R1, R9]
STR R5, [R0]
POP {R4, R5, R8, R9, R10, R11, PC}
DSIX:
PUSH {R4, R5, R8, R9, R10, R11, LR}
MOV R8, #5 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R2, #4] //load timer current value
AND R10, R10, #0b11111
LOOP6:
SUBS R10, R10, #6
BGT LOOP6
CMP R10, #0
ADDNE R10, R10, #6
ADD R9, R10, #1
LDRB R5, [R1, R9]
STR R5, [R0]
POP {R4, R5, R8, R9, R10, R11, PC}
DEIGHT:
PUSH {R4, R5, R8, R9, R10, R11, LR}
MOV R8, #7 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R2, #4] //load timer current value
AND R10, R10, #0b11111
LOOP8:
SUBS R10, R10, #8
BGT LOOP8
CMP R10, #0
ADDNE R10, R10, #8
ADD R9, R10, #1
LDRB R5, [R1, R9]
STR R5, [R0]
POP {R4, R5, R8, R9, R10, R11, PC}
DTEN:
PUSH {R4, R5, R8, R9, R10, R11, LR}
MOV R8, #9 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R2, #4] //load timer current value
AND R10, R10, #0b11111
LOOP10:
SUBS R10, R10, #10
BGT LOOP10
CMP R10, #0
ADDNE R10, R10, #10
ADD R9, R10, #1
MOV R4, #0
CMP R9, #10
MOVEQ R4, #1
LDRB R11, [R1, R4]
LSL R11, #8
LDRNEB R5, [R1, R9]
LDREQB R5, [R1]
ORR R5, R5, R11
STR R5, [R0] //write second digit
POP {R4, R5, R8, R9, R10, R11, PC}
DTWELVE:
PUSH {R4, R5, R8, R9, R10, R11, LR}
MOV R8, #11 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R2, #4] //load timer current value
AND R10, R10, #0b11111
LOOP12:
SUBS R10, R10, #12
BGT LOOP12
CMP R10, #0
ADDNE R10, R10, #12
ADD R9, R10, #1
MOV R4, #0
DIV12:
SUBS R9, R9, #10
ADDGE R4, R4, #1
BGT DIV12
LDRB R5, [R1, R4]
CMP R9, #0
ADDNE R4, R9, #10
MOVEQ R4, #0
LDRB R11, [R1, R4]
LSL R5, #8
ORR R5, R5, R11
STR R5, [R0] //write second digit
POP {R4, R5, R8, R9, R10, R11, PC}
DTWENTY:
PUSH {R4, R5, R8, R9, R10, R11, LR}
MOV R8, #19 //Loop iterator
MOV R9, #0 //Counter
LDR R10, [R2, #4] //load timer current value
AND R10, R10, #0b111111
LOOP20:
SUBS R10, R10, #20
BGT LOOP20
CMP R10, #0
ADDNE R10, R10, #20
ADD R9, R10, #1
MOV R4, #0
DIV20:
SUBS R9, R9, #10
ADDGE R4, R4, #1
BGT DIV20
LDRB R5, [R1, R4]
CMP R9, #0
ADDNE R4, R9, #10
MOVEQ R4, #0
LDRB R11, [R1, R4]
LSL R5, #8
ORR R5, R5, R11
STR R5, [R0] //write second digit
POP {R4, R5, R8, R9, R10, R11, PC}
TIMERSETUP:
PUSH {R3, LR} //save registers
LDR R3, =200000000 //Timer value
STR R3, [R2] //Load to timer load register
MOV R3, #0b011 //Enable auto mode and timer
STR R3, [R2, #8] //Load to timer control register
POP {R3, PC} //Restore and branch out
HEXTABLE: .byte 0b0111111, 0b0000110, 0b1011011, 0b1001111, 0b1100110, 0b1101101, 0b1111101, 0b0000111, 0b1111111, 0b1101111