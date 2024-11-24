    # AUTHOR:       Christian Byrne
    # FILE:         asm5.s
    # COURSE:       CSc 252
    # PROGRAM DESC:


.data
    .globl  merge
    # .globl  quicksort
    # .globl  merge_debug

.text


    # -------------------------------------------------------------------------- #
    #                                Task 1: merge                               #
    # -------------------------------------------------------------------------- #

merge:
    # Implements mergesort over an array of integers. It will call the
    # function merge_debug() after each new value is added to the output array
    #
    # Arguments:
    #   $a0:    Address of the first array
    #   $a1:    Length of the first array
    #   $a2:    Address of the second array
    #   $a3:    Length of the second array
    #   arg5:   Address of the output array. Always the same length as the sum
    #           of the lengths of the two input arrays
    #
    # Returns:
    #   None
    #
    # ```c
    # void merge(int *a, int aLen, int *b, int bLen, int *out) {
    #   int posA=0, posB=0;
    #   while (posA < aLen || posB < bLen) {
    #     if (posB == bLen || posA < aLen && a[posA] <= b[posB]) {
    #       out[posA+posB] = a[posA];
    #       posA++;
    #     } else {
    #       out[posA+posB] = b[posB];
    #       posB++;
    #     }
    #     merge_debug(out, posA+posB);
    #   }
    # }
    # ```

    # Load the extra arg (arg5) into $t0
    lw      $t0,            -4($sp)                 # t0 = arg5 (address of output array)

    # Prologue
    addiu   $sp,            $sp,        -24
    sw      $ra,            0($sp)
    sw      $fp,            4($sp)
    addi    $fp,            $sp,        20

    # Save $sX registers being used
    addiu   $sp,            $sp,        -36         # allocate space for saved regs and array
    sw      $s0,            0($sp)                  # save s0
    sw      $s1,            4($sp)                  # save s1
    sw      $s2,            8($sp)                  # save s2
    sw      $s3,            12($sp)                 # save s3
    sw      $s4,            16($sp)                 # save s4
    sw      $s5,            20($sp)                 # save s5
    sw      $s6,            24($sp)                 # save s6
    sw      $s7,            28($sp)                 # save s7

    # Initialize variables
    add     $s0,            $zero,      $zero       # posA = 0
    add     $s1,            $zero,      $zero       # posB = 0
    add     $s2,            $a1,        $zero       # s2 = aLen
    add     $s3,            $a3,        $zero       # s3 = bLen
    add     $s4,            $a0,        $zero       # s4 = address of a
    add     $s5,            $a2,        $zero       # s5 = address of b
    add     $s6,            $t0,        $zero       # s6 = address of out
    add     $s7,            $zero,      $zero       # s7 = posA + posB

While:
    # Check break conditions
    add     $t7,            $s2,        $s3         # t7 = aLen + bLen (total length)
    beq     $s7,            $t7,        MEpilogue   # if posA + posB == aLen + bLen, finished
    beq     $s0,            $s2,        PopBDirect  # if a exhausted
    beq     $s1,            $s3,        PopADirect  # if b exhausted

    # Load a[posA] and b[posB]
    sll     $t1,            $s0,        2           # t1 = posA * 4
    sll     $t2,            $s1,        2           # t2 = posB * 4
    add     $t1,            $t1,        $s4         # t1 = address of a[posA]
    add     $t2,            $t2,        $s5         # t2 = address of b[posB]
    lw      $t3,            0($t1)                  # t3 = a[posA]
    lw      $t4,            0($t2)                  # t4 = b[posB]

    # Compare a[posA] and b[posB]
    slt     $t5,            $t4,        $t3         # t5 = b[posB] < a[posA] ? 1 : 0
    beq     $t5,            $zero,      PopA        # if a's head <= b's head, add a's head to output
    j       PopB

PopADirect:
    sll     $t1,            $s0,        2           # t1 = posA * 4
    add     $t1,            $t1,        $s4         # t1 = address of a[posA]
    lw      $t3,            0($t1)                  # t3 = a[posA]
    j       PopA

PopA:
    sll     $t6,            $s7,        2           # t6 = (posA + posB) * 4
    add     $t6,            $t6,        $s6         # t6 = address of out[posA+posB]
    sw      $t3,            0($t6)                  # out[posA+posB] = a[posA]
    addi    $s0,            $s0,        1           # posA++
    j       EndPop

PopBDirect:
    sll     $t2,            $s1,        2           # t2 = posB * 4
    add     $t2,            $t2,        $s5         # t2 = address of b[posB]
    lw      $t4,            0($t2)                  # t4 = b[posB]
    j       PopB

PopB:
    sll     $t6,            $s7,        2           # t6 = (posA + posB) * 4
    add     $t6,            $t6,        $s6         # t6 = address of out[posA+posB]
    sw      $t4,            0($t6)                  # out[posA+posB] = b[posB]
    addi    $s1,            $s1,        1           # posB++
    j       EndPop

EndPop:
    addi    $s7,            $s7,        1           # posA + posB++
    # TODO: save any temp registers if they are needing to be persisted before calling merge debug
    add     $a0,            $s6,        $zero       # a0 = address of out
    add     $a1,            $s7,        $zero       # a1 = posA + posB
    jal     merge_debug
    j       While

MEpilogue:
    # Restore $sX registers
    lw      $s0,            0($sp)                  # restore s0
    lw      $s1,            4($sp)                  # restore s1
    lw      $s2,            8($sp)                  # restore s2
    lw      $s3,            12($sp)                 # restore s3
    lw      $s4,            16($sp)                 # restore s4
    lw      $s5,            20($sp)                 # restore s5
    lw      $s6,            24($sp)                 # restore s6
    lw      $s7,            28($sp)                 # restore s7
    addiu   $sp,            $sp,        36          # deallocate space for saved regs and array

    # Epilogue
    lw      $ra,            0($sp)
    lw      $fp,            4($sp)
    addiu   $sp,            $sp,        24
    jr      $ra

    # -------------------------------------------------------------------------- #
    #                              Task 2: quicksort                             #
    # -------------------------------------------------------------------------- #
