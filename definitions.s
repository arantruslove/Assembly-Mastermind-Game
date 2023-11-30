#include <xc.inc>
    
global  input1, input2, input3, input4, subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
	
; Subroutine inputs (0x0 to 0xF)
input1  EQU 0x0
input2	EQU 0x1
input3	EQU 0x2
input4	EQU 0x3
	
; Subroutine local memory (0x10 to 0x1F)
subVar1 EQU 0x10
subVar2 EQU 0x11
subVar3 EQU 0x12
subVar4	EQU 0x13
subVar5	EQU 0x14
subVar6 EQU 0x16

 ; 0x20 upwards reserved for other memory