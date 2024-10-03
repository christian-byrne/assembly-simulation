.data

.globl	printInts
.globl	printWords
.globl	bubbleSort

.globl	printInts_howToFindLen
.globl	intsArray
.globl	intsArray_END
.globl	intsArray_len
.globl	theString

printInts:
	.byte	0
printWords:
	.byte	0
bubbleSort:
	.byte	1

printInts_howToFindLen:
	.half	0	# 0 - read intsArray_len; 1 - calc intsArray_END-intsArray; 2 - null terminated

intsArray:
	.word 3
	.word 4
	.word 2
	.word 2
	.word 5
	.word 0

intsArray_END:

intsArray_len:
	.word	5

theString:
	.asciiz	"wgwa awy awy"



# ----------- main() -----------
.text

.globl	main

main:
	jal studentMain
	

