	#include <xc.inc>

psect	code, abs

output	equ 0x0
min	equ 0x1
max	equ 0x2
	
SUB_counter1	equ 0x3
SUB_counter2	equ 0x4	
SUB_counter3	equ 0x5
	


start:
    org	    0x0
    goto    setup
    org	    0x100
    
setup:
    ; Exposing port B
    movlw   0x0
    movwf   TRISB
    
    ; Setting output to zero and subsequently setting the
    ; minimum value
    movlw   0x0
    movwf   output
    movwf   min
    
    ; Setting the max to 5
    movlw   0x5
    movwf   max
    
increment:
    call display    ; Displaying on port B
    ; Incrementing output by 1
    incf    output
    
    ; Checking if output is greater than max
    movf    max,W
    cpfsgt  output
    bra increment
    
    decf    output
    
decrement:
    ; Decrementing output by 1
    decf    output
    
    call    display ; Displaying on port B
    
    ; Checking if output is less than the minimum value
    movf    min,W
    cpfseq  output
    bra	    decrement
    goto    conclusion	; Ending programme
    
display:
    ; Sets port B to the output value
    movf    output,W
    movwf   PORTB
    
    call    delay
    return
    
delay:
    ; Set the outermost loop counter to 255
    movlw   0x14
    movwf   SUB_counter3

outer_loop:
    ; Set the middle loop counter to 20
    movlw   0xFF
    movwf   SUB_counter1
    
middle_loop:
    movlw   0xFF
    movwf   SUB_counter2

inner_loop:
    decfsz  SUB_counter2, f
    goto    inner_loop

    ; Decrement the middle loop counter and repeat if not zero
    decfsz  SUB_counter1, f
    goto    middle_loop

    ; Decrement the outermost loop counter and repeat if not zero
    decfsz  SUB_counter3, f
    goto    outer_loop

    return

  
conclusion:
    end