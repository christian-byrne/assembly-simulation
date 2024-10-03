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
	.half 1

.globl   intsArray
intsArray:
	

.globl   intsArray_END
intsArray_END:
	

.globl   intsArray_len
intsArray_len:
	.word 0

.globl   theString
theString:
	.asciiz "sometimes i'll hide secret messages in these test cases"


.globl   VyfYGBlkelwR
VyfYGBlkelwR:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   kQoSsQlASXrm
kQoSsQlASXrm:
	.asciiz "==============================================\nTEST (printInts_mode1_extra1):\n\nprintInts=1\nprintWords=0\nbubbleSort=0\nprintInts_howToFindLen=1\nintsArray=[]\nintsArray_len=0\ntheString=\"sometimes i'll hide secret messages in these test cases\"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, kQoSsQlASXrm
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, VyfYGBlkelwR
	syscall

	addi $v0, $zero, 11	# print
	addi $a0, $zero, '['
	syscall

	la $t0, intsArray
    
	

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
