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
	.byte 1

.globl   printInts_howToFindLen
printInts_howToFindLen:
	.half 1

.globl   intsArray
intsArray:
	.word 69

.globl   intsArray_END
intsArray_END:
	

.globl   intsArray_len
intsArray_len:
	.word 1

.globl   theString
theString:
	.asciiz "DO NOT TOUCH!"


.globl   yJgWHYBdYAio
yJgWHYBdYAio:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   ZiIFzCcMECar
ZiIFzCcMECar:
	.asciiz "==============================================\nTEST (bubbleSort_single.s):\n\nprintInts=1\nprintWords=0\nbubbleSort=1\nprintInts_howToFindLen=1\nintsArray=69\nintsArray_len=1\ntheString=\"DO NOT TOUCH!\"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, ZiIFzCcMECar
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, yJgWHYBdYAio
	syscall

	addi $v0, $zero, 11	# print
	addi $a0, $zero, '['
	syscall

	la $t0, intsArray
    
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
