.data
teststring:    .asciiz   "aaaaaaaaaaaaaaa"
.text

.globl main
main:
    la    $a0, teststring
    addi  $a1, $zero, 'a'
    addi  $a2, $zero, 'a'
    addi  $a3, $zero, 'a'
    
    addi  $t0, $zero, 'a'
    addi  $t1, $zero, 'a'
    
    sw    $t0, -8($sp)
    sw    $t1, -4($sp)
    

    jal   stringSearch5
    
    addi    $a0, $v0, 0    # make print int print result of stringSearch5
    addi    $v0, $zero, 1
    
    syscall
    
    addi    $v0, $zero, 11
    addi    $a0, $zero, 0xa
    syscall  # the grading script expects extra newline after output of tests
    
    # apparently, it's necessary to syscall exit to make sure MARS doesn't 
    # infinitely run the test.
    
    addi  $v0, $zero,10
    syscall