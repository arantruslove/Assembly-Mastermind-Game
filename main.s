	#include <xc.inc>

extrn   input1, input2, input3, input4, input5
extrn	max_players, player_num, max_target_num, target_size, number_correct
extrn	permitted_inputs, target_numbers, guess_array, lcd_msg
extrn	Copy, Number_Correct, Character_Input, Press_To_Proceed, RNG, Keyboard_Press, Asci_Map
extrn	LCD_Setup, LCD_Write_Message, LCD_Bottom_Row, LCD_Clear
	
psect	code, abs 
	
main:
	org	0x0
	goto	initialise

	org	0x100  ; Main code starts here at address 0x100

initialise:
	; Specifying permitted inputs
	movlw   permitted_inputs
	movwf   FSR0 ; Set FSR0 to point to the start of permitted_inputs

	movlw   '1'
	movwf   INDF0
	incf    FSR0, F

	movlw   '2'
	movwf   INDF0
	incf    FSR0, F

	movlw   '3'
	movwf   INDF0
	incf    FSR0, F

	movlw   '4'
	movwf   INDF0
	incf    FSR0, F

	movlw   '5'
	movwf   INDF0
	incf    FSR0, F

	movlw   '6'
	movwf   INDF0
	incf    FSR0, F

	movlw   '7'
	movwf   INDF0
	incf    FSR0, F

	movlw   '8'
	movwf   INDF0
	incf    FSR0, F

	movlw   '9'
	movwf   INDF0
	incf    FSR0, F

	movlw   'A'
	movwf   INDF0
	incf    FSR0, F

	movlw   'B'
	movwf   INDF0
	incf    FSR0, F

	movlw   'C'
	movwf   INDF0
	incf    FSR0, F

	movlw   'D'
	movwf   INDF0
	incf    FSR0, F

	movlw   'E'
	movwf   INDF0
	
	
	; Specifying the maximum number allowed in each target slot (12 numbers)
	movlw	0xC
	movwf	max_target_num
	
	; Specifying the number of target slots (4 slots)
	movlw	0x4 
	movwf	target_size
	
	; Set up LCD display
	call	LCD_Setup
	
	; Display input number of players prompt
	call	Input_Player_Msg
	movlw	lcd_msg
	movwf	FSR2
	movlw	15
	call	LCD_Write_Message
	
	; Setting the Character_Input function inputs
	movlw	permitted_inputs ; First of the allowed memory values
	movwf	input1
	
	movlw	0x6 ; Length of allowed values from 0x30
	movwf	input2
	
	movlw	0x1 ; Maximum number of input characters allowed
	movwf	input3
	
	movlw	0x0 ; Output displayed from the start of the LCD
	movwf	input4
	
	movlw	max_players
	movwf	input5 ; Storing in max_players memory location
	call	Character_Input
	call	LCD_Clear
	
	; Start timer for random number?
	
	; Random number generation
	movlw	target_numbers ; First location of random numbers
	movwf	input1
	movf	target_size, W
	movwf	input2
	call	RNG

first_player_turn:
	; Setting turn to player 1
	movlw	'1'
	movwf	player_num
	
player_turn:
	; Display player number at the top of the LCD
	call	Player_Turn_Msg
	movlw	lcd_msg
	movwf	FSR2
	movlw	13
	call	LCD_Write_Message
	
	; Input guess
	movlw	permitted_inputs ; First of the allowed memory values
	movwf	input1
	
	movlw	0x12 ; 12 allowed values
	movwf	input2
	
	movlw	0x4 ; Maximum number of input characters allowed
	movwf	input3
	
	movlw	0x0 ; Output should be displayed at the bottom row of the LCD
	movwf	input4
	
	movlw	guess_array
	movwf	input5 ; Storing in max_players memory location
	
	; Input guess
	call	Character_Input
	call	LCD_Clear
	
	; Check guess
	movlw	guess_array
	movwf	input1
	
	movlw	target_numbers
	movwf	input2
	
	movf	target_size, W
	movwf	input3
	
	call	Number_Correct
	call	Asci_Map ; Convert number correct to Asci
	movwf	number_correct
	
	
	; Check if all of the guess is correct
	movf	target_size, W
	call	Asci_Map
	subwf	number_correct, W
	bz	end_game ; Branch to end of the game
	
	; Display number correct
	call	Number_Correct_Msg
	movlw	lcd_msg
	movwf	FSR2
	movlw	12
	call	LCD_Write_Message
	call	LCD_Bottom_Row
	movlw	number_correct
	movwf	FSR2
	movlw	0x1
	call	LCD_Write_Message ; Display the number
	
	
	; Press F to continue
	call	Press_To_Proceed
	call	LCD_Clear ; Clearing LCD for next turn
	
	; Repeat with next player's turn
	
	; Check if the last player's turn has been played
	movf	max_players, W
	subwf	player_num, W
	bz	first_player_turn
	
	; If not, increment to next player's turn
	incf	player_num
	bra	player_turn
	
	
end_game:
	; Declare winner
	call	Winner_Msg
	movlw	lcd_msg
	movwf	FSR2
	movlw	8
	call	LCD_Write_Message
	call	Press_To_Proceed
	
	; Reset game
	bra	initialise

Input_Player_Msg:
    movlw   lcd_msg
    movwf   FSR0
    
    movlw   'N'
    movwf   INDF0
    incf    FSR0
    movlw   'o'
    movwf   INDF0
    incf    FSR0
    movlw   '.'
    movwf   INDF0
    incf    FSR0
    movlw   ' '
    movwf   INDF0
    incf    FSR0
    movlw   'O'
    movwf   INDF0
    incf    FSR0
    movlw   'f'
    movwf   INDF0
    incf    FSR0
    movlw   ' '
    movwf   INDF0
    incf    FSR0
    movlw   'P'
    movwf   INDF0
    incf    FSR0
    movlw   'l'
    movwf   INDF0
    incf    FSR0
    movlw   'a'
    movwf   INDF0
    incf    FSR0
    movlw   'y'
    movwf   INDF0
    incf    FSR0
    movlw   'e'
    movwf   INDF0
    incf    FSR0
    movlw   'r'
    movwf   INDF0
    incf    FSR0
    movlw   's'
    movwf   INDF0
    incf    FSR0
    movlw   ':'
    movwf   INDF0
    incf    FSR0
    
    return

Player_Turn_Msg:
    movlw   lcd_msg
    movwf   FSR0
    
    movlw   'P'
    movwf   INDF0
    incf    FSR0
    movlw   'l'
    movwf   INDF0
    incf    FSR0
    movlw   'a'
    movwf   INDF0
    incf    FSR0
    movlw   'y'
    movwf   INDF0
    incf    FSR0
    movlw   'e'
    movwf   INDF0
    incf    FSR0
    movlw   'r'
    movwf   INDF0
    incf    FSR0
    movlw   ' '
    movwf   INDF0
    incf    FSR0
    movf    player_num, W
    movwf   INDF0
    incf    FSR0
    movlw   ' '
    movwf   INDF0
    incf    FSR0
    movlw   'T'
    movwf   INDF0
    incf    FSR0
    movlw   'u'
    movwf   INDF0
    incf    FSR0
    movlw   'r'
    movwf   INDF0
    incf    FSR0
    movlw   'n'
    movwf   INDF0
    incf    FSR0
    
    return
    
    
Number_Correct_Msg:
    movlw   lcd_msg
    movwf   FSR0
    
    movlw   'N'
    movwf   INDF0
    incf    FSR0
    movlw   'o'
    movwf   INDF0
    incf    FSR0
    movlw   '.'
    movwf   INDF0
    incf    FSR0
    movlw   ' '
    movwf   INDF0
    incf    FSR0
    movlw   'C'
    movwf   INDF0
    incf    FSR0
    movlw   'o'
    movwf   INDF0
    incf    FSR0
    movlw   'r'
    movwf   INDF0
    incf    FSR0
    movlw   'r'
    movwf   INDF0
    incf    FSR0
    movlw   'e'
    movwf   INDF0
    incf    FSR0
    movlw   'c'
    movwf   INDF0
    incf    FSR0
    movlw   't'
    movwf   INDF0
    incf    FSR0
    movlw   ':'
    movwf   INDF0
    incf    FSR0
    
    return
    
Winner_Msg:
    movlw   lcd_msg
    movwf   FSR0
    
    movlw   'Y'
    movwf   INDF0
    incf    FSR0
    movlw   'o'
    movwf   INDF0
    incf    FSR0
    movlw   'u'
    movwf   INDF0
    incf    FSR0
    movlw   ' '
    movwf   INDF0
    incf    FSR0
    movlw   'W'
    movwf   INDF0
    incf    FSR0
    movlw   'i'
    movwf   INDF0
    incf    FSR0
    movlw   'n'
    movwf   INDF0
    incf    FSR0
    movlw   '!'
    movwf   INDF0
    incf    FSR0
    
    return
    
    end	    main