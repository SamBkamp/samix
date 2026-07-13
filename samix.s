        .include "addresses.s"
        .org $8000

;;configuration
PROCESS_STACK_SIZE = $40        ;64 bytes

splash: .asciiz "samix kernel :3"
version_num: .asciiz "v0.3.3"
hello_msg: .asciiz "stack starts at:"
_start:
        ldx #$FF
        txs

        lda #%10101010          ;just alternating 1s and 0s. NUMSN
        sta random              ;init random counter

        lda #$0                 ;init counter
        sta counter
        sta counter+$1
        sta counter+$2
        sta last_toggle
        sta program_sreg
        sta PROCESS_COUNTER
        sta CURRENT_TASK

        jsr init_ports
        jsr init_timer
        jsr init_screen

        jsr clear_screen
        ldy #$00                ;print to lcd
        jsr print_kernel_splash
        jmp hand_off_to_user_space

_loop:
        jmp _loop

hand_off_to_user_space:
        tsx
        txa                     ;you can't stx indexed with y
        ldy PROCESS_COUNTER
        sta PROCESS_TABLE_PAGE, y
        inc PROCESS_COUNTER
        lda #$0
        ldx #$0
        ldy #$0
        cli
        jsr _main
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

;;include your actual program file here
        .include "sash/sash.s"

;;printing kernel splash
        .include "./print_routines/print_splash.s"

;;code for stack splash printing
        .include "./print_routines/print_stack.s"

;;init code for ports and timers
        .include "./kernel_utils/init.s"

;;screen related boiler plate code
        .include "./lcd/screen_4bit.s"

;;utility code
        .include "./kernel_utils/util.s"

;;syscall handlers
        .include "./kernel_utils/syscall.s"

splash_art:
        .incbin "./splash_screens/jelly_splash.raw"

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
        phx
        phy
        lda IFR
        and #%10000000          ;check if int is set in ifr
        beq _task_switch         ;if its ifr, we must inc timer before switching the task
        bit T1CL                ;unassert VIA
        jsr incr_timer

_task_switch:
        tsx                     ;get stack pointer into a
        txa
        ldx CURRENT_TASK        ;get the current task in the process table
        sta PROCESS_TABLE_PAGE, x ;store the sp in the PT

;;note: PROCESS_COUNTER is 1 indexed, but CURRENT_TASK is 0 indexed, so
;;when they are equal, we have reached one passed the last item on the list
        inx                     ;increment our task to next task
        cpx PROCESS_COUNTER     ;check if we've reached end of list
        bne _no_reset_task_list
        ldx #0                  ;if we have reached end, reset to 0
_no_reset_task_list:            ;otherwise we keep whatever is in x already
        stx CURRENT_TASK
        lda PROCESS_TABLE_PAGE, x ;load the sp of our next process
        tax
        txs
exit_irq:                       ;this should pop a, x, and y from our new stack location
        ply
        plx
        pla
        rti


;; jump table
        .org $FFFA
        .word _nmi
        .word _start
        .word _irq
