public class Test_LeetCode {
  private static class BinaryRepr {
    long num;
    String binary;
  }

  private final static byte INTEGER = 32;
  private final static byte BYTE = 8;
  private final static byte LONG = 64;
  private final static byte SHORT = 16;
  private final static byte NIBBLE = 4;
  private final static byte BIT = 1;

  public static void testHalfAdder(boolean a, boolean b) {
    Sim2_HalfAdder ha = new Sim2_HalfAdder();
    ha.a.set(a);
    ha.b.set(b);
    ha.execute();

    // Expected values
    boolean expectedSum = a ^ b;
    boolean expectedCarry = a && b;

    if (ha.sum.get() != expectedSum || ha.carry.get() != expectedCarry) {
      System.out.printf("HALF ADDER(%d+%d):\n", a ? 1 : 0, b ? 1 : 0);
      System.out.printf("\ta=%d,\tb=%d,\tsum=%d,\tcarry=%d\n\n", a ? 1 : 0, b ? 1 : 0, ha.sum.get() ? 1 : 0,
          ha.carry.get() ? 1 : 0);
    }
  }

  private static BinaryRepr getBinaryRepr(RussWire[] wires) {
    StringBuilder result = new StringBuilder();
    BinaryRepr a = new BinaryRepr();
    for (int i = wires.length - 1; i >= 0; --i) {
      int x = wires[i].get() ? 1 : 0;
      if (result.length() % 5 == 0) {
        result.append(" ");
      }
      result.append(x);
      a.num |= (x << i);
    }
    a.binary = result.toString();
    return a;
  }

  private static BinaryRepr getBinaryRepr(long a, byte dataType) {
    BinaryRepr result = new BinaryRepr();
    StringBuilder b = new StringBuilder();
    result.num = a;
    for (int i = 0; i < dataType; ++i) {
      long x = (a & 1);
      if (b.length() % 5 == 0) {
        b.append(" ");
      }
      b.append(x);
      a >>= 1;
    }

    result.binary = " " + b.reverse().toString().strip();

    return result;
  }

  private static long binary2decimal(BinaryRepr a) {
    long result = 0;
    int k = 0;
    for (int i = a.binary.length() - 1; i >= 0; --i) {
      if (a.binary.charAt(i) == ' ')
        continue;
      result |= ((long) (a.binary.charAt(i) - '0')) << k;
      ++k;
    }
    return result;
  }

  public static void testFullAdder(boolean a, boolean b, boolean carryIn) {
    Sim2_FullAdder fa = new Sim2_FullAdder();
    fa.a.set(a);
    fa.b.set(b);
    fa.carryIn.set(carryIn);
    fa.execute();

    // Expected values
    boolean expectedSum = (a ^ b) ^ carryIn;
    boolean expectedCarryOut = (a && b) || (carryIn && (a ^ b));

    if (fa.sum.get() != expectedSum || fa.carryOut.get() != expectedCarryOut) {
      System.out.printf("FULL ADDER(%d+%d+%d):\n", a ? 1 : 0, b ? 1 : 0, carryIn ? 1 : 0);
      System.out.printf("\ta=%d,\tb=%d,\tcarryIn=%d\tsum=%d\tcarryOut=%d\n\n", fa.a.get() ? 1 : 0, fa.b.get() ? 1 : 0,
          fa.carryIn.get() ? 1 : 0,
          fa.sum.get() ? 1 : 0, fa.carryOut.get() ? 1 : 0);
    }
  }

  public static void testAdderX(long a, long b, byte dataType) {
    long aCopy = a, bCopy = b;
    Sim2_AdderX adder = new Sim2_AdderX(dataType);
    for (int i = 0; i < dataType; ++i) {
      adder.a[i].set((aCopy & 1) == 1);
      adder.b[i].set((bCopy & 1) == 1);
      aCopy >>= 1;
      bCopy >>= 1;
    }
    BinaryRepr result = getBinaryRepr(a + b, dataType);
    adder.execute();

    BinaryRepr binaryA = getBinaryRepr(a, dataType);
    BinaryRepr binaryB = getBinaryRepr(b, dataType);
    BinaryRepr test = getBinaryRepr(adder.sum);
    BinaryRepr testB = getBinaryRepr(adder.a);
    BinaryRepr testC = getBinaryRepr(adder.b);

    // Compare the expected result with the student's result
    if (binary2decimal(result) != binary2decimal(test) || adder.overflow.get()) {
      System.out.printf("%d-bit ADDER(%d + %d):\n", dataType, binary2decimal(binaryA), binary2decimal(binaryB));
      System.out.printf("\tNORMAL:  %d + %d = %d\n", binary2decimal(binaryA), binary2decimal(binaryB),
          binary2decimal(result));
      System.out.printf("\tSTUDENT:  %d + %d = %d\n", binary2decimal(testB), binary2decimal(testC),
          binary2decimal(test));
      System.out.printf("\tNORMAL(base2):\n");
      System.out.printf("\t  %s\n", binaryA.binary);
      System.out.printf("\t+ %s\n", binaryB.binary);
      StringBuilder t = new StringBuilder();
      for (int i = 0; i < (int) (dataType * 1.2); ++i) {
        t.append("-");
      }
      System.out.printf("\t   %s\n", t.toString());
      System.out.printf("\t  %s\n\n", result.binary);
      System.out.printf("\tSTUDENT(base2):\n");
      System.out.printf("\t  %s\n", testB.binary);
      System.out.printf("\t+ %s\n", testC.binary);
      System.out.printf("\t   %s\n", t.toString());
      System.out.printf("\t  %s\n\n", test.binary);
      System.out.printf("\t  overflow=%d, carryOut=%d\n", adder.overflow.get() ? 1 : 0, adder.carryOut.get() ? 1 : 0);
    }
  }

  public static void main(String[] args) {
    // Test BYTE (8-bit) addition
    testAdderX(0L, 0L, BYTE); // 0 + 0
    testAdderX(1L, 1L, BYTE); // 1 + 1
    testAdderX(Byte.MAX_VALUE, 1L, BYTE); // 127 + 1 (positive overflow)
    testAdderX(Byte.MIN_VALUE, -1L, BYTE); // -128 - 1 (negative overflow)
    testAdderX(Byte.MIN_VALUE, Byte.MAX_VALUE, BYTE); // -128 + 127
    testAdderX(63L, 64L, BYTE); // 63 + 64 (carry)
    testAdderX(-64L, -63L, BYTE); // -64 - 63 (borrow)

    // Test SHORT (16-bit) addition
    testAdderX(0L, 0L, SHORT); // 0 + 0
    testAdderX(1L, 1L, SHORT); // 1 + 1
    testAdderX(Short.MAX_VALUE, 1L, SHORT); // 32767 + 1 (positive overflow)
    testAdderX(Short.MIN_VALUE, -1L, SHORT); // -32768 - 1 (negative overflow)
    testAdderX(Short.MIN_VALUE, Short.MAX_VALUE, SHORT); // -32768 + 32767
    testAdderX(16383L, 16384L, SHORT); // 16383 + 16384 (carry)
    testAdderX(-16384L, -16383L, SHORT); // -16384 - 16383 (borrow)

    // Test INTEGER (32-bit) addition
    testAdderX(0L, 0L, INTEGER); // 0 + 0
    testAdderX(1L, 1L, INTEGER); // 1 + 1
    testAdderX(Integer.MAX_VALUE, 1L, INTEGER); // 2147483647 + 1 (positive overflow)
    testAdderX(Integer.MIN_VALUE, -1L, INTEGER); // -2147483648 - 1 (negative overflow)
    testAdderX(Integer.MIN_VALUE, Integer.MAX_VALUE, INTEGER); // -2147483648 + 2147483647
    testAdderX(1073741823L, 1073741824L, INTEGER); // 1073741823 + 1073741824 (carry)
    testAdderX(-1073741824L, -1073741823L, INTEGER); // -1073741824 - 1073741823 (borrow)

    // Test LONG (64-bit) addition
    testAdderX(0L, 0L, LONG); // 0 + 0
    testAdderX(1L, 1L, LONG); // 1 + 1
    testAdderX(Long.MAX_VALUE, 1L, LONG); // 9223372036854775807 + 1 (positive overflow)
    testAdderX(Long.MIN_VALUE, -1L, LONG); // -9223372036854775808 - 1 (negative overflow)
    testAdderX(Long.MIN_VALUE, Long.MAX_VALUE, LONG); // -9223372036854775808 + 9223372036854775807
    testAdderX(4611686018427387903L, 4611686018427387904L, LONG); // 4611686018427387903 + 4611686018427387904 (carry)
    testAdderX(-4611686018427387904L, -4611686018427387903L, LONG); // -4611686018427387904 - 4611686018427387903

    // Test NIBBLE (4-bit) addition
    testAdderX(0L, 0L, NIBBLE); // 0 + 0
    testAdderX(1L, 1L, NIBBLE); // 1 + 1
    testAdderX(15L, 1L, NIBBLE); // 15 + 1 (overflow)
    testAdderX(0L, 1L, NIBBLE); // 0 + 1
    testAdderX(7L, 8L, NIBBLE); // 7 + 8

    // Test BIT (1-bit) addition
    testAdderX(0L, 0L, BIT); // 0 + 0
    testAdderX(1L, 0L, BIT); // 1 + 0
    testAdderX(0L, 1L, BIT); // 0 + 1
    testAdderX(1L, 1L, BIT); // 1 + 1 (positive overflow)

    // Half Adders Test Cases
    testHalfAdder(false, false);
    testHalfAdder(false, true);
    testHalfAdder(true, false);
    testHalfAdder(true, true);

    // Full Adders Test Cases
    testFullAdder(false, false, false);
    testFullAdder(false, false, true);
    testFullAdder(false, true, false);
    testFullAdder(false, true, true);
    testFullAdder(true, false, false);
    testFullAdder(true, false, true);
    testFullAdder(true, true, false);
    testFullAdder(true, true, true);
  }
}
