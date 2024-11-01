/**
 * @file sim4.c
 * @brief Simulates a MIPS processor with a 32-bit instruction set.
 * @author Christian Byrne
 * @date 2024-11-01
 *
 * Modifications made to the standard design:
 *  cpu control bits:
 *    extra1: asserted -> load/store bytes instead of words
 *    extra2: asserted -> don't sign extend immediate values
 */

#include <stdio.h>
#include <stdbool.h>
#include "sim4.h"

/**
 * @brief Extracts the fields from a given instruction.
 *
 * This function takes a 32-bit instruction and extracts its various fields,
 * storing them in the provided InstructionFields structure.
 *
 * @param instruction The 32-bit instruction to be decoded.
 * @param fieldsOut Pointer to an InstructionFields structure where the extracted fields will be stored.
 */
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut)
{
  fieldsOut->opcode = (instruction >> 26) & 0x3F;
  fieldsOut->rs = (instruction >> 21) & 0x1F;
  fieldsOut->rt = (instruction >> 16) & 0x1F;
  fieldsOut->rd = (instruction >> 11) & 0x1F;
  fieldsOut->shamt = (instruction >> 6) & 0x1F;
  fieldsOut->funct = instruction & 0x3F;
  fieldsOut->imm16 = instruction & 0xFFFF;
  fieldsOut->imm32 = signExtend16to32(fieldsOut->imm16);
  fieldsOut->address = instruction & 0x3FFFFFF;
}

/**
 * @brief the CPUControl structure based on the provided instruction fields.
 *
 * Handles the following instructions:
 *  | Instruction | Opcode | Function | Type |
 *  |-------------|--------|----------|------|
 *  | addu        | 000000 | 100001   | R    |
 *  | sub         | 000000 | 100010   | R    |
 *  | subu        | 000000 | 100011   | R    |
 *  | addi        | 001000 |          | I    |
 *  | addiu       | 001001 |          | I    |
 *  | and         | 000000 | 100100   | R    |
 *  | or          | 000000 | 100101   | R    |
 *  | xor         | 000000 | 100110   | R    |
 *  | slt         | 000000 | 101010   | R    |
 *  | slti        | 001010 |          | I    |
 *  | lw          | 100011 |          | I    |
 *  | sw          | 101011 |          | I    |
 *  | beq         | 000100 |          | I    |
 *  | j           | 000010 |          | J    |
 *
 * @param fields A pointer to the InstructionFields structure containing the parsed instruction fields.
 * @param controlOut A pointer to the CPUControl structure that will be filled based on the instruction fields.
 * @return An integer indicating the success or failure of the operation.
 */
int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut)
{
  switch (fields->opcode)
  {
  case 0x00:
    switch (fields->funct)
    {
    // add
    case 0x20:
      controlOut->ALU.op = 0x02;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // addu
    case 0x21:
      controlOut->ALU.op = 0x02;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // sub
    case 0x22:
      controlOut->ALU.op = 0x02;
      controlOut->ALU.bNegate = 1;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // subu
    case 0x23:
      controlOut->ALU.op = 0x02;
      controlOut->ALU.bNegate = 1;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // and
    case 0x24:
      controlOut->ALU.op = 0x00;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // or
    case 0x25:
      controlOut->ALU.op = 0x01;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // xor
    case 0x26:
      controlOut->ALU.op = 0x04;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // nor
    case 0x27:
      controlOut->ALU.op = 0x05;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    // slt
    case 0x2A:
      controlOut->ALU.op = 0x03;
      controlOut->ALU.bNegate = 1;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      return 1;
    default:
      return 0;
    }
    break;
  // j
  case 0x02:
    controlOut->ALU.op = 0x00;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 0;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->branch = 0;
    controlOut->jump = 1;
    return 1;
  // beq
  case 0x04:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 1;
    controlOut->ALUsrc = 0;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->branch = 1;
    controlOut->jump = 0;
    return 1;
  // addi
  case 0x08:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    return 1;
  // addiu
  case 0x09:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    return 1;
  // slti
  case 0x0A:
    controlOut->ALU.op = 0x03;
    controlOut->ALU.bNegate = 1;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    return 1;
  // andi
  case 0x0c:
    controlOut->ALU.op = 0x00;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra2 = 1;
    return 1;
  // ori
  case 0x0d:
    controlOut->ALU.op = 0x01;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra2 = 1;
    return 1;
  // xori
  case 0x0e:
    controlOut->ALU.op = 0x04;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra2 = 1;
    return 1;
  // lui
  case 0x0f:
    controlOut->ALU.op = 0x01;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra1 = 1;
    // controlOut->extra2 = 1;
    return 1;
  // lb
  case 0x20:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 1;
    controlOut->memWrite = 0;
    controlOut->memToReg = 1;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra1 = 1;
    return 1;
  // lw
  case 0x23:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 1;
    controlOut->memWrite = 0;
    controlOut->memToReg = 1;
    controlOut->regDst = 0;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra1 = 0;
    return 1;
  // sb
  case 0x28:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 1;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra1 = 1;
    return 1;
  // sw
  case 0x2B:
    controlOut->ALU.op = 0x02;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 1;
    controlOut->memRead = 0;
    controlOut->memWrite = 1;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra1 = 0;
    return 1;
  default:
    return 0;
  }
}

/**
 * Retrieves the instruction from the instruction memory at the given program counter (PC).
 *
 * @param curPC The current program counter, which is byte-addressed.
 * @param instructionMemory A pointer to the array of instructions (instruction memory).
 * @return The instruction located at the index derived from the program counter.
 *
 * @note The program counter (PC) is byte-addressed, while the instruction memory is an array of words.
 *       Therefore, the PC needs to be shifted right by 2 bits to convert it to a word index.
 */
WORD getInstruction(WORD curPC, WORD *instructionMemory)
{
  // shift the byte-addressed PC right by 2 to get the index in the word array.
  return instructionMemory[curPC >> 2];
}

/**
 * Retrieves the first ALU operand based on the given inputs.
 *
 * The first ALU operand is always the value in the rs field of the instruction,
 * which is provided by the first register file output (Read data 1).
 *
 * @param controlIn Pointer to the CPUControl structure containing control signals.
 * @param fieldsIn Pointer to the InstructionFields structure containing instruction fields.
 * @param rsVal Value from the rs field of the instruction.
 * @param rtVal Value from the rt field of the instruction.
 * @param reg32 Value from register 32.
 * @param reg33 Value from register 33.
 * @param oldPC Value of the old program counter.
 * @return The value in the rs field of the instruction.
 */
WORD getALUinput1(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC)
{
  // The 1st ALU operand comes from the first register file output (Read data 1).
  // It is always the value in the rs field of the instruction.
  return rsVal;
}

/**
 * Retrieves the second input for the ALU based on the control signals.
 *
 * @param controlIn Pointer to the CPUControl structure containing control signals.
 * @param fieldsIn Pointer to the InstructionFields structure containing instruction fields.
 * @param rsVal Value of the first source register.
 * @param rtVal Value of the second source register.
 * @param reg32 Value of the register 32.
 * @param reg33 Value of the register 33.
 * @param oldPC Value of the old program counter.
 * @return The second input for the ALU, which is either the value of the second source register
 *         or the sign-extended immediate value from the instruction, depending on the ALUsrc control signal.
 */
WORD getALUinput2(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC)
{
  switch (controlIn->ALUsrc)
  {
  case 0:
    // When ALUsrc deasserted, the 2nd ALU operand comes from the second register
    // file output (Read data 2).
    return rtVal;
  case 1:
    // When ALUsrc asserted, the 2nd ALU operand is the sign-extended, lower
    // 16 bits of the instruction.
    return controlIn->extra2 ? fieldsIn->imm16 : fieldsIn->imm32;
  }
}

/**
 * @brief Executes the ALU operation based on the control signals and inputs.
 *
 * This function performs an ALU operation specified by the control signals
 * on the given inputs and stores the result in the provided ALUResult structure.
 *
 * @param controlIn Pointer to the CPUControl structure containing the ALU control signals.
 * @param input1 The first input operand for the ALU operation.
 * @param input2 The second input operand for the ALU operation.
 * @param aluResultOut Pointer to the ALUResult structure where the result will be stored.
 *
 * The function supports the following ALU operations:
 * - AND (controlIn->ALU.op == 0x00)
 * - OR (controlIn->ALU.op == 0x01)
 * - ADD (controlIn->ALU.op == 0x02)
 * - SLT (Set on Less Than) (controlIn->ALU.op == 0x03)
 * - XOR (controlIn->ALU.op == 0x04)
 *
 * If the bNegate flag in the control signals is set, the second input operand
 * is negated before performing the operation.
 *
 * The result of the operation is stored in aluResultOut->result.
 * The zero flag (aluResultOut->zero) is set to 1 if the result is zero, otherwise it is set to 0.
 * The extra field (aluResultOut->extra) is currently unused and set to 0.
 */
void execute_ALU(CPUControl *controlIn,
                 WORD input1, WORD input2,
                 ALUResult *aluResultOut)
{
  // Negate the second input operand if the bNegate flag is set.
  if (controlIn->ALU.bNegate)
  {
    input2 = ~input2 + 0b1;
  }

  switch (controlIn->ALU.op)
  {
  // and
  case 0x00:
    aluResultOut->result = input1 & input2;
    aluResultOut->extra = 0;
    break;
  // or
  case 0x01:
    aluResultOut->result = input1 | input2;
    aluResultOut->extra = 0;
    break;
  // add
  case 0x02:
    aluResultOut->result = input1 + input2;
    aluResultOut->extra = 0;
    break;
  // slt
  case 0x03:
    aluResultOut->result = input1 + input2 < 0 ? 1 : 0;
    aluResultOut->extra = 0;
    break;
  // xor
  case 0x04:
    aluResultOut->result = input1 ^ input2;
    aluResultOut->extra = 0;
    break;
  // nor
  case 0x05:
    aluResultOut->result = ~(input1 | input2);
    aluResultOut->extra = 0;
  }

  // The zero flag is set to 1 if the result is zero, otherwise it is set to 0.
  aluResultOut->zero = aluResultOut->result == 0 ? 1 : 0;
}

/**
 * @brief Executes the memory access stage of the CPU pipeline.
 *
 * This function performs memory read and write operations based on the control signals.
 * If the memRead control signal is asserted, it reads a value from memory at the address
 * specified by the ALU result and stores it in the resultOut structure. If the memWrite
 * control signal is asserted, it writes the value of rtVal to the memory at the address
 * specified by the ALU result.
 *
 * @param controlIn Pointer to the CPU control signals.
 * @param aluResultIn Pointer to the ALU result structure.
 * @param rsVal Value of the source register (not used in this function).
 * @param rtVal Value of the target register, used for memory write operations.
 * @param memory Pointer to the memory array.
 * @param resultOut Pointer to the structure where the memory read result will be stored.
 */
void execute_MEM(CPUControl *controlIn,
                 ALUResult *aluResultIn,
                 WORD rsVal, WORD rtVal,
                 WORD *memory,
                 MemResult *resultOut)
{
  // If memWrite asserted, write rtVal to address calculated by ALU.
  if (controlIn->memWrite && !controlIn->memRead)
  {
    switch (controlIn->extra1)
    {
    case 0:
      // For operations w/ addresses, rt val will hold the value to be stored.
      memory[aluResultIn->result >> 2] = rtVal;
      break;
    case 1: // if extra1 asserted, use byte instead of word.
      WORD wordAtAddress = memory[aluResultIn->result >> 2];
      // The last 2 bits of the calculated address will indicate which byte to
      // extract from the loaded word.
      WORD byteIndex = aluResultIn->result & 0x3;

      // Create a mask to zero out the location in the word where the byte will
      // be inserted.
      int shiftCount;
      WORD byteMask;
      switch (byteIndex)
      {
      case 0b00:
        byteMask = 0xFFFFFF00;
        shiftCount = 0;
        break;
      case 0b01:
        byteMask = 0xFFFF00FF;
        shiftCount = 1;
        break;
      case 0b10:
        byteMask = 0xFF00FFFF;
        shiftCount = 2;
        break;
      case 0b11:
        byteMask = 0x00FFFFFF;
        shiftCount = 3;
        break;
      }

      // Shift the byte to the correct position in the word.
      WORD shiftedByte = rtVal << (shiftCount * 8);

      // Insert the byte into the word.
      WORD wordWithByteInserted = (wordAtAddress & byteMask) | shiftedByte;

      // Write the word back to memory.
      memory[aluResultIn->result >> 2] = wordWithByteInserted;
    }
  }

  // If memRead asserted, get value at address calculated by ALU, otherwise 0.
  if (controlIn->memRead)
  {
    WORD wordAtAddress = memory[aluResultIn->result >> 2];
    switch (controlIn->extra1)
    {
    case 0:
      // printf("Reading word at address %d: %d\n", aluResultIn->result >> 2, wordAtAddress);
      resultOut->readVal = wordAtAddress;
      break;
    case 1: // if extra1 is asserted, use byte instead of word.
      // The last 2 bits of the calculated address will indicate which byte to
      // extract from the loaded word.
      WORD byteIndex = aluResultIn->result & 0x3;

      int shiftCount;
      switch (byteIndex)
      {
      case 0b00:
        shiftCount = 0;
        break;
      case 0b01:
        shiftCount = 1;
        break;
      case 0b10:
        shiftCount = 2;
        break;
      case 0b11:
        shiftCount = 3;
        break;
      }

      // Extract the byte from the word by shifting the word right by the
      // byte index * 8 (byte size).
      WORD byteAtAddress = (wordAtAddress >> (shiftCount * 8)) & 0xFF;

      // Sign-extend if negative.
      bool isNegative = byteAtAddress & 0x80 != 0;
      resultOut->readVal = isNegative ? byteAtAddress | 0xFFFFFF00 : byteAtAddress;
    }
  }
  else
  {
    // Set readVal to 0 when nothing happens.
    resultOut->readVal = 0;
  }
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC)
{
  // Add 4 (bytes) to the old PC to get the next instruction address.
  WORD oldPCPlus4 = oldPC + 0b0100;

  if (controlIn->branch && aluZero)
  {
    // Branch instructions use a 16-bit instruction offset field, allowing
    // jumps up to ±2^15 instructions from the current PC.

    // Shift offset (from the immediate field) left by 2 to get word offset.
    // (Since instructions in MIPS are 4 bytes long.)
    WORD wordOffset = fields->imm16 << 2;

    // Add the word offset to the old PC+4 to get the new PC.
    return oldPCPlus4 + wordOffset;
  }
  else if (controlIn->jump)
  {
    // In jump instructions, upper 4 bits of the target adress come from PC+4.
    WORD upperFourPC = oldPCPlus4 & 0xF0000000;

    // The address field is the lower 26 bits of the instruction.
    // Shift left 2 to get the word address. 28 bits total.
    WORD wordAddress = fields->address << 2;

    // Combine upper 4 bits of PC+4 with the 28 bits (lower 26 bits shifted
    // left twice) of instruction.
    return upperFourPC + wordAddress;
  }

  return oldPC + 0b0100;
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult *aluResultIn, MemResult *memResultIn,
                        WORD *regs)
{
  int registerDestinationNumber;

  // Determine register destination number based on the regDst control signal.
  switch (controlIn->regDst)
  {
  case 1:
    // When regDst is asserted, the register destination number for the write
    // register comes from the rd field (bits 15:11).
    registerDestinationNumber = fields->rd;
    break;
  case 0:
    // When regDst is deasserted, the register destination number for the
    // write register comes from the rt field (bits 20:16).
    registerDestinationNumber = fields->rt;
  }

  if (controlIn->memToReg) // If memToReg, write value from memory.
  {
    regs[registerDestinationNumber] = memResultIn->readVal;
  }
  else if (controlIn->regWrite) // If regWrite and not memToReg, write ALU result.
  {
    // If extra1 is asserted, load the lower halfword of ALU result (imm16 + 0)
    // into the upper halfword of the register.
    if (controlIn->extra1)
    {
      regs[registerDestinationNumber] = (aluResultIn->result << 16) & 0xFFFF0000;
    }
    else
    {
      regs[registerDestinationNumber] = aluResultIn->result;
    }
  }
}