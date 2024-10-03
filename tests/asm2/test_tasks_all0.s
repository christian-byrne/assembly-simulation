.data

COMMA_SEP:
	.asciiz ", "
    
.globl   printInts
printInts:
	.byte 1

.globl   printWords
printWords:
	.byte 1

.globl   bubbleSort
bubbleSort:
	.byte 1

.globl   printInts_howToFindLen
printInts_howToFindLen:
	.half 0

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
	.asciiz "Hello World!"


.globl   TtNqfvuilAgV
TtNqfvuilAgV:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   llfUvHWlpLth
llfUvHWlpLth:
	.asciiz "==============================================\nTEST (tasks_all0):\n\nprintInts=1\nprintWords=1\nbubbleSort=1\nprintInts_howToFindLen=0\nintsArray=[1, 2, 3]\nintsArray_len=3\ntheString=\"Hello World!\"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, llfUvHWlpLth
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, TtNqfvuilAgV
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
