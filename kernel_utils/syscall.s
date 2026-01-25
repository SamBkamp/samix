write:
        cpy #$0
        jmp lcd_write          ;temp
        beq lcd_write
        jsr serial_char
        jmp end_write
lcd_write:
        jsr print_char
end_write:
        rts
