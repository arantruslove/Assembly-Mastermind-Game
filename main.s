	#include <xc.inc>

extrn   input1, input2, input3, input4, input5
extrn	var1, var2, var3, var4, var5, var6
extrn	Add_Two_Numbers, Copy, Number_Correct, Character_Input
	
psect	code, abs
	
; Renaming global variables
max_players	EQU var1
player_number	EQU var2

	
main:
	org	0x0
	goto	initialise

	org	0x100		    ; Main code starts here at address 0x100
	
initialise:
	; Adding allowed numbers for character input 1 to 4
	movlw	0x1
	movwf	0x30, A
	
	movlw	0x2
	movwf	0x31, A
	
	movlw	0x3
	movwf	0x32, A
	
	movlw	0x4
	movwf	0x33, A
	
	; Setting the function inputs
	movlw	0x30 ; First of the allowed memory values
	movwf	input1, A
	
	movlw	0x4 ; Length of allowed values from 0x30
	movwf	input2, A
	
	movlw	0x3 ; Maximum number of input characters allowed
	movwf	input3, A
	
	movlw	0x0 ; Output displayed from the start of the LCD
	movwf	input4, A
	
	movlw	0x27
	movwf	input5, A ; Ouput characters starting from this address
	
	call	Character_Input
    
	; Set up display/keypad
	
	; Enter game settings
	
	; Start timer for random number?
	
	; Random number generation
	
player_turn:
    
	; Input guess
	
	; Check guess
	
	; Display number correct
	
	
end_game:
	; Reset game

	end	main