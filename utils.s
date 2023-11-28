#include <xc.inc>
    
global  Add_Two_Numbers
extrn	Input_1, Input_2
 

psect	udata_acs   ; reserve data space in access ram

psect	utils,class=CODE
	
Add_Two_Numbers:
    ; Adds Input_1 and Input_2, returning the result to WREG
    movf    Input_1, W
    addwf   Input_2, W
    return
  

