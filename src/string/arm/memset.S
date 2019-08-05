
.syntax unified

.global memset
.type memset,%function
memset:
	push		{ r0, lr }
	and		r1, r1, #255
	orr		r1, r1, r1, lsl #8
	orr		r1, r1, r1, lsl #16
	mov		lr, r1
	cmp		r2, #15
	bcc		3f

	rsb		r3, r0, #0
	and		r3, r3, #15
	lsls		r12, r3, #31
	strbmi		r1, [r0], #1
	strhcs		r1, [r0], #2
	lsls		r12, r3, #29
	strmi		r1, [r0], #4
	stmiacs 	r0!, { r1, lr }
	sub		r2, r2, r3
	mov		r3, r1
	mov		r12, r1

1:	subs		r2, r2, #16
	stmiacs 	r0!, { r1, r3, r12, lr }
	bcs		1b

	b		4f

2:	subs		r2, r2, #1
	bcc		5f
	strb		r1, [r0], #1
3:	tst		r0, #3
	bne		2b

4:	lsls		r2, r2, #29
	stmiacs 	r0!, { r1, lr }
	strmi		r1, [r0], #4
	lsls		r2, r2, #2
	strhcs		r1, [r0], #2
	strbmi		r1, [r0]

5:	pop		{ r0, lr }
	bx		lr

