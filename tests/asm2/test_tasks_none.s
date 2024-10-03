.data

COMMA_SEP:
	.asciiz ", "
    
.globl   printInts
printInts:
	.byte 0

.globl   printWords
printWords:
	.byte 0

.globl   bubbleSort
bubbleSort:
	.byte 0

.globl   printInts_howToFindLen
printInts_howToFindLen:
	.half 2

.globl   intsArray
intsArray:
	.word 1
	.word 2
	.word 3

.globl   intsArray_END
intsArray_END:
	

.globl   intsArray_len
intsArray_len:
	.word 3

.globl   theString
theString:
	.asciiz "DO NOT TOUCH!"


.globl   eMLjSXvotQGe
eMLjSXvotQGe:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   ZFlHztKinmRD
ZFlHztKinmRD:
	.asciiz "==============================================\nTEST (tasks_none):\n\nprintInts=0\nprintWords=0\nbubbleSort=0\nprintInts_howToFindLen=2\nintsArray=[1, 2, 3]\nintsArray_len=3\ntheString=\"DO NOT TOUCH!\"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, ZFlHztKinmRD
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, eMLjSXvotQGe
	syscall

	addi $v0, $zero, 11	# print
	addi $a0, $zero, '['
	syscall

	la $t0, intsArray
    
	addi $v0, $zero, 1	# print
	lw $a0, 0($t0)
	syscall
	
	addi $t0, $t0, 4
	
	addi $v0, $zero, 4	# print
	la $a0, COMMA_SEP
	syscall

	addi $v0, $zero, 1	# print
	lw $a0, 0($t0)
	syscall
	
	addi $t0, $t0, 4
	
	addi $v0, $zero, 4	# print
	la $a0, COMMA_SEP
	syscall

	addi $v0, $zero, 1	# print
	lw $a0, 0($t0)
	syscall
	
	addi $t0, $t0, 4

	add $t0, $zero, $zero   # reset t0
    
	addi $v0, $zero, 11	# print
	addi $a0, $zero, ']'
	syscall
	addi $v0, $zero, 11
	addi $a0, $zero, '\n'
	syscall

	addi $v0, $zero, 4	# print
	la $a0, theString
	syscall

	addi $v0, $zero, 11
	addi $a0, $zero, '\n'
	syscall


	addi $v0, $zero, 10
	syscall
