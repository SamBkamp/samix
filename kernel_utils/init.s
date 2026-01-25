
;;a, sreg
init_ports:
        lda #$ff                ;all pints port b output
        sta DDRB

        lda #%11110001        ;top 3 pins, bottom pin port a to output
        sta DDRA

        lda #%00010000          ;rs232 tx pin pulled hi by default
        sta PORTA

        rts

;;sreg
init_timer:
        pha
        lda #%01000000          ;free-run mode
        sta ACR

        lda #$10                ;int. every 10k cycles. @1mhz -> every 10ms (i think)
        sta T1CL
        lda #$27
        sta T1CH                ;init the counters (starts count down)

        lda #%11000000          ;set/clear, timer 1 high
        sta IER

        pla
        rts
