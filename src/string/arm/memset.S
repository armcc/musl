/* Copyright (C) 1998-2019 Free Software Foundation, Inc.
   This file is part of the GNU C Library.
   Contributed by Philip Blundell <philb@gnu.org>

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library.  If not, see
   <http://www.gnu.org/licenses/>.  */


	.text
	.syntax unified

	.arm			@ Thumb-2 requires excessive IT insns here.

	.global memset
	.type memset,%function

memset:

	push		{ r0, r4 }

	rsb		r3, r0, #0		@ alignment bytes = ((0 - dst) & 0x03)
	and		r1, r1, #255
	and		r3, r3, #3
	orr		r1, r1, r1, lsl #8
	cmp		r3, r2			@ if alignment bytes > count, then alignment bytes = count
	movhi		r3, r2

	movs		r4, r3, lsl #31
	strbmi		r1, [r0], #1
	strhcs		r1, [r0], #2
	subs		r2, r2, r3		@ count -= alignment bytes
	beq		2f

	orr		r1, r1, r1, lsl #16
	mov		r3, r1
	mov		r4, r1
	mov		r12, r1

1:	subs		r2, r2, #16
	stmiacs		r0!, { r1, r3, r4, r12 }
	subscs		r2, r2, #16
	stmiacs		r0!, { r1, r3, r4, r12 }
	bcs		1b

	movs		r2, r2, lsl #29		@ upto 15 bytes remaining, dst is aligned
	stmiacs		r0!, { r1, r3 }
	strmi		r1, [r0], #4

	movs		r2, r2, lsl #2
	strhcs		r1, [r0], #2
	strbmi		r1, [r0], #1

2:	pop		{ r0, r4 }

	bx		lr
