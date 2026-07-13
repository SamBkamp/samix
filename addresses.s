;;via addresses
PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003
T1CL = $6004
T1CH = $6005
ACR = $600B
IFR = $600D
IER = $600E



;;samix addresses
;;one byte values
irq_a_store = $0200
irq_x_store = $0201
irq_y_store = $0202
program_sreg = $0203            ;flag variable for software use
counter = $0204                 ;3 byte value
last_toggle = $0207             ;one byte value
random = $0208                  ;one byte value
random_internal_state  = $0209  ;one byte value

;;sash addresses
char_buffer = $0300             ;uses full page
char_buffer_idx = $0400         ;one byte value
conversion_word = $000A         ;two byte value
last_keypress_time = $000C      ;one byte value

;;acia addresses
ACIA_DATA_REG = $5000
ACIA_STATUS_REG = $5001
ACIA_CMD_REG = $5002
ACIA_CTRL_REG = $5003


;;pid stuff
PROCESS_COUNTER = $0210         ;keeps track of how many SP we have
CURRENT_TASK = $020A            ;an index + 0x600, pointing at which process we're currently running
TASK_SWITCH_OLD_SF = $020B
WASTE_TIME_TIMER_STORE = $020C
PROCESS_TABLE_PAGE = $0600
;;process table page contains a struct looking like this:
;;
;;  typedef struct {
;;    uint8_t sp;
;;  }proccess;
