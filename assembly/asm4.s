    # AUTHOR:       Christian Byrne
    # FILE:         asm4.s
    # COURSE:       CSc 252
    # PROGRAM DESC: Assembly language program that contains functions to search for
    #               a duplicate value in an array, check if a string starts with a
    #               given substring, search for a sequence of 5 characters in a
    #               string, determine the current election state based on global
    #               vote counts, and add votes to the global vote counts and print
    #               a message if the leader changes or if there is a tie.


.data
tieStr:         .asciiz "TIED!!!"
purpleStr:      .asciiz "Purple pulls ahead!"
yellowStr:      .asciiz "Yellow pulls ahead!"
countStr1:      .asciiz "  purple:"
countStr2:      .asciiz "   yellow:"

                .globl  purpleCount
                .globl  yellowCount
                .globl  arrayDupSearchInts
                .globl  stringSearch5
                .globl  addVotes

purpleCount:    .word   0
yellowCount:    .word   0

.text


    # -------------------------------------------------------------------------- #
    #                       Task 1: Array Duplicate Search                       #
    # -------------------------------------------------------------------------- #

arrayDupSearchInts:
    # Search through an array of integers for a consecutive duplicate value.
    #
    # Args:
    #   arg1: base address of the array
    #   arg2: length of the array
    #   arg3: target value to search for
    #
    # Returns:
    #   int: index of the first match if found, else -1
    #
    # ```c
    # int arrayDupSearchInts(const int *array, int arrayLength, int targetValue)
    # {
    #   int currentIndex = 0;
    #   int adjustedLength = arrayLength - 1;
    #   while (currentIndex < adjustedLength)
    #   {
    #     int currentInt = array[currentIndex];
    #     int nextInt = array[currentIndex + 1];
    #     if (currentInt == targetValue)
    #     {
    #       if (nextInt == targetValue)
    #       {
    #         return currentIndex; // Return index of first match
    #       }
    #     }
    #     currentIndex++;
    #   }
    #   return -1;
    # }
    # ```

    # Prologue
    addiu   $sp,                $sp,            -24         # allocate space for saved regs and array
    sw      $ra,                0($sp)                      # save ra
    sw      $fp,                4($sp)                      # save fp
    addi    $fp,                $fp,            20          # set fp

    # Save $sX registers being used
    addiu   $sp,                $sp,            -20         # allocate space for saved regs
    sw      $s1,                0($sp)                      # save s1
    sw      $s2,                4($sp)                      # save s2
    sw      $s3,                8($sp)                      # save s3
    sw      $s4,                12($sp)                     # save s4
    sw      $s5,                16($sp)                     # save s5

    # Initialize variables being used
    add     $s1,                $zero,          $a0         # s1 = base address of array to search
    sll     $s2,                $a1,            2           # s2 = length of array (in bytes)
    addi    $s2,                $s2,            -4          # s2 = length of array - 1
    add     $s3,                $zero,          $a2         # s3 = the value to search for
    add     $t0,                $zero,          $zero       # t0 = current index

    # Check edge cases
    addi    $t8,                $zero,          2           # t8 = 2
    slt     $t9,                $s2,            $t8         # t9 = length arg < 2 ? 1 : 0
    addi    $t8,                $zero,          1           # t8 = 1
    beq     $t9,                $t8,            RetFail     # if length < 2, return -1

MatchLoop:
    beq     $t0,                $s2,            RetFail     # break condition: index = array len - 1

    # Load the next two ints
    add     $t3,                $s1,            $t0         # t3 = base address of array + index * 4
    lw      $t4,                0($t3)                      # t4 = current int
    lw      $t5,                4($t3)                      # t5 = next int

    beq     $t4,                $s3,            Match1      # if current int = target int, jump to Match1
    j       ArrLoopEnd                                      # jump to end of loop

Match1:
    beq     $t5,                $s3,            RetSuccess  # if next int = target int, return index

ArrLoopEnd:
    addi    $t0,                $t0,            4           # increment index by 4 (1 word)
    j       MatchLoop                                       # jump to end of loop

RetFail:
    addi    $v0,                $zero,          -1          # return -1 (false)
    j       EndArrDup                                       # jump to end of function

RetSuccess:
    sra     $v0,                $t0,            2           # return index of first match
    j       EndArrDup                                       # jump to end of function

EndArrDup:
    # Restore $sX registers that were saved/used
    lw      $s1,                0($sp)                      # restore s1
    lw      $s2,                4($sp)                      # restore s2
    lw      $s3,                8($sp)                      # restore s3
    lw      $s4,                12($sp)                     # restore s4
    lw      $s5,                16($sp)                     # restore s5
    addiu   $sp,                $sp,            20          # deallocate space for saved regs

    # Epilogue
    lw      $ra,                0($sp)                      # restore ra
    lw      $fp,                4($sp)                      # restore fp
    addiu   $sp,                $sp,            24          # deallocate space for saved regs and array
    jr      $ra

    # -------------------------------------------------------------------------- #
    #                         Task 2: Substring Search 5                         #
    # -------------------------------------------------------------------------- #

stringSearch5:
    # Search through a string for a sequence of 5 characters (in order).
    #
    # Args:
    #   arg1: base address of the string
    #   arg2-6: characters 1-5 of the sequence
    #
    # Returns:
    #   int: index of the first character in the sequence if found, else -1
    #
    # ```c
    # int stringSearch5(const char *wordArray, char char1, char char2, char char3, char char4, char char5)
    # {
    #     const char *current = wordArray;
    #     int index = 0;
    #     while (*current != '\0')
    #     {
    #         if (current[0] == char1 &&
    #             current[1] == char2 &&
    #             current[2] == char3 &&
    #             current[3] == char4 &&
    #             current[4] == char5)
    #         {
    #             return index; // Match found, return index
    #         }
    #         current++;
    #         index++;
    #     }
    #     return -1;
    # }
    # ```

    # Load the extra args (arg4, arg5, and arg6) into temp registers
    lw      $t1,                -8($sp)                     # t1 = arg4
    lw      $t2,                -4($sp)                     # t2 = arg5

    # Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Save $sX registers being used
    addiu   $sp,                $sp,            -24         # allocate space for saved regs and array
    sw      $s0,                0($sp)                      # save s0
    sw      $s1,                4($sp)                      # save s1
    sw      $s2,                8($sp)                      # save s2
    sw      $s3,                12($sp)                     # save s3
    sw      $s4,                16($sp)                     # save s4
    sw      $s5,                20($sp)                     # save s5

    # Initialize variables
    add     $s0,                $zero,          $a0         # s0 = the base address of the word array
    add     $s1,                $a1,            $zero       # s1 = char1
    add     $s2,                $a2,            $zero       # s2 = char2
    add     $s3,                $a3,            $zero       # s3 = char3
    add     $s4,                $t1,            $zero       # s4 = char4
    add     $s5,                $t2,            $zero       # s5 = char5
    add     $t0,                $zero,          $zero       # t0 = current index

SearchLoop:
    lb      $t1,                0($s0)                      # t1 = current byte of string
    beq     $t1,                $zero,          ReturnFalse # If current byte is null terminator, end function
    j       NestedWhileL                                    # jump to NestedWhileL

ReturnFalse:
    addi    $v0,                $zero,          -1          # return -1 (false)
    j       EndStrSearch                                    # jump to end of function

ReturnTrue:
    add     $v0,                $t0,            $zero       # return address of first character in matched sequence
    j       EndStrSearch                                    # jump to end of function

NestedWhileL:
    lb      $t2,                0($s0)                      # load current byte of string
    bne     $t2,                $s1,            SearchClose # if current byte != char1, jump to SearchClose
    lb      $t2,                1($s0)                      # load next byte of string
    bne     $t2,                $s2,            SearchClose # if next byte != char2, jump to SearchClose
    lb      $t2,                2($s0)                      # load next byte of string
    bne     $t2,                $s3,            SearchClose # if next byte != char3, jump to SearchClose
    lb      $t2,                3($s0)                      # load next byte of string
    bne     $t2,                $s4,            SearchClose # if next byte != char4, jump to SearchClose
    lb      $t2,                4($s0)                      # load next byte of string
    bne     $t2,                $s5,            SearchClose # if next byte != char5, jump to SearchClose
    j       ReturnTrue                                      # if all 5 bytes match, return true

SearchClose:
    addi    $s0,                $s0,            1           # increment current addres
    addi    $t0,                $t0,            1           # increment current index
    j       SearchLoop                                      # jump back to top of loop

EndStrSearch:
    # Restore $sX registers that were saved/used
    lw      $s0,                0($sp)                      # restore s0
    lw      $s1,                4($sp)                      # restore s1
    lw      $s2,                8($sp)                      # restore s2
    lw      $s3,                12($sp)                     # restore s3
    lw      $s4,                16($sp)                     # restore s4
    lw      $s5,                20($sp)                     # restore s5
    addiu   $sp,                $sp,            24          # deallocate space for saved regs

    # Epilogue
    lw      $ra,                0($sp)                      # restore ra
    lw      $fp,                4($sp)                      # restore fp
    addiu   $sp,                $sp,            24          # deallocate space for saved regs and array
    jr      $ra

    # -------------------------------------------------------------------------- #
    #                          Task 3: Head to the Polls                         #
    # -------------------------------------------------------------------------- #

getElectionState:
    # Helper function to determine the current election state based on the global
    # vote counts.
    #
    # Args:
    #   None
    #
    # Returns:
    #   int: 0 if purpleCount > yellowCount,
    #        1 if yellowCount > purpleCount,
    #        2 if purpleCount == yellowCount
    #       -1 if both counts are 0
    #
    # ```c
    # int getElectionState()
    # {
    #   if (purpleCount == 0 && yellowCount == 0)
    #   {
    #     return -1;
    #   }
    #   if (purpleCount > yellowCount)
    #   {
    #     return 0;
    #   }
    #   else if (yellowCount > purpleCount)
    #   {
    #     return 1;
    #   }
    #   return 2;
    # }
    # ```

    # Standard Prologue
    addiu   $sp,                $sp,            -24         # allocate space for saved regs and array
    sw      $ra,                0($sp)                      # save ra
    sw      $fp,                4($sp)                      # save fp
    addi    $fp,                $fp,            20          # set fp

    # Initialize (global) variables
    la      $t0,                purpleCount                 # t0 = &purpleCount
    la      $t1,                yellowCount                 # t1 = &yellowCount
    lw      $t0,                0($t0)                      # t0 = purpleCount
    lw      $t1,                0($t1)                      # t1 = yellowCount

    # Determine state
    add     $t4,                $t0,            $t1         # t4 = purpleCount + yellowCount
    beq     $t4,                $zero,          ReturnFirst # if purpleCount == yellowCount == 0, return -1
    beq     $t0,                $t1,            ReturnTie   # if purpleCount == yellowCount, return 2
    slt     $t2,                $t0,            $t1         # t2 = purpleVotesAdd < yellowVotesAdd ? 1 : 0
    beq     $t2,                $zero,          ReturnPurp  # if purpleCount > yellowCount, return 0

    addi    $v0,                $zero,          1           # return 1 (yellow lead)
    j       EndGetState

ReturnFirst:
    addi    $v0,                $zero,          -1          # state = -1 (both counts are 0)
    j       EndGetState

ReturnTie:
    addi    $v0,                $zero,          2           # state = 2 (tie)
    j       EndGetState

ReturnPurp:
    add     $v0,                $zero,          $zero       # state = 0 (purple lead)
    j       EndGetState

EndGetState:
    # Epilogue
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
    jr      $ra


addVotes:
    # Add the new votes to the total votes for the purple and yellow parties'
    # global vote counts. If the new votes change the leader or if the result is
    # a tie, print a message indicating as much.
    #
    # Args:
    #   arg1: number of purple votes to add
    #   arg2: number of yellow votes to add
    #
    # ```c
    # extern int purpleCount;
    # extern int yellowCount;
    #
    # void addVotes(int purpleVotesAdd, int yellowVotesAdd)
    # {
    #   int preState = getElectionState();
    #   purpleCount += purpleVotesAdd;
    #   yellowCount += yellowVotesAdd;
    #   int postState = getElectionState();
    #   if (preState == -1)
    #     return;
    #   if (postState == 2)
    #     printf("TIED!!!\n");
    #   if (preState == 2)
    #     return;
    #   else if (postState != preState)
    #   {
    #     if (postState == 0)
    #     {
    #       printf("Purple pulls ahead!  purple: %d   yellow: %d\n", purpleCount, yellowCount);
    #     }
    #     else
    #     {
    #       prinf("Yellow pulls ahead!  purple: %d   yellow: %d\n", purpleCount, yellowCount);
    #     }
    #   }
    # }
    # ```

    # Standard Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Save $sX registers being used
    addiu   $sp,                $sp,            -16
    sw      $s0,                0($sp)
    sw      $s1,                4($sp)
    sw      $s2,                8($sp)
    sw      $s3,                12($sp)

    # Initialize variables
    add     $s0,                $zero,          $a0         # s0 = arg1 (purpleVotesAdd)
    add     $s1,                $zero,          $a1         # s1 = arg2 (yellowVotesAdd)
    add     $s2,                $zero,          $zero       # declare s2 = preState
    add     $s3,                $zero,          $zero       # declare s3 = postState

    # Set preState based on the current leader before adding votes
    jal     getElectionState                                # getElectionState()
    add     $s2,                $zero,          $v0         # s2 = preState

    # Load the running total of purple and yellow votes (global variables)
    la      $t0,                purpleCount                 # t0 = &purpleCount
    la      $t1,                yellowCount                 # t1 = &yellowCount
    lw      $t2,                0($t0)                      # t2 = purpleCount
    lw      $t3,                0($t1)                      # t3 = yellowCount

    # Add the new votes to the running totals
    # TODO: consider overflow
    add     $t4,                $t2,            $s0         # t3 = purpleCount + purpleVotesAdd
    add     $t5,                $t3,            $s1         # t4 = yellowCount + yellowVotesAdd

    # Store the updated vote counts back into the global variables
    sw      $t4,                0($t0)                      # *t0 = purpleCount + purpleVotesAdd (t4)
    sw      $t5,                0($t1)                      # *t1 = yellowCount + yellowVotesAdd (t5)

    # Set postState based on the current leader after adding votes
    jal     getElectionState                                # getElectionState()
    add     $s3,                $zero,          $v0         # s3 = postState

    # Determine if the leader has changed or if there is a tie
    addi    $t7,                $zero,          -1          # t7 = -1
    beq     $s2,                $t7,            EndAddVotes # if this was the first vote, don't print anything
    addi    $t6,                $zero,          2           # t6 = 2
    beq     $s3,                $t6,            printTie    # Tie after: print tie
    beq     $s2,                $t6,            EndAddVotes # Tie before and not tie after: print nothing
    beq     $s2,                $s3,            EndAddVotes # if no change in leader, jump to EndAddVotes
    beq     $s3,                $zero,          printPurple # if postState == 0, printPurple
    addi    $t6,                $zero,          1           # t6 = 1
    beq     $s3,                $t6,            printYellow # if postState == 1, printYellow

printTie:
    # Print "TIED!!!"
    la      $a0,                tieStr                      # a0 = &tieStr
    addi    $v0,                $zero,          4           # print string syscall code
    syscall                                                 # print string
    j       printNewline                                    # jump to printNewline

printPurple:
    # Print "Purple pulls ahead!"
    la      $a0,                purpleStr                   # a0 = &purpleStr
    addi    $v0,                $zero,          4           # print string syscall code
    syscall                                                 # print string
    j       printCounts                                     # jump to printCounts

printYellow:
    # Print "Yellow pulls ahead!"
    la      $a0,                yellowStr                   # a0 = &yellowStr
    addi    $v0,                $zero,          4           # v0 = 4 (print string syscall code)
    syscall                                                 # print string
    j       printCounts                                     # jump to printCounts

printCounts:
    # Print "  purple:"
    la      $a0,                countStr1                   # a0 = &countStr1
    addi    $v0,                $zero,          4           # v0 = 4 (print string syscall code)
    syscall                                                 # print string

    # Print purpleCount
    la      $t0,                purpleCount                 # t0 = &purpleCount
    lw      $a0,                0($t0)                      # a0 = purpleCount
    addi    $v0,                $zero,          1           # v0 = 1 (print int syscall code)
    syscall                                                 # print int

    # Print "   yellow:"
    la      $a0,                countStr2                   # a0 = &countStr2
    addi    $v0,                $zero,          4           # v0 = 4 (print string syscall code)
    syscall                                                 # print string

    # Print yellowCount
    la      $t1,                yellowCount                 # t1 = &yellowCount
    lw      $a0,                0($t1)                      # a0 = yellowCount
    addi    $v0,                $zero,          1           # v0 = 1 (print int syscall code)
    syscall                                                 # print int
    j       printNewline                                    # jump to printNewline

printNewline:
    addi    $a0,                $zero,          0xa         # a0 = 0xa (newline char)
    addi    $v0,                $zero,          11          # v0 = 11 (print char syscall code)
    syscall                                                 # print char
    j       EndAddVotes                                     # jump to EndAddVotes

EndAddVotes:
    # Restore $sX registers that were saved/used
    lw      $s0,                0($sp)                      # restore s0
    lw      $s1,                4($sp)                      # restore s1
    lw      $s2,                8($sp)                      # restore s2
    lw      $s3,                12($sp)                     # restore s3
    addiu   $sp,                $sp,            16          # deallocate space for saved regs

    # Epilogue
    lw      $ra,                0($sp)                      # restore ra
    lw      $fp,                4($sp)                      # restore fp
    addiu   $sp,                $sp,            24          # deallocate space for saved regs and array
    jr      $ra

