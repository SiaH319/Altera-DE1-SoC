
.equ LOAD, 0xFFFEC600
.equ CONTROL, 0xFFFEC608
.equ INTERRUPT, 0xFFFEC60C
.equ COUNTER, 0xFFFEC604

.equ HEX_0_3,0xFF200020
.equ HEX_4_5, 0xFF200030 // hex display HEX4-HEX5

.equ COUNT_VALUE, 0xBEBC200 //2*10^8

//==============================================================================================
//==============================================================================================
HEX_0_write_ASM:
	PUSH {R0-R12,LR}
	LDR R2, =HEX_0_3
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


	AND R5, R5, #0xFFFFFF00
	ORR R5, R5, R4

	STR R5, [R2]


	POP {R0-R12, LR}
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

.global _start
_start:
	LDR R6, =COUNT_VALUE // load register
	MOV r7, #3 // I-A-E: control register
	/*
	E=1: start timer
	E=0: end timer
	A=1: timer automatically reload value
	A=0:timer stops when the timer reaches 0
	I=1: processor interrupt can be generated when tmer reaches 0
	I=0
	*/
	BL ARM_TIM_config_ASM
	MOV R1, #0 // start from 0


STOPWATCH:
	/*
	R0: hex display
	R1: number to display
	*/

	BL ARM_TIM_read_INT_ASM
	CMP R12, #1 // if R=12
	ADDEQ R1, #1 // increment


	BLEQ ARM_TIM_clear_INT_ASM
	CMP R1, #15 // when it get greater than 15, reset
	MOVGT R1, #0
	BL HEX_0_write_ASM

B STOPWATCH

.end
