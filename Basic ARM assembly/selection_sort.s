.global _start
array: .word 4,2,1,4,-1
n: .word 5

_start:
	LDR R0,=array
	LDR R1, n
	MOV R2, #0 		//i = 0
	SUB R6, R0, #1	//n-1
	MOV R9, #0      //counter

OUTER_FOR:
	// move one by one of the element of the array
	ADD R9, #1		// increment counter
	CMP R9, R1		// if out of the array
	BEQ END 		// END

	LDR R3, [R0, R2, LSL#2]		 //current address array[i]
	MOV R3, R3 					 //current item array[i]

	MOV R7, R2 		// store i as a mininum value index

	ADD R4, R2, #1 	// j = i+1

INNER_FOR:
	// find the index for the smallest element of the array
	CMP R4, R1 // j - n
	BGE SWAP   // if j>=n, swap

IF:
	LDR R5, [R0, R4, LSL#2]  // address array[j]
	MOV R5, R5	 // value for array[i]
	CMP R3, R5   // *(ptr+i) - *(ptr+j)
	BLE ELSE 	 // *(ptr+i) <= *(ptr+j), else
	MOV R3, R5   // tmp = array[j]
	MOV R7, R4   // store j as a mininum value index

ELSE:
	// If current item value is less than *(ptr+j), increment j
	ADD R4, R4, #1 //j++
	B INNER_FOR

SWAP:
	LDR R3, [R0, R2, LSL#2] //current item address
	MOV R3, R3 				//current item value

	LDR R8, [R0, R7, LSL#2] //current minum address
	MOV R8, R8				//current minimum value

	STR R8, [R0, R2, LSL#2] // store min value in current item address
	STR R3, [R0, R7, LSL#2] // store curr value in min item address
	ADD R2, R2, #1

	B OUTER_FOR

END:
	B END
