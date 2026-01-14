PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
ACR = $600B
T1CL = $6004
T1CH = $6005
IFR = $600D
IER = $600E

E = %10000000
RW = %01000000
RS = %00100000

program_sreg = $00              ;flag variable for software use
counter = $01                   ;location of the counter
last_toggle = $04

;;two 1 byte values
value = $0200
remainder = $0201


        .org $8000

splash: .asciiz "samux kernel :3"
version_num: .asciiz "v0.0.1"
hello_msg: .asciiz "stack starts at:"
_start:
        ldx #$FF
        txs

        lda #$0                 ;init counter
        sta counter
        sta counter+$1
        sta counter+$2
        sta last_toggle
        sta program_sreg
        sta remainder

        tsx
        stx value

        jsr init_ports
        jsr init_timer
        jsr init_screen

        cli

        ldx #$0
print_splash_loop:
        lda splash, x
        beq prep_version_print
        jsr print_char
        inx
        jmp print_splash_loop

prep_version_print:
        lda #$01
        jsr go_to_line
        ldx #$0

print_version_loop:
        lda version_num, x
        beq _loop
        jsr print_char
        inx
        jmp print_version_loop

_loop:
        lda program_sreg        ;check if program sreg lsb is set
        and #$01
        bne _loop
        jsr print_stack_splash

        jmp _loop

toggle_led:
        lda counter
        sec
        sbc last_toggle
        cmp #$f
        bcc end_toggle
        lda #$1
        eor PORTA
        sta PORTA
        lda counter
        sta last_toggle
end_toggle:
        rts

;;code for stack splash printing
        .include "print_stack.s"

;;init code for ports and timers
        .include "init.s"

;;screen related boiler plate code
        .include "screen.s"

;;utility code
        .include "util.s"


incr_timer:
        inc counter
        bne exit_incr_timer
        inc counter+$1
        bne exit_incr_timer
        inc counter+$2
exit_incr_timer:
        rts

_nmi:
        rti
_irq:
        pha
        bit T1CL
        jsr incr_timer
exit_irq:
        jsr toggle_led
        pla
        rti

;; jump table
        .org $FFFA
        .word _nmi
        .word _start
        .word _irq
