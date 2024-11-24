    # AUTHOR:       Christian Byrne
    # FILE:         asm5.s
    # COURSE:       CSc 252
    # PROGRAM DESC:


.data
    .globl  merge
    .globl  quicksort

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
    lw      $t0,                -4($sp)                 # t0 = arg5 (address of output array)

    # Prologue
    addiu   $sp,                $sp,        -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $sp,        20

    # Save $sX registers being used
    addiu   $sp,                $sp,        -36         # allocate space for saved regs and array
    sw      $s0,                0($sp)                  # save s0
    sw      $s1,                4($sp)                  # save s1
    sw      $s2,                8($sp)                  # save s2
    sw      $s3,                12($sp)                 # save s3
    sw      $s4,                16($sp)                 # save s4
    sw      $s5,                20($sp)                 # save s5
    sw      $s6,                24($sp)                 # save s6
    sw      $s7,                28($sp)                 # save s7

    # Initialize variables
    add     $s0,                $zero,      $zero       # posA = 0
    add     $s1,                $zero,      $zero       # posB = 0
    add     $s2,                $a1,        $zero       # s2 = aLen
    add     $s3,                $a3,        $zero       # s3 = bLen
    add     $s4,                $a0,        $zero       # s4 = address of a
    add     $s5,                $a2,        $zero       # s5 = address of b
    add     $s6,                $t0,        $zero       # s6 = address of out
    add     $s7,                $zero,      $zero       # s7 = posA + posB

While:
    # Check break conditions
    add     $t7,                $s2,        $s3         # t7 = aLen + bLen (total length)
    beq     $s7,                $t7,        MEpilogue   # if posA + posB == aLen + bLen, finished
    beq     $s0,                $s2,        PopBDirect  # if a exhausted
    beq     $s1,                $s3,        PopADirect  # if b exhausted

    # Load a[posA] and b[posB]
    sll     $t1,                $s0,        2           # t1 = posA * 4
    sll     $t2,                $s1,        2           # t2 = posB * 4
    add     $t1,                $t1,        $s4         # t1 = address of a[posA]
    add     $t2,                $t2,        $s5         # t2 = address of b[posB]
    lw      $t3,                0($t1)                  # t3 = a[posA]
    lw      $t4,                0($t2)                  # t4 = b[posB]

    # Compare a[posA] and b[posB]
    slt     $t5,                $t4,        $t3         # t5 = b[posB] < a[posA] ? 1 : 0
    beq     $t5,                $zero,      PopA        # if a's head <= b's head, add a's head to output
    j       PopB

PopADirect:
    sll     $t1,                $s0,        2           # t1 = posA * 4
    add     $t1,                $t1,        $s4         # t1 = address of a[posA]
    lw      $t3,                0($t1)                  # t3 = a[posA]
    j       PopA

PopA:
    sll     $t6,                $s7,        2           # t6 = (posA + posB) * 4
    add     $t6,                $t6,        $s6         # t6 = address of out[posA+posB]
    sw      $t3,                0($t6)                  # out[posA+posB] = a[posA]
    addi    $s0,                $s0,        1           # posA++
    j       EndPop

PopBDirect:
    sll     $t2,                $s1,        2           # t2 = posB * 4
    add     $t2,                $t2,        $s5         # t2 = address of b[posB]
    lw      $t4,                0($t2)                  # t4 = b[posB]
    j       PopB

PopB:
    sll     $t6,                $s7,        2           # t6 = (posA + posB) * 4
    add     $t6,                $t6,        $s6         # t6 = address of out[posA+posB]
    sw      $t4,                0($t6)                  # out[posA+posB] = b[posB]
    addi    $s1,                $s1,        1           # posB++
    j       EndPop

EndPop:
    addi    $s7,                $s7,        1           # posA + posB++
    # TODO: save any temp registers if they are needing to be persisted before calling merge debug
    add     $a0,                $s6,        $zero       # a0 = address of out
    add     $a1,                $s7,        $zero       # a1 = posA + posB
    jal     merge_debug
    j       While

MEpilogue:
    # Restore $sX registers
    lw      $s0,                0($sp)                  # restore s0
    lw      $s1,                4($sp)                  # restore s1
    lw      $s2,                8($sp)                  # restore s2
    lw      $s3,                12($sp)                 # restore s3
    lw      $s4,                16($sp)                 # restore s4
    lw      $s5,                20($sp)                 # restore s5
    lw      $s6,                24($sp)                 # restore s6
    lw      $s7,                28($sp)                 # restore s7
    addiu   $sp,                $sp,        36          # deallocate space for saved regs and array

    # Epilogue
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
    addiu   $sp,                $sp,        24
    jr      $ra

    # -------------------------------------------------------------------------- #
    #                              Task 2: quicksort                             #
    # -------------------------------------------------------------------------- #

quicksort:
    # Implements quicksort over an array of integers. It will call the
    # function quicksort_debug() after each partitioning step
    #
    # Arguments:
    #   $a0:    Address of the array
    #   $a1:    Length of the array
    #
    # Returns:
    #   None
    #
    # ```c
    # void quicksort(int *data, int n) {
    #     if (n < 2)
    #         return;
    #
    #     int left = 1; // first unsorted index. Note that [0] is the pivot.
    #     int right = n-1; // last unsorted index
    #
    #     while (left <= right) {
    #         quicksort_debug(data,n, left,right);
    #
    #         while (left <= right && data[left] <= data[0])
    #             left++;
    #         while (left <= right && data[right] > data[0])
    #             right--;
    #         if (left < right) {
    #             quicksort_debug(data, n, left,right);
    #             int tmp = data[left];
    #             data[left] = data[right];
    #             data[right] = tmp;
    #             left++;
    #             right--;
    #         }
    #     }
    #     quicksort_debug(data, n, left,right);
    #     int tmp = data[0];
    #     data[0] = data[left-1];
    #     data[left-1] = tmp;
    #     quicksort_debug(data, n, -1,-1);
    #     quicksort(data, left-1);
    #     quicksort(data+left, n-left);
    #     quicksort_debug(data, n, -1,-1);
    # }
    # ```

    # Prologue
    addiu   $sp,                $sp,        -24
    sw      $ra,                0($sp)
    sw      $fp,                4($sp)
    addi    $fp,                $sp,        20

    # Save $sX registers being used
    addiu   $sp,                $sp,        -36         # allocate space for saved regs and array
    sw      $s0,                0($sp)                  # save s0
    sw      $s1,                4($sp)                  # save s1
    sw      $s2,                8($sp)                  # save s2
    sw      $s3,                12($sp)                 # save s3
    sw      $s4,                16($sp)                 # save s4
    sw      $s5,                20($sp)                 # save s5
    sw      $s6,                24($sp)                 # save s6
    sw      $s7,                28($sp)                 # save s7

    # Initialize variables
    addiu   $s0,                $zero,      1           # s0 = 1 = left
    addiu   $s1,                $a1,        -1          # s1 = n - 1 = right
    add     $s2,                $a0,        $zero       # s2 = address of data
    add     $s3,                $a1,        $zero       # s3 = n
    lw      $s4,                0($s2)                  # s4 = data[0] = pivot

WhileQS:
    # Check break conditions
    slt     $t0,                $s1,        $s0         # t0 = right < left ? 1 : 0
    bne     $t0,                $zero,      LoopBreak   # if right < left, finished

    # Call quicksort_debug
    add     $a0,                $s2,        $zero       # a0 = address of data
    add     $a1,                $s3,        $zero       # a1 = n
    add     $a2,                $s0,        $zero       # a2 = left
    add     $a3,                $s1,        $zero       # a3 = right
    jal     quicksort_debug
    j       IterLeft

IterLeft:
    # Check break condition - left passed right
    slt     $t0,                $s1,        $s0         # t0 = right < left ? 1 : 0
    bne     $t0,                $zero,      IL_Break    # if right < left, finished

    # Check break condition - data[left] <= pivot (hit a value that is greater than pivot and needs swap)
    sll     $t1,                $s0,        2           # t1 = left * 4
    add     $t1,                $t1,        $s2         # t1 = address of data[left]
    lw      $t2,                0($t1)                  # t2 = data[left]
    slt     $t3,                $s4,        $t2         # t3 = pivot < data[left] ? 1 : 0
    bne     $t3,                $zero,      IL_Break    # if pivot < data[left]

    addi    $s0,                $s0,        1           # left++
    j       IterLeft

IL_Break:
    j       IterRight

IterRight:
    # Check break condition - left passed right
    slt     $t0,                $s1,        $s0         # t0 = right < left ? 1 : 0
    bne     $t0,                $zero,      IR_Break    # if right < left, finished

    # Check break condition - data[right] > pivot (hit a value that is less than pivot and needs swap)
    sll     $t1,                $s1,        2           # t1 = right * 4
    add     $t1,                $t1,        $s2         # t1 = address of data[right]
    lw      $t2,                0($t1)                  # t2 = data[right]
    slt     $t3,                $t2,        $s4         # t3 = data[right] < pivot ? 1 : 0
    bne     $t3,                $zero,      IR_Break    # if data[right] < pivot

    addi    $s1,                $s1,        -1          # right--
    j       IterRight

IR_Break:
    j       Swap

Swap:
    # Check break condition - left passed right
    slt     $t0,                $s0,        $s1         # t0 = left < right ? 1 : 0
    bne     $t0,                $zero,      LoopBreak   # if left < right, finished

    # Call quicksort_debug
    add     $a0,                $s2,        $zero       # a0 = address of data
    add     $a1,                $s3,        $zero       # a1 = n
    add     $a2,                $s0,        $zero       # a2 = left
    add     $a3,                $s1,        $zero       # a3 = right
    jal     quicksort_debug

    # Swap data[left] and data[right]
    sll     $t1,                $s0,        2           # t1 = left * 4
    sll     $t2,                $s1,        2           # t2 = right * 4
    add     $t1,                $t1,        $s2         # t1 = address of data[left]
    add     $t2,                $t2,        $s2         # t2 = address of data[right]
    lw      $t3,                0($t1)                  # t3 = data[left]
    lw      $t4,                0($t2)                  # t4 = data[right]
    sw      $t4,                0($t1)                  # data[left] = data[right]
    sw      $t3,                0($t2)                  # data[right] = data[left]

    addi    $s0,                $s0,        1           # left++
    addi    $s1,                $s1,        -1          # right--
    j       WhileQS

LoopBreak:
    # Call quicksort_debug
    add     $a0,                $s2,        $zero       # a0 = address of data
    add     $a1,                $s3,        $zero       # a1 = n
    add     $a2,                $s0,        $zero       # a2 = left
    add     $a3,                $s1,        $zero       # a3 = right
    jal     quicksort_debug

    # Swap data[0] and data[left-1]
    sll     $t1,                $s0,        2           # t1 = left * 4
    add     $t1,                $t1,        $s2         # t1 = address of data[left]
    lw      $t2,                0($t1)                  # t2 = data[left]
    sll     $t3,                $s3,        2           # t3 = n * 4
    add     $t3,                $t3,        $s2         # t3 = address of data[n]
    lw      $t4,                0($t3)                  # t4 = data[n]
    sw      $t4,                0($t1)                  # data[left] = data[n]
    sw      $t2,                0($t3)                  # data[n] = data[left]

    # Call quicksort_debug
    add     $a0,                $s2,        $zero       # a0 = address of data
    add     $a1,                $s3,        $zero       # a1 = n
    addi    $a2,                $zero,      -1          # a2 = -1
    addi    $a3,                $zero,      -1          # a3 = -1
    jal     quicksort_debug

    # Call quicksort(data, left-1)
    add     $a0,                $s2,        $zero       # a0 = address of data
    add     $a1,                $s0,        $zero       # a1 = left-1
    jal     quicksort

    # Call quicksort(data+left, n-left)
    sll     $t0,                $s0,        2           # t0 = left * 4
    add     $a0,                $s2,        $t0         # a0 = address of data + left * 4
    sub     $a1,                $s3,        $s0         # a1 = n - left
    jal     quicksort

    # Call quicksort_debug
    add     $a0,                $s2,        $zero       # a0 = address of data
    add     $a1,                $s3,        $zero       # a1 = n
    addi    $a2,                $zero,      -1          # a2 = -1
    addi    $a3,                $zero,      -1          # a3 = -1
    jal     quicksort_debug

QSEpilogue:
    # Restore $sX registers
    lw      $s0,                0($sp)                  # restore s0
    lw      $s1,                4($sp)                  # restore s1
    lw      $s2,                8($sp)                  # restore s2
    lw      $s3,                12($sp)                 # restore s3
    lw      $s4,                16($sp)                 # restore s4
    lw      $s5,                20($sp)                 # restore s5
    lw      $s6,                24($sp)                 # restore s6
    lw      $s7,                28($sp)                 # restore s7
    addiu   $sp,                $sp,        36          # deallocate space for saved regs and array

    # Epilogue
    lw      $ra,                0($sp)
    lw      $fp,                4($sp)
    addiu   $sp,                $sp,        24
    jr      $ra
