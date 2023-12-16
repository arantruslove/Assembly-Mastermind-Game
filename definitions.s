#include <xc.inc>

global	keyboardColumn, keyboardRow, keyboardResult, zeroCheck
global	LCD_cnt_l, LCD_cnt_h, LCD_cnt_ms
global	number, random1, random2, random3, random4, finish
global  input1, input2, input3, input4, input5
global  subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
global	max_players, player_num, max_target_num, target_size, number_correct
global  permitted_inputs, target_numbers, guess_array, lcd_msg
    
; Keyboard variables
keyboardColumn  EQU 0x1
keyboardRow  EQU 0x2
keyboardResult  EQU 0x3
zeroCheck   EQU 0x4

; LCD variables
LCD_cnt_l   EQU 0x5
LCD_cnt_h   EQU 0x6
LCD_cnt_ms  EQU 0x7
    
; Random number variables
number EQU 0x50
random1 EQU 0x20
random2 EQU 0x21
random3 EQU 0x22
random4 EQU 0x23
finish EQU 0x24
   
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


