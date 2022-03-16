.text
	.align 2
	.global part_1

part_1:
	; Initialize port 1
	; Store address of P1IN in R7, P1OUT in R8, P1DIR in R9, P1REN in R10
	; Using very little alteration to the code provided in the lab document,
	; I was able to change the program to take an input from S1.

	; Turn on LED 1 when SW1 is pressed, turn it off when SW1 is not pressed

	MOV  R7, #4c00h  	; Put lower half-word of P1IN address in R7
	MOVT R7, #4000h  	; Put upper half-word of P1IN address in R7

	MOV  R8, #4c02h  	; Put lower half-word of P1OUT address in R8
	MOVT R8, #4000h  	; Put upper half-word of P1OUT address in R8

	MOV  R9, #4c04h  	; Put lower half-word of P1DIR address in R9
	MOVT R9, #4000h  	; Put upper half-word of P1DIR address in R9

	MOV  R10, #4c06h   	; Put lower half-word of P1REN address in R10
	MOVT R10, #4000h   	; Put upper half-word of P1REN address in R10

	; Set P1.0 as output and P1.1 as input in P1DIR
	MOV R6, #00000001b 	; Bit 0 is ‘1’ (output), Bit 1 is ‘0’ (input)
	STRB R6, [R9]  		; Use to set direction in P1DIR [R9]
	; Enable pull-up resistor on P1.1
	MOV R6, #00000010b 	; Set bit 1
	STRB R6, [R10]  	; Enable pull resistor (set pin 1 of P1REN)
	STRB R6, [R8]  		; Make it a pull-up (set pin 1 of P1OUT)

	; Turn off LED
	MOV  R6, #00000010b 	; Reset P1.0, but keep P1.1 high for pull-up
	STRB   R6, [R8]

loop:
	; Read SW2 (P1.1)
	LDRB   R6, [R7]  	; Read 8 bits of port 1
	AND R6, R6, #00000010b  ; Mask to keep just bit 1
	CMP R6, #00000000b 	; See if it is 0
	BEQ led_on  		; Branch to led_off if P1.1 is 0 (SW2 pushed)

	; Turn off LED
	MOV  R6, #00000010b
	STRB   R6, [R8]  	; Set P1.0, but keep P1.1 high for pull-up
	B loop   		; Read SW2 again

led_on:
	; Turn oon LED
	MOV  R6, #00000011b
	STRB   R6, [R8] 	; Reset P1.0, but keep P1.1 high for pull-up
	B loop   		; Read SW2 again
 .end
