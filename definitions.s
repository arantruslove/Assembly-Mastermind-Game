#include <xc.inc>
    
global  input1, input2, input3, input4, input5
global  subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
global	max_players, player_num, max_target_num, target_size, number_correct
global  permitted_inputs, target_numbers, guess_array
	
; Subroutine inputs (0x0 to 0xF)
input1  EQU 0x0
input2	EQU 0x1
input3	EQU 0x2
input4	EQU 0x3
input5	EQU 0x4
	
; Subroutine local memory (0x10 to 0x2F)
subVar1 EQU 0x10
subVar2 EQU 0x11
subVar3 EQU 0x12
subVar4	EQU 0x13
subVar5	EQU 0x14
subVar6 EQU 0x16

 ; General memory (0x30 upwards)
max_players		EQU 0x30
player_num		EQU 0x31
max_target_num		EQU 0x32
target_size		EQU 0x33
number_correct		EQU 0x34
permitted_inputs	EQU 0x35
target_numbers		EQU 0x43
guess_array		EQU 0x51