/*
SIA HAM
ECSE 324
LAB 3
PART 1: VGA
*/
.equ PIX_BUFF, 0xC8000000
.equ CHAR_BASE, 0xC9000000

.equ px_x, 320
.equ px_y, 240


.equ char_x, 80
.equ char_y, 60

.global _start
_start:
        bl      draw_test_screen
end:
        b       end
		
/*MY CODES GOES HERE*/
/*
R0: x 
R1: y
R2: colour
*/
VGA_draw_point_ASM:
/*draws a point on the screen with the color as indicated in the third argument, 
by accessing only the pixel buffer memory. 
Hint: This subroutine should only access the pixel buffer memory.*/
	
	/*access individual pixel colors
	 0xc8000000 | (y << 10) | (x << 1) */
	 
	PUSH {R0-R3,LR}

	LSL R0, R0, #1 // (x << 1)
	LSL R1, R1, #10 //(y << 10)
	ORR R1, R1, R0 // (y << 10) | (x << 1)

	LDR R3, =PIX_BUFF

	ORR R3, R3, R1 // 0xc8000000 | (y << 10) | (x << 1)
	STRH R2, [R3] // each pixel color is represented as a 16-bit halfword
	POP {R0-R3,LR}
	BX LR
	
		
VGA_clear_pixelbuff_ASM:
/*clears (sets to 0) all the valid memory locations in the pixel buffer. 
It takes no arguments and returns nothing. Hint: You can implement this function 
by calling VGA_draw_point_ASM with a color value of zero for every valid location 
on the screen.*/
	PUSH {R0-R3,LR}
	MOV R0, #0 //x
	MOV R1, #0 //y
	MOV R2, #0 //colour
	CLEAR_X:
		BL VGA_draw_point_ASM
		// clear horizontally
		ADD R0, #1
		CMP R0, #px_x
		MOVEQ R0, #0
		BGE END_PixBuff
		B CLEAR_X
		
	CLEAR_Y:
		BL VGA_draw_point_ASM
		// clear  vertically
		ADD R1, #1
		CMP R1, #px_y
		MOVEQ R1, #0
		BGE END_PixBuff
		B CLEAR_Y

	END_PixBuff:
		POP {R0-R3,LR}
		BX LR

VGA_write_char_ASM:
/*
writes the ASCII code passed in the third argument (r2) to the screen 
at the (x, y) coordinates given in the first two arguments (r0 and r1).
Essentially, the subroutine will store the value of the third argument 
at the address calculated with the first two arguments. 
The subroutine should check that the coordinates supplied are valid, 
i.e., x in [0, 79] and y in [0, 59].
Hint: This subroutine should only access the character buffer memory.
*/

//buffer provides a resolution of 80 × 60 characters
	PUSH {R0-R3,LR}
	CMP R0,#79 
	BGT END_Char
	CMP R1,#59
	BGT END_Char
	LDR R3, =CHAR_BASE

//An individual character can be accessed at 0xc9000000 | (y << 7) | x
	LSL R1, R1, #7	//(y << 7)
	ORR R3, R3, R1	//0xc9000000 | (y << 7) 
	ORR R3, R3, R0	//0xc9000000 | (y << 7) | x
	STRB R2, [R3]		

END_Char:
	POP {R0-R3,LR}
	BX LR

		
VGA_clear_charbuff_ASM:
/*clears (sets to 0) all the valid memory locations in the character buffer. 
It takes no arguments and returns nothing. Hint: You can implement this function by 
calling VGA_write_char_ASM with a character value of zero for every valid location 
on the screen.*/
	PUSH {R0-R3, LR}
	MOV R0, #0 //x
	MOV R1, #0 //y
	MOV R2, #0 //colour

	CLEAR_charX:
		BL VGA_draw_point_ASM
		// clear horizontally
		ADD R0, #1
		CMP R0, #char_x
		MOVEQ R0, #0
		BGE END_charbuff
		B CLEAR_charX
		
	CLEAR_charY:
		BL VGA_draw_point_ASM
		// clear  vertically
		ADD R1, #1
		CMP R1, #char_y
		MOVEQ R1, #0
		BGE END_charbuff
		B CLEAR_charY
		
	END_charbuff:
		POP {R0-R3,LR}
		BX LR
/*MY CODES END HERE*/

draw_test_screen:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r6, #0
        ldr     r10, .draw_test_screen_L8
        ldr     r9, .draw_test_screen_L8+4
        ldr     r8, .draw_test_screen_L8+8
        b       .draw_test_screen_L2
.draw_test_screen_L7:
        add     r6, r6, #1
        cmp     r6, #320
        beq     .draw_test_screen_L4
.draw_test_screen_L2:
        smull   r3, r7, r10, r6
        asr     r3, r6, #31
        rsb     r7, r3, r7, asr #2
        lsl     r7, r7, #5
        lsl     r5, r6, #5
        mov     r4, #0
.draw_test_screen_L3:
        smull   r3, r2, r9, r5
        add     r3, r2, r5
        asr     r2, r5, #31
        rsb     r2, r2, r3, asr #9
        orr     r2, r7, r2, lsl #11
        lsl     r3, r4, #5
        smull   r0, r1, r8, r3
        add     r1, r1, r3
        asr     r3, r3, #31
        rsb     r3, r3, r1, asr #7
        orr     r2, r2, r3
        mov     r1, r4
        mov     r0, r6
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        add     r5, r5, #32
        cmp     r4, #240
        bne     .draw_test_screen_L3
        b       .draw_test_screen_L7
.draw_test_screen_L4:
        mov     r2, #72
        mov     r1, #5
        mov     r0, #20
        bl      VGA_write_char_ASM
        mov     r2, #101
        mov     r1, #5
        mov     r0, #21
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #22
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #23
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #24
        bl      VGA_write_char_ASM
        mov     r2, #32
        mov     r1, #5
        mov     r0, #25
        bl      VGA_write_char_ASM
        mov     r2, #87
        mov     r1, #5
        mov     r0, #26
        bl      VGA_write_char_ASM
        mov     r2, #111
        mov     r1, #5
        mov     r0, #27
        bl      VGA_write_char_ASM
        mov     r2, #114
        mov     r1, #5
        mov     r0, #28
        bl      VGA_write_char_ASM
        mov     r2, #108
        mov     r1, #5
        mov     r0, #29
        bl      VGA_write_char_ASM
        mov     r2, #100
        mov     r1, #5
        mov     r0, #30
        bl      VGA_write_char_ASM
        mov     r2, #33
        mov     r1, #5
        mov     r0, #31
        bl      VGA_write_char_ASM
        pop     {r4, r5, r6, r7, r8, r9, r10, pc}
.draw_test_screen_L8:
        .word   1717986919
        .word   -368140053
        .word   -2004318071