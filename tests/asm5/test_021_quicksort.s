# ----------- main() -----------
.text


.globl main
main:
    # fill the sX registers (and fp) with junk.  Each testcase will use a different
    # set of values.
    lui     $fp,      0x75a6
    ori     $fp, $fp, 0xa062
    srl     $s0, $fp, 16
    ori     $s0, $s0, 0xb36c
    srl     $s1, $s0, 16
    ori     $s1, $s1, 0xb02a
    srl     $s2, $s1, 16
    ori     $s2, $s2, 0x32c3
    srl     $s3, $s2, 16
    ori     $s3, $s3, 0x31b9
    srl     $s4, $s3, 16
    ori     $s4, $s4, 0x6a3f
    srl     $s5, $s4, 16
    ori     $s5, $s5, 0x7b53
    srl     $s6, $s5, 16
    ori     $s6, $s6, 0xffb6
    srl     $s7, $s6, 16
    ori     $s7, $s7, 0x1220

    # instead of explicitly dumping the stack pointer, I'll push a dummy
    # variable onto the stack.  Some students are reporting different
    # stack values in their output.
    srl     $t0, $s7, 16
    ori     $t0, $t0,0x8441
    addiu   $sp, $sp,-4
    sw      $t0, 0($sp)


.data
QS_DATA_1:
    .word   14
    .word    4
    .word    9
    .word   84
    .word   60
    .word   23
    .word    2
    .word   16
    .word   35
    .word   46
    .word   66
    .word   63
    .word   44
    .word   54
    .word   24
    .word  100
    .word   42
    .word   75
    .word    3
    .word   43
    .word   89
    .word   78
    .word    0
    .word    5
    .word   81
    .word   33
    .word   87
    .word   30
    .word   17
    .word    3
    .word   50
    .word   25
.text
    la      $a0, QS_DATA_1
    addi    $a1, $zero,32         # arg2: len
    jal     quicksort


    # print out a testcase-specific tail message.
.data
TESTCASE_TAIL_MSG: .asciiz "This is the tail message, with trailing constant 0x9eca\n"
.text
    addi    $v0, $zero,4
    la      $a0, TESTCASE_TAIL_MSG
    syscall


    # dump out all of the registers.
.data
TESTCASE_DUMP1: .ascii  "\n"
                .ascii  "+-----------------------------------------------------------+\n"
     .ascii "|    Magic Value (popped from the stack):                   |\n"
     .asciiz "+-----------------------------------------------------------+\n"

TESTCASE_DUMP2: .ascii  "\n"
                .ascii  "+-----------------------------------------------------------+\n"
     .ascii "|    Testcase Register Dump (fp, then 8 sX regs):           |\n"
     .asciiz "+-----------------------------------------------------------+\n"
.text
    addi   $v0, $zero, 4  # print_str(TESTCASE_DUMP1)
    la     $a0, TESTCASE_DUMP1
    syscall

    # we pop this from the stack so that, if the stack pointer is not
    # predictable, we'll still get reliable results.
    lw      $a0, 0($sp)
    addiu   $sp, $sp,4
    jal     printHex

    # the rest of the registers have hard-coded values
    addi    $v0, $zero, 4             # print_str(TESTCASE_DUMP2)
    la      $a0, TESTCASE_DUMP2
    syscall

    add     $a0, $fp, $zero
    jal     printHex
    add     $a0, $s0, $zero
    jal     printHex
    add     $a0, $s1, $zero
    jal     printHex
    add     $a0, $s2, $zero
    jal     printHex
    add     $a0, $s3, $zero
    jal     printHex
    add     $a0, $s4, $zero
    jal     printHex
    add     $a0, $s5, $zero
    jal     printHex
    add     $a0, $s6, $zero
    jal     printHex
    add     $a0, $s7, $zero
    jal     printHex

    # terminate the program
    addi    $v0, $zero, 10           # syscall_exit
    syscall
    # never get here!



.globl merge_debug
merge_debug:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

.data
merge_debug_MSG: .asciiz "So Far:"
.text

    add     $t0, $a0,$zero    # save 'buf'
    add     $t1, $a1,$zero    # save 'len'

    addi    $v0, $zero,4      # print_str(MSG)
    la      $a0, merge_debug_MSG
    syscall

    add     $t2, $zero,0      # i=0
merge_debug_LOOP:
    slt     $t8, $t2,$a1      # if (i >= len) break
    beq     $t8,$zero, merge_debug_END

    addi    $v0, $zero,11     # print_char(' ')
    addi    $a0, $zero,' '
    syscall

    sll     $t3, $t2,2        # t3 =  i*4
    add     $t3, $t0,$t3      # t3 = &out[i]
    lw      $a0, 0($t3)       # a0 =  out[i]

    addi    $v0, $zero,1      # print_int(out[i])
    syscall

    addi    $t2, $t2,1        # i++
    j       merge_debug_LOOP

merge_debug_END:
    addi    $v0, $zero,11     # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra



.globl quicksort_debug
quicksort_debug:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

# quicksort_debug(int *data, int n, int left,int right) {
#     printf("The numbers:");
#     for (int i=0; i<n; i++) {
#         if (i==left)
#             printf(" (");
#         printf(" %d", data[i]);
#         if (i==right)
#             printf(" )");
#     }
#     printf("\n");
# }
#
# REGISTERS
#   t0 - data
#   t1 - n
#   t2 - left
#   t3 - right
#   t4 - i
#   t5 - data[i]
#   t8 - various temporaries

.data
quicksort_debug_START:   .asciiz "The numbers:"
quicksort_debug_LEFT:    .asciiz " ("
quicksort_debug_RIGHT:   .asciiz " )"
.text

    add   $t0, $a0,$zero    # save the aX registers
    add   $t1, $a1,$zero    # save the aX registers
    add   $t2, $a2,$zero    # save the aX registers
    add   $t3, $a3,$zero    # save the aX registers

    addi  $v0, $zero,4      # print_str(START)
    la    $a0, quicksort_debug_START
    syscall

    addi  $t4, $zero,0      # i=0

quicksort_debug_LOOP:
    slt   $t8, $t4,$t1      # if (i >= n) break
    beq   $t8,$zero, quicksort_debug_END

    bne   $t4,$t2, quicksort_debug_AFTER_LEFT
    addi  $v0, $zero,4      # print_str(LEFT)
    la    $a0, quicksort_debug_LEFT
    syscall
quicksort_debug_AFTER_LEFT:

    addi  $v0, $zero,11     # print_char(' ')
    addi  $a0, $zero,' '
    syscall

    sll   $t5, $t4,2        # t5 = data[i]
    add   $t5, $t0,$t5
    lw    $t5, 0($t5)

    addi  $v0, $zero,1      # print_int(data[i])
    add   $a0, $t5,$zero
    syscall

    bne   $t4,$t3, quicksort_debug_AFTER_RIGHT
    addi  $v0, $zero,4      # print_str(RIGHT)
    la    $a0, quicksort_debug_RIGHT
    syscall
quicksort_debug_AFTER_RIGHT:

    addi  $t4, $t4,1
    j     quicksort_debug_LOOP

quicksort_debug_END:

    addi  $v0, $zero,11     # print_char('\n')
    addi  $a0, $zero,'\n'
    syscall

    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra



# void printHex(int val)
# {
#     printHex_recurse(val, 8);
#     printf("\n");
# }
printHex:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    # printHex(val, 8)
    addi    $a1, $zero, 8
    jal     printHex_recurse

    addi    $v0, $zero, 11      # print_char('\n')
    addi    $a0, $zero, 0xa
    syscall

    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra



printHex_recurse:
    # standard prologue
    addiu   $sp, $sp, -24
    sw      $fp, 0($sp)
    sw      $ra, 4($sp)
    addiu   $fp, $sp, 20

    # if (len == 0) return;    // base case (NOP)
    beq     $a1, $zero, printHex_recurse_DONE

    # recurse first, before we print this character.
    #
    # The reason for this is because the easiest way to break up
    # a long integer is using a small shift and modulo; so *this*
    # call will be responsible for the *last* hex digit, and we'll
    # use recursion to handle the things which come *before* it.
    #
    # As we've seen just above, if the current len==1, then the
    # recursive call will be the base case, and a NOP.

    # of course, we have to save a0 before we recurse.  We do *NOT*
    # need to save a1, since we'll never need it again.
    sw      $a0, 8($sp)

    # printHex_recurse(val >> 4, len-1)
    srl     $a0, $a0,4
    addi    $a1, $a1,-1
    jal     printHex_recurse

    # restore a0
    lw      $a0, 8($sp)

    # the value we will print is (val & 0xf), interpreted as hex.
    andi    $t0, $a0,0x0f      # digit = (val & 0xf)

    slti    $t1, $t0,10        # t1 = (digit < 10)
    beq     $t1, $zero, printHex_recurse_LETTER

    # if we get here, then $t0 contains an integer from 0 to 9, inclusive.
    addi    $v0, $zero, 11     # print_char(digit+'0')
    addi    $a0, $t0, '0'
    syscall

    j       printHex_recurse_DONE

printHex_recurse_LETTER:
    # if we get here, then $t0 contains an integer from 10 to 15, inclusive.
    # convert to the equivalent letter.
    addi    $t0, $t0,-10        # digit -= 10

    addi    $v0, $zero, 11     # print_char(digit+'a')
    addi    $a0, $t0, 'a'
    syscall

    # intentional fall-through to the epilogue

printHex_recurse_DONE:
    # standard epilogue
    lw      $ra, 4($sp)
    lw      $fp, 0($sp)
    addiu   $sp, $sp, 24
    jr      $ra

