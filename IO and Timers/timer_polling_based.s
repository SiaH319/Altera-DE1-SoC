
.equ LOAD, 0xFFFEC600
.equ CONTROL, 0xFFFEC608
.equ INTERRUPT, 0xFFFEC60C
.equ COUNTER, 0xFFFEC604

.equ HEX_0_3,0xFF200020
.equ HEX_4_5, 0xFF200030 // hex display HEX4-HEX5

.equ PB_DATA, 0xFF200050
.equ PB_INTERRUPT, 0xFF200058
.equ PB_EDGE, 0xFF20005C

.equ PB0, 0x00000001
.equ PB1, 0x00000002
.equ PB2, 0x00000004

.equ COUNT_VALUE, 0x1E8480 //2*10^6

//==============================================================================================
//==============================================================================================
HEX_0_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_0_3
	LDR R6, [R7]

// number to display //
	CMP R9, #0
	MOVEQ R8, #0x3F
	CMP R9, #1
	MOVEQ R8, #0x6
	CMP R9, #2
	MOVEQ R8, #0x5B
	CMP R9, #3
	MOVEQ R8, #0x4F
	CMP R9, #4
	MOVEQ R8, #0x66
	CMP R9, #5
	MOVEQ R8, #0x6D
	CMP R9, #6
	MOVEQ R8, #0x7D
	CMP R9, #7
	MOVEQ R8, #0x7
	CMP R9, #8
	MOVEQ R8, #0x7F
	CMP R9, #9
	MOVEQ R8, #0x67
	CMP R9, #10
	MOVEQ R8, #0x77
	CMP R9, #11
	MOVEQ R8, #0x7C
	CMP R9, #12
	MOVEQ R8, #0x39
	CMP R9, #13
	MOVEQ R8, #0x5E
	CMP R9, #14
	MOVEQ R8, #0x79
	CMP R9, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFFFFFF00
	ORR R6, R6, R8
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR

//==============================================================================================
//==============================================================================================
HEX_1_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_0_3
	LDR R6, [R7]

// number to display //
	CMP R1, #0
	MOVEQ R8, #0x3F
	CMP R1, #1
	MOVEQ R8, #0x6
	CMP R1, #2
	MOVEQ R8, #0x5B
	CMP R1, #3
	MOVEQ R8, #0x4F
	CMP R1, #4
	MOVEQ R8, #0x66
	CMP R1, #5
	MOVEQ R8, #0x6D
	CMP R1, #6
	MOVEQ R8, #0x7D
	CMP R1, #7
	MOVEQ R8, #0x7
	CMP R1, #8
	MOVEQ R8, #0x7F
	CMP R1, #9
	MOVEQ R8, #0x67
	CMP R1, #10
	MOVEQ R8, #0x77
	CMP R1, #11
	MOVEQ R8, #0x7C
	CMP R1, #12
	MOVEQ R8, #0x39
	CMP R1, #13
	MOVEQ R8, #0x5E
	CMP R1, #14
	MOVEQ R8, #0x79
	CMP R1, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFFFF00FF // clear display
	ORR R6, R6, R8, LSL #8
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR
//==============================================================================================
//==============================================================================================
HEX_2_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_0_3
	LDR R6, [R7]

// number to display //
	CMP R2, #0
	MOVEQ R8, #0x3F
	CMP R2, #1
	MOVEQ R8, #0x6
	CMP R2, #2
	MOVEQ R8, #0x5B
	CMP R2, #3
	MOVEQ R8, #0x4F
	CMP R2, #4
	MOVEQ R8, #0x66
	CMP R2, #5
	MOVEQ R8, #0x6D
	CMP R2, #6
	MOVEQ R8, #0x7D
	CMP R2, #7
	MOVEQ R8, #0x7
	CMP R2, #8
	MOVEQ R8, #0x7F
	CMP R2, #9
	MOVEQ R8, #0x67
	CMP R2, #10
	MOVEQ R8, #0x77
	CMP R2, #11
	MOVEQ R8, #0x7C
	CMP R2, #12
	MOVEQ R8, #0x39
	CMP R2, #13
	MOVEQ R8, #0x5E
	CMP R2, #14
	MOVEQ R8, #0x79
	CMP R2, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFF00FFFF // clear display
	ORR R6, R6, R8, LSL #16
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR
//==============================================================================================
//==============================================================================================
HEX_3_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_0_3
	LDR R6, [R7]

// number to display //
	CMP R3, #0
	MOVEQ R8, #0x3F
	CMP R3, #1
	MOVEQ R8, #0x6
	CMP R3, #2
	MOVEQ R8, #0x5B
	CMP R3, #3
	MOVEQ R8, #0x4F
	CMP R3, #4
	MOVEQ R8, #0x66
	CMP R3, #5
	MOVEQ R8, #0x6D
	CMP R3, #6
	MOVEQ R8, #0x7D
	CMP R3, #7
	MOVEQ R8, #0x7
	CMP R3, #8
	MOVEQ R8, #0x7F
	CMP R3, #9
	MOVEQ R8, #0x67
	CMP R3, #10
	MOVEQ R8, #0x77
	CMP R3, #11
	MOVEQ R8, #0x7C
	CMP R3, #12
	MOVEQ R8, #0x39
	CMP R3, #13
	MOVEQ R8, #0x5E
	CMP R3, #14
	MOVEQ R8, #0x79
	CMP R3, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0x00FFFFFF // clear display
	ORR R6, R6, R8, LSL #24
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR
//==============================================================================================
//==============================================================================================
HEX_4_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_4_5
	LDR R6, [R7]

// number to display //
	CMP R4, #0
	MOVEQ R8, #0x3F
	CMP R4, #1
	MOVEQ R8, #0x6
	CMP R4, #2
	MOVEQ R8, #0x5B
	CMP R4, #3
	MOVEQ R8, #0x4F
	CMP R4, #4
	MOVEQ R8, #0x66
	CMP R4, #5
	MOVEQ R8, #0x6D
	CMP R4, #6
	MOVEQ R8, #0x7D
	CMP R4, #7
	MOVEQ R8, #0x7
	CMP R4, #8
	MOVEQ R8, #0x7F
	CMP R4, #9
	MOVEQ R8, #0x67
	CMP R4, #10
	MOVEQ R8, #0x77
	CMP R4, #11
	MOVEQ R8, #0x7C
	CMP R4, #12
	MOVEQ R8, #0x39
	CMP R4, #13
	MOVEQ R8, #0x5E
	CMP R4, #14
	MOVEQ R8, #0x79
	CMP R4, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFFFFFF00 // clear display
	ORR R6, R6, R8, LSL #0
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR

//==============================================================================================
//==============================================================================================
HEX_5_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_4_5
	LDR R6, [R7]

// number to display //
	CMP R5, #0
	MOVEQ R8, #0x3F
	CMP R5, #1
	MOVEQ R8, #0x6
	CMP R5, #2
	MOVEQ R8, #0x5B
	CMP R5, #3
	MOVEQ R8, #0x4F
	CMP R5, #4
	MOVEQ R8, #0x66
	CMP R5, #5
	MOVEQ R8, #0x6D
	CMP R5, #6
	MOVEQ R8, #0x7D
	CMP R5, #7
	MOVEQ R8, #0x7
	CMP R5, #8
	MOVEQ R8, #0x7F
	CMP R5, #9
	MOVEQ R8, #0x67
	CMP R5, #10
	MOVEQ R8, #0x77
	CMP R5, #11
	MOVEQ R8, #0x7C
	CMP R5, #12
	MOVEQ R8, #0x39
	CMP R5, #13
	MOVEQ R8, #0x5E
	CMP R5, #14
	MOVEQ R8, #0x79
	CMP R5, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFFFF00FF // clear display
	ORR R6, R6, R8, LSL #8
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR
//==============================================================================================
//==============================================================================================
ARM_TIM_config_ASM:
// Configure the timer.
	PUSH {R2,R3,LR}

	LDR R2, =LOAD
	LDR R3, =CONTROL

	STR R6, [R2]
	// pass initial count value to the load register
	STR R7, [R3]
	// pass configuration bits to the control register

	POP {R2,R3, LR}
	BX LR


ARM_TIM_read_INT_ASM:
// retrun F value to R12
	PUSH {R2, LR}
	LDR R2,=INTERRUPT
	LDR R12, [R2]
	POP {R2, LR}
	BX LR

ARM_TIM_clear_INT_ASM:
// clear the F value
	PUSH {R2, R3, LR}
	LDR R2,=INTERRUPT
	MOV R3, #1
	STR R3, [R2] // clear F
	POP {R2, R3, LR}
	BX LR
//==============================================================================================
//==============================================================================================
read_PB_edgecp_ASM:
//The subroutine returns the indices of the pushbuttons that have been pressed and then released
	PUSH {R2,LR}
	MOV R0, #0
	LDR R2, =PB_EDGE
	LDR R0, [R2]
	POP {R2,LR}
	BX LR


PB_clear_edgecp_ASM:
	PUSH {R2,R3,LR}
	LDR R2, =PB_EDGE
	LDR R3, [R2]
	STR R3, [R2]
	POP {R2, R3,LR}
	BX LR


START:
	PUSH {R6, R7, LR}
	LDR R6, =COUNT_VALUE // load register
	MOV R7, #3 // I-A-E: control register
	/*
	E=1: start timer
	E=0: end timer
	A=1: timer automatically reload value
	A=0:timer stops when the timer reaches 0
	I=1: processor interrupt can be generated when tmer reaches 0
	I=0
	*/
	BL ARM_TIM_config_ASM
	POP {R6, R7, LR}
	BX LR
STOP:
	PUSH {R6, R7, LR}
	LDR R6, =COUNT_VALUE // load register
	MOV R7, #2 // I-A-E: control register
	/*
	E=1: start timer
	E=0: end timer
	A=1: timer automatically reload value
	A=0:timer stops when the timer reaches 0
	I=1: processor interrupt can be generated when tmer reaches 0
	I=0
	*/
	BL ARM_TIM_config_ASM
	POP {R6, R7, LR}
	BX LR
//==============================================================================================
//==============================================================================================
.global _start
_start:
	BL read_PB_edgecp_ASM
	CMP R0, #PB0 //PB0: start
	BLEQ START

	/*
	E=1: start timer
	E=0: end timer
	A=1: timer automatically reload value
	A=0:timer stops when the timer reaches 0
	I=1: processor interrupt can be generated when tmer reaches 0
	I=0
	*/

STOPWATCH:
	/*
	number to display
	R9: HEX0
	R1: HEX1
	R2: HEX2
	R3: HEX3
	R4: HEX4
	R5: HEX5
	*/

	BL ARM_TIM_read_INT_ASM
	CMP R12, #1 // if R=12 (F=1)
	ADDEQ R9, #1 // increment

	BLEQ ARM_TIM_clear_INT_ASM
	//mili seconds
	CMP R9, #9
	MOVGT R9, #0
	ADDGT R1, #1

	CMP R1, #9
	MOVGE R1, #0
	ADDGE R2, #1
	// seconds
	CMP R2, #9
	MOVGT R2, #0
	ADDGT R3, #1

	CMP R3, #6
	MOVGE R3, #0
	ADDGE R4, #1
	//minutes
	CMP R4, #9
	MOVGT R4, #0
	ADDGT R5, #1

	BL HEX_0_write_ASM
	BL HEX_1_write_ASM
	BL HEX_2_write_ASM
	BL HEX_3_write_ASM
	BL HEX_4_write_ASM
	BL HEX_5_write_ASM


	BL read_PB_edgecp_ASM
	CMP R0, #PB0 //PB0: start
	BLEQ START
	CMP R0, #PB1 //PB0: stop
	BLEQ STOP
	CMP R0, #PB2 //PB0: reset
	MOVEQ R0, #0
	MOVEQ R1, #0
	MOVEQ R2, #0
	MOVEQ R3, #0
	MOVEQ R4, #0
	MOVEQ R5, #0

	BL PB_clear_edgecp_ASM


B STOPWATCH

.end
