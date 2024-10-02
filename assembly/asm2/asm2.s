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
printUnknownSuffix: .asciiz " an unknown number of elements. Will stop at a zero element.\n"
printPrefix:        .asciiz "printInts: About to print "
printKnownSuffix:   .asciiz " elements.\n"
space:              .asciiz " "
nullTerminator:     .asciiz "\0"
printWordsPrefix:   .asciiz "printWords: There were "
printWordsSuffix:   .asciiz " words.\n"
swapMessagePrefix:  .asciiz "Swap at: "

.text
                    .globl  studentMain

studentMain:
    addiu   $sp,            $sp,                            -24                                 # allocate stack space -- default of 24 here
    sw      $fp,            0($sp)                                                              # save frame pointer of caller
    sw      $ra,            4($sp)                                                              # save return address
    addiu   $fp,            $sp,                            20                                  # setup frame pointer of main

    # Load the 6 given parameter variables into registers $s0-$s5
    la      $s0,            jan                                                                 # s0 = &jan
    lw      $s0,            0($s0)                                                              # s0 = jan
    la      $s1,            feb                                                                 # s1 = &feb
    lw      $s1,            0($s1)                                                              # s1 = feb
    la      $s2,            mar                                                                 # s2 = &mar
    lw      $s2,            0($s2)                                                              # s2 = mar
    la      $s3,            apr                                                                 # s3 = &apr
    lw      $s3,            0($s3)                                                              # s3 = apr
    la      $s4,            may                                                                 # s4 = &may
    lw      $s4,            0($s4)                                                              # s4 = may
    la      $s5,            jun                                                                 # s5 = &jun
    lw      $s5,            0($s5)                                                              # s5 = jun

    # For each task, load the task's variable into $t0 and check if the variable is 1.
    # If the variable is 1, proceed with the task; else, jump to the next task.

    # ----------------------------- Task: Print Ints ------------------------------

printInts:
    # ```c
    # if (printInts != 0)
    # {
    #     if (printInts_howToFindLen != 2)
    #     {
    #         int count;
    #         if (printInts_howToFindLen == 0)
    #             count = intsArray_len;
    #         else
    #             count = intsArray_END - intsArray; // remember to divide by 4!
    #
    #         printf("printInts: About to print %d elements.\n", count);
    #         for (int i = 0; i < count; i++)
    #             printf("%d\n", intsArray[i]);
    #     }
    #     else
    #     {
    #         // searches for a null terminator
    #         int *cur = intsArray; // same as &intsArray[0];
    #         printf("printInts: About to print an unknown number of elements. "
    #               "Will stop at a zero element.\n"); // all one line!
    #
    #         while (*cur != 0)
    #         {
    #             printf("%d\n", *cur);
    #             cur++;
    #         }
    #     }
    # }
    # ```
    #
    #  0 - length variable. Read the variable intsArray len to find the length.
    #  1 - pointer subtraction. We have another variable, named intsArray END,
    # which is immediately after the last element in the array. Subtract the two
    # pointers (start and end of the array) to figure out the length.
    #  2 - null terminator. It’s very unusual to have a null-terminated array of
    # integers, but it happens occasionally
    #
    # Registers
    #   $s0     will store the number of elements to print.
    #   $s1     will store the address of the array

    la      $t0,            printInts                                                           # t0 = &printInts
    lw      $t0,            0($t0)                                                              # t0 = printInts
    beq     $t0,            $zero,                          printWords                          # if printInts == 0, jump to printWords (next task)

    la      $t0,            printInts_howToFindLen                                              # t0 = &printInts_howToFindLen
    lw      $t0,            0($t0)                                                              # t0 = printInts_howToFindLen

    addi    $t1,            $zero,                          2                                   # t1 = 2
    beq     $t0,            $t1,                            getCountNullTerminator
    beq     $t0,            $zero,                          getCountIntLengthsVariable          # if printInts_howToFindLen == 0, jump to printIntsLength


getCountPointerSubtraction:
    # Get the length of the array by subtracting the end of the array from the start of the array
    # ```c
    #             count = intsArray_END - intsArray;
    # ```

    la      $s1,            intsArray                                                           # s1 = &intsArray
    la      $t3,            intsArray_END                                                       # t3 = &intsArray_END
    sub     $t4,            $t3,                            $s1                                 # array length = $t4 = intsArray_END - intsArray
    sra     $s0,            $t4,                            2                                   # divide by 4 by shifting right 2 bits, store in s0

    j       printCount                                                                          # jump to printCount


getCountIntLengthsVariable:
    # Get the length of the array from the intsArray_len variable
    # ```c
    #         if (printInts_howToFindLen == 0)
    #             count = intsArray_len;
    # ```

    la      $t4,            intsArray_len                                                       # t4 = &intsArray_len
    lw      $s0,            0($t4)                                                              # s0 = intsArray_len

    j       printCount                                                                          # jump to printCount

getCountNullTerminator:
    # If printInts_howToFindLen == 2, we will print until we reach a null terminator
    # ```c
    #         while (*cur != 0)
    #         {
    #             printf("%d\n", *cur);
    #             cur++;
    #         }
    # ```

    add     $t3,            $zero,                          $s1                                 # t3 = s1 = &intsArray

    # Print an unknown number of elements. Will stop at a zero element.
    la      $a0,            printIntsUnknownNumElements                                         # a0 = &printIntsUnknownNumElements
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

whileLoop:
    # Iterate through the array and print each element until we reach a zero element
    lw      $t4,            0($t3)                                                              # t4 = intsArray[i]
    beq     $t4,            $zero,                          printCount                          # if t4 == 0, jump to printCount
    move    $a0,            $t4                                                                 # a0 = t4
    addi    $v0,            $zero,                          1                                   # set syscall to print integer
    syscall                                                                                     # print the integer
    addi    $t3,            $t3,                            4                                   # increment t3 by 4

    # Print a newline
    la      $a0,            newLine                                                             # a0 = &newLine
    lw      $a0,            0($a0)                                                              # a0 = newLine
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

    j       whileLoop                                                                           # jump to start of loop

    j       printWords                                                                          # jump to printWords (next task)


printCount:
    # Print `count` elements
    # ```c
    #         printf("printInts: About to print %d elements.\n", count);
    #         for (int i = 0; i < count; i++)
    #             printf("%d\n", intsArray[i]);
    # ```

    # Print messaged indicating the number of elements to be printed
    la      $a0,            printPrefix                                                         # a0 = &printPrefix
    lw      $a0,            0($a0)                                                              # a0 = printPrefix
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall

    add     $a0,            $s0,                            $zero                               # a0 = s0 = count
    addi    $v0,            $zero,                          1                                   # set syscall to print integer
    syscall                                                                                     # print the integer

    la      $a0,            printKnownSuffix                                                    # a0 = &printKnownSuffix
    lw      $a0,            0($a0)                                                              # a0 = printKnownSuffix
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

forLoop:
    # Iterate through the array and print each element
    addi    $t0,            $zero,                          0                                   # t0 = 0, Set the index to 0

    slt     $t6,            $t0,                            $s0                                 # t1 = 1 if index < count else 0
    beq     $t6,            $zero,                          printWords                          # if t6 == 0, we are at the end of the array, jump to printWords (next task)

    add     $t1,            $s1,                            $t0                                 # t1 = s1 + t0 = &intsArray[i]
    lw      $a0,            0($t1)                                                              # a0 = intsArray[i]
    addi    $v0,            $zero,                          1                                   # set syscall to print integer
    syscall                                                                                     # print the integer

    # Print a newline
    la      $a0,            newLine                                                             # a0 = &newLine
    lw      $a0,            0($a0)                                                              # a0 = newLine
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

    # ----------------------------- Task: Print Words -----------------------------

printWords:
    # ```c
    # if (printWords != 0)
    # {
    #     char *start = theString;
    #     char *cur = start;
    #     int count = 1;
    #     while (*cur != '\0') // null terminator. ASCII value is 0x00
    #     {
    #         if (*cur == ' ')
    #         {
    #             *cur = '\0';
    #             count++;
    #         }
    #         cur++;
    #     }
    #     printf("printWords: There were %d words.\n", count);
    #     while (cur >= start)
    #     {
    #         if (cur == start || cur[-1] == '\0')
    #             printf("%s\n", cur);
    #         cur--;
    #     }
    # }
    # ```
    #
    # REGISTERS
    #   $s3    will store the address of the string
    #   $s4    will store the space string
    #   $s5    will store the null terminator string
    #   $s6   will store the number of words

    la      $t0,            printWords                                                          # t0 = &printWords
    lw      $t0,            0($t0)                                                              # t0 = printWords
    beq     $t0,            $zero,                          bubbleSort                          # if printWords == 0, jump to bubbleSort (next task)

    la      $s3,            theString                                                           # t0 = &theString

    la      $t0,            space                                                               # t0 = &space
    lw      $s4,            0($t0)                                                              # s4 = space

    la      $t0,            nullTerminator                                                      # t0 = &nullTerminator
    lw      $s5,            0($t0)                                                              # s5 = nullTerminator

    add     $t1,            $s3,                            $zero                               # t1 = t0 = &theString
    add     $s6,            $zero,                          1                                   # s6 = 1

whileLoopWords:
    # Iterate through the string and count the number of words



    lb      $t2,            0($t1)                                                              # t2 = theString[i]
    beq     $t2,            $s5,                            printWordsCount                     # if t2 == null terminator, jump to printWordsCount
    beq     $t2,            $s4,                            isSpace                             # if t2 == space, jump to isSpace
    j       isSpaceAfter                                                                        # jump to isSpaceAfter

isSpace:
    # Increment the count of words
    addi    $s6,            $s6,                            1                                   # increment s6 by 1

    # Change the space to a null terminator
    sb      $s5,            0($t1)                                                              # theString[i] = null terminator

isSpaceAfter:
    j       whileLoopWords                                                                      # jump to start of loop

printWordsCount:

    # Print the message indicating the number of words
    la      $a0,            printWordsPrefix                                                    # a0 = &printWordsPrefix
    lw      $a0,            0($a0)                                                              # a0 = printWordsPrefix
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

    add     $a0,            $s6,                            $zero                               # a0 = s6 = count
    addi    $v0,            $zero,                          1                                   # set syscall to print integer
    syscall                                                                                     # print the integer

    la      $a0,            printWordsSuffix                                                    # a0 = &printWordsSuffix
    lw      $a0,            0($a0)                                                              # a0 = printWordsSuffix
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

loopBackwards:
    # Iterate through the string using the same (already incremeneted) index backwards and print each word
    # ```c
    #     while (cur >= start)
    #     {
    #         if (cur == start || cur[-1] == '\0')
    #             printf("%s\n", cur);
    #         cur--;
    #     }
    # ```

    slt     $t6,            $t1,                            $s3                                 # t6 = 1 if t1 >= s3 else 0
    bne     $t6,            $zero,                          bubbleSort                          # if t6 != 0 (equals 1), then the index is less than the start of the string so break

    lb      $t2,            0($t1)                                                              # t2 = theString[i]
    # print the word
    add     $a0,            $t1,                            $zero                               # a0 = t1 = &theString[i]
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

    j       loopBackwards                                                                       # jump to start of loop

    # ----------------------------- Task: Bubble Sort -----------------------------

bubbleSort:
    # ```c
    # if (bubbleSort != 0)
    # {
    #     for (int i = 0; i < intsArray_len; i++)
    #         for (int j = 0; j < intsArray_len - 1; j++)
    #             if (intsArray[j] > intsArray[j + 1])
    #             {
    #                 printf("Swap at: %d\n", j);
    #                 int tmp = intsArray[j];
    #                 intsArray[j] = intsArray[j + 1];
    #                 intsArray[j + 1] = tmp;
    #             }
    # }
    # ```
    #
    #  Bubble Sort is notoriously slow, but it’s the easiest sort to implement.
    #   In this code, we’ll use the same intsArray as in the printInts task - but
    #   in this case, you don’t need to worry about the various modes. If I ask you to
    #   do Bubble Sort, then your Bubble Sort code should always use intsArray len
    #   to find the length.
    #   Implement the following C code: Make sure that you actually modify
    #   the integers in memory, or this won’t work!
    #
    # REGISTERS
    #  $s0  the outer loop index
    #  $s1  the inner loop index
    #  $s3 the address of the array
    #  $s4 the length of the array
    #  $s5 the length of the array - 1

    la      $t0,            bubbleSort                                                          # t0 = &bubbleSort
    lw      $t0,            0($t0)                                                              # t0 = bubbleSort
    beq     $t0,            $zero,                          epilogue                            # if bubbleSort == 0, jump to epilogue

    la      $s3,            intsArray                                                           # s3 = &intsArray

    la      $s4,            intsArray_len                                                       # s4 = &intsArray_len
    lw      $s4,            0($s4)                                                              # s4 = intsArray_len
    subi    $s5,            $s4,                            1                                   # s5 = s4 - 1

    # Initialize both indices to 0
    addi    $s0,            $zero,                          0                                   # s0 = 0
    addi    $s1,            $zero,                          0                                   # s1 = 0

outerLoop:
    # Iterate through the array and swap elements if the current element is greater than the next element
    slt     $t6,            $s0,                            $s4                                 # t6 = 1 if s0 < s4 else 0
    beq     $t6,            $zero,                          epilogue                            # if t6 == 0 => s0 >= s4, end of outer loop, jump to epilogue

innerLoop:

    slt     $t6,            $s1,                            $s5                                 # t6 = 1 if s1 < s4 else 0
    beq     $t6,            $zero,                          incrementOuterLoop                  # if t6 == 0 => s1 >= s4, end of inner loop, jump to incrementOuterLoop

    add     $t1,            $s3,                            $s1                                 # t1 = s3 + s1 = &intsArray[j]
    lw      $t2,            0($t1)                                                              # t2 = intsArray[j]

    addi    $t3,            $t1,                            4                                   # t3 = t1 + 4 = &intsArray[j + 1]
    lw      $t4,            0($t3)                                                              # t4 = intsArray[j + 1]

    slt     $t6,            $t2,                            $t4                                 # t6 = 1 if t2 < t4 else 0
    beq     $t6,            $zero,                          incrementInnerLoop                  # if t6 == 0 => t2 >= t4, jump to incrementInnerLoop

swap:
    # Swap the elements
    sw      $t2,            0($t3)                                                              # intsArray[j + 1] = t2
    sw      $t4,            0($t1)                                                              # intsArray[j] = t4

    # Print the swap message
    la      $a0,            swapMessagePrefix                                                   # a0 = &swapMessagePrefix
    lw      $a0,            0($a0)                                                              # a0 = swapMessagePrefix
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

    la      $a0,            $s1                                                                 # a0 = s1
    addi    $v0,            $zero,                          1                                   # set syscall to print integer
    syscall                                                                                     # print the integer

    # Print a newline
    la      $a0,            newLine                                                             # a0 = &newLine
    lw      $a0,            0($a0)                                                              # a0 = newLine
    addi    $v0,            $zero,                          4                                   # set syscall to print string

incrementInnerLoop:
    addi    $s1,            $s1,                            4                                   # increment s1 by 4
    j       innerLoop                                                                           # jump to start of loop

incrementOuterLoop:
    addi    $s0,            $s0,                            4                                   # increment s0 by 4
    j       outerLoop                                                                           # jump to start of loop


    # ------------------------------- Epilogue -------------------------------

epilogue:
    # print final newline to match test expectations
    la      $a0,            newLine                                                             # a0 = &newLine
    addi    $v0,            $zero,                          4                                   # set syscall to print string
    syscall                                                                                     # print the string

    lw      $ra,            4($sp)                                                              # get return address from stack
    lw      $fp,            0($sp)                                                              # restore the frame pointer of caller
    addiu   $sp,            $sp,                            24                                  # restore the stack pointer of caller
    jr      $ra                                                                                 # return to code of caller



