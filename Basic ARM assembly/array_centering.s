.global _start

array: .word 3,4,5,4
n: .word 4
mean: .word 0
log2_n: .word 0

_start:
	LDR R0, n
	LDR R1, =array	// R1 <- &array[0]
	LDR R2, mean
	LDR R3, log2_n

	MOV R4, #0 // i = 0
	MOV R5, #1 // for WHILE

WHILE:
	LSL R5, R5, R3 //R5 <- (1<<log2_n)
	CMP R5, R0	   // R4 - R0 <- (1<<log2_n)-n
	BGE CONTINUE1  // if (1<<log2_n)-n > 0, break while and continue
	ADD R3, R3, #1 // log2_n++
	B WHILE

CONTINUE1:
	LDR R6, [R1] // ptr = &array[0], hold the address of array[0]

FOR1: // mean = sum of the elements of the array
	CMP R4, R0 //i-n
	BGE CONTINUE2 // if i-n>=0, then CONTINUE2
	ADD R4, R4, #1 // i = i+1
	ADD R2, R2, R6 // mean = mean + *ptr
	LDR R6, [R1, R4, LSL#2] //ptr++
	B FOR1

CONTINUE2:
	ASR R2, R2, R3 // mean = mean >> log2_n
	MOV R4, #0 // i = 0

	LDR R6, [R1] // ptr = &array[0], hold the address of array[0]

FOR2: // for each element of the array, subtract by mean
	CMP R4, R0 //i-n
	BGE END // if i-n>=0, then END
	ADD R4, #1 // i = i+1
	SUB R7, R6 ,R2
	STR R7, [R1]
	ADD R1, R1, #4

	LDR R6, [R1]

	B FOR2

END:
	B END
