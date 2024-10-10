    # AUTHOR
    #   Christian Byrne
    #
    # PROGRAM DESCRIPTION:
    #   This program completes three different tasks:
    #   1. Printing a list of integers, either based on length or using
    #      a null terminator as a stopping point.
    #   2. Printing each word from a given string after replacing spaces
    #      with null terminators. The program counts the words as it processes
    #      them and prints the total word count at the end.
    #   3. Sorting an array of integers using the bubble sort algorithm.
    #      The program uses conditional checks to determine which task to
    #      perform. The program is written in MIPS assembly and is designed
    #      to run on the MARS MIPS simulator.


.data
newLine:            .asciiz "\n"
printPrefix:        .asciiz "printInts: About to print "
printUnknownSuffix: .asciiz "an unknown number of elements.  Will stop at a zero element.\n"
printKnownSuffix:   .asciiz " elements.\n"
printWordsPrefix:   .asciiz "printWords: There were "
printWordsSuffix:   .asciiz " words.\n"
swapMessagePrefix:  .asciiz "Swap at: "

space:              .byte   0x20                                        # ASCII value for ' '
nullTerminator:     .byte   0x00                                        # Null terminator character '\0'


.text
                    .globl  studentMain


studentMain:
    addiu   $sp,            $sp,                    -24                 # allocate stack space (24 bytes)
    sw      $fp,            0($sp)                                      # save frame pointer of caller
    sw      $ra,            4($sp)                                      # save return address
    addiu   $fp,            $sp,                    20                  # setup frame pointer for the function


    # ----------------------------- Task: Print Ints ------------------------------

taskPrintInts:
    # Prints a list of integers based on the printInts flag and howToFindLen
    #
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

    la      $t0,            printInts                                   # load address of printInts flag
    lb      $t0,            0($t0)                                      # load printInts flag value
    beq     $t0,            $zero,                  taskPrintWords      # if printInts == 0, jump to taskPrintWords

    # Print the prefix message
    la      $a0,            printPrefix                                 # load address of printPrefix
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the string

    # Determine how to calculate the number of elements
    la      $s1,            intsArray                                   # load address of intsArray into $s1
    la      $t0,            printInts_howToFindLen                      # load address of howToFindLen
    lh      $t0,            0($t0)                                      # load value of printInts_howToFindLen

    addi    $t1,            $zero,                  2                   # t1 = 2
    beq     $t0,            $t1,                    ctNullTerminator    # if howToFindLen == 2, use null terminator method
    beq     $t0,            $zero,                  ctIntLengthsVar     # if howToFindLen == 0, use length variable

getCountPointerSubtraction:
    # Use pointer subtraction to get the length of the array
    la      $t3,            intsArray_END                               # load address of intsArray_END
    sub     $t4,            $t3,                    $s1                 # calculate length (intsArray_END - intsArray)
    sra     $s0,            $t4,                    2                   # divide by 4 to get number of elements (size of int is 4 bytes)

    j       printCount                                                  # jump to printCount

ctIntLengthsVar:
    # Use the length variable to get the count
    la      $t4,            intsArray_len                               # load address of intsArray_len
    lw      $s0,            0($t4)                                      # load the number of elements into $s0

    j       printCount                                                  # jump to printCount

ctNullTerminator:
    # Use a null terminator to get the count
    #
    # Iterate until a null terminator is found
    # ```c
    # while (*cur != 0)
    # {
    #     printf("%d\n", *cur);
    #     cur++;
    # }
    # ```
    add     $t3,            $zero,                  $s1                 # set $t3 to the address of intsArray

    # Print an unknown number of elements. Will stop at a zero element.
    la      $a0,            printUnknownSuffix                          # load address of printUnknownSuffix
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the string

whileLoop:
    # Iterate through the array and print each element until a zero element is reached
    lw      $t4,            0($t3)                                      # load intsArray[i]
    beq     $t4,            $zero,                  taskPrintWords      # if element is zero, jump to taskPrintWords
    add     $a0,            $t4,                    $zero               # set syscall argument to intsArray[i]

    addi    $v0,            $zero,                  1                   # set syscall to print integer
    syscall                                                             # print the integer
    addi    $t3,            $t3,                    4                   # increment address by 4 (next element)

    # Print a newline
    la      $a0,            newLine                                     # load address of newLine
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the newline

    j       whileLoop                                                   # repeat loop

printCount:
    # Print the known number of elements
    #
    # ```c
    # printf("printInts: About to print %d elements.\n", count);
    # for (int i = 0; i < count; i++)
    #     printf("%d\n", intsArray[i]);
    # ```
    add     $a0,            $s0,                    $zero               # set $a0 to the number of elements (count)
    addi    $v0,            $zero,                  1                   # set syscall to print integer
    syscall                                                             # print the integer

    la      $a0,            printKnownSuffix                            # load address of printKnownSuffix
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the suffix

    addi    $t0,            $zero,                  0                   # initialize index $t0 to 0

forLoop:
    # Print each element in the array
    slt     $t6,            $t0,                    $s0                 # check if index is less than count
    beq     $t6,            $zero,                  taskPrintWords      # if index >= count, jump to taskPrintWords

    sll     $t7,            $t0,                    2                   # calculate offset (t0 * 4)
    add     $t7,            $t7,                    $s1                 # get the address of the current element
    lw      $t8,            0($t7)                                      # load the element

    add     $a0,            $t8,                    $zero               # set syscall argument to the element
    addi    $v0,            $zero,                  1                   # set syscall to print integer
    syscall                                                             # print the integer

    # Print a newline
    la      $a0,            newLine                                     # load address of newLine
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the newline

    addi    $t0,            $t0,                    1                   # increment index
    j       forLoop                                                     # repeat loop


    # ----------------------------- Task: Print Words -----------------------------

taskPrintWords:
    # Prints each word from a string after replacing spaces with null terminators
    #
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
    la      $t0,            printWords                                  # load address of printWords flag
    lb      $t0,            0($t0)                                      # load printWords flag
    beq     $t0,            $zero,                  taskBubbleSort      # if taskPrintWords == 0, jump to bubbleSort

    la      $s3,            theString                                   # load address of the string

    # Load space and null terminator values
    la      $s4,            space                                       # load address of space
    lb      $s4,            0($s4)                                      # load space value
    la      $s5,            nullTerminator                              # load address of null terminator
    lb      $s5,            0($s5)                                      # load null terminator

    add     $t1,            $s3,                    $zero               # initialize pointer to start of the string
    addi    $s6,            $zero,                  1                   # initialize word count to 1

whileLoopWords:
    # Scan through the string and count words
    lb      $t2,            0($t1)                                      # load current character
    beq     $t2,            $s5,                    printWordsCount     # if null terminator, jump to printWordsCount
    beq     $t2,            $s4,                    isSpace             # if space, go to isSpace
    j       isSpaceAfter                                                # otherwise, continue scanning

isSpace:
    # Increment word count and replace space with null terminator
    addi    $s6,            $s6,                    1                   # increment word count
    sb      $s5,            0($t1)                                      # replace space with null terminator

isSpaceAfter:
    addi    $t1,            $t1,                    1                   # move to next character
    j       whileLoopWords                                              # repeat loop

printWordsCount:
    # Print the number of words
    la      $a0,            printWordsPrefix                            # load address of printWordsPrefix
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the prefix

    add     $a0,            $s6,                    $zero               # set syscall argument to the word count
    addi    $v0,            $zero,                  1                   # set syscall to print integer
    syscall                                                             # print the word count

    la      $a0,            printWordsSuffix                            # load address of printWordsSuffix
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the suffix

    addi    $t1,            $t1,                    -1                  # decrement pointer to last character

loopBackwards:
    # Scan backwards through the string and print each word
    slt     $t6,            $t1,                    $s3                 # check if pointer is past the start of the string
    bne     $t6,            $zero,                  taskBubbleSort      # if past the start, jump to bubbleSort

    # Check if at start or the previous character is a null terminator
    beq     $t1,            $s3,                    printWord           # if at the start, print word
    lb      $t7,            -1($t1)                                     # load previous character
    beq     $t7,            $zero,                  printWord           # if previous character is null terminator, print word

    addi    $t1,            $t1,                    -1                  # move to previous character
    j       loopBackwards                                               # repeat loop

printWord:
    # Print the word
    add     $a0,            $t1,                    $zero               # set syscall argument to the address of the word
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print the word

    # Print newline
    la      $a0,            newLine                                     # load address of newLine
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print newline

    addi    $t1,            $t1,                    -1                  # move to previous character
    j       loopBackwards                                               # repeat loop


    # ----------------------------- Task: Bubble Sort -----------------------------

taskBubbleSort:
    # Sorts an array of integers using the bubble sort algorithm
    #
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
    la      $t0,            bubbleSort                                  # load address of bubbleSort flag
    lb      $t0,            0($t0)                                      # load bubbleSort flag
    beq     $t0,            $zero,                  epilogue            # if bubbleSort == 0, jump to epilogue

    la      $s3,            intsArray                                   # load address of intsArray

    la      $s4,            intsArray_len                               # load address of intsArray_len
    lw      $s4,            0($s4)                                      # load the length of the array
    addi    $t9,            $zero,                  1                   # initialize $t9 to 1
    sub     $s5,            $s4,                    $t9                 # $s5 = array length - 1

    # Initialize outer and inner loop indices to 0
    addi    $s0,            $zero,                  0                   # $s0 = 0 (outer loop index)
    addi    $s1,            $zero,                  0                   # $s1 = 0 (inner loop index)

outerLoop:
    # Outer loop (iterate through array)
    slt     $t6,            $s0,                    $s4                 # check if $s0 < array length
    beq     $t6,            $zero,                  epilogue            # if outer loop index >= array length, jump to epilogue

innerLoop:
    # Inner loop (compare adjacent elements)
    slt     $t6,            $s1,                    $s5                 # check if inner loop index < array length - 1
    beq     $t6,            $zero,                  incrementOuterLoop  # if inner loop index >= array length - 1, go to outer loop increment

    # Get current element and next element
    sll     $t8,            $s1,                    2                   # calculate offset (s1 * 4)
    add     $t8,            $t8,                    $s3                 # get address of current element
    lw      $t3,            0($t8)                                      # load current element

    addi    $t9,            $t8,                    4                   # get address of next element
    lw      $t4,            0($t9)                                      # load next element

    # Compare current and next element
    slt     $t6,            $t4,                    $t3                 # set $t6 to 1 if next element < current element

    beq     $t6,            $zero,                  incrementInnerLoop  # if already in order, skip swap

swap:
    # Swap elements if out of order
    sw      $t4,            0($t8)                                      # store next element in place of current element
    sw      $t3,            0($t9)                                      # store current element in place of next element

    # Print swap message
    la      $a0,            swapMessagePrefix                           # load address of swapMessagePrefix
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print swap message

    add     $a0,            $s1,                    $zero               # set syscall argument to index
    addi    $v0,            $zero,                  1                   # set syscall to print integer
    syscall                                                             # print index

    # Print newline
    la      $a0,            newLine                                     # load address of newLine
    addi    $v0,            $zero,                  4                   # set syscall to print string
    syscall                                                             # print newline

incrementInnerLoop:
    addi    $s1,            $s1,                    1                   # increment inner loop index
    j       innerLoop                                                   # repeat inner loop

incrementOuterLoop:
    addi    $s0,            $s0,                    1                   # increment outer loop index
    addi    $s1,            $zero,                  0                   # reset inner loop index to 0
    j       outerLoop                                                   # repeat outer loop


    # ------------------------------- Epilogue -------------------------------

epilogue:
    lw      $ra,            4($sp)                                      # restore return address
    lw      $fp,            0($sp)                                      # restore frame pointer
    addiu   $sp,            $sp,                    24                  # restore stack pointer
    jr      $ra                                                         # return to caller

