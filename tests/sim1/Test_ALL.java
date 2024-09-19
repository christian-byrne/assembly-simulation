/*
 * Author: Joseph Marbella
 * Description: 52 test cases for sub and add
 */

class Test_ALL {
  public static void print_binary(String prefix, int val) {
    int i;

    System.out.printf("%s", prefix);

    for (i = 31; i >= 0; i--) {
      System.out.printf("%d", (val >> i) & 0x1);

      if (i % 4 == 0 && i != 0)
        System.out.printf(" ");
    }

    System.out.println();
  }

  public static int to_int(RussWire[] data) {
    int result = 0;

    for (byte i = 0; i < 32; ++i) {
      if (data[i].get()) {
        result |= (1 << i);
      }
    }

    return result;
  }

  public static void print_data(int a, int b, Sim1_ADD adder, Sim1_SUB sub) {
    int sum = adder != null ? to_int(adder.sum) : to_int(sub.sum);
    System.out.printf("Decimal:\n");
    System.out.printf("    %11d\n", a);
    System.out.printf("  %c %11d\n", adder == null ? '-' : '+', b);
    System.out.printf(" --------------\n");
    System.out.printf("    %11d\n", sum);
    System.out.printf("  aNonNeg=%d, bNonNeg=%d, sumNonNeg=%d\n", a >= 0 ? 1 : 0, b >= 0 ? 1 : 0,
        adder != null ? ((a + b) >= 0 ? 1 : 0) : ((a - b) >= 0 ? 1 : 0));

    /*
     * This is commented out because not everyone's adder in the SUB class is named
     * "add".
     * Thus, testing for overflow and carryout are omitted. If your adder passes the
     * testAdd cases,
     * then we can assume that the carryOut and overflow will pass these testSub
     * cases as well.
     */

    // System.out.printf(" carryOut=%d\n",
    // adder != null ? (adder.carryOut.get() ? 1 : 0) : (sub.add.carryOut.get() ? 1
    // : 0));
    // System.out.printf(" overflow=%d\n",
    // adder != null ? (adder.overflow.get() ? 1 : 0) : (sub.add.overflow.get() ? 1
    // : 0));

    System.out.printf("\n");

    System.out.printf("Binary:\n");
    print_binary("    ", a);
    print_binary("  + ", adder != null ? b : -b);
    System.out.printf(" -------------------------------------------\n");
    print_binary("    ", sum);
    System.out.printf("\n\n --------------------------------------------------------------------------------------\n");
  }

  public static void testAdd(int a, int b) {
    int aCopy = a, bCopy = b;
    final Sim1_ADD adder = new Sim1_ADD();
    for (byte i = 0; i < 32; ++i) {
      adder.a[i].set((a & 1) != 0);
      adder.b[i].set((b & 1) != 0);
      a >>= 1;
      b >>= 1;
    }
    System.out.println();
    adder.execute();
    print_data(aCopy, bCopy, adder, null);
  }

  public static void testSub(int a, int b) {
    int aCopy = a, bCopy = b;
    final Sim1_SUB sub = new Sim1_SUB();
    for (byte i = 0; i < 32; ++i) {
      sub.a[i].set((a & 1) != 0);
      sub.b[i].set((b & 1) != 0);
      a >>= 1;
      b >>= 1;
    }
    System.out.println();
    sub.execute();
    print_data(aCopy, bCopy, null, sub);
  }

  public static void main(String[] args) {
    testAdd(1, -2);
    testAdd(2, -3);
    testAdd(-3, -3);
    testAdd(Integer.MAX_VALUE, 1);
    testAdd(Integer.MAX_VALUE, Integer.MIN_VALUE);
    testAdd(Integer.MIN_VALUE, -1);
    testAdd(0xCFFFFFFF, 0xCFFFFFFF);
    testAdd(0, -1);
    testAdd(-1, -1);
    testAdd(Integer.MIN_VALUE, -Integer.MIN_VALUE);
    testAdd(0, 0);
    testAdd(Integer.MAX_VALUE, 0);
    testAdd(Integer.MAX_VALUE, Integer.MAX_VALUE);
    testAdd(Integer.MIN_VALUE, 500);
    testAdd(Integer.MAX_VALUE, -Integer.MAX_VALUE);
    testAdd(32, 64);
    testAdd(0xC0000000, 0xC0000000);
    testAdd(3333, 2222);
    testAdd(-3333, 2222);
    testAdd(Integer.MIN_VALUE, 0x80000000);
    testAdd(Integer.MAX_VALUE, -Integer.MIN_VALUE);
    testAdd(Integer.MIN_VALUE, Integer.MAX_VALUE);
    testAdd(-32768, -1);
    testAdd(Integer.MAX_VALUE, 0xFFFFFFFE);
    testAdd(Integer.MAX_VALUE, 0xFFFFFFFF);
    testAdd(Integer.MAX_VALUE, 0xFFFFFFFD);
    testAdd(-3, 5);
    testAdd(-69, 69);
    testAdd(0, 10);
    testAdd(Integer.MAX_VALUE, -2);
    testAdd(-3, Integer.MIN_VALUE);
    testSub(Integer.MAX_VALUE, 1);
    testSub(Integer.MAX_VALUE, Integer.MAX_VALUE);
    testSub(Integer.MAX_VALUE, 0);
    testSub(0, Integer.MAX_VALUE);
    testSub(Integer.MAX_VALUE, -2);
    testSub(-3, Integer.MIN_VALUE);
    testSub(Integer.MAX_VALUE, 1);
    testSub(Integer.MAX_VALUE, 0xFFFFFFFE);
    testSub(Integer.MAX_VALUE, 0xFFFFFFFF);
    testSub(Integer.MAX_VALUE, 0xFFFFFFFD);
    testSub(Integer.MIN_VALUE, -1);
    testSub(Integer.MIN_VALUE, Integer.MAX_VALUE);
    testSub(1, 1);
    testSub(0, 0);
    testSub(-5, 5);
    testSub(-1, 4);
    testSub(1, -1999);
    testSub(0, Integer.MIN_VALUE);
    testSub(55555, 55555);
    testSub(55555, -69);
    testSub(-55555, 69);
    testSub(55555, 666666);
  }
}