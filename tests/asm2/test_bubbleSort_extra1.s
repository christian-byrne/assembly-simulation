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
	.word -29595
	.word 29769
	.word 124
	.word -14280
	.word 6964
	.word 30314
	.word 14673
	.word 14415
	.word -6610
	.word -3587
	.word -12365
	.word -12691
	.word -21071
	.word 20058
	.word 28579
	.word -16640
	.word -21246
	.word 4221
	.word -7307
	.word 13537
	.word 26477
	.word 6509
	.word -11893
	.word 28165
	.word -14691
	.word -22357
	.word -21512
	.word 29235
	.word 6218
	.word -5920
	.word 17657
	.word 17029
	.word -285
	.word -20608
	.word -17252
	.word 27217
	.word 10077
	.word -6299
	.word 26476
	.word -28029
	.word 31526
	.word -13262
	.word -20131
	.word -11735
	.word -5842
	.word -4452
	.word -454
	.word -12497
	.word -11537
	.word 2693
	.word 26406
	.word 31636
	.word -19511
	.word 20918
	.word -1684
	.word -23737
	.word -20670
	.word -3002
	.word 28697
	.word 9939
	.word -31782
	.word -20041
	.word 241
	.word -13448
	.word 6706
	.word -9703
	.word -6320
	.word 15579
	.word -3019
	.word -3961
	.word -2898
	.word -4578
	.word 27533
	.word -28994
	.word 7801
	.word -696
	.word 19512
	.word -20689
	.word -19532
	.word -21628
	.word -17514
	.word -8850
	.word -3806
	.word 1994
	.word -24660
	.word 17126
	.word 3259
	.word -11679
	.word 11260
	.word 30728
	.word -32027
	.word -9266
	.word 10403
	.word -4679
	.word 15635
	.word -9729
	.word 3984
	.word 29768
	.word 284
	.word 0
	.word 5485

.globl   intsArray_END
intsArray_END:
	

.globl   intsArray_len
intsArray_len:
	.word 101

.globl   theString
theString:
	.asciiz "DO NOT TOUCH!"


.globl   LejiStkXilBr
LejiStkXilBr:
	.asciiz "\n+-------------------------------+\n|    Testcase Variable Dump:    |\n+-------------------------------+\n\n"

.globl   LfZatmopgXbf
LfZatmopgXbf:
	.asciiz "==============================================\nTEST (bubbleSort_extra1.s):\n\nprintInts=1\nprintWords=0\nbubbleSort=1\nprintInts_howToFindLen=1\nintsArray=[-29595, 29769, 124, -14280, 6964, 30314, 14673, 14415, -6610, -3587, -12365, -12691, -21071, 20058, 28579, -16640, -21246, 4221, -7307, 13537, 26477, 6509, -11893, 28165, -14691, -22357, -21512, 29235, 6218, -5920, 17657, 17029, -285, -20608, -17252, 27217, 10077, -6299, 26476, -28029, 31526, -13262, -20131, -11735, -5842, -4452, -454, -12497, -11537, 2693, 26406, 31636, -19511, 20918, -1684, -23737, -20670, -3002, 28697, 9939, -31782, -20041, 241, -13448, 6706, -9703, -6320, 15579, -3019, -3961, -2898, -4578, 27533, -28994, 7801, -696, 19512, -20689, -19532, -21628, -17514, -8850, -3806, 1994, -24660, 17126, 3259, -11679, 11260, 30728, -32027, -9266, 10403, -4679, 15635, -9729, 3984, 29768, 284, 0, 5485]\nintsArray_len=101\ntheString=\"DO NOT TOUCH!\"\n\n==============================================\n\n"


.text

.globl main

main:
	addi $v0, $zero, 4	# print
	la $a0, LfZatmopgXbf
	syscall

	jal studentMain

.text
	addi $v0, $zero, 4	# print
	la $a0, LejiStkXilBr
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
