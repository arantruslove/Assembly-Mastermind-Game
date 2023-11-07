	#include <xc.inc>

psect	code, abs

number1		equ	0x0
number2		equ	0x1
output		equ	0x2
SUB_counter	equ	0x3
SUB_value	equ	0x4
		
start:
    org	    0x0
    goto    main
    org	    0x100
	
main:
    
    ; Exposing port B
    movlw   0x0
    movwf   TRISB
    
    ; Number 1
    movlw   0xA
    movwf   number1

    ; Number 2
    movlw   0xB
    movwf   number2

    call    multiply
    movwf   output
    
    ; Outputting to Port B
    movf    output, W
    movwf   PORTB
    
    goto conclusion
	
addTwoNumbers:
    ; Adds number1 and number2, outputting to wreg.
    movf    number1, W
    addwf   number2, W
    return 

	
multiply:
    ; Multiplies number1 by number2.
    
    ; Sets the initial value to zero (which will have number2 added to it
    ; number1 times.
    movlw   0x0
    movwf   SUB_counter
    
    ; Add number 1 as a counter.
    movf    number1, W
    movwf   SUB_counter
    
    loop:
	movf	SUB_value, W
	addwf	number2, W
	movwf	SUB_value
    
    ; Decremented value is placed back into SUB_counter
    decfsz  SUB_counter, F
    bra	loop
    
    ; Outputting the result of the multiplication to SUB_value
    movf    SUB_value, W
    
    return
    
conclusion:
    end	