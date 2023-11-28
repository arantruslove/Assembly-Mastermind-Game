	#include <xc.inc>

extrn	Test_Function
	
psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0
	movwf	TRISB, A	    ; Port C all outputs
	
	movlw	0x3
	movwf	0x1, A

	call Test_Function
	
	
	end	main
