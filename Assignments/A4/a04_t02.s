.org    0x1000    // Start at memory location 1000
.equ LIMIT, 10 //Limits the number of times the loop will loops.
.text  // Code Section
.global _start
_start:

bl fib

_stop:
B    _stop

fib:
stmfd  sp!, {r0-r3, r4, lr}

ldr r0, =arr
mov r1, #1
mov r2, #1
mov r4, #3

loop:
	add r3, r1, r2
	add r4, r4, #1
	mov r1, r2
	mov r2, r3
	cmp r4, #LIMIT
	ble loop

str r3, [r0]
ldmfd  sp!, {r0-r3, r4, pc}

.data
arr:
.space 4

endarr:

.end