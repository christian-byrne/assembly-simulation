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
	.byte	1
printWords:
	.byte	0
bubbleSort:
	.byte	0

printInts_howToFindLen:
	.half	2	# 0 - read intsArray_len; 1 - calc intsArray_END-intsArray; 2 - null terminated

intsArray:
	.word 1
	.word 0

intsArray_END:

intsArray_len:
	.word	2

theString:
	.asciiz	"aion awiothw awiotn"



# ----------- main() -----------
.text

.globl	main

main:
	jal studentMain
	
	
