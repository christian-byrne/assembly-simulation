.data

COMMA_SEP:
	.asciiz ", "
    
.globl   printInts
printInts:
	.byte 0

.globl   printWords
printWords:
	.byte 1

.globl   bubbleSort
bubbleSort:
	.byte 0

.globl   printInts_howToFindLen
printInts_howToFindLen:
	.half 0

.globl   intsArray
intsArray:
	

.globl   intsArray_END
intsArray_END:
	

.globl   intsArray_len
intsArray_len:
	.word 0

.globl   theString
theString:
	.asciiz "   This is a test string with leading and trailing spaces    "


.globl   eVOyQTUUwTKx
eVOyQTUUwTKx:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   dhTyGxPFudsB
dhTyGxPFudsB:
	.asciiz "==============================================\nTEST (printWords_leading_trailing_spaces):\n\nprintInts=0\nprintWords=1\nbubbleSort=0\nprintInts_howToFindLen=0\nintsArray=[]\nintsArray_len=0\ntheString=\"   This is a test string with leading and trailing spaces    \"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, dhTyGxPFudsB
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, eVOyQTUUwTKx
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
