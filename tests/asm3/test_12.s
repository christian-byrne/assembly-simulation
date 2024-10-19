 # For this test, we'll use a modified version of getNextLetter from test01
.globl getNextLetter
getNextLetter:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20

.data
getNextLetter_BUF:	.asciiz "vaoijwhiewhtowehtweoaiowtt"
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
			.word   0    # make sure we never overrun the buffer!
.text
	# no matter what input they give us, we will modulo by 32, so that positions
	# "wrap around" over time.
	andi   $a0, $a0,0x1f        # this mask has 5 bits turned on!
	
	# read the address of the string
	la     $v0, getNextLetter_BUF
	
	# offset by the parameter
	add    $v0, $v0,$a0
	
	# end then read the character there, as the value we'll return.
	lb     $v0, 0($v0)
	
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra

.globl main
main: 
   
    # collatz_line(45)
	addi  $a0, $zero, 45
	jal   collatz_line
    
       
    # collatz_line(1)
	addi  $a0, $zero, 1
	jal   collatz_line
    
       
    # collatz_line(239)
	addi  $a0, $zero, 239
	jal   collatz_line
    
       
    # collatz_line(19)
	addi  $a0, $zero, 19
	jal   collatz_line
    
       
    # collatz_line(4)
	addi  $a0, $zero, 4
	jal   collatz_line
    
       
    # collatz_line(5)
	addi  $a0, $zero, 5
	jal   collatz_line
    
       
    # collatz_line(392)
	addi  $a0, $zero, 392
	jal   collatz_line
    
       
    # collatz_line(593)
	addi  $a0, $zero, 593
	jal   collatz_line
    
       
    # collatz_line(55)
	addi  $a0, $zero, 55
	jal   collatz_line
    
       
    # collatz_line(2)
	addi  $a0, $zero, 2
	jal   collatz_line
    
       
    # collatz_line(563)
	addi  $a0, $zero, 563
	jal   collatz_line
    
       
    # collatz_line(95)
	addi  $a0, $zero, 95
	jal   collatz_line
    
       
    # collatz_line(25)
	addi  $a0, $zero, 25
	jal   collatz_line
    
       
    # collatz(45)
	addi  $a0, $zero, 45
	jal   collatz
    
       
    # collatz(1)
	addi  $a0, $zero, 1
	jal   collatz
    
       
    # collatz(239)
	addi  $a0, $zero, 239
	jal   collatz
    
       
    # collatz(19)
	addi  $a0, $zero, 19
	jal   collatz
    
       
    # collatz(4)
	addi  $a0, $zero, 4
	jal   collatz
    
       
    # collatz(5)
	addi  $a0, $zero, 5
	jal   collatz
    
       
    # collatz(392)
	addi  $a0, $zero, 392
	jal   collatz
    
       
    # collatz(593)
	addi  $a0, $zero, 593
	jal   collatz
    
       
    # collatz(55)
	addi  $a0, $zero, 55
	jal   collatz
    
       
    # collatz(2)
	addi  $a0, $zero, 2
	jal   collatz
    
       
    # collatz(563)
	addi  $a0, $zero, 563
	jal   collatz
    
       
    # collatz(95)
	addi  $a0, $zero, 95
	jal   collatz
    
       
    # collatz(25)
	addi  $a0, $zero, 25
	jal   collatz
    
    
.data
SEARCH_STRING0:   .asciiz ""
SEARCH_STRING1:   .asciiz "%"
SEARCH_STRING2:   .asciiz "iot%"
SEARCH_STRING3:   .asciiz "i%"
SEARCH_STRING4:   .asciiz "woirj%zia%"
SEARCH_STRING5:   .asciiz "woer   %"

.text
	la      $a0, SEARCH_STRING0
	jal     percentSearch
	add     $t0, $v0,$zero
    
    addi    $v0, $zero,1              
	add     $a0, $t0,$zero
	syscall                 # print percentSearch(SEARCH_STRING0)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                 # print newline
    
    	la      $a0, SEARCH_STRING1
	jal     percentSearch
	add     $t0, $v0,$zero
    
    addi    $v0, $zero,1              
	add     $a0, $t0,$zero
	syscall                 # print percentSearch(SEARCH_STRING1)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                 # print newline
    
    	la      $a0, SEARCH_STRING2
	jal     percentSearch
	add     $t0, $v0,$zero
    
    addi    $v0, $zero,1              
	add     $a0, $t0,$zero
	syscall                 # print percentSearch(SEARCH_STRING2)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                 # print newline
    
    	la      $a0, SEARCH_STRING3
	jal     percentSearch
	add     $t0, $v0,$zero
    
    addi    $v0, $zero,1              
	add     $a0, $t0,$zero
	syscall                 # print percentSearch(SEARCH_STRING3)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                 # print newline
    
    	la      $a0, SEARCH_STRING4
	jal     percentSearch
	add     $t0, $v0,$zero
    
    addi    $v0, $zero,1              
	add     $a0, $t0,$zero
	syscall                 # print percentSearch(SEARCH_STRING4)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                 # print newline
    
    	la      $a0, SEARCH_STRING5
	jal     percentSearch
	add     $t0, $v0,$zero
    
    addi    $v0, $zero,1              
	add     $a0, $t0,$zero
	syscall                 # print percentSearch(SEARCH_STRING5)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                 # print newline
    
    addi    $a0, $zero,3               # letterTree(3)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(3)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,25               # letterTree(25)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(25)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,325               # letterTree(325)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(325)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,2359               # letterTree(2359)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(2359)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,395               # letterTree(395)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(395)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,2954               # letterTree(2954)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(2954)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,35               # letterTree(35)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(35)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,31               # letterTree(31)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(31)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,5               # letterTree(5)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(5)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,2               # letterTree(2)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(2)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    addi    $a0, $zero,19               # letterTree(19)
	jal     letterTree                
	add     $t0, $v0,$zero             
	
	addi    $v0, $zero,1               
	add     $a0, $t0,$zero
	syscall                             # print letterTree(19)
	
	addi    $v0, $zero,11             
	addi    $a0, $zero,0xa
	syscall                             # print newline
    
    