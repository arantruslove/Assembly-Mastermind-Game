  #include <xc.inc>

global  Keyboard_Press, Asci_Map
extrn	subVar5

psect	udata_acs   ; named variables in access ram

keyboardColumn  EQU 0x1
keyboardRow  EQU 0x2
KB_Fin  EQU 0x3
KB_Pressed  EQU 0x4
KB_Fix  EQU 0x5
                
KB_fin   EQU 0x8
LCD_cnt_l   EQU 0x9
LCD_cnt_h   EQU 0xA
LCD_cnt_ms  EQU 0xB
zeroCheck   EQU 0xC
    
psect	kb_code,class=CODE
    
Keyboard_Press:
    ; Make sure that the keyboard is not already pressed
    call    keyboard_check
    movwf   zeroCheck
    movlw   0x0
    subwf   zeroCheck, W
    bz           keyboard_wait
    
    bra         Keyboard_Press
    
keyboard_wait:
    call    keyboard_check
    movwf   zeroCheck
    movlw   0x0
    subwf   zeroCheck, W
    bz           keyboard_wait
    return 
                

keyboard_check:
                movlw  0x0
                movwf  keyboardRow
                movlw  0x0
                movwf  keyboardColumn
                
    
                banksel PADCFG1
                bsf          REPU
                clrf          LATE, A
                banksel 0  ; we need this to put default bank back to A
                
                movlw  0x0F
                movwf  TRISE
                
                ; delay
                movlw  1
                call          LCD_delay_ms
                
                ; Drive output bits low all at once
                movlw  0x00
                movwf  PORTE, A
                
                ; Read 4 PORTE input pins
                movff    PORTE, keyboardRow

                ; Invert the pins to show only the pressed ones
                movlw  0x0F
                xorwf    keyboardRow, 1, 0
                
                ; Configure bits 0-3 output, 4-7 input
                movlw  0xF0
                movwf  TRISE
                
                movlw  1
                call          LCD_delay_ms
                
                ; Drive output bits low all at once
                movlw  0x00
                movwf  PORTE, A
                

                ; Read4 PORTE input pins
                movff    PORTE, keyboardColumn
                movlw  0xF0
                xorwf    keyboardColumn, 1, 0
                
                movf     keyboardColumn, W
                iorwf     keyboardRow, W
                movwf  KB_Fin
                
keymap:
                movlw  0b00010001
                subwf   KB_Fin, W
                bz           Ckey
                
                movlw  0b00010010
                subwf   KB_Fin, W
                bz           Dkey      
                
                movlw  0b00010100
                subwf   KB_Fin, W
                bz           Ekey
                
                movlw  0b00011000
                subwf   KB_Fin, W
                bz           Fkey
                
                movlw  0b00100001
                subwf   KB_Fin, W
                bz           Bkey
                
                movlw  0b00100010
                subwf   KB_Fin, W
                bz           ninekey 
                
                movlw  0b00100100
                subwf   KB_Fin, W
                bz           sixkey
                
                movlw  0b00101000
                subwf   KB_Fin, W
                bz           threekey
                
                movlw  0b01000001
                subwf   KB_Fin, W
                bz           zerokey
                
                movlw  0b01000010
                subwf   KB_Fin, W
                bz           eightkey              
                
                movlw  0b01000100
                subwf   KB_Fin, W
                bz           fivekey
                
                movlw  0b01001000
                subwf   KB_Fin, W
                bz           twokey
                
                movlw  0b10000001
                subwf   KB_Fin, W
                bz           Akey
                
                movlw  0b10000010
                subwf   KB_Fin, W
                bz           sevenkey             
                
                movlw  0b10000100
                subwf   KB_Fin, W
                bz           fourkey
                
                movlw  0b10001000
                subwf   KB_Fin, W
                bz           onekey
                
                movlw  0x0
                return

Ckey:
                movlw  'C'
                return   
Dkey:
                movlw  'D'
                return
Ekey:
                movlw  'E'
                return
Fkey:
                movlw  'F'
                return
Bkey:
                movlw  'B'
                return   
ninekey:
                movlw  '9'
                return
sixkey:
                movlw  '6'
                return
threekey:
                movlw  '3'
                return
zerokey:
                movlw  '0'
                return   
eightkey:
                movlw  '8'
                return
fivekey:
                movlw  '5'
                return
twokey:
                movlw  '2'
                return
Akey:
                movlw  'A'
                return   
sevenkey:
                movlw  '7'
                return
fourkey:
                movlw  '4'
                return
onekey:
                movlw  '1'
                return


                


                
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms:                     ; delay given in ms in W
                movwf  LCD_cnt_ms, A
lcdlp2:   movlw  250             ; 1 ms delay
                call          LCD_delay_x4us               
                decfsz   LCD_cnt_ms, A
                bra         lcdlp2
                return
    
LCD_delay_x4us:                                 ; delay given in chunks of 4 microsecond in W
                movwf  LCD_cnt_l, A       ; now need to multiply by 16
                swapf   LCD_cnt_l, F, A   ; swap nibbles
                movlw  0x0f           
                andwf   LCD_cnt_l, W, A ; move low nibble to W
                movwf  LCD_cnt_h, A     ; then to LCD_cnt_h
                movlw  0xf0           
                andwf   LCD_cnt_l, F, A ; keep high nibble in LCD_cnt_l
                call          LCD_delay
                return

LCD_delay:                                         ; delay routine   4 instruction loop == 250ns              
                movlw   0x00                       ; W=0
lcdlp1:   decf       LCD_cnt_l, F, A  ; no carry when 0x00 -> 0xff
                subwfb LCD_cnt_h, F, A ; no carry when 0x00 -> 0xff
                bc           lcdlp1                    ; carry, then loop again
                return                                   ; carry reset so return

   
    
Asci_Map:
    ; Inputs: WREG
    ; Outputs the relevant number to WREG
    
    ; Storing the number
    movwf   subVar5 
    
    ; Checking for a match
    movlw   0x0
    subwf   subVar5, W
    bz	    asci_1_match
    
    movlw   0x1
    subwf   subVar5, W
    bz	    asci_2_match
    
    movlw   0x2
    subwf   subVar5, W
    bz	    asci_3_match
    
    movlw   0x3
    subwf   subVar5, W
    bz	    asci_4_match
    
    movlw   0x4
    subwf   subVar5, W
    bz	    asci_5_match
    
    movlw   0x5
    subwf   subVar5, W
    bz	    asci_6_match
    
    movlw   0x6
    subwf   subVar5, W
    bz	    asci_7_match
    
    movlw   0x7
    subwf   subVar5, W
    bz	    asci_8_match
    
    movlw   0x8
    subwf   subVar5, W
    bz	    asci_9_match
    
    movlw   0x9
    subwf   subVar5, W
    bz	    asci_10_match
    
    movlw   0xA
    subwf   subVar5, W
    bz	    asci_11_match
    
    movlw   0xB
    subwf   subVar5, W
    bz	    asci_12_match
    
    movlw   0xC
    subwf   subVar5, W
    bz	    asci_13_match
    

asci_1_match:
    movlw   '0'
    return
    
asci_2_match:
    movlw   '1'
    return
    
asci_3_match:
    movlw   '2'
    return
    
asci_4_match:
    movlw   '3'
    return
    
asci_5_match:
    movlw   '4'
    return
    
asci_6_match:
    movlw   '5'
    return
    
asci_7_match:
    movlw  '6'
    return
    
asci_8_match:
    movlw   '7'
    return
    
asci_9_match:
    movlw   '8'
    return
    
asci_10_match:
    movlw   '9'
    return
    
asci_11_match:
    movlw   'A'
    return
    
asci_12_match:
    movlw   'B'
    return
    
asci_13_match:
    movlw   'C'
    return
    
    
    
    
    end

