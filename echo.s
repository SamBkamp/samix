_main = echo
char = $0300

;;control characters
NEWLINE = $0a
RETURN = $0d

ACIA_DATA_REG = $5000
ACIA_STATUS_REG = $5001
ACIA_CMD_REG = $5002
ACIA_CTRL_REG = $5003

;;status reg masks
RXR_FULL_MASK = $08
TXR_FULL_MASK = %00010000

;;ctrl reg settings
STOP_BIT_N = %00000000          ;1 stop bit
WORD_LEN = %00000000            ;8 bit word
RX_CLK_SRC = %00010000          ;internal generator
SEL_BAUD_RATE = %00001111       ;19,200 baud

;;cmd reg settings
PARITY_MODE = %00000000         ;odd parity tx/rx
PARITY_MODE_ENABLED = %00000000 ;no parity enabled
ECHO_MODE = %00000000           ;rx normal mode (no echo)
IRQ_CTRL = %00001000            ;irq pulled low, tx irq disabled
IRQ_ENABLED = %00000010         ;irq disabled
DTR_ENABLED = %00000001         ;dtr ready
;;9600 baud = ~104us per bit
motd: .asciiz "Welcome to samix!"
echo:
        jsr clear_screen

        lda #">"
        jsr print_char

        ;init acia
        lda #$00
        sta ACIA_STATUS_REG         ;write something to the status reg to reset chip
        lda #( STOP_BIT_N | WORD_LEN | RX_CLK_SRC | SEL_BAUD_RATE )
        sta ACIA_CTRL_REG
        lda #( PARITY_MODE | PARITY_MODE_ENABLED | ECHO_MODE | IRQ_CTRL | IRQ_ENABLED | DTR_ENABLED )
        sta ACIA_CMD_REG

        jsr print_motd

event_loop:
        lda ACIA_STATUS_REG
        and #$08
        beq event_loop

        lda ACIA_DATA_REG
        jsr print_char
        sta ACIA_DATA_REG
        jmp event_loop
        rts


print_motd:
        ldx #$00
print_motd_loop:
        lda motd, x
        beq end_loop
        jsr serial_char
        inx
        jmp print_motd_loop
end_loop:
        lda #RETURN
        jsr serial_char
        lda #NEWLINE
        jsr serial_char
        rts

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
        nop
        dex
        bne uart_bug_loop1

        plx
        rts
