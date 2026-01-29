serial_char:
        pha
serial_loop:
        sta ACIA_DATA_REG
        jsr uart_bug_loop
        pla
        rts

uart_bug_loop:
        phx
        ldx #$ff
uart_bug_loop1:
        nop
        dex
        bne uart_bug_loop1

        plx
        rts
