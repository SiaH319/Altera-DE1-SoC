.equ SW_MEMORY, 0xFF200040
.equ LED_MEMORY, 0xFF200000

.equ HEX_0_3, 0xFF200020
.equ HEX_4_5, 0xFF200030

.equ PB_DATA, 0xFF200050
.equ PB_INTERRUPT, 0xFF200058
.equ PB_EDGE, 0xFF20005C

.equ PB0, 0x00000001
.equ PB1, 0x00000002
.equ PB2, 0x00000004
.equ PB3, 0x00000008


//==============================================================================================
//==============================================================================================
// returns the state of slider switches in R0
read_slider_switches_ASM:
	PUSH {LR}
    LDR R1, =SW_MEMORY
    LDR R2, [R1]
	POP {LR}
    BX  LR

// LEDs Driver
// writes the state of LEDs (On/Off state) in R0 to the LEDs memory location
write_LEDs_ASM:
	PUSH {R2,R1,LR}
    LDR R1, =LED_MEMORY
    STR R2, [R1]
	POP {R2,R1, LR}
    BX  LR

//==============================================================================================
//==============================================================================================

ARM_flood_HEX4_5:
	PUSH {R2,R3,R7, LR}
	TST R0, #0x00000200

	LDR R2,=HEX_4_5
	LDR R3, [R2]
	ORREQ R3, R3, #0XFF// flood
 	STREQ R3, [R2]

	LSLEQ R3, #8
	ORREQ R3, R3, #0XFF// flood
 	STREQ R3, [R2]
	POP {R2,R3,R7, LR}
	BX LR

//==============================================================================================
//==============================================================================================

HEX_write_ASM_HEX_0_3:
	PUSH {R9,R4,R5,LR}
	LDR R9, =HEX_0_3
	LDR R5, [R9]

// number to display //
	CMP R2, #0
	MOVEQ R4, #0x3F
	CMP R2, #1
	MOVEQ R4, #0x6
	CMP R2, #2
	MOVEQ R4, #0x5B
	CMP R2, #3
	MOVEQ R4, #0x4F
	CMP R2, #4
	MOVEQ R4, #0x66
	CMP R2, #5
	MOVEQ R4, #0x6D
	CMP R2, #6
	MOVEQ R4, #0x7D
	CMP R2, #7
	MOVEQ R4, #0x7
	CMP R2, #8
	MOVEQ R4, #0x7F
	CMP R2, #9
	MOVEQ R4, #0x67
	CMP R2, #10
	MOVEQ R4, #0x77
	CMP R2, #11
	MOVEQ R4, #0x7C
	CMP R2, #12
	MOVEQ R4, #0x39
	CMP R2, #13
	MOVEQ R4, #0x5E
	CMP R2, #14
	MOVEQ R4, #0x79
	CMP R2, #15
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
	STR R5, [R9]
	// shift by 8*3 to get to the designated hex display
	// and ORR the number to display

	POP {R9,R4,R5,LR}
	BX LR
//==============================================================================================
//==============================================================================================

read_PB_data_ASM:
//returns the indices of the pressed pushbuttons
	PUSH {R2, LR}
	MOV R0, #0
	LDR R2, =PB_DATA
	LDR R0, [R2]
	POP {R2, LR}
	BX LR

PB_data_is_pressed_ASM:
//receives pushbuttons indices as an argument (One index at a time).
//Then, it returns 0x00000001 when the the corresponding pushbutton is pressed.
	PUSH {R2, R3, LR}
	LDR R2, =PB_DATA
	LDR R3, [R2]
	TST R3, R0
	MOVNE R11, #0x00000001
	POP {R2, R3, LR}
	BX LR
//==============================================================================================
//==============================================================================================

read_PB_edgecp_ASM:
//The subroutine returns the indices of the pushbuttons that have been pressed and then released
	PUSH {R2, LR}
	MOV R0, #0
	LDR R2, =PB_EDGE
	LDR R0, [R2]
	POP {R2, LR}
	BX LR

PB_edgecp_is_pressed_ASM: // Result => R11
//receives pushbuttons indices as an argument (One index at a time).
//Then, it returns 0x00000001 when the the corresponding pushbutton is pressed.
	PUSH {R2, R3, r11, LR}
	LDR R2, =PB_EDGE
	LDR R3, [R2]
	TST R3, R0
	MOVNE R11, #0x00000001
	POP {R2, R3, r11, LR}
	BX LR

PB_clear_edgecp_ASM:
	PUSH {R2, R8, LR}
	LDR R2, =PB_EDGE
	LDR R8, [R2]
	STR R8, [R2]
	POP {R2, R8, LR}
	BX LR

//==============================================================================================
//==============================================================================================

enable_PB_INT_ASM:
// receives pushbuttons indices as an argument.

/*
enable the interrupt function for the corresponding pushbuttons,
whose indicies are passed through R0,
by setting their respective interrupt mask bits to '1'.
This can be done by simply storing the value of R0
into the address of the pushbutton mask bit register
*/
	PUSH {R9, LR}
	LDR R9, =PB_INTERRUPT
	STR R0, [R9]
	POP {R9, LR}
	BX LR

disable_PB_INT_ASM:
// receives pushbuttons indices as an argument.
// disables the interrupt function for the corresponding pushbuttons
	LDR R9, =PB_INTERRUPT
	PUSH {R9, R10, LR}
	LDR R9, =PB_INTERRUPT
	LDR R10, [R9]

	TST R8, #1	// PB0
	ANDNE R10, R10, #14 //#1110 = 8+4+2

	TST R8, #2  // PB1
	ANDNE R10, R10, #13 //#1101 = 8+4+1

	TST R8, #4	// PB2
	ANDNE R10, R10, #11 //#1011 = 8+2+1

	TST R8, #8	// PB3
	ANDNE R10, R10, #7 //#0111 = 4+2+1

	POP {R9, R10, LR}
	BX LR

//==============================================================================================
//==============================================================================================

.global _start
_start:

	/*
	R2: swithces
	R0: PB pressed and released
	*/

	BL read_slider_switches_ASM
	BL write_LEDs_ASM

	// clear all if SW9 is pressed
	TST R2, #0x00000200
	BLEQ ARM_flood_HEX4_5
	LDRNE R3, =HEX_0_3
	MOVNE R6, #0x00000000
	STRNE R6, [R3]
	LDRNE R3, =HEX_4_5
	MOVNE R6, #0x00000000
	STRNE R6, [R3]


	BL read_PB_edgecp_ASM
	BL HEX_write_ASM_HEX_0_3
	BL PB_clear_edgecp_ASM

B _start
