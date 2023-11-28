	#include <xc.inc>

extrn   input1, input2
extrn	Add_Two_Numbers, Copy
	
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
	movwf	input1, A
	
	movlw	0x5
	movwf	input2, A
	
	call	Add_Two_Numbers
	movwf	0x2, A
	
	; Copying the first 3 memory values to 0x7, 0x8 and 0x10
	movlw	input1
	movwf	FSR0, A
	
	movlw	0x7
	movwf	FSR1, A
	movlw	0x3
	
	call	Copy
	    
	end	main
