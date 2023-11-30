	#include <xc.inc>

extrn   input1, input2, input3
extrn	Add_Two_Numbers, Copy, Number_Correct
	
psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	; Guess is 5,2,3,4
	movlw	0x5
	movwf	0x20, A
	movlw	0x2
	movwf	0x21, A
	movlw	0x3
	movwf	0x22, A
	movlw	0x4
	movwf	0x23, A
	
	; Targt is 4,5,6,7
	movlw	0x4
	movwf	0x24, A
	movlw	0x5
	movwf	0x25, A
	movlw	0x6
	movwf	0x26, A
	movlw	0x7
	movwf	0x27, A
	
	; Checking number correct
	movlw	0x20 ; Location of the first guess number
	movwf	input1, A
	
	movlw	0x24 ; Location of the first target number
	movwf	input2, A
	
	movlw	0x4
	movwf	input3, A
	
	; Should be two correct
	call Number_Correct
	movwf	0x0, A
	end	main
