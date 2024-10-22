
caller:
    # ... rest of code

    addiu   $sp,    $sp,        -12         # allocate space to save temp registers
    sw      $t0,    0($sp)                  # save $t0
    sw      $t1,    4($sp)                  # save $t1
    sw      $t2,    8($sp)                  # save $t2

    addiu   $a0,    $zero,      1           # first arg = 1
    addiu   $a1,    $zero,      2           # second arg = 2

    jal     foo                             # call foo

    # Cleanup
    lw      $t0,    0($sp)                  # restore $t0
    lw      $t1,    4($sp)                  # restore $t1
    lw      $t2,    8($sp)                  # restore $t2

    addiu   $sp,    $sp,        12          # deallocate space for temp registers


caller2:
    # ... rest of code

    addiu   $sp,    $sp,        -12         # allocate space to save temp registers
    sw      $t1,    0($sp)                  # save $t1
    sw      $t3,    4($sp)                  # save $t3
    sw      $t5,    8($sp)                  # save $t5

    addiu   $a0,    $zero,      0           # first arg = 0
    addiu   $a1,    $zero,      0x1234      # second arg = 0x1234
    la      $a2,    str                     # third arg = address of str (first char in str)

    jal     bar                             # call bar

    # Cleanup
    lw      $t1,    0($sp)                  # restore $t1
    lw      $t3,    4($sp)                  # restore $t3
    lw      $t5,    8($sp)                  # restore $t5

    addiu   $sp,    $sp,        12          # deallocate space for temp registers

caller3:
    # ... rest of code

    addiu   $sp,    $sp,        -16         # allocate space to save temp registers
    sw      $t1,    0($sp)                  # save $t1
    sw      $t2,    4($sp)                  # save $t2
    sw      $t3,    8($sp)                  # save $t3
    sw      $t4,    12($sp)                 # save $t4

    addiu   $a0,    $zero,      123         # first arg = 123
    addiu   $a1,    $zero,      456         # second arg = 456
    addiu   $a2,    $zero,      0xabc       # third arg = 0xabc
    addiu   $a3,    $zero,      0xdef       # fourth arg = 0xdef

    # Extra args
    addiu   $t0,    $zero,      0           # fifth arg = 0
    sw      $t0,    -8($sp)                 # store extra arg 1 (arg5) two words after stack pointer
    addiu   $t0,    $zero,      10          # sixth arg = 10
    sw      $t0,    -4($sp)                 # store extra arg 2 (arg6) one word after stack pointer

    jal     fred                            # call fred

    # Cleanup
    lw      $t1,    0($sp)                  # restore $t1
    lw      $t2,    4($sp)                  # restore $t2
    lw      $t3,    8($sp)                  # restore $t3
    lw      $t4,    12($sp)                 # restore $t4

    addiu   $sp,    $sp,        16          # deallocate space for temp registers

caller4:
    # ... rest of code

    addiu   $sp,    $sp,        -8          # allocate space to save temp registers
    sw      $t0,    0($sp)                  # save $t0
    sw      $t1,    4($sp)                  # save $t1

    addi    $a0,    $zero,      'a'         # first arg = 'a' (ASCII value of 'a')
    addiu   $a1,    $zero,      10          # second arg = 10
    addi    $a2,    $zero,      'B'         # third arg = 'B' (ASCII value of 'B')
    addiu   $a3,    $zero,      -2          # fourth arg = -2

    addi    $t0,    $zero,      0xffff      # fifth arg = 0xffff
    sw      $t0,    -4($sp)                 # store extra arg 1 (arg5) one word after stack pointer

    jal     qwerty                          # call qwerty

    # Cleanup
    lw      $t0,    0($sp)                  # restore $t0
    lw      $t1,    4($sp)                  # restore $t1

    addiu   $sp,    $sp,        8           # deallocate space for temp registers


