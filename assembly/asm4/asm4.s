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
purpleCount:    .word   0
yellowCount:    .word   0

.text

    # -------------------------------------------------------------------------- #
    #                       Task 1: Array Duplicate Search                       #
    # -------------------------------------------------------------------------- #

arrayDuplicateSearch:
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
    # int arrayDuplicateSearch(int *array, int length, int target)
    # {
    #   int lastMatchIndex = -1;
    #
    #   for (int i = 0; i < length; i++)
    #   {
    #     if (array[i] == target)
    #     {
    #       if (lastMatchIndex != -1) // two consecutive matches
    #       {
    #         return lastMatchIndex; // return index of first match
    #       }
    #       else
    #       {
    #         lastMatchIndex = i; // only one consecutive match
    #       }
    #     }
    #     else
    #     {
    #       lastMatchIndex = -1; // no match, reset lastMatchIndex
    #     }
    #   }
    #   return -1; // no matches found
    # }
    # ```

    # Standard Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Save $sX registers being used
    addiu   $sp,                $sp,            -16
    sw      $s1,                0($sp)
    sw      $s2,                4($sp)
    sw      $s3,                8($sp)
    sw      $s4,                12($sp)
    sw      $s5,                16($sp)

    # Initialize variables being used
    add     $s1,                $zero,          $a0         # s1 = base address of array to search
    add     $s3,                $zero,          $a2         # s3 = the value to search for
    add     $t0,                $zero,          $zero       # t0 = current index
    add     $t1,                $zero,          $zero       # t1 = last (immediate) found
    addiu   $t2,                $zero,          -1          # t2 = -1

    # Scale the length of the array by 4 so it represents length in bytes
    sll     $s2,                $a1,            2           # s2 = length of array (in bytes)

SearchLoop:
    # Get full address that index is pointing to
    add     $t3,                $s1,            $t0         # t3 = base address of array + index * 4
    lw      $t4,                0($t3)                      # t4 = current int

    beq     $t0,                $s2,            EndArrDup   # break condition: index = length of array
    beq     $t4,                $s3,            Match       # if current int == int to search for, jump to Match
    addiu   $t2,                $zero,          -1          # if there's no match this iteration, set last found register back to -1
    j       SearchLoopClose                                 # jump to end of loop

Match:
    bne     $t1,                $t2,            EndArrDup   # Check if two consecutive matches

    # If not two matches in a row, set t1 to point to this match, then proceed
    srl     $t5,                $t0,            2           # t5 = index of current int (converted to word-index)
    addi    $t9,                $t5,            4           # t9 = index + 1 (in instructions)
    beq     $t9,                $s2,            MatchClose  # if index + 1 == length of array, don't set match index
    add     $t1,                $zero,          $t5         # last match index (t1) = index of current int

MatchClose:
    j       SearchLoopClose                                 # jump to end of loop

SearchLoopClose:
    addiu   $t0,                $t0,            4           # iterate the index/pointer by 4 because it is a word array
    j       SearchLoop                                      # jump back to top of loop

EndArrDup:
    add     $v0,                $zero,          $t1         # add last match index to return register

    # Restore $sX registers that were saved/used
    sw      $s1,                0($sp)
    sw      $s2,                4($sp)
    sw      $s3,                8($sp)
    sw      $s4,                12($sp)
    sw      $s5,                16($sp)
    addiu   $sp,                $sp,            16

    # Standard EpilogueArrayDuplicateSearch
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
    jr      $ra

    # -------------------------------------------------------------------------- #
    #                         Task 2: Substring Search 5                         #
    # -------------------------------------------------------------------------- #

stringStartsWith:
    # Helper function to check if a string starts with a given substring.
    #
    # Args:
    #   arg1: base address of the string
    #   arg2: base address of the substring
    #
    # Returns:
    #   int: 1 if the string starts with the substring, else 0
    #
    # ```c
    # int stringStartsWith(char *string, char *prefix)
    # {
    #   int i = 0;
    #   while (string[i] != '\0' && prefix[i] != '\0')
    #   {
    #     if (string[i] != prefix[i])
    #     {
    #       return 0;
    #     }
    #     i++;
    #   }
    #   if (prefix[i] == '\0')
    #   {
    #     return 1;
    #   }
    #   return 0;
    # }
    # ```

    # Standard Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Initialize variables
    add     $t0,                $zero,          $zero       # t0 = index
    add     $t1,                $zero,          $a0         # s1 = base address of string
    add     $t2,                $zero,          $a1         # s2 = base address of substring

StartsWithLoop:
    add     $t3,                $t1,            $t0         # t3 = base address of string + index
    add     $t4,                $t2,            $t0         # t4 = base address of substring + index
    lb      $t5,                0($t3)                      # t5 = current byte of string
    lb      $t6,                0($t4)                      # t6 = current byte of substring
    # add     $t7,                $t5,        $t6             # t7 = sum of current bytes
    beq     $t6,                $zero,          ReturnTrue  # if substring end, return true
    # beq     $t5,                $zero,      ReturnFalse     # if string end before substring, return false
    bne     $t5,                $t6,            ReturnFalse # if current bytes don't match, return false
    addi    $t0,                $t0,            1           # increment index
    j       StartsWithLoop                                  # jump back to top of loop

ReturnTrue:
    add     $v0,                $zero,          1           # return true
    j       EndStartsWith

ReturnFalse:
    add     $v0,                $zero,          0           # return false

EndStartsWith:
    # Standard Epilogue
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
    jr      $ra

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
    # int stringSearch5(char *string, char char1, char char2, char char3, char char4, char char5)
    # {
    #   // Construct array from the 5 characters
    #   char array[5] = {char1, char2, char3, char4, char5};
    #
    #   int i = 0;
    #   while (string[i] != '\0')
    #   {
    #     if (stringStartsWith(&string[i], array))
    #     {
    #       return i;
    #     }
    #     i++;
    #   }
    #   return -1;
    # }
    # ```

    # Standard Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Load the extra args (arg4, arg5, and arg6) into temp registers
    lw      $t1,                24($sp)                     # t1 = arg4
    lw      $t2,                28($sp)                     # t2 = arg5
    lw      $t3,                32($sp)                     # t3 = arg6

    # Save $sX registers being used
    addiu   $sp,                $sp,            -28         # allocate space for saved regs and array
    sw      $s0,                24($sp)                     # save s0

    # Create an array on the stack to store the 5 target characters
    sb      $a1,                0($sp)                      # stackArray[0] = first character (arg2)
    sb      $a2,                4($sp)                      # stackArray[1] = second character (arg3)
    sb      $t1,                8($sp)                      # stackArray[2] = third character (arg4)
    sb      $t2,                12($sp)                     # stackArray[3] = fourth character (arg5)
    sb      $t3,                16($sp)                     # stackArray[4] = fifth character (arg6)
    sb      $zero,              20($sp)                     # stackArray[5] = null terminator

    # Initialize variables
    add     $s0,                $zero,          $a0         # s0 = the base address of the word array
    addiu   $t9,                $zero,          -1          # t9 = return val (default = -1)
    add     $t0,                $zero,          $zero       # t0 = current index

SearchLoop:
    # Load current byte
    lb      $t1,                0($s0)
    beq     $t1,                $zero,          ReturnFalse # If current byte is null terminator, end function

    # Call stringStartsWith
    add     $a0,                $s0,            $zero       # a0 = addres of current byte in string
    add     $a1,                $sp,            0           # a1 = address of first character in array
    jal     stringStartsWith
    addi    $t2,                $zero,          1
    beq     $v0,                $t2,            ReturnTrue

    j       SearchLoop

ReturnFalse:
    addi    $v0,                $zero,          -1          # return -1 (false)
    j       EndStrSearch

ReturnTrue:
    add     $v0,                $s0,            $zero       # return address of first character in matched sequence
    j       EndStrSearch

EndStrSearch:
    # Restore $sX registers that were saved/used
    sw      $s0,                24($sp)
    addiu   $sp,                $sp,            28

    # Standard Epilogue
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
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
    #
    # ```c
    # int getElectionState()
    # {
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
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Initialize (global) variables
    la      $t0,                purpleCount
    la      $t1,                yellowCount
    lw      $t0,                0($t0)                      # t0 = purpleCount
    lw      $t1,                0($t1)                      # t1 = yellowCount

    # Determine state
    beq     $t0,                $t1,            ReturnTie   # if purpleCount == yellowCount, return 2
    slt     $t2,                $t0,            $t1         # t2 = purpleVotesAdd < yellowVotesAdd ? 1 : 0
    beq     $t2,                $zero,          ReturnPurp  # if purpleCount > yellowCount, return 0

    addi    $v0,                $zero,          1           # return 1 (yellow lead)
    j       EndGetState

ReturnTie:
    addi    $v0,                $zero,          2           # preState = 2 (tie)
    j       EndGetState

ReturnPurp:
    add     $v0,                $zero,          $zero       # preState = 0 (purple lead)
    j       EndGetState

EndGetState:
    # Standard Epilogue
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
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
    #
    #   int preState;
    #   if (purpleCount > yellowCount)
    #   {
    #     preState = 0;
    #   }
    #   else if (yellowCount > purpleCount)
    #   {
    #     preState = 1;
    #   }
    #   else
    #   {
    #     preState = 2;
    #   }
    #
    #   purpleCount += purpleVotesAdd;
    #   yellowCount += yellowVotesAdd;
    #
    #   int postState;
    #   if (purpleCount > yellowCount)
    #   {
    #     postState = 0;
    #   }
    #   else if (yellowCount > purpleCount)
    #   {
    #     postState = 1;
    #   }
    #   else
    #   {
    #     postState = 2;
    #   }
    #
    #   if (postState == 2)
    #   {
    #     printf("TIED!!!\n");
    #   }
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

    beq     $s3,                $zero,          printPurple # if postState == 0, printPurple
    addi    $t6,                $zero,          1           # t6 = 1
    beq     $s3,                $t6,            printYellow # if postState == 1, printYellow

printTie:
    # Print "TIED!!!"
    la      $a0,                tieStr                      # a0 = &tieStr
    addi    $v0,                $zero,          4           # print string syscall code
    syscall                                                 # print string
    j       EndAddVotes                                     # jump to EndAddVotes

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

EndAddVotes:
    # Restore $sX registers that were saved/used
    lw      $s0,                0($sp)
    lw      $s1,                4($sp)
    lw      $s2,                8($sp)
    lw      $s3,                12($sp)
    addiu   $sp,                $sp,            16

    # Standard Epilogue
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
    jr      $ra

