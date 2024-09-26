// NAME: 
//    Christian Byrne
// PROGRAM DESCRIPTION:
//    Implements a multi-bit adder using full adders with ripple carry. 
// LIMITATIONS:
//    1. no addition except ++ in for loops
//    2. subtraction only for calculating indices in carrying logic or to find the last of the bits in order to calculatie carryOut and over flow (in AdderX)
//    3. no use of == or !=. use logic gates instead
//    4. no if statements, figure out how to do it with logic gates

public class Sim2_AdderX {
  public RussWire[] a, b; // inputs
  public RussWire[] sum; // output
  public RussWire carryOut, overflow; // output

  public Sim2_FullAdder[] fullAdders;

  public void execute() {

    // Initialize carryIn for the least significant bit (bit 0).
    boolean carryIn = false;
    for (int i = 0; i < a.length; i++) {
      fullAdders[i].a.set(a[i].get());
      fullAdders[i].b.set(b[i].get());
      fullAdders[i].carryIn.set(carryIn);
      fullAdders[i].execute();
      sum[i].set(fullAdders[i].sum.get());
      carryIn = fullAdders[i].carryOut.get();
    }

    // Set the final carryOut after the loop ends
    carryOut.set(carryIn);

    // Overflow occurs when the sign of the result does not match the sign of the
    // inputs.
    boolean a_sign = a[a.length - 1].get();
    boolean b_sign = b[b.length - 1].get();
    boolean sum_sign = sum[sum.length - 1].get();

    boolean overflow_bit = (a_sign && b_sign && !sum_sign) || (!a_sign && !b_sign && sum_sign);
    overflow.set(overflow_bit);
  }

  /**
   * Sim2_AdderX is a class that represents an X-bit adder.
   * It initializes the necessary wires and full adders to perform
   * the addition of two X-bit binary numbers.
   *
   * @param X the number of bits for the adder
   */
  public Sim2_AdderX(int X) {
    // Create the wires
    a = new RussWire[X];
    b = new RussWire[X];
    sum = new RussWire[X];

    for (int i = 0; i < X; i++) {
      a[i] = new RussWire();
      b[i] = new RussWire();
      sum[i] = new RussWire();
    }

    // Create the output bits
    carryOut = new RussWire();
    overflow = new RussWire();

    // Create the full adders
    fullAdders = new Sim2_FullAdder[X];
    for (int i = 0; i < X; i++) {
      fullAdders[i] = new Sim2_FullAdder();
    }

  }
}