# AUTHOR
#   Christian Byrne
#
# PROGRAM DESCRIPTION:
#   This program can complete four different tasks:
#   finding the minimum value of six given variables, negating the
#   values of the six given variables, printing the even values of the
#   six given variables, and printing the values of the six given
#   variables. The program uses a series of if-else statements to
#   determine which task to complete. The program uses the MIPS assembly
#   language and is designed to be run on the MARS MIPS simulator.
#
# REGISTERS
#   s0 — jan
#   s1 — feb
#   s2 — mar
#   s3 — apr
#   s4 — may
#   s5 — jun
#   s7 — mask (0x0001) for isolating the least significant bit
#   t0-t8 — various temporary values
#   v0 — syscall
#   a0 — syscall argument


.data
newLine:            .asciiz "\n"
minimumString:      .asciiz "minimum: "
negateString:       .asciiz "NEGATE\n"
evensStartString:   .asciiz "EVENS START\n"
evensEndString:     .asciiz "EVENS END\n"
janString:          .asciiz "jan: "
febString:          .asciiz "\nfeb: "
marString:          .asciiz "\nmar: "
aprString:          .asciiz "\napr: "
mayString:          .asciiz "\nmay: "
junString:          .asciiz "\njun: "

.text
.globl  studentMain

studentMain:
    addiu   $sp,    $sp,                -24         # allocate stack space -- default of 24 here
    sw      $fp,    0($sp)                          # save frame pointer of caller
    sw      $ra,    4($sp)                          # save return address
    addiu   $fp,    $sp,                20          # setup frame pointer of main

    # Load the 6 given parameter variables into registers $s0-$s5
    la      $s0,    jan                             # s0 = &jan
    lw      $s0,    0($s0)                          # s0 = jan
    la      $s1,    feb                             # s1 = &feb
    lw      $s1,    0($s1)                          # s1 = feb
    la      $s2,    mar                             # s2 = &mar
    lw      $s2,    0($s2)                          # s2 = mar
    la      $s3,    apr                             # s3 = &apr
    lw      $s3,    0($s3)                          # s3 = apr
    la      $s4,    may                             # s4 = &may
    lw      $s4,    0($s4)                          # s4 = may
    la      $s5,    jun                             # s5 = &jun
    lw      $s5,    0($s5)                          # s5 = jun

    # For each task, load the task's variable into $t0 and check if the variable is 1.
    # If the variable is 1, proceed with the task; else, jump to the next task.

    # ------------------------------- Task: minimum -------------------------------

taskMinimum:
    la      $t0,    minimum                         # t0 = &minimum
    lw      $t0,    0($t0)                          # t0 = minimum

    slt     $t1,    $zero,              $t0         # if 0 < minimum, set t1 = 1
    beq     $t1,    $zero,              taskNegate  # if t1 = 0, jump to taskNegate

    # Find the minimum value. Use t2 to store the minimum value
    add     $t2,    $zero,              $s0         # Set the minimum value to jan as a start

    # Begin comparing the minimum value to the other values
    slt     $t3,    $s0,                $s1         # if current minimum value (t3) < feb, t3 = 1
    bne     $t3,    $zero,              notFeb      # if t3 = 1, jump to minFeb
    add     $t2,    $zero,              $s1         # set the new minimum value to feb

notFeb:
    slt     $t3,    $t2,                $s2         # if current minimum value (t3) < mar, t3 = 1
    bne     $t3,    $zero,              notMar      # if t3 = 1, jump to setMarMin
    add     $t2,    $zero,              $s2         # set the new minimum value to mar

notMar:
    slt     $t3,    $t2,                $s3         # if current minimum value (t3) < apr, $3 = 1
    bne     $t3,    $zero,              notApr      # if t3 = 1, jump to setAprMin
    add     $t2,    $zero,              $s3         # set the new minimum value to apr

notApr:
    slt     $t3,    $t2,                $s4         # if current minimum value (t3) < may, t3 = 1
    bne     $t3,    $zero,              notMay      # if t3 = 1, jump to setMayMin
    add     $t2,    $zero,              $s4         # set the new minimum value to may

notMay:
    slt     $t3,    $t2,                $s5         # if current minimum value (t3) < jun, t3 = 1
    bne     $t3,    $zero,              notJun      # if t3 = 1, jump to setJunMin
    add     $t2,    $zero,              $s5         # set the new minimum value to jun

notJun:

    # print the minimum value
    la      $a0,    minimumString                   # a0 = &minimumString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

    add     $a0,    $zero,              $t2         # load the minimum value into $a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

    # ------------------------------- Task: negate -------------------------------

taskNegate:
    la      $t0,    negate                          # t0 = &negate
    lw      $t0,    0($t0)                          # t0 = negate

    slt     $t1,    $zero,              $t0         # if 0 < negate, set t1 = 1
    beq     $t1,    $zero,              taskEvens   # if t1 = 0, jump to taskEvens

    # Arithmetically negate each of the variables, and store back into its slot in memory
    sub     $s0,    $zero,              $s0         # s0 = -jan (negative sign rather than tilde to indicate arithmetic negation)
    la      $t8,    jan                             # t8 = &jan
    sw      $s0,    0($t8)                          # jan = -jan

    sub     $s1,    $zero,              $s1         # s1 = -feb
    la      $t8,    feb                             # t8 = &feb
    sw      $s1,    0($t8)                          # feb = -feb

    sub     $s2,    $zero,              $s2         # s2 = -mar
    la      $t8,    mar                             # t8 = &mar
    sw      $s2,    0($t8)                          # mar = -mar

    sub     $s3,    $zero,              $s3         # s3 = -apr
    la      $t8,    apr                             # t8 = &apr
    sw      $s3,    0($t8)                          # apr = -apr

    sub     $s4,    $zero,              $s4         # s4 = -may
    la      $t8,    may                             # t8 = &may
    sw      $s4,    0($t8)                          # may = -may

    sub     $s5,    $zero,              $s5         # s5 = -jun
    la      $t8,    jun                             # t8 = &jun
    sw      $s5,    0($t8)                          # jun = -jun

    # print "NEGATE"
    la      $a0,    negateString                    # a0 = &negateString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

    # ------------------------------- Task: evens -------------------------------

taskEvens:
    la      $t0,    evens                           # t0 = &evens
    lw      $t0,    0($t0)                          # t0 = evens

    slt     $t1,    $zero,              $t0         # if 0 < evens, set t1 = 1
    beq     $t1,    $zero,              taskprint   # if t1 = 0, jump to taskprint

    # print "EVEN START"
    la      $a0,    evensStartString                # a0 = &evensStartString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

    # Create a mask 0x0001 for isolating the least significant bit
    addi    $s7,    $zero,              1           # set 4 to 1 (0x0001)

    # Check if each of the variables is even or odd by checking the least significant bit is 0 or 1
    and     $t0,    $s0,                $s7         # mask jan to isolate the least significant bit
    bne     $t0,    $zero,              janEnd      # if jan is odd, jump to janEnd

    # print the value of jan from s0
    add     $a0,    $zero,              $s0         # load jan into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

janEnd:
    and     $t1,    $s1,                $s7         # mask feb to isolate the least significant bit
    bne     $t1,    $zero,              febEnd      # if feb is odd, jump to febEnd

    # print the value of feb from s1
    add     $a0,    $zero,              $s1         # load feb into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

febEnd:
    and     $t2,    $s2,                $s7         # mask mar to isolate the least significant bit
    bne     $t2,    $zero,              marEnd      # if mar is odd, jump to marEnd

    # print the value of mar from s2
    add     $a0,    $zero,              $s2         # load mar into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

marEnd:
    and     $t3,    $s3,                $s7         # mask apr to isolate the least significant bit
    bne     $t3,    $zero,              aprEnd      # if apr is odd, jump to aprEnd

    # print the value of apr from s3
    add     $a0,    $zero,              $s3         # load apr into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

aprEnd:
    and     $t4,    $s4,                $s7         # mask may to isolate the least significant bit
    bne     $t4,    $zero,              mayEnd      # if may is odd, jump to mayEnd

    # print the value of may from s4
    add     $a0,    $zero,              $s4         # load may into $a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string


mayEnd:
    and     $t5,    $s5,                $s7         # mask jun to isolate the least significant bit
    bne     $t5,    $zero,              junEnd      # if jun is odd, jump to junEnd

    # print the value of jun from s5
    add     $a0,    $zero,              $s5         # load jun into $a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # print newline
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

junEnd:
    # print "EVEN END"
    la      $a0,    evensEndString                  # a0 = &evensEndString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

    # ------------------------------- Task: print -------------------------------

taskprint:
    la      $t0,    print                           # t0 = &print
    lw      $t0,    0($t0)                          # t0 = print

    slt     $t1,    $zero,              $t0         # if 0 < print, set t1 = 1
    beq     $t1,    $zero,              epilogue    # if $t1 = 0, jump to epilogue

    # print the values of the variables
    la      $a0,    janString                       # a0 = &janString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string
    add     $a0,    $zero,              $s0         # load jan into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    la      $a0,    febString                       # a0 = &febString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string
    add     $a0,    $zero,              $s1         # load feb into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    la      $a0,    marString                       # a0 = &marString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string
    add     $a0,    $zero,              $s2         # load mar into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    la      $a0,    aprString                       # a0 = &aprString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string
    add     $a0,    $zero,              $s3         # load apr into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    la      $a0,    mayString                       # a0 = &mayString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string
    add     $a0,    $zero,              $s4         # load may into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    la      $a0,    junString                       # a0 = &junString
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string
    add     $a0,    $zero,              $s5         # load jun into a0
    addi    $v0,    $zero,              1           # set syscall to print integer
    syscall                                         # print the integer

    # ------------------------------- Epilogue -------------------------------

    # print final newline to match test expectations
    la      $a0,    newLine                         # a0 = &newLine
    addi    $v0,    $zero,              4           # set syscall to print string
    syscall                                         # print the string

epilogue:

    lw      $ra,    4($sp)                          # get return address from stack
    lw      $fp,    0($sp)                          # restore the frame pointer of caller
    addiu   $sp,    $sp,                24          # restore the stack pointer of caller
    jr      $ra                                     # return to code of caller



