/*
SIA HAM
ECSE 324
LAB 3
PART 2: PS/2
*/
//variables of vga
.equ PIX_BUFF, 0xC8000000
.equ CHAR_BASE, 0xC9000000

.equ px_x, 320
.equ px_y, 240

.equ char_x, 80
.equ char_y, 60

//variables for ps/s
.equ PS2, 0xFF200100

.global _start
_start:
        bl      input_loop
end:
        b       end


/*MY CODES GOES HERE*/
/*VGA Driver*/
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
	CLEAR_pixelbuff:
		MOV R2, #0 //colour
		BL VGA_draw_point_ASM
		// clear horizontally & vertically
		ADD R1, #1
		CMP R1, #px_y
		MOVEQ R1, #0
		ADDEQ R0, #1
		CMP R0, #px_x
		BGE END_PixBuff
		B CLEAR_pixelbuff
		
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
	PUSH {R0-R12,LR}
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
	POP {R0-R12,LR}
	BX LR

		
VGA_clear_charbuff_ASM:
/*clears (sets to 0) all the valid memory locations in the character buffer. 
It takes no arguments and returns nothing. Hint: You can implement this function by 
calling VGA_write_char_ASM with a character value of zero for every valid location 
on the screen.*/
	PUSH {R0-R12, LR}
	MOV R0, #0 //x
	MOV R1, #0 //y
	CLEAR_charbuff:
		MOV R2, #0 //char value
		BL VGA_write_char_ASM
		// clear horizontally & vertically
		ADD R1, #1
		CMP R1, #char_y
		MOVEQ R1, #0
		ADDEQ R0, #1
		CMP R0, #char_x
		BGE END_charbuff
		B CLEAR_charbuff
		
	END_charbuff:
		POP {R0-R12, LR}
		BX LR
		

/*PS/2 Driver*/
read_PS2_data_ASM:
	PUSH {R1-R12, LR}
	LDR R2, =PS2
	LDR R2, [R2]
	ASR R3, R2, #15 //((*(volatile int *)0xff200100) >> 15)
	
	//RVALID = ((*(volatile int *)0xff200100) >> 15) & 0x1
	TST R3, #1
	BNE VALID
	
	MOV R0, #0
	B END_PS2
	
	VALID:	 //RVALID VALID
	//the data from the same register stored at the address in the pointer argument
		MOV R5, #0b11111111
		AND R6, R2, R5
		STRB R6, [R0]  
		MOV R0, #1 //return 1 to denote valid data
	END_PS2:
		POP {R1-R12, LR}
		BX LR
		
/*MY CODES END HERE*/

write_hex_digit:
        push    {r4, lr}
        cmp     r2, #9
        addhi   r2, r2, #55
        addls   r2, r2, #48
        and     r2, r2, #255
        bl      VGA_write_char_ASM
        pop     {r4, pc}
write_byte:
        push    {r4, r5, r6, lr}
        mov     r5, r0
        mov     r6, r1
        mov     r4, r2
        lsr     r2, r2, #4
        bl      write_hex_digit
        and     r2, r4, #15
        mov     r1, r6
        add     r0, r5, #1
        bl      write_hex_digit
        pop     {r4, r5, r6, pc}
input_loop:
        push    {r4, r5, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      VGA_clear_charbuff_ASM
        mov     r4, #0
        mov     r5, r4
        b       .input_loop_L9
.input_loop_L13:
        ldrb    r2, [sp, #7]
        mov     r1, r4
        mov     r0, r5
        bl      write_byte
        add     r5, r5, #3
        cmp     r5, #79
        addgt   r4, r4, #1
        movgt   r5, #0
.input_loop_L8:
        cmp     r4, #59
        bgt     .input_loop_L12
.input_loop_L9:
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .input_loop_L8
        b       .input_loop_L13
.input_loop_L12:
        add     sp, sp, #12
        pop     {r4, r5, pc}

