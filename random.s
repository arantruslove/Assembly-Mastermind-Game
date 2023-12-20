; Coded adapted from the Imperial physics year 3 microprocessors lab repository
;(https://github.com/ImperialCollegeLondon/MicroprocessorsLab/tree/ADC_test_measurement)
; ACD.s file
    
#include <xc.inc>

global RNG
extrn	input1, input2, subVar1, Asci_Map
extrn	number, random1, random2, random3, random4, finish

psect random_code,class=CODE
 
 
RNG:
    ; Inputs:
    ; input1: The first location for the random numbers to be output to
    ; input2: The number of random numbers to be generated
    
    ; Settinig a counter 
    movf    input2, W
    movwf   subVar1
    
    ; Generate the random numbers
    call    random_start
    
    ; Setting a pointer to the first location of the subroutine generated 
    ; random number
    movlw   random1
    movwf   FSR0
    
    ; Setting a pointer to the first location for the random numbers to be 
    ; output to
    movf    input1, W
    movwf   FSR1
    
rng_loop:
    ; Ouputting random number to memory location
    movf    INDF0, W
    call    Asci_Map ; Convert number to corresponding Ascii
    movwf   INDF1
    
    incf    FSR0
    incf    FSR1
    
    decfsz  subVar1
    bra	    rng_loop
    
    return

random_start:
	call ADCSetup; Re-run program from start
	movlw 0x0
	movwf random1
	movwf random2
	movwf random3
	movwf random4
	movwf finish
	call generate
 
ADCSetup:
	bsf	TRISA, PORTA_RA0_POSN, A  ; pin RA0==AN0 input
	movlb	0x0f
	bsf	ANSEL0	    ; set AN0 to analog
	movlb	0x00
	movlw   0x01	    ; select AN0 for measurement
	movwf   ADCON0, A   ; and turn ADC on
	movlw   0x30	    ; Select 4.096V positive reference
	movwf   ADCON1,	A   ; 0V for -ve reference and -ve input
	movlw   0xF6	    ; Right justified output
	movwf   ADCON2, A   ; Fosc/64 clock and acquisition times
	return

ADCRead:
	bsf	GO	    ; Start conversion by setting GO bit in ADCON0
adcloop:
	btfsc   GO	    ; check to see if finished
	bra	adcloop
	return

generate:
	movlw 0x0
	cpfseq finish
	return
	call measure
	goto generate
	
measure:
	call measure_random
	movlw 0x0
	cpfseq	random1
	goto point2
	call measure1
	return
point2:
	movlw 0x0
	cpfseq random2
	goto point3
	call measure2
	return
point3:
	movlw 0x0
	cpfseq random3
	goto point4
	call measure3
	return
point4:
	movlw 0x0
	cpfsgt	random4
	call measure4
	return

measure1:
	movff number,random1
	return

measure2:
	movff number,random2
	movf random1,W
	cpfseq random2
	return
	goto reset2
reset2:
	movlw 0x0
	movwf random2
	return
	
measure3:
	movff number,random3
	movf random1,W
	cpfseq random3
	goto check3pt2
	goto reset3
check3pt2:
	movf random2,W
	cpfseq random3
	return
	goto reset3
reset3:
	movlw 0x0
	movwf random3
	return
	
measure4:
	movff number,random4
	movf random1,W
	cpfseq random4
	goto check4pt2
	goto reset4
check4pt2:
	movf random2,W
	cpfseq random4
	goto check4pt3
	goto reset4
check4pt3:
	movf random3,W
	cpfseq random4
	goto finish1
	goto reset4
finish1:
	movlw 0x1
	movwf finish
	return
reset4:
	movlw 0x0
	movwf random4
	return
measure_random:
	call	ADCRead
	movf	ADRES,W
	movwf	number
subtract:
	movlw	12
	cpfsgt	number
	return
	subwf	number
	goto subtract
	end


