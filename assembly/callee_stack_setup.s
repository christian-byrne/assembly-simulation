
callee1:
    # --- Standard Prologue ---

    addiu   $sp,    $sp,        -24 # allocate space for args 1-4, ra, and fp
    sw      $fp,    0($sp)          # save fp
    sw      $ra,    4($sp)          # save ra
    addiu   $fp,    $sp,        20  # set fp to point to top of frame

    # --- Save Registers and Args ---

    # Save args that need to be persisted
    # arg1 would go to 8($sp)
    # arg2 would go to 12($sp)
    sw      $a2,    16($sp)         # save arg3 to 16($sp)
    # arg4 would go to 20($sp)

    # Save $sX registers used by this function
    addiu   $sp,    $sp,        -12 # allocate space to save $sX registers
    sw      $s3,    0($sp)          # save s3
    sw      $s1,    4($sp)          # save s1
    sw      $s0,    8($sp)          # save s0


    # ... rest of code ...


    # --- Restore Registers ---

    # Restore $sX registers used by this function
    lw      $s3,    0($sp)          # restore s3
    lw      $s1,    4($sp)          # restore s1
    lw      $s0,    8($sp)          # restore s0
    addiu   $sp,    $sp,        12  # deallocate space for $sX registers

    # --- Standard Epilogue ---

    lw      $fp,    0($sp)          # restore fp
    lw      $ra,    4($sp)          # restore ra
    addiu   $sp,    $sp,        24  # deallocate space for args 1-4, ra, and fp
    jr      $ra                     # return


callee2:
    # --- Standard Prologue ---

    addiu   $sp,    $sp,        -24 # allocate space for args 1-4, ra, and fp
    sw      $fp,    0($sp)          # save fp
    sw      $ra,    4($sp)          # save ra
    addiu   $fp,    $sp,        20  # set fp to point to top of frame

    # --- Save Registers and Args ---

    # Save args that need to be persisted
    # arg1 would go to 8($sp)
    # arg2 would go to 12($sp)
    # arg3 would go to 16($sp)
    # arg4 would go to 20($sp)

    # Save $sX registers used by this function
    addiu   $sp,    $sp,        -12 # allocate space to save $sX registers
    sw      $s6,    0($sp)          # save s6
    sw      $s4,    4($sp)          # save s4
    sw      $s2,    8($sp)          # save s2


    # ... rest of code ...


    # --- Restore Registers ---

    # Restore $sX registers used by this function
    lw      $s6,    0($sp)          # restore s6
    lw      $s4,    4($sp)          # restore s4
    lw      $s2,    8($sp)          # restore s2
    addiu   $sp,    $sp,        12  # deallocate space for $sX registers

    # --- Standard Epilogue ---

    lw      $fp,    0($sp)          # restore fp
    lw      $ra,    4($sp)          # restore ra
    addiu   $sp,    $sp,        24  # deallocate space for args 1-4, ra, and fp
    jr      $ra                     # return

callee3:
    # --- Standard Prologue ---

    addiu   $sp,    $sp,        -32 # allocate space for args 1-4, ra, and fp, and two extra args
    sw      $fp,    0($sp)          # save fp
    sw      $ra,    4($sp)          # save ra
    addiu   $fp,    $sp,        28  # set fp to point to top of frame

    # --- Save Registers and Args ---

    # Save args that need to be persisted
    sw      $a0,    8($sp)          # save arg1
    sw      $a1,    12($sp)         # save arg2
    sw      $a2,    16($sp)         # save arg3
    sw      $a3,    20($sp)         # save arg4

    # Save $sX registers used by this function
    addiu   $sp,    $sp,        -8  # allocate space to save $sX registers
    sw      $s1,    0($sp)          # save s1
    sw      $s0,    4($sp)          # save s0


    # ... rest of code ...


    # --- Restore Registers ---

    # Restore $sX registers used by this function
    lw      $s1,    0($sp)          # restore s1
    lw      $s0,    4($sp)          # restore s0
    addiu   $sp,    $sp,        8   # deallocate space for $sX registers

    # --- Standard Epilogue ---

    lw      $fp,    0($sp)          # restore fp
    lw      $ra,    4($sp)          # restore ra
    addiu   $sp,    $sp,        32  # deallocate space for args 1-4, ra, and fp, and two extra args
    jr      $ra                     # return


callee4:
    # --- Standard Prologue ---

    addiu   $sp,    $sp,        -28 # allocate space for args 1-4, ra, and fp, and one extra arg
    sw      $fp,    0($sp)          # save fp
    sw      $ra,    4($sp)          # save ra
    addiu   $fp,    $sp,        24  # set fp to point to top of frame

    # --- Save Registers and Args ---

    # Save args that need to be persisted
    sw      $a1,    12($sp)         # save arg2

    # Save $sX registers used by this function
    addiu   $sp,    $sp,        -4  # allocate space to save $sX registers
    sw      $s1,    0($sp)          # save s1


    # ... rest of code ...


    # --- Restore Registers ---

    # Restore $sX registers used by this function
    lw      $s1,    0($sp)          # restore s1

    # --- Standard Epilogue ---

    lw      $fp,    0($sp)          # restore fp
    lw      $ra,    4($sp)          # restore ra
    addiu   $sp,    $sp,        28  # deallocate space for args 1-4, ra, and fp, and one extra arg
    jr      $ra                     # return