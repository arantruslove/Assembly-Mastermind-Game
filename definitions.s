#include <xc.inc>
    
global  input1, input2, input3, input4, input5
global  subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
global	max_players, player_num, max_target_num, target_size, number_correct
global  permitted_inputs, target_numbers, guess_array, lcd_msg
   
; Subroutine inputs (0x0 to 0xF)
input1  EQU 0x95
input2	EQU 0x96
input3	EQU 0x97
input4	EQU 0x98
input5	EQU 0x99
	
; Subroutine local memory (0x10 to 0x2F)
subVar1 EQU 0xA0
subVar2 EQU 0xA1
subVar3 EQU 0xA2
subVar4	EQU 0xA3
subVar5	EQU 0xA4
subVar6 EQU 0xA6

 ; General memory (0x30 upwards)
max_players		EQU 0xB0
player_num		EQU 0xB1
max_target_num		EQU 0xB2
target_size		EQU 0xB3
number_correct		EQU 0xB4
permitted_inputs	EQU 0xB5
target_numbers		EQU 0xC3
guess_array		EQU 0xD1
lcd_msg			EQU 0xE0


