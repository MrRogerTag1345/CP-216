.org    0x1000    // Start at memory location 1000
.equ UART_BASE, 0xff201000     // UART base address
.text  // Code Section
.global _start
_start:

ldr r0, =array 
ldr r2, =arrayEnd 
SUB r1, r2, r0 
MOV r3, #4 

STMFD sp!, {r1,r3} 
bl div 
LDMFD sp!, {r1,r3}

STMFD sp!, {r0,r2} 
bl bheap 
LDMFD sp!, {r0,r2} 

stop: 
b stop

bheap:
STMFD sp!, {fp,lr} 

mov fp,sp 
STMFD sp!, {r0-r2} 

ldr r0, [fp,#8]
ldr r1, [fp,#12] 
MOV r2, #2 

STMFD sp!, {r1,r2}
bl div
LDMFD sp!, {r1} 
add sp, #4 
SUB r2, #1

bHeapLoop:
cmp r2, #0 
blt _bHeap 
STMFD sp!, {r0,r1,r2}

bl heapify 
LDMFD sp!, {r0,r1,r2}
sub r2,#1 
b bHeapLoop

_bHeap:  
LDMFD sp!, {r0-r2}

LDMFD sp!, {fp,pc}

heapify: 
STMFD sp!, {fp,lr} 

mov fp, sp
STMFD sp!, {r0-r9} 

ldr r0, [fp,#8]
ldr r1, [fp,#12]
ldr r2, [fp,#16]
MOV r4, #4
MOV r9, r2

LSL r7, r2, #1
LSL r8, r2, #1
ADD r7, #1
ADD r8, #2


One:
cmp r1, r7
blt Two

MUL r5, r9, r4
ldr r5, [r0, r5] 

MUL r6, r7, r4
ldr r6, [r0, r6] 

cmp r5, r6
MOVLT r9, r7 

Two: 
cmp r1, r8 
blt Three 

MUL r5, r9, r4
ldr r5, [r0, r5] 

MUL r6, r8, r4
ldr r6, [r0, r6] 
cmp r5, r6
MOVLT r9, r8 
Three: 
cmp r9, r2 
bne SWAP 
b _heapify 
SWAP:

MUL r5, r9, r4
ldr r3, [r0, r5] 

MUL r6, r2, r4
ldr r4, [r0, r6] 

str r3, [r0, r6]
str r4, [r0, r5]

STMFD sp!, {r0, r1, r9} 
bl heapify 
LDMFD sp!, {r0, r1, r9} 

_heapify: 
LDMFD sp!, {r0-r9}
LDMFD sp!, {fp,pc}

div:
STMFD sp!, {fp,lr} 
mov fp, sp 
STMFD sp!, {r0-r1}
ldr r0, [fp, #8] 
ldr r1, [fp, #12]
mov r2, #0 

DLoop:
cmp r0, r1 
blt _div 

SUB r0, r1
ADD r2, #1 
b DLoop 

_div: 
LDMFD sp!, {r0-r1}
LDMFD sp!, {fp, pc}

.data
array: // Array
.word 1,3,5,4,6,13,10,9,8,15,17
arrayEnd: // End of the array
.end