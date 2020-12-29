.equ HEX_0_3, 0xFF200020 // hex display HEX0-HEX3
.equ HEX_4_5, 0xFF200030 // hex display HEX4-HEX5

//==============================================================================================
//==============================================================================================

HEX_clear_ASM:
	PUSH {R0-R12, LR} // push registers to the stack
	LDR R2, =HEX_0_3
	LDR R3, =HEX_4_5

	MOV R4, #0xFFFFFF00
	// 11111111 11111111 11111111 00000000
	MOV R5, #0 // counter for on hot encode detection
clear:
	CMP R5, #5 // detected HEX0-HEX5
	BGT end_clear

	CMP R5, #4 // detected HEX0-HEX3
	MOVEQ R2, R3
	MOVEQ R4, #0xFFFFFF00 // restore R3

	AND R6, R0, #1 //check which hex display to use
	ASR R0, R0, #1 // move to the next bit

	CMP R6, #0 // if 1, clear that hex display
	ADDEQ R5, R5, #1
	// increment the counter: next display
	LSLEQ R4, #8 	// shift by 8
	ADDEQ R4, R4, #0xFF
	/*
	HEX0: #0xFFFFFF00
	HEX1: #0xFFFF00FF
	HEX2: #0xFF00FFFF
	HEX3: #0x00FFFFFF
	HEX4: #0xFFFFFF00
	HEX5: #0xFFFF00FF
	*/
	BEQ clear

	LDR R7, [R2] // load HEX0-3 or HEX4-5
	AND R7, R7, R4 // clear the designated hex display
	// AND 0 to any value is 0 => clear
 	STR R7, [R2]

	ADD R5, R5, #1 // increment counter
	LSL R4, #8 // shift by 8
	ADD R4, R4, #0xFF
		/*
	HEX0: #0xFFFFFF00
	HEX1: #0xFFFF00FF
	HEX2: #0xFF00FFFF
	HEX3: #0x00FFFFFF
	HEX4: #0xFFFFFF00
	HEX5: #0xFFFF00FF
	*/
	B clear

end_clear:
	POP {R0-R12, LR}
	BX LR

//==============================================================================================
//==============================================================================================


HEX_flood_ASM:
	PUSH {R0-R12, LR}
	LDR R2, =HEX_0_3
	LDR R3, =HEX_4_5

	MOV R4, #0x000000FF
	// 00000000 00000000 00000000 11111111
	MOV R5, #0 // counter for on hot encode detection
flood:
	CMP R5, #5 // detected HEX0-HEX5
	BGT end_flood

	CMP R5, #4 // detected HEX0-HEX3
	MOVEQ R2, R3
	MOVEQ R4, #0x000000FF // restore R3

	AND R6, R0, #1 //check which hex display to use
	ASR R0, R0, #1 // move to the next bit

	CMP R6, #0 // if 1, flood that hex display
	ADDEQ R5, R5, #1
	// increment the counter: next display
	LSLEQ R4, #8 // shift by 8
	/*
	ORR the followings if the designated HEX display is:
	HEX0:	#0x000000FF
	HEX0:	#0x0000FF00
	HEX0:	#0x00FF0000
	HEX0:	#0x00FF0000
	HEX0:	#0x000000FF
	HEX0:	#0x0000FF00
	*/
	BEQ flood

	LDR R7, [R2] // load HEX0-3 or HEX4-5 display
	ORR R7, R7, R4 // flood
 	STR R7, [R2]

	ADD R5, R5, #1 // increment counter
	LSL R4, #8 // shift by 8
	B flood

end_flood:
	POP {R0-R12, LR}
	BX LR

//==============================================================================================
//==============================================================================================
HEX_write_ASM:
	PUSH {R0-R12,LR}
	LDR R2, =HEX_0_3
	LDR R3, =HEX_4_5
	LDR R5, [R2]

// number to display //
	CMP R1, #0
	MOVEQ R4, #0x3F
	CMP R1, #1
	MOVEQ R4, #0x6
	CMP R1, #2
	MOVEQ R4, #0x5B
	CMP R1, #3
	MOVEQ R4, #0x4F
	CMP R1, #4
	MOVEQ R4, #0x66
	CMP R1, #5
	MOVEQ R4, #0x6D
	CMP R1, #6
	MOVEQ R4, #0x7D
	CMP R1, #7
	MOVEQ R4, #0x7
	CMP R1, #8
	MOVEQ R4, #0x7F
	CMP R1, #9
	MOVEQ R4, #0x67
	CMP R1, #10
	MOVEQ R4, #0x77
	CMP R1, #11
	MOVEQ R4, #0x7C
	CMP R1, #12
	MOVEQ R4, #0x39
	CMP R1, #13
	MOVEQ R4, #0x5E
	CMP R1, #14
	MOVEQ R4, #0x79
	CMP R1, #15
	MOVEQ R4, #0x71

// hex display //
	TST R0, #1 // HEX0
	ANDNE R5, R5, #0xFFFFFF00 // clear display
	ORRNE R5, R5, R4, LSL #0
	// shift by 0 to get to the designated hex display
	// and ORR the number to display

	TST R0, #2 // HEX1
	ANDNE R5, R5, #0xFFFF00FF // clear display
	ORRNE R5, R5, R4, LSL #8
	// shift by 8 to get to the designated hex display
	// and ORR the number to display

	TST R0, #4 // HEX2
	ANDNE R5, R5, #0xFF00FFFF // clear display
	ORRNE R5, R5, R4, LSL #16
	// shift by 8*2 to get to the designated hex display
	// and ORR the number to display

	TST R0, #8 // HEX3
	ANDNE R5, R5, #0x00FFFFFF // clear display
	ORRNE R5, R5, R4, LSL #24
	STR R5, [R2]
	// shift by 8*3 to get to the designated hex display
	// and ORR the number to display


	LDR R5, [R3]  // HEX4-5 display

	TST R0, #16 // HEX4
	ANDNE R5, R5, #0xFFFFFF00 // clear display
	ORRNE R5, R5, R4, LSL #0
	// shift by 0 to get to the designated hex display
	// and ORR the number to display

	TST R0, #32 // HEX5
	ANDNE R5, R5, #0xFFFF00FF // clear display
	ORRNE R5, R5, R4, LSL #8
	STR R5, [R3]
	// shift by 8 to get to the designated hex display
	// and ORR the number to display

	B end_write

end_write:
	POP {R0-R12, LR}
	BX LR


.global _start
_start:
/* Examples for Function Calls */
	mov R0, #0x0000003D // hex display
	mov R1, #1	// number display

	//BL HEX_clear_ASM
	//BL HEX_flood_ASM
	BL HEX_write_ASM

	B _start
