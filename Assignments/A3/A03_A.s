// Assignment 3 Question A

// Constants
.equ UART_BASE, 0xff201000     // UART base address
.equ MASK, 0x0F
.equ DIGIT, 0x30
.equ LETTER, 0x37
.org    0x1000    // Start at memory location 1000

.text  // Code Section

.global _start

_start:

///////////////////////////////////////
///////////Your Code Here /////////////
///////////////////////////////////////

ldr r3, =mylist
ldr r5, =stopendarray
mov r8, #0

loopdeloop:

	ldr r7, [r3]
	add r8, r8, #1
	lsls r7, #1 
	
	bcs plusone
	b gonext

plusone:
	add r4, #1
	
gonext:
	add r3, #4 
	lsl r4, #1  
			    
	cmp r3, r5  
	bne loopdeloop

lsr r4, #1 

rsb r9, r8, #32  
cmp r8, #32
lsllt r4, r9

// Print R4 to UART as ASCII in hexadecimal

LDR R0, =UART_BASE

MOV R1,#8

// Print the register contents as ASCII characters

// Assumes value to print is in R4, UART address in R0

// Uses R1 for counter and R2 for temporary value

// R0 and R4 are preserved

TOP:

ROR R4,#28            // Rotate next four bits to LSB

MOV R2,R4             // Copy to R2 for masking

AND R2,R2,#MASK       // Keep last 4 bits only

CMP R2,#9             // Compare last 4 bits to 9

ADDLE R2,R2,#DIGIT    // add ASCII coding for 0 to 9

ADDGT R2,R2,#LETTER   // add ASCII coding for A to F

STR R2,[R0]           // Copy ASCII byte to UART

SUB R1,#1             // Move to next byte

CMP R1,#0             // Compare the countdown value to 0

BGT TOP               // Branch to TOP if greater than 0

 

_stop:

B    _stop

.data
mylist:
	.word -15, 15, 1, 2, -1, -2, -13, -14, -99, 12, 13, 1, 2, -1, -2, -3
stopendarray: 