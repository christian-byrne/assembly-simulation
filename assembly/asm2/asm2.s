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
    addiu   $sp,            $sp,                    -24                                         # allocate stack space -- default of 24 here
    sw      $fp,            0($sp)                                                              # save frame pointer of caller
    sw      $ra,            4($sp)                                                              # save return address
    addiu   $fp,            $sp,                    20                                          # setup frame pointer of main


    # ----------------------------- Task: Print Ints ------------------------------

taskPrintInts:
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
    lb      $t0,            0($t0)                                                              # t0 = tprintInts
    beq     $t0,            $zero,                  taskPrintWords                              # if printInts == 0, jump to taskPrintWords (next task)

    la      $t0,            printInts_howToFindLen                                              # t0 = &printInts_howToFindLen
    lh      $t0,            0($t0)                                                              # t0 = printInts_howToFindLen

    addi    $t1,            $zero,                  2                                           # t1 = 2
    beq     $t0,            $t1,                    getCountNullTerminator
    beq     $t0,            $zero,                  getCountIntLengthsVariable                  # if printInts_howToFindLen == 0, jump to taskPrintIntsLength


getCountPointerSubtraction:
    # Get the length of the array by subtracting the end of the array from the start of the array
    # ```c
    #             count = intsArray_END - intsArray;
    # ```

    la      $s1,            intsArray                                                           # s1 = &intsArray
    la      $t3,            intsArray_END                                                       # t3 = &intsArray_END
    sub     $t4,            $t3,                    $s1                                         # array length = $t4 = intsArray_END - intsArray
    sra     $s0,            $t4,                    2                                           # divide by 4 by shifting right 2 bits, store in s0

    j       printCount                                                                          # jump to printCount


getCountIntLengthsVariable:
    # Get the length of the array from the intsArray_len variable
    # ```c
    #         if (taskPrintInts_howToFindLen == 0)
    #             count = intsArray_len;
    # ```

    la      $t4,            intsArray_len                                                       # t4 = &intsArray_len
    lw      $s0,            0($t4)                                                              # s0 = intsArray_len

    j       printCount                                                                          # jump to printCount

getCountNullTerminator:
    # If taskPrintInts_howToFindLen == 2, we will print until we reach a null terminator
    # ```c
    #         while (*cur != 0)
    #         {
    #             printf("%d\n", *cur);
    #             cur++;
    #         }
    # ```

    add     $t3,            $zero,                  $s1                                         # t3 = s1 = &intsArray

    # Print an unknown number of elements. Will stop at a zero element.
    la      $a0,            printUnknownSuffix                                                  # a0 = &printUnknownSuffix
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

whileLoop:
    # Iterate through the array and print each element until we reach a zero element
    lw      $t4,            0($t3)                                                              # t4 = intsArray[i]
    beq     $t4,            $zero,                  printCount                                  # if t4 == 0, jump to printCount
    add    $a0,            $t4,                    $zero                                       # a0 = t4 = intsArray[i]

    addi    $v0,            $zero,                  1                                           # set syscall to print integer
    syscall                                                                                     # print the integer
    addi    $t3,            $t3,                    4                                           # increment t3 by 4

    # Print a newline
    la      $a0,            newLine                                                             # a0 = &newLine
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

    j       whileLoop                                                                           # jump to start of loop

    j       taskPrintWords                                                                      # jump to taskPrintWords (next task)


printCount:
    # Print `count` elements
    # ```c
    #         printf("taskPrintInts: About to print %d elements.\n", count);
    #         for (int i = 0; i < count; i++)
    #             printf("%d\n", intsArray[i]);
    # ```

    # Print messaged indicating the number of elements to be printed
    la      $a0,            printPrefix                                                         # a0 = &printPrefix
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall

    add     $a0,            $s0,                    $zero                                       # a0 = s0 = count
    addi    $v0,            $zero,                  1                                           # set syscall to print integer
    syscall                                                                                     # print the integer

    la      $a0,            printKnownSuffix                                                    # a0 = &printKnownSuffix
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

forLoop:
    # Iterate through the array and print each element
    addi    $t0,            $zero,                  0                                           # t0 = 0, Set the index to 0

    slt     $t6,            $t0,                    $s0                                         # t1 = 1 if index < count else 0
    beq     $t6,            $zero,                  taskPrintWords                              # if t6 == 0, we are at the end of the array, jump to taskPrintWords (next task)

    add     $t1,            $s1,                    $t0                                         # t1 = s1 + t0 = &intsArray[i]
    add     $a0,            $t1,                    $zero                                       # a0 = t1 = &intsArray[i]
    addi    $v0,            $zero,                  1                                           # set syscall to print integer
    syscall                                                                                     # print the integer

    # Print a newline
    la      $a0,            newLine                                                             # a0 = &newLine
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

    # ----------------------------- Task: Print Words -----------------------------

taskPrintWords:
    # ```c
    # if (taskPrintWords != 0)
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
    #     printf("taskPrintWords: There were %d words.\n", count);
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

    la      $t0,            printWords                                                          # t0 = &taskPrintWords
    lb      $t0,            0($t0)                                                              # t0 = taskPrintWords
    beq     $t0,            $zero,                  taskBubbleSort                              # if taskPrintWords == 0, jump to bubbleSort (next task)


    # Initialize the required strings and variables
    la      $s3,            theString                                                           # t0 = &theString
    la      $s4,            space                                                               # t0 = &space
    la      $s5,            nullTerminator                                                      # t0 = &nullTerminator

    add     $t1,            $s3,                    $zero                                       # t1 = t0 = &theString
    addi    $s6,            $zero,                  1                                           # s6 = 1

whileLoopWords:
    # Iterate through the string and count the number of words
    lw      $t2,            0($t1)                                                              # t2 = theString[i]
    beq     $t2,            $s5,                    taskPrintWordsCount                         # if t2 == null terminator, jump to taskPrintWordsCount
    beq     $t2,            $s4,                    isSpace                                     # if t2 == space, jump to isSpace
    j       isSpaceAfter                                                                        # jump to isSpaceAfter

isSpace:
    # Increment the count of words
    addi    $s6,            $s6,                    1                                           # increment s6 by 1

    # Change the space to a null terminator
    sw      $s5,            0($t1)                                                              # theString[i] = null terminator

isSpaceAfter:
    addi    $t1,            $t1,                    4                                           # increment t1 by 4
    j       whileLoopWords                                                                      # jump to start of loop

taskPrintWordsCount:
    # Print the message indicating the number of words
    la      $a0,            printWordsPrefix                                                    # a0 = &printWordsPrefix
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

    add     $a0,            $s6,                    $zero                                       # a0 = s6 = count
    addi    $v0,            $zero,                  1                                           # set syscall to print integer
    syscall                                                                                     # print the integer

    la      $a0,            printWordsSuffix                                                    # a0 = &printWordsSuffix
    addi    $v0,            $zero,                  4                                           # set syscall to print string
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

    slt     $t6,            $t1,                    $s3                                         # t6 = 1 if t1 >= s3 else 0
    bne     $t6,            $zero,                  taskBubbleSort                              # if t6 != 0 (equals 1), then the index is less than the start of the string so break

    lb      $t2,            0($t1)                                                              # t2 = theString[i]
    # print the word
    add     $a0,            $t1,                    $zero                                       # a0 = t1 = &theString[i]
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

    j       loopBackwards                                                                       # jump to start of loop

    # ----------------------------- Task: Bubble Sort -----------------------------

taskBubbleSort:
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
    #   In this code, we’ll use the same intsArray as in the taskPrintInts task - but
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
    lb      $t0,            0($t0)                                                              # t0 = bubbleSort
    beq     $t0,            $zero,                  epilogue                                    # if bubbleSort == 0, jump to epilogue

    la      $s3,            intsArray                                                           # s3 = &intsArray

    la      $s4,            intsArray_len                                                       # s4 = &intsArray_len
    lw      $s4,            0($s4)                                                              # s4 = intsArray_len
    addi    $t9,            $zero,                  1
    sub     $s5,            $s4,                    $t9                                         # s5 = s4 - 1

    # Initialize both indices to 0
    addi    $s0,            $zero,                  0                                           # s0 = 0
    addi    $s1,            $zero,                  0                                           # s1 = 0

outerLoop:
    # Iterate through the array and swap elements if the current element is greater than the next element
    slt     $t6,            $s0,                    $s4                                         # t6 = 1 if s0 < s4 else 0
    beq     $t6,            $zero,                  epilogue                                    # if t6 == 0 => s0 >= s4, end of outer loop, jump to epilogue

innerLoop:

    slt     $t6,            $s1,                    $s5                                         # t6 = 1 if s1 < s4 else 0
    beq     $t6,            $zero,                  incrementOuterLoop                          # if t6 == 0 => s1 >= s4, end of inner loop, jump to incrementOuterLoop

    # Get the current element
    sll     $t8,            $s1,                    2                                           # t8 = s1 * 4
    add     $t8,            $t8,                    $s3                                         # t8 = s3 + s1 = &intsArray[j] (base address + offset)
    lw      $t3,            0($t8)                                                              # t8 = intsArray[j]

    # Get the immediate next element
    addi    $t9,            $t8,                    4                                           # t9 = s1 + 4 = j + 1
    lw      $t4,            0($t9)                                                              # t9 = intsArray[j + 1]

    # Compare the current element to the next element
    slt     $t6,            $t4,                    $t3                                         # t6 = 1 if t8 < t9 else 0

    beq     $t6,            $zero,                  incrementInnerLoop                          # if t6 == 0, jump to incrementInnerLoop (already in order)

swap:
    # If the current element is greater than the next element, swap the elements
    sw      $t4,            0($t8)                                                              # intsArray[j] = intsArray[j + 1]
    sw      $t3,            0($t9)                                                              # intsArray[j + 1] = intsArray[j]

    # Print the swap message
    la      $a0,            swapMessagePrefix                                                   # a0 = &swapMessagePrefix
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall                                                                                     # print the string

    add     $a0,            $s1,                    $zero                                       # a0 = s1 = j
    addi    $v0,            $zero,                  1                                           # set syscall to print integer
    syscall                                                                                     # print the integer

    # Print a newline
    la      $a0,            newLine                                                             # a0 = &newLine
    addi    $v0,            $zero,                  4                                           # set syscall to print string
    syscall

incrementInnerLoop:
    addi    $s1,            $s1,                    1                                           # increment s1 by 1
    j       innerLoop                                                                           # jump to start of loop

incrementOuterLoop:
    addi    $s0,            $s0,                    1                                           # increment s0 by 1
    addi    $s1,            $zero,                  0                                           # reset s1 to 0
    j       outerLoop                                                                           # jump to start of loop


    # ------------------------------- Epilogue -------------------------------

epilogue:
    # print final newline to match test expectations
    # la      $a0,            newLine                                                             # a0 = &newLine
    # addi    $v0,            $zero,                  4                                           # set syscall to print string
    # syscall                                                                                     # print the string

    lw      $ra,            4($sp)                                                              # get return address from stack
    lw      $fp,            0($sp)                                                              # restore the frame pointer of caller
    addiu   $sp,            $sp,                    24                                          # restore the stack pointer of caller
    jr      $ra                                                                                 # return to code of caller



