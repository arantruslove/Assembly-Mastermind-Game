#include <xc.inc>
    
global  Add_Two_Numbers, Copy, Number_Correct
extrn	input1, input2, input3, subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
 


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
    
    
Number_Correct:
    ; Inputs:
    ; input1: The location of the first memory address of the guess
    ; input2: The memory location of the first target number of the guess
    ; input3: The number of values to be tested contiguously from FSR0 and FSR1.
    ; For the basic implementation of this game, WREG will be set to 4
    ;
    ; Outputs the number correct to WREG
    
    ; Copying the target number values to subroutine memory to allow for 
    ; manipulation
    movf    input3, W
    movwf   subVar1, A ; Storing the number of terms to be tested
    
    movf    input2, W ; Memory location of the first target number of the guess
    movwf   FSR0, A
    
    movlw   subVar5 ; Output of first memory address for copy (0x14)
    movwf   FSR1, A 
    
    movf    subVar1, W
    call    Copy
    
    ; Setting memory location of the first test value
    movf    input1, W
    movwf   FSR0, A
    
    ; Setting a tally to zero
    movlw   0x0
    movwf   subVar1, A ; 0x0
    
    
    ; Setting a guess counter that tracks the number of guesses that need to
    ; be checked
    movf    input3, W
    movwf   subVar2, A ; 0x11
    incf    subVar2    ; Incrementing by 1 since this counter is checked at the
		       ; start of the guess loop
    
guess_loop:
    ; Setting the target tracker which tracks the number of target values 
    ; remaning to be checked for the given guess
    movf    input3, W
    movwf   subVar3, A
    
    ; Setting memory location to the first target value
    movlw   subVar5 ; 0x14
    movwf   FSR1, A
    
    ; Setting the test guess value
    movf    INDF0, W
    movwf   subVar4, A
    
    ; Decrement counter to check when all the guess values have been tested
    decf     subVar2, A
    movf     subVar2, W
    bz	     finish
    
target_loop:
    movf    INDF1, W ; Accessing the current target value
    subwf   subVar4, W
    bz	    guess_equal_target
    
increment_target:
    incf    FSR1, A ; Increment target location by 1
    
    decfsz  subVar3 ; Skip and go to guess_loop when the target counter has
		    ; reached zero
    bra	    target_loop ; Repeat loop for next target value
    
    incf    FSR0, A ; Point to the next guess value's memory address
    bra	    guess_loop 

guess_equal_target:
    incf    subVar1
    clrf    INDF1 ; Setting the guess to zero so repeats aren't counted
    incf    FSR0, A ; Point to the next guess value's memory address
    bra	    guess_loop
    

finish:
    movf    subVar1, W
    return