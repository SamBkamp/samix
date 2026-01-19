_main = echo
;;9600 baud = ~104us per bit
;;timer increments every 100us, close enough for 10 bits
echo:
        lda #">"
        ldx #$00                ;print
        brk                     ;syscall
        nop


        rts

wait_start_bit:
        lda PORTA
        and #%00010000
        bne wait_start_bit      ;pin 3 is high at idle

        lda #"x"
        ldx #$00
        brk
        nop

bit_time:
        wai                     ;wait for next interrupt (100ms)
        rts
