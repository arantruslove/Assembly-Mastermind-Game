#include <xc.inc>
    
global  Add_Two_Numbers, Copy, Number_Correct, Character_Input
extrn	input1, input2, input3, input4, input5
extrn	subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
extrn	var1
 


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
    

Character_Input:
    ; Inputs:
    ; input1: The memory address of the first allowed number
    ; input2: The number of values allowed contiguously from the memory address
    ; stored in input1
    ; input3: The maximum number of values allowed for inputs
    ; input4: The index on the LCD that the first digit should be output to on 
    ; the LCD
    ; input5: The memory address that will store the first of the output numbers
    
    ; Setting subVar1 to the maximum number of values allowed for input 
    ; which will be used to check whether the maximum number of characters have 
    ; been reached
    movf    input3, W
    movwf   subVar1, A
    
    ; Setting the first character output location to subVar4
    movlw   subVar4
    movwf   FSR0, A

input_loop:
    ; Await keypad button click here
    
    ; Check whether the maximum number of inputs has been reached 
    
    
    ; Moving keypad character input to subVar3 for testing
    movwf   subVar3, A
    
    ; F is the submit key and will branch to the testing stage of the output
    movlw   0xF
    subwf   subVar3, W
    bz	    test_output
    
    ; Not accepting the next input if all the input slots are already filled
    movf    subVar1, W
    bz	    input_loop

    ; Storing the memory address of the first allowed number
    movf    input1, W
    movwf   FSR1, A
    
    ; Setting the check input loop to the number of permitted values
    movf    input2, W
    movwf   subVar2, A
    
check_input:
    ; Check if the input value is equal to one of the permitted values
    movf    INDF1, W
    subwf   subVar3, W
    
    ; Adds the character to the memory block and display if it is equal to a
    ; permitted character
    bz	    add_to_display 
    
    incf    FSR1, A ; Pointing to the memory address of the next allowed value
    decfsz  subVar2 ; Decrementing the check input loop counter by 1
    bra	    check_input ;  Check again if not at the end of the loop
    
     ; Go back to the input loop if it is deemed that the 
     ; input character does not match any of the valid 
     ; characters
    bra    input_loop 
    
add_to_display:
    movf    subVar3, W
    movwf   INDF0 ; Add the keypad input to the memory block
    incf    FSR0  ; Increment to the next location in memory
    decf    subVar1 ; Decrement the number of remaining slots for character 
		    ; input
    
    ; Update all the values stored beginning at the subVar4 memory block
    
    bra	    input_loop
    
test_output:
    ; Setting FSR1 to the memory address of subVar4
    movlw   subVar4
    movwf   FSR1, A
    
    ; Setting FSR2 to point to the memory address contained in input5
    movf    input5, W
    movwf   FSR2, A
    
    ; Setting the counter
    movf    input3, W
    movwf   subVar2, A
    
    ; Testing if the required number of input values have been provided
    movf    subVar1, W
    bz	    output_loop
    bra	    input_loop

output_loop:
    ; Allocates the values to the output specified by input5
    movf    INDF1, W
    movwf   INDF2, A
    
    ; Increment memory addresses
    incf    FSR1
    incf    FSR2
    
    ; Decrement and return if iterated through all the values
    decfsz  subVar2
    bra	    output_loop
    
    return 