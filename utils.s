#include <xc.inc>
    
global  Add_Two_Numbers, Copy
extrn	input1, input2, subVar1
 

psect	udata_acs   ; reserve data space in access ram

psect	utils,class=CODE
	
Add_Two_Numbers:
    ; Adds Input_1 and Input_2, returning the result to WREG
    movf    input1, W
    addwf   input2, W
    return

Copy:
    ; Inputs:
    ; FSR0: The location of the first memory address
    ; WREG: The number of values to be copied consecutively from the location
    ; stored by FSR0
    ; FSR1: The output location of the first value to be copied, remaining
    ; values will be outpus from there
    
    ; Set the counter to the value in WREG which will be decremented until the
    ; desired number of values have been copied
    movwf   subVar1, A
    
    ; Iterating over and copying all the desired values to the new memory 
    ; location
loop:
    ; Copying the data over to the new memory address
    movf    INDF0, W
    movwf   INDF1, A
    
    ; Incrementing the memory locations by 1
    incf    FSR0
    incf    FSR1
    
    ; Decrementing the counter by 1
    decfsz  subVar1
    bra	    loop
    
    return
    
    