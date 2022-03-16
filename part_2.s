.text
	.align 2
	.global part_2

part_2:
	; Initialize port 1
	; Store address of P1IN in R7, P1OUT in R8, P1DIR in R9, P1REN in R10

	; Turn on LED1 when either SW1 or SW2 are pressed, and turn off otherwise


	MOV  R7, #4c00h  	; Put lower half-word of P1IN address in R7
	MOVT R7, #4000h  	; Put upper half-word of P1IN address in R7

	MOV  R8, #4c02h  	; Put lower half-word of P1OUT address in R8
	MOVT R8, #4000h  	; Put upper half-word of P1OUT address in R8

	MOV  R9, #4c04h  	; Put lower half-word of P1DIR address in R9
	MOVT R9, #4000h  	; Put upper half-word of P1DIR address in R9

	MOV  R10, #4c06h   	; Put lower half-word of P1REN address in R10
	MOVT R10, #4000h   	; Put upper half-word of P1REN address in R10

	; Set P1.0 as output, with P1.1 & P.1.4 as inputs in P1DIR
	MOV R6, #00000001b 	; Bit 0 is ‘1’ (output), Bits 1 & 4 are ‘0’ (input)
	STRB R6, [R9]  		; Use to set direction in P1DIR [R9]
	; Enable pull-up resistor on P1.1 & P1.4
	MOV R6, #00010010b 	; Set bit 1
	STRB R6, [R10]  	; Enable pull resistor (set pins 1 & 4 of P1REN)
	STRB R6, [R8]  		; Make it a pull-up (set pins 1 & 4 of P1OUT)

	; Turn off LED
	MOV  R6, #00010010b 	; Reset P1.0, but keep P1.1 & P1.4 high for pull-up
	STRB   R6, [R8]

loop:
	; Read SW2 (P1.1)
	LDRB   R6, [R7]  	; Read 8 bits of port 1
	AND R6, R6, #00010000b  ; Mask to keep bits 1 & 4, our inputs
	CMP R6, #00000000b 	; See if it is 0--which ones are pressed?
	BEQ led_on  		; Branch to led_off if P1.1 is 0, or if P1.4 (SW1 | SW2 pushed)
	LDRB R6, [R7]
	AND R6, R6, #00000010b
	CMP R6, #00000000b
	BEQ led_on

	; Turn off LED
	MOV  R6, #00010010b
	STRB   R6, [R8]  	; Reset P1.0, but keep P1.1 high for pull-up
	B loop   		; Read SW2 again

led_on:
	; Turn on LED
	MOV  R6, #00010011b
	STRB   R6, [R8] 	; Set P1.0, but keep P1.1 high for pull-up
	B loop   		; Read SW2 again
 .end
