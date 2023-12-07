  #include <xc.inc>

global  Keyboard_Setup, Keyboard_Press
extrn	subVar1

psect	udata_acs   ; named variables in access ram

;KB_row	EQU 0xB0
;KB_col	EQU 0xB1
;KB_fin	EQU 0xB2
;LCD_cnt_l   EQU	0xB3
;LCD_cnt_h   EQU	0xB4
;LCD_cnt_ms  EQU	0xB5
	
KB_Val:ds 1
KB_Col:ds 1
KB_Row:ds 1
KB_Fin:ds 1
KB_Pressed: ds 1
KB_Fix: ds 1
	
KB_row:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
KB_col:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
KB_fin:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_l:	ds 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h:	ds 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms:	ds 1   ; reserve 1 byte for ms counter
    
psect	kb_code,class=CODE
    
Keyboard_Setup:
	movlw	0
	movwf	KB_row
	movlw	0
	movwf	KB_col
	
    
	banksel PADCFG1
	bsf	REPU
	clrf	LATE, A
	banksel	0  ; we need this to put default bank back to A
	
	movlw	0x0F
	movwf	TRISE
	
	; delay?
	movlw	1
	call	LCD_delay_ms
	
	; Drive output bits low all at once
	movlw	0x00
	movwf	PORTE, A
	
	; Read 4 PORTE input pins
	movff 	PORTE, KB_col

	; Invert the pins to show only the pressed ones
	movlw	0x0F
	xorwf	KB_col, 1, 0
	
	; If no column pressed return
	movlw	0x00
	cpfsgt	KB_col
	return
	
	
	; Configure bits 0-3 output, 4-7 input
	movlw	0xF0
	movwf	TRISE
	
	movlw	1
	call	LCD_delay_ms
	
	; Drive output bits low all at once
	movlw	0x00
	movwf	PORTE, A
	
	
	; Read4 PORTE input pins
	movff 	PORTE, KB_row
	movlw	0xF0
	xorwf	KB_row, 1, 0
	
	; Decode results to determine
	; Print results to PORTD
	
	movlw	0x00
	;movwf	TRISD, A
	movwf	KB_fin
	movf	KB_row, 0
	addwf	KB_fin
	movf	KB_col, 0
	addwf	KB_fin
	;movff	KB_fin, PORTD
	movf	KB_fin, 0  ; store KB_fin in w reg for later use
	return
	
Keyboard_Press:	
	;call	write
	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	;call	LCD_Setup
	movlw	3
	movwf	KB_Fix

	
	goto	set_kb

	; ******* Main programme ****************************************
	
set_kb:
	movlw	0x0
	movwf	KB_Pressed, A
	goto	start

start:
	call	Keyboard_Setup
	;movlw	0x1
	movwf	KB_Val, A  ; store the value of KB row and column
	
	; check KB_val is not zero
	movlw	0x00
	cpfsgt	KB_Val
	bra	set_kb

	; are we already pressed
	movlw	0x00
	cpfseq	KB_Pressed
	bra	start
	
	movlw	0x01
	movwf	KB_Pressed
	
	;split into KB_col and KB_row
	movlw	0x0f
	andwf	KB_Val, 0
	movwf	KB_Col, A
	
	swapf	KB_Val, 1
	movlw	0x0f
	andwf	KB_Val, 0
	movwf	KB_Row, A
	
	; starts at 1, need to start at 0
	bcf     STATUS, 0
	rrcf	KB_Col, 1
	bcf     STATUS, 0
	rrcf	KB_Row, 1
	
	movlw	4
	cpfslt	KB_Row
	movff	KB_Fix, KB_Row
	movlw	4
	cpfslt	KB_Col
	movff	KB_Fix, KB_Col
	
	movlw	0x00
	movwf	TRISH, A
	movff	KB_Col, PORTH
	movlw	0x00
	movwf	TRISJ, A
	movff	KB_Row, PORTJ
	
	; KB_Col + 4 * KB_Row
	movf	KB_Row, 0
	addwf	KB_Row, 0
	addwf	KB_Row, 0
	addwf	KB_Row, 0
	bcf     STATUS, 0
	addwfc	KB_Col, 0
	call	Keyboard_Map
	return

	
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms:		    ; delay given in ms in W
	movwf	LCD_cnt_ms, A
lcdlp2:	movlw	250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms, A
	bra	lcdlp2
	return
    
LCD_delay_x4us:		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l, A	; now need to multiply by 16
	swapf   LCD_cnt_l, F, A	; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l, W, A ; move low nibble to W
	movwf	LCD_cnt_h, A	; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay:			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1:	decf 	LCD_cnt_l, F, A	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h, F, A	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return


	
	
Keyboard_Map:
    ; Inputs: WREG
    ; Outputs the relevant number to WREG
    
    ; Storing the number
    movwf   subVar1 
    
    ; Checking for a match
    movlw   0x0
    subwf   subVar1, W
    bz	    key_1_match
    
    movlw   0x1
    subwf   subVar1, W
    bz	    key_2_match
    
    movlw   0x2
    subwf   subVar1, W
    bz	    key_3_match
    
    movlw   0x3
    subwf   subVar1, W
    bz	    key_4_match
    
    movlw   0x4
    subwf   subVar1, W
    bz	    key_5_match
    
    movlw   0x5
    subwf   subVar1, W
    bz	    key_6_match
    
    movlw   0x6
    subwf   subVar1, W
    bz	    key_7_match
    
    movlw   0x7
    subwf   subVar1, W
    bz	    key_8_match
    
    movlw   0x8
    subwf   subVar1, W
    bz	    key_9_match
    
    movlw   0x9
    subwf   subVar1, W
    bz	    key_10_match
    
    movlw   0xA
    subwf   subVar1, W
    bz	    key_11_match
    
    movlw   0xB
    subwf   subVar1, W
    bz	    key_12_match
    
    movlw   0xC
    subwf   subVar1, W
    bz	    key_13_match
    
    movlw   0xD
    subwf   subVar1, W
    bz	    key_14_match
    
    movlw   0xE
    subwf   subVar1, W
    bz	    key_15_match

    movlw   0xF
    subwf   subVar1, W
    bz	    key_16_match

key_1_match:
    movlw   0xC
    return
    
key_2_match:
    movlw   0xD
    return
    
key_3_match:
    movlw   0xE
    return
    
key_4_match:
    movlw   0xF
    return
    
key_5_match:
    movlw   0xB
    return
    
key_6_match:
    movlw   0x9
    return
    
key_7_match:
    movlw   0x6
    return
    
key_8_match:
    movlw   0x3
    return
    
key_9_match:
    movlw   0x0
    return
    
key_10_match:
    movlw   0x8
    return
    
key_11_match:
    movlw   0x5
    return
    
key_12_match:
    movlw   0x2
    return
    
key_13_match:
    movlw   0xA
    return
    
key_14_match:
    movlw   0x7
    return
    
key_15_match:
    movlw   0x4
    return
    
key_16_match:
    movlw   0x1
    return
    
    end




