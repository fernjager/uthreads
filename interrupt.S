#include <avr/io.h>

.extern totalThreads
.extern currentThread
.extern savedStates

.global addThread
addThread:
	; disable interrupts
	cli

	; #### THE CURRENT THREAD IS PUSHED TO STACK
	; ## Let's pop all the registers and put them in our special zone
	; Get total threads value
	lds	r2, totalThreads

	; get currentThread variable value
	lds r3, currentThread

	; Get the memory address for our savedStates blocks
	; we store stuff descending
	; savedStatesBeginningPtr + 40 * (currentThread)
	; load into X
	ldi r16, 40
	mov r17, r3
	rcall mult

	; okay, now we're in position- start storing data
	; buggg second part?
	clr XL
	clr XH
	ldi XL, savedStates
	add XL, r16

	; store current thread from the stack into the state block
	; WHILE LOOP
	; pop r4
	; st X+,r4

	; #### THE NEW THREAD IS PUSHED TO STACK IN THE ALLOCATED SPACE

	; Increment number of threads
	inc	r2
	sts	totalThreads, r2

	; Increment current thread count
	inc r3
	sts currentThread, r3

	; DEBUG:
	ser r21

	; populate saved savedStates for this currentThread
	; 40 bytes
	; LOW --| [CTRL][PCL][PCH][SPL][SPH][STATUS][ARGL][ARGH][R0...R31] |-- HIGH
	st X+,r21 	; CTRL
	st X+,r21 	; PCL
	st X+,r21 	; PCH
	st X+,r21 	; SPL
	st X+,r21 	; SPH
	st X+,r21 	; STATUS
	st X+,r21 	; ARGL
	st X+,r21 	; ARGH


	; Populate R0 ... R31
	ldi r20, 32
	fillRegs:
		st 		X+,r21    ; 0
		dec 	r20
		brne 	fillRegs


	; # GREAT, NOW JUMP TO THE FUNCTION AND RUN IT
	; r24,25 together compose a 16-bit address to the function pointer
	; that is the first argument to this function
	; we make this Z, so that when we call ijmp, it'll  jump to the function
	; ZL(r30) ZH (r31)
	; YL(r28) YH( r29)
	; XL(r26) XH (r27)

	mov	ZL,r24
	mov	ZH,r25

	; r22,r23 together compose a 16-bit (void*) pointer as the second argument,
	; which we're just simply passing as the first argument to the next function call
	mov	r24,r22
	mov	r25,r23

	//ijmp

; multiplication function
; r16 = r16 * r17, uses r18, r19
mult:
	; save original second term
	mov r18, r16
	; save second term as counter
	mov r19, r17

	; end if we're multiplying with zero
	cp r17, r1
	breq zero

	multloop:
		dec r19
		cp r19, r1
		breq end
		add r16,r18
		rjmp multloop
	end:
		ret
	zero:
		clr r16
		ret
