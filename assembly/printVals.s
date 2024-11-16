    # Print current bytes
    la      $a0,                cbStr1                  # a0 = &cbStr1
    addi    $v0,                $zero,          4       # v0 = 4 (print string syscall code)
    syscall                                             # print string

    add     $a0,                $t0,            $zero   # a0 = current byte of array
    addi   $v0,                $zero,          11      # v0 = 11 (print char syscall code)
    syscall                                             # print char

    la      $a0,                cbStr2                  # a0 = &cbStr2
    addi    $v0,                $zero,          4       # v0 = 4 (print string syscall code)
    syscall                                             # print string

    add     $a0,                $t1,            $zero   # a0 = current byte of subarray
    addi    $v0,                $zero,          11      # v0 = 11 (print char syscall code)
    syscall                                             # print char