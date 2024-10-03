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
	.byte	1
bubbleSort:
	.byte	0

printInts_howToFindLen:
	.half	0	# 0 - read intsArray_len; 1 - calc intsArray_END-intsArray; 2 - null terminated

intsArray:
	.word	10

intsArray_END:

intsArray_len:
	.word	1

theString:
	.asciiz	""



# ----------- main() -----------
.text

.globl	main

main:
	jal studentMain
	
