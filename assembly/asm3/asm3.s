    # AUTHOR
    #   Christian Byrne
    # PROGRAM DESCRIPTION:
    #   This program uses functions. there is no standard wrapper or main function.
    #   Instead, there are several independent functions. There are no global variables
    #   provided by the caller - all data is passed through the function parameters.
    #   The functions included are:
    #     1. Collatz Part 1: models a part of the Collatz conjecture which finds the odd
    #         number that is the result of reducing an even number by half.
    #     2. Collatz Part 2: Models the Collatz conjecture for a certain number all the
    #         way to 1.
    #     3. Find the % Character: Accepts a string and returns the index of the first '%'
    #         character. If the character is not found, the function returns -1.
    #     4. A Tree of Letters: Accepts a string and prints a tree of letters based on
    #         the string.
    #   The program is written in MIPS assembly and is designed to run on the MARS MIPS simulator.

.data
collatzMsg1:    .asciiz "collatz("
collatzMsg2:    .asciiz ") completed after "
collatzMsg3:    .asciiz " calls to collatz_line().\n"

.text

    # ------------------------------------------------------------------------- #
    #                               Collatz Part 1                              #
    # ------------------------------------------------------------------------- #

                .globl  collatz_line

collatz_line:
    # Models a part of the Collatz conjecture which finds the odd number that is
    # the result of reducing an even number by half. It is assumed that the
    # parameter is a positive integer.
    # ```c
    # int collatz_line(int val)
    # {
    #   if (val % 2 == 1) // is the value odd?
    #   {
    #     printf("%d\n", val);
    #     return val;
    #   }
    #   printf("%d", val);
    #   int cur = val;
    #   while (cur % 2 == 0)
    #   {
    #     cur /= 2;
    #     printf(" %d", cur);
    #   }
    #   printf("\n");
    #   return cur;
    # }
    # ```

    # -------------------------------- Prologue --------------------------------

    # Save the pointers and return address
    addiu   $sp,                $sp,            -24             # allocate stack space (24 bytes)
    sw      $fp,                0($sp)                          # save frame pointer of caller
    sw      $ra,                4($sp)                          # save return address
    addiu   $fp,                $sp,            20              # setup frame pointer for the function

    # Save the registers that will be used in the function
    sw      $s0,                8($sp)                          # save s0
    sw      $s1,                12($sp)                         # save s1
    sw      $s2,                16($sp)                         # save s2

    # -------------------------------- Function --------------------------------

    # Store the value of the parameter in an s register
    addiu   $s0,                $a0,            0

whileLoop:
    # Print the value
    addi    $v0,                $zero,          1               # syscall 1 (print_int)
    add     $a0,                $zero,          $s0             # add the parameter int to the syscall argument
    syscall

    # Check if the value is odd
    andi    $t0,                $s0,            0x0001          # mask the value with 1 to get the LSB
    addi    $t1,                $zero,          1
    beq     $t0,                $t1,            whileLoopEnd    # if the LSB is 1, the value is odd

    sra     $s0,                $s0,            1               # shift the value right by 1 (divide by 2)

    # Print a space character
    addi    $v0,                $zero,          11              # syscall 11 (print_char)
    addi    $a0,                $zero,          32              # space character
    syscall

    j       whileLoop                                           # jump back to the beginning of the loop

whileLoopEnd:
    # Print newline character
    addi    $v0,                $zero,          11              # syscall 11 (print_char)
    addi    $a0,                $zero,          10              # newline character
    syscall

    # Set the return value
    add     $v0,                $zero,          $s0             # set the return value to the current value

    # -------------------------------- Epilogue --------------------------------
    # Restore the registers that were used in the function
    lw      $s2,                16($sp)                         # restore s2
    lw      $s1,                12($sp)                         # restore s1
    lw      $s0,                8($sp)                          # restore s0

    # Restore the pointers and return address
    lw      $ra,                4($sp)                          # restore return address
    lw      $fp,                0($sp)                          # restore frame pointer of caller
    addiu   $sp,                $sp,            24              # restore stack pointer
    jr      $ra                                                 # return to the caller

    # ------------------------------------------------------------------------- #
    #                               Collatz Part 2                              #
    # ------------------------------------------------------------------------- #

                .globl  collatz

collatz:
    # Models the Collatz conjecture for a certain number all the way to 1.
    # ```c
    # void collatz(int val)
    # {
    #   int cur = val;
    #   int calls = 0;
    #   cur = collatz_line(cur);

    #   while (cur != 1)
    #   {
    #     cur = 3 * cur + 1;
    #     cur = collatz_line(cur);
    #     calls++;
    #   }
    #   printf("collatz(%d) completed after %d calls to collatz_line().\n", val, calls);
    #   printf("\n");
    # }
    # ```

    # -------------------------------- Prologue --------------------------------

    # Save the pointers and return address
    addiu   $sp,                $sp,            -28             # allocate stack space (24 bytes)
    sw      $fp,                0($sp)                          # save frame pointer of caller
    sw      $ra,                4($sp)                          # save return address
    addiu   $fp,                $sp,            24              # setup frame pointer for the function

    # Save the registers that will be used in the function
    sw      $s0,                8($sp)                          # save s0
    sw      $s1,                12($sp)                         # save s1
    sw      $s2,                16($sp)                         # save s2
    sw      $s3,                20($sp)                         # save s3

    # -------------------------------- Function --------------------------------

    # Store the value of the parameter twice (one to be iterated on, one to be printed)
    addiu   $s0,                $a0,            0               # store the value of the parameter in s0
    addiu   $s3,                $a0,            0               # store the value of the parameter in s3 (static version)

    # Initialize the number of calls in an s register
    addiu   $s1,                $zero,          0               # initialize calls to 0

    # Keep value of 1 in an s register
    addiu   $s2,                $zero,          1               # store 1 in s2

whileCurNotOne:
    # Call collatz_line with the current value
    add     $a0,                $zero,          $s0             # add the parameter int to the syscall argument
    jal     collatz_line                                        # call collatz_line
    add     $s0,                $v0,            $zero           # set the current value to the return value

    beq     $s0,                $s2,            endCollatz      # if the current value is 1, jump to endCollatz

    # Perform the Collatz calculation
    add     $t0,                $s0,            $s0             # t0 = 2 * cur
    add     $s0,                $t0,            $s0             # cur = t0 + cur = 3 * cur
    addi    $s0,                $s0,            1               # cur = 3 * cur + 1

    addi    $s1,                $s1,            1               # increment the number of calls
    j       whileCurNotOne                                      # jump back to the beginning of the loop

endCollatz:
    # Print the output message detailing the number of calls and the original value
    la      $a0,                collatzMsg1                     # load the address of the first message
    addi    $v0,                $zero,          4               # syscall 4 (print_string)
    syscall

    add     $a0,                $zero,          $s3             # load the original value of the parameter
    addi    $v0,                $zero,          1               # syscall 1 (print_int)
    syscall

    la      $a0,                collatzMsg2                     # load the address of the second message
    addi    $v0,                $zero,          4               # syscall 4 (print_string)
    syscall

    add     $a0,                $zero,          $s1             # load the number of calls into a0
    addi    $v0,                $zero,          1               # syscall 1 (print_int)
    syscall

    la      $a0,                collatzMsg3                     # load the address of the third message
    addi    $v0,                $zero,          4               # syscall 4 (print_string)
    syscall

    addi    $v0,                $zero,          11              # syscall 11 (print_char)
    addi    $a0,                $zero,          10              # newline character
    syscall

    # -------------------------------- Epilogue --------------------------------
    # Restore the registers that were used in the function
    lw      $s3,                20($sp)                         # restore s3
    lw      $s2,                16($sp)                         # restore s2
    lw      $s1,                12($sp)                         # restore s1
    lw      $s0,                8($sp)                          # restore s0

    # Restore the pointers and return address
    lw      $ra,                4($sp)                          # restore return address
    lw      $fp,                0($sp)                          # restore frame pointer of caller
    addiu   $sp,                $sp,            28              # restore stack pointer
    jr      $ra                                                 # return to the caller

    # ------------------------------------------------------------------------- #
    #                         Find the % Character                              #
    # ------------------------------------------------------------------------- #

                .globl  percentSearch

percentSearch:
    # Accepts a string and returns the index of the first '%' character. If the
    # character is not found, the function returns -1.
    # ```c
    # int percentSearch(char *str)
    # {
    #   int i = 0;
    #   while (str[i] != '\0')
    #   {
    #     if (str[i] == '%')
    #     {
    #       return i;
    #     }
    #     i++;
    #   }
    #   return -1;
    # }
    # ```

    # -------------------------------- Prologue --------------------------------
    # Save the pointers and return address
    addiu   $sp,                $sp,            -24             # allocate stack space (24 bytes)
    sw      $fp,                0($sp)                          # save frame pointer of caller
    sw      $ra,                4($sp)                          # save return address
    addiu   $fp,                $sp,            20              # setup frame pointer for the function

    # Save the registers that will be used in the function
    sw      $s0,                8($sp)                          # save s0
    sw      $s1,                12($sp)                         # save s1

    # -------------------------------- Function --------------------------------
    # Initialize the index in an s register
    addiu   $s0,                $zero,          0               # initialize i to 0

    # Load the address of the string into an s register
    add     $s1,                $a0,            $zero           # load the address of the string into s1

stringLoop:
    lb      $t0,                0($s1)                          # load the character at the current index
    beq     $t0,                $zero,          notFound        # if the character is null, jump to notFound
    addi    $t3,                $zero,          37              # set t3 to 37 ('%' character in ASCII)
    beq     $t0,                $t3,            foundPercent    # if the character is '%', jump to foundPercent
    addiu   $s0,                $s0,            1               # increment the index
    addiu   $s1,                $s1,            1               # move to the next character

    j       stringLoop                                          # jump back to the beginning of the loop

foundPercent:
    add     $v0,                $zero,          $s0             # set the return value to the index
    j       endPercentSearch                                    # jump to the end of the function

notFound:
    addi    $v0,                $zero,          -1              # set the return value to -1

endPercentSearch:

    # -------------------------------- Epilogue --------------------------------
    # Restore the registers that were used in the function
    lw      $s1,                12($sp)                         # restore s1
    lw      $s0,                8($sp)                          # restore s0

    # Restore the pointers and return address
    lw      $ra,                4($sp)                          # restore return address
    lw      $fp,                0($sp)                          # restore frame pointer of caller
    addiu   $sp,                $sp,            24              # restore stack pointer
    jr      $ra                                                 # return to the caller

    # ------------------------------------------------------------------------- #
    #                           A Tree of Letters                               #
    # ------------------------------------------------------------------------- #

                .globl  letterTree

letterTree:
    # Accepts a string and prints a tree of letters based on the string.
    # The `getNextLetter` function is assumed to be implemented elsewhere.
    # `getNextLetter` accepts an integer and returns a character.
    # ```c
    # int letterTree(int step)
    # {
    #   int count = 0;
    #   int pos = 0;
    #   while (1) // we’ll break out manually, when required
    #   {
    #     char c = getNextLetter(pos);
    #     if (c == '\0') // this is literally *ZERO*
    #       break;
    #     for (int i = 0; i <= count; i++)
    #       printf("%c", c); // use syscall 11
    #     printf("\n");
    #     count++;
    #     pos += step;
    #   }
    #   return pos;
    # }
    # ```

    # -------------------------------- Prologue --------------------------------
    # Save the pointers and return address
    addiu   $sp,                $sp,            -32             # allocate stack space (24 bytes)
    sw      $fp,                0($sp)                          # save frame pointer of caller
    sw      $ra,                4($sp)                          # save return address
    addiu   $fp,                $sp,            28              # setup frame pointer for the function

    # Save the registers that will be used in the function
    sw      $s0,                8($sp)                          # save s0
    sw      $s1,                12($sp)                         # save s1
    sw      $s2,                16($sp)                         # save s2
    sw      $s3,                20($sp)                         # save s3
    sw      $s4,                24($sp)                         # save s4

    # -------------------------------- Function --------------------------------
    # Initialize the parameter and count and pos indices in s registers
    addiu   $s0,                $zero,          0               # initialize count to 0
    addiu   $s1,                $zero,          0               # initialize pos to 0
    add     $s4,                $zero,          $a0             # store the step in s4

whileTrue:
    # Call getNextLetter with the current position
    add     $a0,                $s1,            $zero           # add the position to the syscall argument
    jal     getNextLetter                                       # call getNextLetter
    add     $s2,                $v0,            $zero           # store the return value in s2

    # Check if the character is null
    beq     $s2,                $zero,          endLetterTree   # if the character is null, jump to endLetterTree

    # Print the character count times
    add     $s3,                $s0,            $zero           # store the count in s3
countLoop:
    addi    $v0,                $zero,          11              # syscall 11 (print_char)
    add     $a0,                $s2,            $zero           # add the character to the syscall argument
    syscall

    # Check after printing the character to ensure print happens on 0 count (<= 0)
    beq     $s3,                $zero,          printNewline    # if the count is 0, jump to printNewline
    addi    $s3,                $s3,            -1              # decrement the count
    j       countLoop                                           # jump back to the beginning of the loop

printNewline:
    # Print newline character
    addi    $v0,                $zero,          11              # syscall 11 (print_char)
    addi    $a0,                $zero,          10              # newline character
    syscall

    # Increment the count and position
    addi    $s0,                $s0,            1               # increment the count by 1
    add     $s1,                $s1,            $s4             # increment the position by the step

    j       whileTrue                                           # jump back to the beginning of the loop

endLetterTree:
    # Set the return value
    add     $v0,                $zero,          $s1             # set the return value to the position

    # -------------------------------- Epilogue --------------------------------
    # Restore the registers that were used in the function
    lw      $s4,                24($sp)                         # restore s4
    lw      $s3,                20($sp)                         # restore s3
    lw      $s2,                16($sp)                         # restore s2
    lw      $s1,                12($sp)                         # restore s1
    lw      $s0,                8($sp)                          # restore s0

    # Restore the pointers and return address
    lw      $ra,                4($sp)                          # restore return address
    lw      $fp,                0($sp)                          # restore frame pointer of caller
    addiu   $sp,                $sp,            32              # restore stack pointer
    jr      $ra                                                 # return to the caller

