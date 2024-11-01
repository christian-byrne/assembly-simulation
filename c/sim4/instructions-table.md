# Standard Instructions

| Instruction | Opcode | Function | Type |
|-------------|--------|----------|------|
| addu        | 000000 | 100001   | R    |
| sub         | 000000 | 100010   | R    |
| subu        | 000000 | 100011   | R    |
| addi        | 001000 |          | I    |
| addiu       | 001001 |          | I    |
| and         | 000000 | 100100   | R    |
| or          | 000000 | 100101   | R    |
| xor         | 000000 | 100110   | R    |
| slt         | 000000 | 101010   | R    |
| slti        | 001010 |          | I    |
| lw          | 100011 |          | I    |
| sw          | 101011 |          | I    |
| beq         | 000100 |          | I    |
| j           | 000010 |          | J    |

# Extra Instructions


> Your implementation for these instructions must match the MIPS architec- ture; you can look each of these up, in Appendix A, to find out exactly how they work.
>
> You must use the opcode that MIPS requires, and do exactly what the MIPS architecture says these instructions do.
>
> However, none of these can be implemented with the standard CPU design that we’ve discussed. Each one needs some sort of small change.
>
> Some can be implemented by adding a new ALU operation, or by adding a new input to an existing MUX; others will require that you add a new MUX, or new logic somewhere in the processor.


| Instruction | Opcode | Function | Type | Group |
|-------------|--------|----------|------|-------|
| andi        | 001100 |          | I    | 1     |
| ori         | 001101 |          | I    | 1     |
| xori        | 001110 |          | I    | 1     |
| nor         | 000000 | 100111   | R    | 1     |
| lui         | 001111 |          | I    | 2     |
| sra         | 000000 | 000111   | R    | 3     |
| srl         | 000000 | 000010   | R    | 3     |
| sll         | 000000 | 000000   | R    | 3     |
| srav        | 000000 | 000111   | R    | 4     |
| srlv        | 000000 | 000010   | R    | 4     |
| sllv        | 000000 | 000000   | R    | 4     |
| bne         | 000101 |          | I    | 5     |
| lb          | 100000 |          | I    | 6     |
| sb          | 101000 |          | I    | 6     |
| mul         | 011100 |          | I    | 7     |
| mult        | 000000 | 011000   | R    | 8     |
| div         | 000000 | 011010   | R    | 8     |
| mfhi        | 000000 | 010000   | R    | 9     |
| mflo        | 000000 | 010010   | R    | 9     |