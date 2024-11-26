# test_060_search.s
#
# A testcase for Asm 6.



# ----------- main() -----------
.text


.globl	main
main:
    # fill the sX registers (and fp) with junk.  Each testcase will use a different
    # set of values.
    lui     $fp,      0x8539
    ori     $fp, $fp, 0xb61b
    sll     $s0, $fp, 16
    ori     $s0, $s0, 0x4a4b
    sll     $s1, $s0, 16
    ori     $s1, $s1, 0x0843
    sll     $s2, $s1, 16
    ori     $s2, $s2, 0xc42d
    sll     $s3, $s2, 16
    ori     $s3, $s3, 0x48ad
    sll     $s4, $s3, 16
    ori     $s4, $s4, 0x1a34
    sll     $s5, $s4, 16
    ori     $s5, $s5, 0x0065
    sll     $s6, $s5, 16
    ori     $s6, $s6, 0x56ce
    sll     $s7, $s6, 16
    ori     $s7, $s7, 0xd5c1

    # instead of explicitly dumping the stack pointer, I'll push a dummy
    # variable onto the stack.  Some students are reporting different
    # stack values in their output.
    sll     $t0, $s7, 16
    ori     $t0, $t0,0xe201
    addiu $sp, $sp,-4
    sw    $t0, 0($sp)


.data

OBJ_a:	.word	21
    .word	OBJ_b
    .word	OBJ_c

OBJ_b:	.word	-22
    .word	0        # NULL
    .word	OBJ_e

OBJ_c:	.word	31
    .word	OBJ_h
    .word	OBJ_d

OBJ_d:	.word	52
    .word	0        # NULL
    .word	OBJ_f

OBJ_e:	.word	-9
    .word	OBJ_g
    .word	OBJ_j

OBJ_f:	.word	100
    .word	0        # NULL
    .word	0        # NULL

OBJ_g:	.word	-10
    .word	OBJ_i
    .word	0        # NULL

OBJ_h:	.word	22
    .word	0        # NULL
    .word	0        # NULL

OBJ_i:	.word	-19
    .word   0        # NULL
    .word	0        # NULL

OBJ_j:	.word	7
    .word   0        # NULL
    .word	0        # NULL

.text

    # ----- DELETE -22 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,-22
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
.data
DIVIDER:
    .asciiz "---\n"
.text
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE 100 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,100
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE -10 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,-10
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE 52 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,52
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE -19 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,-19
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE 7 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,7
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE 22 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,22
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE 31 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,31
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    # ----- DELETE -9 -----
    la      $a0, OBJ_a
    addi    $a1, $zero,-9
    jal     bst_delete

    # ----- PRINT THE TRAVERSALS -----
    la      $a0, OBJ_a
    jal     bst_in_order_traversal

    addi    $v0, $zero,4             # print_str("---\n")
    la      $a0, DIVIDER
    syscall

    la      $a0, OBJ_a
    jal     bst_pre_order_traversal

    addi    $v0, $zero,11            # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall




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



.data
HIT:	.asciiz "bst_search() returned an object:  key="
MISS:	.asciiz "bst_search() returned NULL\n"
.text

dump_search_retval:
    beq     $a0,$zero, dump_search_retval__WAS_NULL

    # read the key for the node into $t0, since we're about to overwrite $a0
    lw      $t0, 0($a0)

    addi    $v0, $zero,4            # print_str(HIT)
    la      $a0, HIT
    syscall

    addi    $v0, $zero,1            # print_int(node->key)
    add     $a0, $t0,$zero
    syscall

    addi    $v0, $zero,11           # print_char('\n')
    addi    $a0, $zero,'\n'
    syscall

    j       dump_search_retval__DONE

dump_search_retval__WAS_NULL:
    addi    $v0, $zero,4            # print_str(MISS)
    la      $a0, MISS
    syscall

dump_search_retval__DONE:
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


