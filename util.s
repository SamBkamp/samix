;;clobbers sreg, x, y and a
div_by_ten:
        pha
        phx
        clc
        ldx #$08
dividing_loop:
        rol value               ;rotate quotient and mantissa
        rol remainder

;;a is dividend - divisor
        sec
        lda remainder
        sbc #10
        bcc ignore_result       ;discard if not divisible here

        sta remainder
ignore_result:
        dex
        bne dividing_loop

        rol value               ;shift last carry bit into bottom of value
        plx
        pla
        rts

;;easy as pie
div_by_hex:
        pha
        lda value
        and #$0f                ;keep only low nibble
        sta remainder

        lsr value               ;move hi nibble into low nible pos
        lsr value
        lsr value
        lsr value
        pla
        rts
