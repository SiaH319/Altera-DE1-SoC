.global _start

a: .word 168
xi: .word 1
cnt: .word 100
k: .word 10
t: .word 2

_start:
// load variables
LDR R1, a
LDR R2, xi
LDR R3, cnt
LDR R4, k
LDR R5, t

sqrtRecur: // function
	CMP R3, #0
	BEQ THEN // if R3 == 0 (cnt == 0), branch to END
	// else
	MUL R0, R2, R2 // grad = xi*xi
	SUB R0, R0, R1 // grad = [xi*xi]-a
	MUL R0, R0, R2 // grad = [xi*xi-a]*xi
	ASR R0, R0, R4 // grad = [(xi*xi-a)*xi] >> k

IF:
	CMP R0, R5	//  r0-r5 (grad-t)
	MOVGT R0,R5	//  if grad-t>0, grad <= t
	BLE ELSE_IF	// else
	SUB R2, R2, R0	// xi = xi-grad
	B RECURSIVE

ELSE_IF:
	NEG R6, R5	// R6 = -R5 = -t
	CMP R0, R6  // R0-R8 (grad+t)
	MOVLT R0, R6 // if R0-R8<0, R0 <= R6
	SUB R2, R2, R0	// xi = xi-grad
	B RECURSIVE

RECURSIVE:
	SUB R3, R3, #1
	BL sqrtRecur

THEN:
	BX LR
	STR R2, xi // return xi

END:
	B END
