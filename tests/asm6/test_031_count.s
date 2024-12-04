# test_031_count.s
#
# A testcase for Asm 6.



# ----------- main() -----------
.text


.globl	main
main:
    # fill the sX registers (and fp) with junk.  Each testcase will use a different
    # set of values.
    lui     $fp,      0xcaa3
    ori     $fp, $fp, 0x7d5d
    sll     $s0, $fp, 16
    ori     $s0, $s0, 0xa3cc
    sll     $s1, $s0, 16
    ori     $s1, $s1, 0x6f98
    sll     $s2, $s1, 16
    ori     $s2, $s2, 0x695e
    sll     $s3, $s2, 16
    ori     $s3, $s3, 0x77de
    sll     $s4, $s3, 16
    ori     $s4, $s4, 0xa145
    sll     $s5, $s4, 16
    ori     $s5, $s5, 0x7b79
    sll     $s6, $s5, 16
    ori     $s6, $s6, 0xe909
    sll     $s7, $s6, 16
    ori     $s7, $s7, 0x6a4e

    # instead of explicitly dumping the stack pointer, I'll push a dummy
    # variable onto the stack.  Some students are reporting different
    # stack values in their output.
    sll     $t0, $s7, 16
    ori     $t0, $t0,0x0d69
    addiu $sp, $sp,-4
    sw    $t0, 0($sp)


# THIS BUILDS A TREE THAT LOOKS AS FOLLOWS:
#
#       97
#      /  \
#     0    1000
#      \
#       28
#      / \
#     18  30
#    / \   \
#   9  26   31
#      /
#    21
#      \
#      22


.data

OBJ_00:
    .word 0
    .word 0        # NULL
    .word OBJ_28

OBJ_09:
    .word 9
    .word 0        # NULL
    .word 0        # NULL

OBJ_18:
    .word 18
    .word OBJ_09
    .word OBJ_26

OBJ_21:
    .word 21
    .word 0        # NULL
    .word OBJ_22

OBJ_22:
    .word 22
    .word 0        # NULL
    .word 0        # NULL

OBJ_26:
    .word 26
    .word OBJ_21
    .word 0        # NULL

OBJ_28:
    .word 28
    .word OBJ_18
    .word OBJ_30

OBJ_30:
    .word 30
    .word 0        # NULL
    .word OBJ_31

OBJ_31:
    .word 31
    .word 0        # NULL
    .word 0        # NULL

OBJ_97:
    .word 97
    .word OBJ_00
    .word OBJ_1000

OBJ_1000:
    .word 1000
    .word 0        # NULL
    .word 0        # NULL

.text

    la      $a0, OBJ_00
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    addi    $a0, $zero,0
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_09
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_18
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_21
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_22
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_26
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_28
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_30
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_31
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_97
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

    la      $a0, OBJ_1000
    jal     bst_count

    add     $a0, $v0,$zero
    jal     dump_count_retval

.data
TESTCASE_DUMP1:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
    	.ascii	"|    Magic Value (popped from the stack):                   |\n"
    	.asciiz	"+-----------------------------------------------------------+\n"

TESTCASE_DUMP2:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
    	.ascii	"|    Testcase Register Dump (fp, then 8 sX regs):           |\n"
    	.asciiz	"+-----------------------------------------------------------+\n"
.text
    addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP1)
    la	$a0, TESTCASE_DUMP1
    syscall

    # we pop this from the stack so that, if the stack pointer is not
    # predictable, we'll still get reliable results.
    lw      $a0, 0($sp)
    addiu   $sp, $sp,4
    jal     printHex

    # the rest of the registers have hard-coded values
    addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP2)
    la	$a0, TESTCASE_DUMP2
    syscall

    add	$a0, $fp, $zero
    jal     printHex
    add	$a0, $s0, $zero
    jal     printHex
    add	$a0, $s1, $zero
    jal     printHex
    add	$a0, $s2, $zero
    jal     printHex
    add	$a0, $s3, $zero
    jal     printHex
    add	$a0, $s4, $zero
    jal     printHex
    add	$a0, $s5, $zero
    jal     printHex
    add	$a0, $s6, $zero
    jal     printHex
    add	$a0, $s7, $zero
    jal     printHex
    
    # terminate the program
    addi	$v0, $zero, 10		# syscall_exit
    syscall
    # never get here!



dump_count_retval:
    addi    $v0, $zero,1            # print_int(node->key)
    # a0 is already set
    syscall

    addi    $v0, $zero,11           # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    jr	$ra



# ---- some functions that the student code can call ----





# ---- UTILITY FUNCTIONS, FOR THE TESTCASE ITSELF ----

# void printHex(int val)
# {
#     printHex_recurse(val, 8);
#     printf("\n");
# }
printHex:
    # standard prologue
    addiu  $sp, $sp, -24
    sw     $fp, 0($sp)
    sw     $ra, 4($sp)
    addiu  $fp, $sp, 20
    
    # printHex(val, 8)
    addi   $a1, $zero, 8
    jal    printHex_recurse
    
    addi   $v0, $zero, 11      # print_char('\n')
    addi   $a0, $zero, 0xa
    syscall

    # standard epilogue
    lw     $ra, 4($sp)
    lw     $fp, 0($sp)
    addiu  $sp, $sp, 24
    jr     $ra
    
    
    
printHex_recurse:
    # standard prologue
    addiu  $sp, $sp, -24
    sw     $fp, 0($sp)
    sw     $ra, 4($sp)
    addiu  $fp, $sp, 20
    
    # if (len == 0) return;    // base case (NOP)
    beq    $a1, $zero, printHex_recurse_DONE

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
    sw     $a0, 8($sp)
    
    # printHex_recurse(val >> 4, len-1)
    srl    $a0, $a0,4
    addi   $a1, $a1,-1
    jal    printHex_recurse
    
    # restore a0
    lw     $a0, 8($sp)
    
    # the value we will print is (val & 0xf), interpreted as hex.
    andi   $t0, $a0,0x0f      # digit = (val & 0xf)
    
    slti   $t1, $t0,10        # t1 = (digit < 10)
    beq    $t1, $zero, printHex_recurse_LETTER
    
    # if we get here, then $t0 contains an integer from 0 to 9, inclusive.
    addi   $v0, $zero, 11     # print_char(digit+'0')
    addi   $a0, $t0, '0'
    syscall
    
    j      printHex_recurse_DONE
    
printHex_recurse_LETTER:
    # if we get here, then $t0 contains an integer from 10 to 15, inclusive.
    # convert to the equivalent letter.
    addi   $t0, $t0,-10        # digit -= 10
    
    addi   $v0, $zero, 11     # print_char(digit+'a')
    addi   $a0, $t0, 'a'
    syscall
    
    # intentional fall-through to the epilogue

printHex_recurse_DONE:
    # standard epilogue
    lw     $ra, 4($sp)
    lw     $fp, 0($sp)
    addiu  $sp, $sp, 24
    jr     $ra


