	#include <xc.inc>

extrn   input1, input2, input3, input4, input5
extrn	max_players, player_num, max_target_num, target_size, number_correct
extrn	permitted_inputs, target_numbers, guess_array
extrn	Add_Two_Numbers, Copy, Number_Correct, Character_Input, RNG
	
psect	code, abs 
	
main:
	org	0x0
	goto	initialise

	org	0x100  ; Main code starts here at address 0x100

initialise:
	; Specifying permitted inputs
	movlw   permitted_inputs
	movwf   FSR0, A ; Set FSR0 to point to the start of permitted_inputs

	movlw   0x1
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x2
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x3
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x4
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x5
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x6
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x7
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x8
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0x9
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0xA
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0xB
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0xC
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0xD
	movwf   INDF0, A
	incf    FSR0, F

	movlw   0xE
	movwf   INDF0, A
	
	
	; Specifying the maximum number allowed in each target slot (12 numbers)
	movlw	0xC
	movwf	max_target_num
	
	; Specifying the number of target slots (4 slots)
	movlw	0x4 
	movwf	target_size
	
	; Set up display/keypad
	
	; Enter game settings
	
	; Setting the Character_Input function inputs
	movlw	permitted_inputs ; First of the allowed memory values
	movwf	input1, A
	
	movlw	0x6 ; Length of allowed values from 0x30
	movwf	input2, A
	
	movlw	0x1 ; Maximum number of input characters allowed
	movwf	input3, A
	
	movlw	0x0 ; Output displayed from the start of the LCD
	movwf	input4, A
	
	movlw	max_players
	movwf	input5, A ; Storing in max_players memory location
	
	call	Character_Input
	
	; Start timer for random number?
	
	; Random number generation

first_player_turn:
	; Setting turn to player 1
	movlw	0x1
	movwf	player_num
	
player_turn:
	; Display player number at the top of the LCD
	
	; Input guess
	movlw	permitted_inputs ; First of the allowed memory values
	movwf	input1, A
	
	movlw	0x12 ; 12 allowed values
	movwf	input2, A
	
	movlw	0x4 ; Maximum number of input characters allowed
	movwf	input3, A
	
	movlw	0x0 ; Output should be displayed at the bottom row of the LCD
	movwf	input4, A
	
	movlw	guess_array
	movwf	input5, A ; Storing in max_players memory location
	
	call	Character_Input
	
	; Check guess
	movlw	guess_array
	movwf	input1
	
	movlw	target_numbers
	movwf	input2
	
	movf	max_target_num, W
	movwf	input3
	
	call	Number_Correct
	
	; Check if all of the guess is correct
	subwf	max_target_num, W
	bz	end_game ; Branch to end the game
	
	; Display number correct
	
	; Repeat with next player's turn
	
	; Check if the last player's turn has been played
	movlw	max_players
	subwf	player_num, W
	bz	first_player_turn
	
	; If not, increment to next player's turn
	incf	player_num
	bra	player_turn
	
	
end_game:
	; Reset game

	end	main