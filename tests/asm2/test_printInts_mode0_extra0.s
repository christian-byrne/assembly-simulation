.data

COMMA_SEP:
	.asciiz ", "
    
.globl   printInts
printInts:
	.byte 1

.globl   printWords
printWords:
	.byte 0

.globl   bubbleSort
bubbleSort:
	.byte 0

.globl   printInts_howToFindLen
printInts_howToFindLen:
	.half 0

.globl   intsArray
intsArray:
	.word -5000
	.word -1000
	.word -3000
	.word 2000
	.word -3000

.globl   intsArray_END
intsArray_END:
	

.globl   intsArray_len
intsArray_len:
	.word 5

.globl   theString
theString:
	.asciiz "Hello World!"


.globl   NdONmPTJlnCT
NdONmPTJlnCT:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   HimVvgtbqMqE
HimVvgtbqMqE:
	.asciiz "==============================================\nTEST (printInts_mode0_extra):\n\nprintInts=1\nprintWords=0\nbubbleSort=0\nprintInts_howToFindLen=0\nintsArray=[-5000, -1000, -3000, 2000, -3000]\nintsArray_len=5\ntheString=\"Hello World!\"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, HimVvgtbqMqE
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, NdONmPTJlnCT
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
