.data
array:

.text

.globl main
main:
    la      $a0, array
    addi    $a1, $zero, 0
    addi    $a2, $zero, 10
    jal     arrayDupSearchInts
    
    addi    $a0, $v0, 0    # make print int print result of arrayDupSearchInts
    addi    $v0, $zero, 1
    
    syscall
    
    addi    $v0, $zero, 11
    addi    $a0, $zero, 0xa
    syscall  # the grading script expects extra newline after output of tests
    
    # apparently, it's necessary to syscall exit to make sure MARS doesn't 
    # infinitely run the test.
    
    addi  $v0, $zero,10
    syscall
