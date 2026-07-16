;;ctrl reg settings
STOP_BIT_N = %00000000          ;1 stop bit
WORD_LEN = %00000000            ;8 bit word
RX_CLK_SRC = %00010000          ;internal generator
SEL_BAUD_RATE = %00001111       ;19,200 baud

;;cmd reg settings
ODD_PARITY_MODE = %00000000         ;odd parity tx/rx
PARITY_MODE_DISABLED = %00000000 ;no parity enabled
NO_ECHO = %00000000           ;rx normal mode (no echo)
IRQ_CTRL = %00001000            ;irq pulled low, tx irq disabled
IRQ_DISABLED = %00000010         ;irq disabled
DTR_ENABLED = %00000001         ;dtr ready


;;status reg stuff
ACIA_PARITY_ERROR  =        %1
ACIA_FRAMING_ERROR =       %10
ACIA_OVERRUN       =      %100
ACIA_RDR_FULL      =     %1000
ACIA_TDR_EMPTY     =    %10000
ACIA_DC_DETECTB    =   %100000
ACIA_DS_READYB     =  %1000000
ACIA_IRQ           = %10000000


serial_setup:
        pha
        ;init char buffer
        lda #$00
        sta char_buffer_idx


        ;init acia
        sta ACIA_STATUS_REG         ;write something to the status reg to reset chip
        lda #( STOP_BIT_N | WORD_LEN | RX_CLK_SRC | SEL_BAUD_RATE )
        sta ACIA_CTRL_REG
        lda #( ODD_PARITY_MODE | PARITY_MODE_DISABLED | NO_ECHO | IRQ_CTRL | IRQ_DISABLED | DTR_ENABLED )
        sta ACIA_CMD_REG
        pla
        rts

check_new_serial_char:
        lda ACIA_STATUS_REG
        and #ACIA_RDR_FULL
        rts

;;todo, turn this into a ring buffer, with int handling
;;puts new character in A reg
read_serial:
        lda ACIA_DATA_REG
        rts

write_serial:
        pha
        sta ACIA_DATA_REG
        jsr uart_bug_loop
        pla
        rts

uart_bug_loop:
        phx
        ldx #$90
_uart_bug_loop_wait:
        nop
        dex
        bne _uart_bug_loop_wait

        plx
        rts
