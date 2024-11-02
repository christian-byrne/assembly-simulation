int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut)
{
  switch (fields->opcode)
  {
  case 0x00:
    switch (fields->funct)
    {
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
    // mfhi (move from hi)
    case 0x10:
      controlOut->ALU.op = 0x08;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      controlOut->extra1 = 1;
      controlOut->extra3 = 1;
      controlOut->extra2 = 0;
      return 1;
    // mflo (move from lo)
    case 0x12:
      controlOut->ALU.op = 0x08;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 1;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      controlOut->extra1 = 0;
      controlOut->extra3 = 1;
      controlOut->extra2 = 0;
      return 1;
    // mult
    case 0x18:
      controlOut->ALU.op = 0x07;
      controlOut->ALU.bNegate = 0;
      controlOut->ALUsrc = 0;
      controlOut->memRead = 0;
      controlOut->memWrite = 0;
      controlOut->memToReg = 0;
      controlOut->regDst = 0;
      controlOut->regWrite = 1;
      controlOut->branch = 0;
      controlOut->jump = 0;
      controlOut->extra2 = 1;
      controlOut->extra3 = 1;
      controlOut->extra1 = 0;
      return 1;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
    return 1;
  // bne
  case 0x05:
    controlOut->ALU.op = 0x06;
    controlOut->ALU.bNegate = 1;
    controlOut->ALUsrc = 0;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 0;
    controlOut->regWrite = 0;
    controlOut->branch = 1;
    controlOut->jump = 0;
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
    controlOut->extra2 = 1;
      controlOut->extra1 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra1 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
    return 1;
  // mul
  case 0x1c:
    controlOut->ALU.op = 0x07;
    controlOut->ALU.bNegate = 0;
    controlOut->ALUsrc = 0;
    controlOut->memRead = 0;
    controlOut->memWrite = 0;
    controlOut->memToReg = 0;
    controlOut->regDst = 1;
    controlOut->regWrite = 1;
    controlOut->branch = 0;
    controlOut->jump = 0;
    controlOut->extra1 = 0;
    controlOut->extra2 = 1;
    controlOut->extra3 = 1;
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
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
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
      controlOut->extra2 = 0;
      controlOut->extra3 = 0;
    return 1;
  default:
    return 0;
  }
}