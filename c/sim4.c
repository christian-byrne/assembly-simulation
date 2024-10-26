/**
 * @file sim4.c
 * @brief Simulates a MIPS processor with a 32-bit instruction set.
 * @author Christian Byrne
 * @date 2024-10-25
 */

#include <stdio.h>
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
    }
    break;
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
  default:
    return 0;
  }
}
