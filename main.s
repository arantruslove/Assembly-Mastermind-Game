	#include <xc.inc>

extrn	Add_Two_Numbers, Input_1, Input_2
	
psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0
	movwf	TRISB, A	    ; Port C all outputs
	
	; Adding 2 and 5
	movlw	0x2
	movwf	Input_1, A
	
	movlw	0x5
	movwf	Input_2, A

	call	Add_Two_Numbers
	
	; Writing the output to 0x2
	movwf	0x2, A
	
	
	end	main
