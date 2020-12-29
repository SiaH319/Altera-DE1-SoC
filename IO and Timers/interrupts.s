
.section .vectors, "ax"
B _start
B SERVICE_UND       // undefined instruction vector
B SERVICE_SVC       // software interrupt vector
B SERVICE_ABT_INST  // aborted prefetch vector
B SERVICE_ABT_DATA  // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ       // IRQ interrupt vector
B SERVICE_FIQ       // FIQ interrupt vector


tim_int_flag : .word 0x0
PB_int_flag : .word 0x0

/*ARM9 timer*/
.equ TIMER_LOAD, 0xFFFEC600
.equ TIMER_CONTROL, 0xFFFEC608
.equ TIMER_INTERRUPT, 0xFFFEC60C
.equ TIMER_COUNTER, 0xFFFEC604
.equ COUNT_VALUE, 0x1E8480

/*push buttos*/
.equ PB_DATA, 0xFF200050
.equ PB_INTERRUPT, 0xFF200058
.equ PB_EDGE, 0xFF20005C

.equ HEX_0_3,0xFF200020
.equ HEX_4_5, 0xFF200030 // hex display HEX4-HEX5
.text
.global _start

_start:
    /* Set up stack pointers for IRQ and SVC processor modes */
    MOV        R1, #0b11010010      // interrupts masked, MODE = IRQ
    MSR        CPSR_c, R1           // change to IRQ mode
    LDR        SP, =0xFFFFFFFF - 3  // set IRQ stack to A9 onchip memory
    /* Change to SVC (supervisor) mode with interrupts disabled */
    MOV        R1, #0b11010011      // interrupts masked, MODE = SVC
    MSR        CPSR, R1             // change to supervisor mode
    LDR        SP, =0x3FFFFFFF - 3  // set SVC stack to top of DDR3 memory
    BL     CONFIG_GIC           // configure the ARM GIC
    // To DO: write to the pushbutton KEY interrupt mask register
    // Or, you can call enable_PB_INT_ASM subroutine from previous task
    // to enable interrupt for ARM A9 private timer, use ARM_TIM_config_ASM subroutine

///===========MY CODE GOES THERE===========================

 	LDR R9, =PB_INTERRUPT
 	STR R0, [R9]

	LDR R0, =TIMER_LOAD
	ldr R5, =TIMER_CONTROL
	LDR R6, =COUNT_VALUE
	MOV R7, #7 //I-A-E
	STR R6, [R0]
	// pass initial count value to the load register
	STR R7, [R5]
	// pass configuration bits to the control register

///======================================================

	LDR        R0, =0xFF200050      // pushbutton KEY base address
    MOV        R1, #0xF             // set interrupt mask bits
    STR        R1, [R0, #0x8]       // interrupt mask register (base + 8)
    // enable IRQ interrupts in the processor
    MOV        R0, #0b01010011      // IRQ unmasked, MODE = SVC
    MSR        CPSR_c, R0
IDLE:
///===========MY CODE GOES THERE===========================

// PB BUTTONS
	MOV R9, #0 //HEX0
	MOV R1, #0 //HEX1
	MOV R8, #0//HEX2
	MOV R10, #0//HEX3
	MOV R11, #0 //HEX4
	MOV R7, #0 //HEX5
stopwatch:
	LDR R0, =PB_int_flag
	LDR R12, [R0]
	CMP R12, #1

	LDR R2, =tim_int_flag
	LDR R0, [R2]
	CMP R0, #1

	ADDEQ R9, #1
	MOV R4, #0

	STREQ R4, [R2] //clear timer
STOP:
	// mili seconds
	CMP R9, #9
	MOVGT R9, #0
	ADDGT R1, #1

	CMP R1, #9
	MOVGE R1, #0
	ADDGE R8, #1
	// seconds
	CMP R8, #9
	MOVGT R8, #0
	ADDGT R10, #1

	CMP R10, #6
	MOVGE R10, #0
	ADDGE R11, #1
	// minutes
	CMP R11, #9
	MOVGT R11, #0
	ADDGT R7, #1

	BL HEX_0_write_ASM
	BL HEX_1_write_ASM
	BL HEX_2_write_ASM
	BL HEX_3_write_ASM
	BL HEX_4_write_ASM
	BL HEX_5_write_ASM

	/////////PB///////////
	LDR R0, =PB_int_flag
	LDR R12, [R0]

	CMP R12, #1 //START
	BEQ stopwatch

	CMP R12, #2
	//STOP
	BEQ STOP
	CMP R12, #4 //RESET
	MOVEQ R9, #0 //HEX0
	MOVEQ R1, #0 //HEX1
	MOVEQ R8, #0 //HEX2
	MOVEQ R10, #0 //HEX3
	MOVEQ R11, #0 //HEX4
	MOVEQ R7, #0 //HEX5
	STREQ R4, [R12] // clear flag
	B stopwatch // This is where you write your objective task

HEX_0_write_ASM:
	PUSH {R6-R9,LR}
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

	POP {R6-R9, LR}
	BX LR

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

HEX_2_write_ASM:
	PUSH {R2,R6-R7,LR}
	LDR R7, =HEX_0_3
	LDR R6, [R7]

// number to display //
	CMP R8, #0
	MOVEQ R2, #0x3F
	CMP R8, #1
	MOVEQ R2, #0x6
	CMP R8, #2
	MOVEQ R2, #0x5B
	CMP R8, #3
	MOVEQ R2, #0x4F
	CMP R8, #4
	MOVEQ R2, #0x66
	CMP R8, #5
	MOVEQ R2, #0x6D
	CMP R8, #6
	MOVEQ R2, #0x7D
	CMP R8, #7
	MOVEQ R2, #0x7
	CMP R8, #8
	MOVEQ R2, #0x7F
	CMP R8, #9
	MOVEQ R2, #0x67
	CMP R8, #10
	MOVEQ R2, #0x77
	CMP R8, #11
	MOVEQ R2, #0x7C
	CMP R8, #12
	MOVEQ R2, #0x39
	CMP R8, #13
	MOVEQ R2, #0x5E
	CMP R8, #14
	MOVEQ R2, #0x79
	CMP R8, #15
	MOVEQ R2, #0x71

	AND R6, R6, #0xFF00FFFF // clear display
	ORR R6, R6, R2, LSL #16
	STR R6, [R7]

	POP {R2, R6-R7, LR}
	BX LR
HEX_3_write_ASM:
	PUSH {R6-R8,LR}
	LDR R7, =HEX_0_3
	LDR R6, [R7]

// number to display //
	CMP R10, #0
	MOVEQ R8, #0x3F
	CMP R10, #1
	MOVEQ R8, #0x6
	CMP R10, #2
	MOVEQ R8, #0x5B
	CMP R10, #3
	MOVEQ R8, #0x4F
	CMP R10, #4
	MOVEQ R8, #0x66
	CMP R10, #5
	MOVEQ R8, #0x6D
	CMP R10, #6
	MOVEQ R8, #0x7D
	CMP R10, #7
	MOVEQ R8, #0x7
	CMP R10, #8
	MOVEQ R8, #0x7F
	CMP R10, #9
	MOVEQ R8, #0x67
	CMP R10, #10
	MOVEQ R8, #0x77
	CMP R10, #11
	MOVEQ R8, #0x7C
	CMP R10, #12
	MOVEQ R8, #0x39
	CMP R10, #13
	MOVEQ R8, #0x5E
	CMP R10, #14
	MOVEQ R8, #0x79
	CMP R10, #15
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
	CMP R11, #0
	MOVEQ R8, #0x3F
	CMP R11, #1
	MOVEQ R8, #0x6
	CMP R11, #2
	MOVEQ R8, #0x5B
	CMP R11, #3
	MOVEQ R8, #0x4F
	CMP R11, #4
	MOVEQ R8, #0x66
	CMP R11, #5
	MOVEQ R8, #0x6D
	CMP R11, #6
	MOVEQ R8, #0x7D
	CMP R11, #7
	MOVEQ R8, #0x7
	CMP R11, #8
	MOVEQ R8, #0x7F
	CMP R11, #9
	MOVEQ R8, #0x67
	CMP R11, #10
	MOVEQ R8, #0x77
	CMP R11, #11
	MOVEQ R8, #0x7C
	CMP R11, #12
	MOVEQ R8, #0x39
	CMP R11, #13
	MOVEQ R8, #0x5E
	CMP R11, #14
	MOVEQ R8, #0x79
	CMP R11, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFFFFFF00 // clear display
	ORR R6, R6, R8, LSL #0
	STR R6, [R7]

	POP {R6-R8, LR}
	BX LR

//==============================================================================================
//==============================================================================================
HEX_5_write_ASM:
	PUSH {R6,R8,R12, LR}
	LDR R12, =HEX_4_5
	LDR R6, [R12]

// number to display //
	CMP R7, #0
	MOVEQ R8, #0x3F
	CMP R7, #1
	MOVEQ R8, #0x6
	CMP R7, #2
	MOVEQ R8, #0x5B
	CMP R7, #3
	MOVEQ R8, #0x4F
	CMP R7, #4
	MOVEQ R8, #0x66
	CMP R7, #5
	MOVEQ R8, #0x6D
	CMP R7, #6
	MOVEQ R8, #0x7D
	CMP R7, #7
	MOVEQ R8, #0x7
	CMP R7, #8
	MOVEQ R8, #0x7F
	CMP R7, #9
	MOVEQ R8, #0x67
	CMP R7, #10
	MOVEQ R8, #0x77
	CMP R7, #11
	MOVEQ R8, #0x7C
	CMP R7, #12
	MOVEQ R8, #0x39
	CMP R7, #13
	MOVEQ R8, #0x5E
	CMP R7, #14
	MOVEQ R8, #0x79
	CMP R7, #15
	MOVEQ R8, #0x71

	AND R6, R6, #0xFFFF00FF // clear display
	ORR R6, R6, R8, LSL #8
	STR R6, [R12]

	POP {R6,R8,R12, LR}
	BX LR

///===========MY CODE ENDS THERE===========================

/*--- Undefined instructions ---------------------------------------- */
SERVICE_UND:
    B SERVICE_UND
/*--- Software interrupts ------------------------------------------- */
SERVICE_SVC:
    B SERVICE_SVC
/*--- Aborted data reads -------------------------------------------- */
SERVICE_ABT_DATA:
    B SERVICE_ABT_DATA
/*--- Aborted instruction fetch ------------------------------------- */
SERVICE_ABT_INST:
    B SERVICE_ABT_INST
/*--- IRQ ----------------------------------------------------------- */
SERVICE_IRQ:
    PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
    LDR R4, =0xFFFEC100
    LDR R5, [R4, #0x0C] // read from ICCIAR


/* To Do: Check which interrupt has occurred (check interrupt IDs)
   Then call the corresponding ISR
   If the ID is not recognized, branch to UNEXPECTED
   See the assembly example provided in the De1-SoC Computer_Manual on page 46 */

///===========MY CODE GOES THERE===========================

ARM_TIMER_CHECK:
	CMP R5, #29
	BNE Pushbutton_check
	BL ARM_TIM_ISR
	B EXIT_IRQ

///===========MY CODE ENDS THERE===========================

Pushbutton_check:
    CMP R5, #73
UNEXPECTED:
    BNE UNEXPECTED      // if not recognized, stop here
    BL KEY_ISR
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
    STR R5, [R4, #0x10] // write to ICCEOIR
    POP {R0-R7, LR}
	SUBS PC, LR, #4
/*--- FIQ ----------------------------------------------------------- */
SERVICE_FIQ:
    B SERVICE_FIQ

CONFIG_GIC:
    PUSH {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
/* To Do: you can configure different interrupts
   by passing their IDs to R0 and repeating the next 3 lines */
///===========MY CODE GOES THERE===========================

	MOV R0, #29            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT

///===========MY CODE ENDS THERE===========================

	MOV R0, #73            // KEY port (Interrupt ID = 73)
    MOV R1, #1             // this field is a bit-mask; bit 0 targets cpu0
    BL CONFIG_INTERRUPT

/* configure the GIC CPU Interface */
    LDR R0, =0xFFFEC100    // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
    LDR R1, =0xFFFF        // enable interrupts of all priorities levels
    STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
    MOV R1, #1
    STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
    LDR R0, =0xFFFED000
    STR R1, [R0]
    POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default (reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/
CONFIG_INTERRUPT:
    PUSH {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
    LSR R4, R0, #3    // calculate reg_offset
    BIC R4, R4, #3    // R4 = reg_offset
    LDR R2, =0xFFFED100
    ADD R4, R2, R4    // R4 = address of ICDISER
    AND R2, R0, #0x1F // N mod 32
    MOV R5, #1        // enable
    LSL R2, R5, R2    // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
    LDR R3, [R4]      // read current register value
    ORR R3, R3, R2    // set the enable bit
    STR R3, [R4]      // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
    BIC R4, R0, #3    // R4 = reg_offset
    LDR R2, =0xFFFED800
    ADD R4, R2, R4    // R4 = word address of ICDIPTR
    AND R2, R0, #0x3  // N mod 4
    ADD R4, R2, R4    // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
    STRB R1, [R4]
    POP {R4-R5, PC}
///===========MY CODE GOES THERE===========================

KEY_ISR:
	LDR R0, =PB_EDGE //clear pushbutton
	LDR R1, [R0]

	MOV R2, #31 //11111
	STR R2, [R0]

	LDR R0, =PB_int_flag // flag updated
	STR R1, [R0]
	BX LR

ARM_TIM_ISR:
	LDR R0, =TIMER_INTERRUPT
	MOV R2, #1 //clear interrupt
	STR R2, [R0]

	LDR R0, =tim_int_flag // flag updated
	STR R2, [R0]
	BX LR

///===========MY CODE ENDS THERE===========================
