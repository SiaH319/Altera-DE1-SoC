.global _start
array: .word 5,6,7,8
n: .word 4
log2_n:.word 0
tmp: .word 0
norm: .word 1
cnt: .word 100
k: .word 10;
t: .word 2

_start:

LDR R0, =array
LDR R1, n
LDR R2, log2_n
LDR R3, tmp
LDR R4, norm
LDR R5, cnt
LDR R6, k
LDR R7, t
MOV R8, #1

WHILE:
	LSL R9, R8, R2 // 1<<log2_n
	CMP R1, R9 // n - 1<<log2_n
	BLE CONTINUE
	ADD R2, R2 , #1 // log2_n++;
	B WHILE

CONTINUE:
	ldr R8 , [R0] // p = &array[0];
	MOV R9 , #0// R9 =i
FOR:
	CMP R9, R1 // i-n
	BGE AND
	MUL R8, R8, R8
	ADD R3, R8
	ADD R9, R9, #1  //i++
	LDR R8,[R0, R9, LSL#2]
	B FOR
AND:
	ASR R3, R3, R2 //mean = mean >> log2_n
	PUSH {LR}
	BL SQRTITER
	STR R4, norm
	POP {LR}
 	B END

SQRTITER:
	MOV R12, #0 //i=0
LOOP:
	CMP R12, R5	// R0-R3 = i -cnt
    BGE THEN  // If (i-cnt>=0)
	MUL R10, R4, R4 // step = xi*xi
	SUB R10, R10, R3 // step = [xi*xi]-a
	MUL R10, R10, R4 // Step = [(xi*xi-a)]*xi
	ASR R10, R10, R6 // step = [(xi*xi-a)*xi] >> k
	ADD R12, R12, #1 // i = i+1

IF:
	CMP R10, R7	//r7-r5
	MOVGT R10,R7	// if step-t>0, step = t
	BLE ELSE_IF
	SUB R4, R4, R10	// xi = xi-step
	B LOOP

ELSE_IF:
	NEG R11,R7  // R8 = -t
	CMP R10, R11
	MOVLT R10,R11
	SUB R4, R4, R10
	B LOOP

THEN:
	BX LR

END:
	B END
