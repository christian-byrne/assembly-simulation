.text
.globl main
main:

    addi    $a0, $zero, 2
    addi    $a1, $zero, 5
    jal     addVotes


    addi    $a0, $zero, 3
    addi    $a1, $zero, 0
    jal     addVotes


    addi    $a0, $zero, 0
    addi    $a1, $zero, 0
    jal     addVotes


    addi    $a0, $zero, 1
    addi    $a1, $zero, 0
    jal     addVotes


    addi    $a0, $zero, 0
    addi    $a1, $zero, 2
    jal     addVotes


    addi    $a0, $zero, 3
    addi    $a1, $zero, 0
    jal     addVotes



    addi    $v0, $zero, 11
    addi    $a0, $zero, 0xa
    syscall  # the grading script expects extra newline after output of tests
    
    # apparently, it's necessary to syscall exit to make sure MARS doesn't 
    # infinitely run the test.
    
    addi  $v0, $zero,10
    syscall
