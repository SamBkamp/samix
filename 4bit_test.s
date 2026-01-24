PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
ACR = $600B
T1CL = $6004
T1CH = $6005
IFR = $600D
IER = $600E

        .org $8000

_start:
        lda #$FF
        sta DDRB
        lda #$00
        sta PORTB
        jsr init_screen

        lda #"A"
        jsr print_char

        lda #"H"
        jsr print_char

        lda #"!"
        jsr print_char
        
_loop:
        jmp _loop

;;screen related boiler plate code
        .include "screen_4bit.s"
        
_nmi:
_irq:
        rti

        ;; jump table
        .org $FFFA
        .word _nmi
        .word _start
        .word _irq
