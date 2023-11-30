#include <xc.inc>
    
global  input1, input2, input3, input4, input5
global  subVar1, subVar2, subVar3, subVar4, subVar5, subVar6
global	var1, var2, var3, var4, var5, var6
	
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
var1	EQU 0x30
var2	EQU 0x31
var3	EQU 0x32
var4	EQU 0x33
var5	EQU 0x34
var6	EQU 0x35