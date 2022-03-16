.text
	.align 2
	.global part_3

part_3:
	; Initialize port 1
	; Store address of P1IN in R7, P2OUT in R8, P1DIR in R9, P1REN in R10
	; In order to set LED2 as an output, we need to set P2DIR using R11
	; We aren't using any inputs in P2, so we don't care about anything else.

	; When SW1 is pressed, LED2 turns red
	; When SW2 is pressed, LED2 turns green
	; When both SW1 & SW2 are pressed, LED2 turns blue


	MOV  R7, #4c00h  	; Put lower half-word of P1IN address in R7
	MOVT R7, #4000h  	; Put upper half-word of P1IN address in R7

	MOV  R8, #4c03h  	; Put lower half-word of P2OUT address in R8
	MOVT R8, #4000h  	; Put upper half-word of P2OUT address in R8

	MOV R11, #4c05h		; P2DIR address
	MOVT R11, #4000h

	MOV  R9, #4c04h  	; Put lower half-word of P1DIR address in R9
	MOVT R9, #4000h  	; Put upper half-word of P1DIR address in R9

	MOV  R10, #4c06h   	; Put lower half-word of P1REN address in R10
	MOVT R10, #4000h   	; Put upper half-word of P1REN address in R10

	; Set P1.0 as output, with P1.1 & P.1.4 as inputs in P1DIR
	MOV R2, #00000111b	; Prepare to use P2.0-P2.2 as outputs
	MOV R6, #00000000b 	; Bits 1 & 4 are ‘0’ (input)

	STRB R6, [R9]  		; Use to set direction in P1DIR [R9]
	STRB R2, [R11]		; Set the direction of P2DIR -- three outputs

	; Enable pull-up resistor on P1.1 & P1.4
	MOV R6, #00010010b
	STRB R6, [R10]  	; Enable pull resistor (set pins 1 & 4 of P1REN)
	STRB R6, [R8]  		; Make it a pull-up (set pins 1 & 4 of P1OUT)

	; Turn off LED
	MOV  R6, #00000000b 	; Reset P2.0, P2.1, P2.2
	STRB   R6, [R8]

loop:
	; Read SW2 (P1.1)
	LDRB   R6, [R7]  	; Read 8 bits of port 1
	AND R5, R6, #00010010b  ; Mask to keep bits 1 & 4, our inputs
	CMP R5, #00000000b 	; See if it is 0--which ones are pressed?
	BEQ led_blue  		; Branch to led_blue if they're both pressed

	AND R5, R6, #00000010b
	CMP R5, #00000000b
	BEQ led_red		; branch to led_red if SW1 is pressed

	AND R5, R6, #00010000b
	CMP R5, #00000000b
	BEQ led_green		; branch to led_green if SW2 is pressed

	; Turn off LED
	MOV  R6, #00000000b
	STRB   R6, [R8]  	; Reset P2.0
	B loop   		; Read both switches again


led_blue:
	; Turn the LED blue
	MOV R6, #00000100b
	STRB R6, [R8]
	B loop

led_red:
	; Turn the LED red
	MOV R6, #00000001b
	STRB R6, [R8]
	B loop

led_green:
	; Turn the LED green
	MOV R6, #00000010b
	STRB R6, [R8]
	B loop
 .end
