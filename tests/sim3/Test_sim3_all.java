public class Test_sim3_all {
  static class Bits {
    public static String AND = "000";
    public static String OR = "001";
    public static String ADD = "010";
    public static String LESS = "011";
    public static String XOR = "100";

    public String toOperation() {
      switch (this.bits) {
        case "000":
          return "&";
        case "001":
          return "|";
        case "010":
          return "+";
        case "011":
          return "<";
        case "100":
          return "^";
        default:
          return "UNKNOWN OPERATION";
      }
    }

    private String bits;

    public Bits(String bits) {
      this.bits = bits;
    }

    public boolean nthBit(int n) {
      return (this.bits.charAt(this.bits.length() - 1 - n) == '1');
    }

    /**
     * Converts the object into RussWire[] representation
     * 
     * @return
     */
    public RussWire[] asRussWire() {
      RussWire[] rw = new RussWire[this.bits.length()];
      for (int i = 0, n = this.bits.length(); i < n; ++i) {
        rw[i] = new RussWire();
        rw[i].set(this.nthBit(i));
      }
      return rw;
    }

    /**
     * Copies the bits into some RussWire[] called `russWires`
     * 
     * @param russWires
     */
    public void into(RussWire[] russWires) {
      for (int i = 0, n = this.bits.length(); i < n; ++i) {
        russWires[i].set(this.nthBit(i));
      }
    }

    @Override
    public String toString() {
      return this.bits;
    }

    public static Bits valueOf(long n) {
      StringBuilder a = new StringBuilder();
      while (n > 0) {
        if ((n & 1) == 1) {
          a.append('1');
        } else {
          a.append('0');
        }
        n >>= 1;
      }
      return new Bits(a.reverse().toString());
    }

    public static Bits valueOf(long n, int length) {
      StringBuilder a = new StringBuilder();
      for (int i = 0; i < length; ++i) {
        if ((n & 1) == 1) {
          a.append('1');
        } else {
          a.append('0');
        }
        n >>= 1;
      }
      return new Bits(a.reverse().toString());
    }

    public static Bits valueOf(RussWire[] russWires) {
      StringBuilder a = new StringBuilder();
      for (int i = 0; i < russWires.length; ++i) {
        if (russWires[i].get()) {
          a.append('1');
        } else {
          a.append('0');
        }
      }
      return new Bits(a.reverse().toString());
    }

    public String getOpCode() {
      switch (this.bits) {
        case "000":
          return "AND";
        case "001":
          return "OR";
        case "010":
          return "ADD";
        case "011":
          return "LESS";
        case "100":
          return "XOR";
        default:
          return "UNKNOWN OPERATION";
      }
    }

    public int toSignedInteger() {
      int k = 0;
      for (int i = 0, n = this.bits.length(); i < n; ++i) {
        if (this.bits.charAt(i) == '1') {
          k |= 1 << (n - 1 - i);
        }
      }
      if (this.bits.charAt(0) == '1') {
        return k - (1 << this.bits.length());
      }
      return k;
    }

    public int toUnsignedInteger() {
      int k = 0;
      for (int i = 0, n = this.bits.length(); i < n; ++i) {
        if (this.bits.charAt(i) == '1') {
          k |= 1 << (n - 1 - i);
        }
      }
      return k;
    }
  }

  public static void testMux(String in, String ctrl) {
    Bits input = new Bits(in), control = new Bits(ctrl);
    Sim3_MUX_8by1 mux = new Sim3_MUX_8by1();
    control.into(mux.control);
    input.into(mux.in);
    mux.execute();
    System.out.println();
    System.out.println("--------------------------------");
    System.out.println("MUX_8by1 test\n");
    System.out.println("FORMAT:\t\t\t[ INPUT | CONTROL ] = OUTPUT\n");
    System.out.printf("ENCODED INSTRUCTION:\t[ %s | %s ] = %s\n", input, control, mux.out.get() ? 1 : 0);
    System.out.printf("READABLE INSTRUCTION:\t[ %s | %s ] = %s\n", input, control.getOpCode(), mux.out.get() ? 1 : 0);
    System.out.println("--------------------------------");
    System.out.println();
  }

  public static void testALUElement(String aluOp, boolean a, boolean b, boolean carryIn, boolean bInvert,
      boolean less) {
    Bits aluOpBits = new Bits(aluOp);
    Sim3_ALUElement el = new Sim3_ALUElement();
    el.a.set(a);
    el.b.set(b);
    el.carryIn.set(carryIn);
    el.bInvert.set(bInvert);
    aluOpBits.into(el.aluOp);
    el.execute_pass1();
    el.less.set(less && (el.addResult.get()));
    el.execute_pass2();

    System.out.printf("ENCODED INSTRUCTION:\t%s\t%s %s %s = %d\t\t%d\t%d\t\t%d\t\t%d\n", aluOpBits, a ? "1" : "0",
        aluOpBits.toOperation(),
        b ? "1" : "0",
        el.result.get() ? 1 : 0, el.carryIn.get() ? 1 : 0, el.carryOut.get() ? 1 : 0, el.addResult.get() ? 1 : 0,
        el.less.get() ? 1 : 0);
    System.out.printf("READABLE INSTRUCTION:\t%s\t%s %s %s = %d\t\t%d\t%d\t\t%d\t\t%d\n", aluOpBits.getOpCode(),
        a ? "1" : "0",
        aluOpBits.toOperation(),
        b ? "1" : "0",
        el.result.get() ? 1 : 0, el.carryIn.get() ? 1 : 0, el.carryOut.get() ? 1 : 0, el.addResult.get() ? 1 : 0,
        el.less.get() ? 1 : 0);
    System.out.println();
  }

  // Only works for LESS and ADD
  // Automatic bInvert for when b is negative
  public static void testALU_autoBInvert(String aluOp, long a, long b, int size) {
    long copyA = a, copyB = (b < 0 && !aluOp.equals(Bits.LESS)) ? -b : b;
    Bits aluOpBits = new Bits(aluOp), aBits = Bits.valueOf(a, size), bBits = Bits.valueOf(b, size);

    Sim3_ALU alu = new Sim3_ALU(size);
    for (int i = 0; i < size; ++i) {
      alu.a[i].set(((copyA >> i) & 1) == 1);
      alu.b[i].set(((copyB >> i) & 1) == 1);
    }
    aluOpBits.into(alu.aluOp);
    alu.bNegate.set(b < 0 || aluOp.equals(Bits.LESS));
    alu.execute();
    Bits resultBits = Bits.valueOf(alu.result);
    System.out.printf("ENCODED:\t%s  %s %s %s = %s\n", aluOpBits, aBits, aluOpBits.toOperation(), bBits, resultBits);
    System.out.printf("ASSEMBLY:\t%s  %d %s %d = %s\n", aluOpBits.getOpCode(), a, aluOpBits.toOperation(), b,
        resultBits.toSignedInteger());
    if (aluOp.equals(Bits.LESS)) {
      System.out.printf("\t\t      %d - %s < 0\n", a, copyB < 0 ? String.format("(%d)", copyB) : (copyB + ""));
      System.out.printf("\t\t        = %d (%b)\n", a - copyB, a - copyB < 0);
    }
    System.out.println();

  }

  public static void testALU(String aluOp, long a, long b, int size) {
    long copyA = a, copyB = b;
    Bits aluOpBits = new Bits(aluOp), aBits = Bits.valueOf(a, size), bBits = Bits.valueOf(b, size);

    Sim3_ALU alu = new Sim3_ALU(size);
    for (int i = 0; i < size; ++i) {
      alu.a[i].set(((copyA >> i) & 1) == 1);
      alu.b[i].set(((copyB >> i) & 1) == 1);
    }
    aluOpBits.into(alu.aluOp);
    alu.bNegate.set(false);
    alu.execute();
    Bits resultBits = Bits.valueOf(alu.result);
    System.out.printf("ENCODED:\t%s  %s %s %s = %s\n", aluOpBits, aBits, aluOpBits.toOperation(), bBits, resultBits);
    System.out.printf("ASSEMBLY:\t%s  %d %s %d = %s\n", aluOpBits.getOpCode(), a, aluOpBits.toOperation(), b,
        resultBits.toSignedInteger());
    if (aluOp.equals(Bits.LESS)) {
      System.out.printf("\t\t      %d - %s < 0\n", a, copyB < 0 ? String.format("(%d)", copyB) : (copyB + ""));
      System.out.printf("\t\t        = %d (%b)\n", a - copyB, a - copyB < 0);
    }
    System.out.println();

  }

  public static void main(String[] args) {
    // Test basic MUX functionality
    // 8 input, 3 control
    // There are only 5 OP codes: AND, OR, ADD, LESS, XOR
    testMux("00000001", Bits.AND);
    testMux("00000010", Bits.OR);
    testMux("00000100", Bits.ADD);
    testMux("00001000", Bits.LESS);
    testMux("00010000", Bits.XOR);

    // Test MUX with all bits on except the bit we select
    testMux("11111110", Bits.AND);
    testMux("11111101", Bits.OR);
    testMux("11111011", Bits.ADD);
    testMux("11110111", Bits.LESS);
    testMux("11101111", Bits.XOR);

    // Test ALUElement inputs
    System.out.println();
    System.out.println("--------------------------------");
    System.out.println("ALUElement test (basic operations)\n");
    System.out.println("FORMAT:\t\t\tOPCODE\ta ? b = result\t\tcarryIn\tcarryOut\taddResult\tless\n");
    testALUElement(Bits.AND, true, true, false, false, false);
    testALUElement(Bits.OR, true, true, false, false, false);

    testALUElement(Bits.ADD, true, true, false, false, false);

    testALUElement(Bits.LESS, true, true, false, false, false);

    testALUElement(Bits.XOR, true, true, false, false, false);

    System.out.println("--------------------------------");
    System.out.println();
    System.out.println("--------------------------------");
    System.out.println("ALUElement test (add operations)\n");
    System.out.println("FORMAT:\t\t\tOPCODE\ta ? b = result\t\tcarryIn\tcarryOut\taddResult\tless\n");
    testALUElement(Bits.ADD, false, false, false, false, false);
    testALUElement(Bits.ADD, true, false, false, false, false);

    testALUElement(Bits.ADD, false, true, false, false, false);

    testALUElement(Bits.ADD, true, true, false, false, false);

    System.out.println("--------------------------------");
    System.out.println();
    System.out.println("--------------------------------");
    System.out.println("ALUElement test (mixed operations)\n");
    System.out.println("FORMAT:\t\t\tOPCODE\ta ? b = result\t\tcarryIn\tcarryOut\taddResult\tless\n");
    testALUElement(Bits.OR, false, false, false, false, false);
    testALUElement(Bits.XOR, true, false, false, false, false);

    // subtraction 1-0
    testALUElement(Bits.ADD, true, false, true, true, false);

    // subtraction 1-1
    testALUElement(Bits.ADD, true, true, true, true, false);

    // subtraction 0-1
    testALUElement(Bits.ADD, false, true, true, true, false);

    testALUElement(Bits.AND, false, true, false, false, false);

    testALUElement(Bits.LESS, false, true, false, false, true);
    testALUElement(Bits.LESS, false, false, true, true, true);
    testALUElement(Bits.LESS, false, true, true, true, true);

    System.out.println("--------------------------------");
    System.out.println();
    System.out.println("--------------------------------");
    System.out.println("ALU every operation test\n");
    System.out.println("FORMAT:\t\tOPCODE  A ? B = RESULT\n");
    testALU(Bits.AND, 4L, 4L, 8);
    testALU(Bits.AND, 4L, 5L, 8);
    testALU(Bits.AND, 5L, 4L, 8);
    testALU(Bits.AND, Byte.MAX_VALUE, 21, 8);
    testALU(Bits.AND, Byte.MIN_VALUE, 21, 8);
    testALU(Bits.AND, 0, 0, 8);
    testALU(Bits.AND, -1, 69, 8);
    testALU_autoBInvert(Bits.LESS, -1, 69, 8);
    testALU_autoBInvert(Bits.LESS, -1, -1, 8);
    testALU_autoBInvert(Bits.LESS, -1, Byte.MIN_VALUE, 8);
    testALU_autoBInvert(Bits.LESS, 0, 0, 8);
    testALU_autoBInvert(Bits.LESS, 7, 5, 8);
    testALU_autoBInvert(Bits.LESS, 69, 127, 8);
    testALU_autoBInvert(Bits.LESS, -80, 80, 8);
    testALU_autoBInvert(Bits.LESS, -65, 64, 8);
    testALU_autoBInvert(Bits.LESS, -64, 64, 8);
    testALU_autoBInvert(Bits.LESS, Byte.MIN_VALUE, Byte.MAX_VALUE, 8);
    testALU_autoBInvert(Bits.LESS, 1, Byte.MIN_VALUE, 8);
    testALU_autoBInvert(Bits.LESS, Integer.MAX_VALUE, 1, 32);
    testALU_autoBInvert(Bits.LESS, Integer.MIN_VALUE, Integer.MIN_VALUE + 1, 32);
    testALU_autoBInvert(Bits.LESS, Integer.MIN_VALUE, Integer.MAX_VALUE - 1, 32);
    testALU(Bits.LESS, Integer.MIN_VALUE, Integer.MAX_VALUE - 1, 32);
    testALU_autoBInvert(Bits.ADD, Integer.MAX_VALUE, Integer.MIN_VALUE, 32);
    testALU_autoBInvert(Bits.ADD, Integer.MAX_VALUE, Integer.MAX_VALUE, 32);
    testALU_autoBInvert(Bits.ADD, 0, 0, 8);
    testALU_autoBInvert(Bits.ADD, 0, -1, 8);
    testALU_autoBInvert(Bits.ADD, 5, -5, 8);
    testALU(Bits.ADD, 5, -5, 8);
    testALU(Bits.ADD, 0, -1, 8);
    testALU(Bits.OR, -1, 88, 8);
    testALU(Bits.OR, Byte.MAX_VALUE, Byte.MIN_VALUE, 8);
    testALU(Bits.OR, 0xD0D0, 69, 16);
    testALU(Bits.OR, 0, 0, 32);
    testALU(Bits.OR, 0, -1, 16);
    testALU(Bits.XOR, 1, 1, 2);
    testALU(Bits.XOR, 3, 2, 4);
    testALU(Bits.XOR, -1, 127, 8);
    testALU(Bits.XOR, -88, Byte.MAX_VALUE, 8);
    testALU(Bits.XOR, Byte.MAX_VALUE, -1, 8);

    System.out.println("--------------------------------");

  }
}
