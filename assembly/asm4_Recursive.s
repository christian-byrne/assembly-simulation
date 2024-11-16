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

cbStr1:         .asciiz "\nCurrent Byte in Array:    "
cbStr2:         .asciiz "\nCurrent Byte in Subarray: "

                .globl  purpleCount
                .globl  yellowCount
                .globl  arrayDupSearchInts
                .globl  stringSearch5
                .globl  addVotes

purpleCount:    .word   0
yellowCount:    .word   0

.text

    # -------------------------------------------------------------------------- #
    #                              Helper Functions                              #
    # -------------------------------------------------------------------------- #

arrayContains:
    # Helper function to check if an array contains a subarray.
    #
    # Args:
    #   arg1: base address of the array
    #   arg2: base address of the subarry
    #
    # Returns:
    #   int: base address of the array's matching subarry if found, else -1
    #
    # ```c
    # int arrayContains(char *array, char *subarray)
    # {
    #   if (subarray[0] == '\0')
    #   {
    #     return array;
    #   }
    #   if (array[0] == subarray[0])
    #   {
    #     return arrayContains(&array[1], &subarray[1]);
    #   }
    #   return -1;
    # }
    # ```
    # Args:
    #   $a0: base address of the array
    #   $a1: base address of the subarray
    #   $a2: current remaining length of the array
    #   $a3: current remaining length of the subarray
    #   $a4: starting index in the array for this match attempt
    #
    # Returns:
    #   $v0: index of the start of the matching subarray if found, else -1

    # Standard Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Load the extra args (arg4) into temp registers
    lw      $t1,                24($sp)                     # t1 = arg4

    # Store $sX registers being used
    addiu   $sp,                $sp,            -20
    sw      $s0,                0($sp)
    sw      $s1,                4($sp)
    sw      $s2,                8($sp)
    sw      $s3,                12($sp)
    sw      $s4,                16($sp)

    # Initialize variables
    add     $s1,                $zero,          $a0         # s1 = base address of array
    add     $s2,                $zero,          $a1         # s2 = base address of subarray
    add     $s3,                $zero,          $a2         # s3 = current length of array
    add     $s4,                $zero,          $t1         # s4 = current length of subarray

BaseCaseCheck:
    # Check if subarray length is zero (match found)
    beq     $s4,                $zero,          MatchFound

    # Check if array length is zero (no match possible)
    beq     $s3,                $zero,          NoMatch

CompareBytes:
    lb      $t0,                0($s1)                      # Load current byte of array
    lb      $t1,                0($s2)                      # Load current byte of subarray

    # Print current bytes
    la      $a0,                cbStr1                      # a0 = &cbStr1
    addi    $v0,                $zero,          4           # v0 = 4 (print string syscall code)
    syscall                                                 # print string

    add     $a0,                $t0,            $zero       # a0 = current byte of array
    addi    $v0,                $zero,          11          # v0 = 11 (print char syscall code)
    syscall                                                 # print char

    la      $a0,                cbStr2                      # a0 = &cbStr2
    addi    $v0,                $zero,          4           # v0 = 4 (print string syscall code)
    syscall                                                 # print string

    add     $a0,                $t1,            $zero       # a0 = current byte of subarray
    addi    $v0,                $zero,          11          # v0 = 11 (print char syscall code)
    syscall                                                 # print char

    bne     $t0,                $t1,            Backtrack   # If mismatch, backtrack

    # Recursive Case: Bytes match, decrement lengths and increment pointers
    addiu   $a0,                $s1,            1           # Increment array pointer
    addiu   $a1,                $s2,            1           # Increment subarray pointer
    addiu   $a2,                $s3,            -1          # Decrement array length
    addiu   $a3,                $s4,            -1          # Decrement subarray length
    jal     arrayContains                                   # Recursive call
    addiu   $t0,                $zero,          -1          # If recursion fails, backtrack
    beq     $v0,                $t0,            Backtrack
    j       EndContains                                     # If recursion succeeds, return

Backtrack:
    # Backtracking: Try next position in array
    addiu   $a0,                $s1,            1           # Increment array pointer
    add     $a1,                $zero,          $a1         # Reset subarray pointer to start
    addiu   $a2,                $s3,            -1          # Decrement array length
    addi    $t6,                $s4,            1           # t6 = incremented subarray length
    sw      $t6,                -4($sp)                     # save incremented subarray length
    jal     arrayContains                                   # Recursive call
    j       EndContains

MatchFound:
    # Match found: Return starting index
    add     $v0,                $s4,            $zero
    # add     $v0,                $a4,            $zero       # Return the starting index
    j       EndContains

NoMatch:
    # No match found
    addiu   $v0,                $zero,          -1
    j       EndContains

EndContains:
    # Restore $sX registers
    lw      $s0,                0($sp)
    lw      $s1,                4($sp)
    lw      $s2,                8($sp)
    lw      $s3,                12($sp)
    lw      $s4,                16($sp)
    addiu   $sp,                $sp,            20

    # Standard Epilogue
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
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
    # int stringSearch5(char *string, char char1, char char2, char char3, char char4, char char5)
    # {
    #   char array[5] = {char1, char2, char3, char4, char5};
    #   return arrayContains(string, array);
    # }
    # ```

    # Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Load the extra args (arg4, arg5, and arg6) into temp registers
    lw      $t1,                24($sp)                     # t1 = arg4
    lw      $t2,                28($sp)                     # t2 = arg5
    lw      $t3,                32($sp)                     # t3 = arg6

    # Save $sX registers being used
    addiu   $sp,                $sp,            -24         # allocate space for saved regs and array

    # Create an array on the stack to store the 5 target characters
    sb      $a1,                0($sp)                      # stackArray[0] = first character (arg2)
    sb      $a2,                1($sp)                      # stackArray[1] = second character (arg3)
    sb      $t1,                2($sp)                      # stackArray[2] = third character (arg4)
    sb      $t2,                2($sp)                      # stackArray[3] = fourth character (arg5)
    sb      $t3,                3($sp)                      # stackArray[4] = fifth character (arg6)
    sb      $zero,              4($sp)                      # stackArray[5] = null terminator

    # Call arrayContains NOTE: a0 is already set to the base address of the string
    addi    $t9,                $zero,          30          # t9 = length of string
    addiu   $a1,                $sp,            0           # arg2 = base address of substring
    addi    $a2,                $zero,          5           # arg3 = length of substring
    sw      $t9,                -4($sp)                     # arg4 = length of string
    jal     arrayContains

    #

    # Deallocate char array stack space
    addiu   $sp,                $sp,            24          # Deallocate char array stack space

    # Epilogue
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
    jr      $ra


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
    # int arrayDupSearchInts(int *array, int targetInt)
    # {
    #   int subarray[2] = {targetInt, targetInt};
    #   return arrayContains(array, subarray);
    # }
    # ```

    # Prologue
    addiu   $sp,                $sp,            -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $fp,            20

    # Save $sX registers being used
    addiu   $sp,                $sp,            -24         # allocate space for saved regs and array

    # Create an array on the stack to store the targetInt twice consecutively
    sw      $a2,                0($sp)                      # stackArray[0] = targetInt
    sw      $a2,                4($sp)                      # stackArray[1] = targetInt
    sw      $zero,              8($sp)                      # stackArray[2] = 0

    # Call arrayContains NOTE: a0 is already set to the base address of the string
    addiu   $a1,                $sp,            0           # a1 = base address of substring
    jal     arrayContains
    addiu   $sp,                $sp,            24          # Deallocate char array stack space

    # Epilogue
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
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
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
    addiu   $sp,                $sp,            24
    jr      $ra

