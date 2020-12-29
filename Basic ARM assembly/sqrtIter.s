.global _start

a: .word 168
xi: .word 1
cnt: .word 100
k: .word 10
t: .word 2

_start:

MOV R0, #0 // i=0
LDR R1, a
LDR R2, xi
LDR R3, cnt
LDR R4, k
LDR R5, t

LOOP:
	CMP R0, R3	// R0-R3 = i -cnt
	BGE THEN  // If (i-cnt>=0)

	MUL R7, R2, R2 // step = xi*xi
	SUB R7, R7, R1 // step = [xi*xi]-a
	MUL R7, R7, R2 // Step = [(xi*xi-a)]*xi
	ASR R7, R7, R4 // step = [(xi*xi-a)*xi] >> k

	ADD R0, R0, #1 // i = i+1

IF:
	CMP R7, R5	//step - t
	MOVGT R7,R5	// if step-t>0, step = t
	BLE ELSE_IF
	SUB R2, R2, R7	// xi = xi-step
	B LOOP

ELSE_IF:
	NEG R8,R5  // R8 = -t
	CMP R7, R8	// step - (-t)
	MOVLT R7,R8	// step+t<0
	SUB R2, R2, R7 //xi = xi -step
	B LOOP

THEN:
	STR R2, xi

END:
	B END
