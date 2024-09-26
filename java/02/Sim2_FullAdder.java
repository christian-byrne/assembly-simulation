// NAME: 
//    Christian Byrne
// PROGRAM DESCRIPTION:
//    Implements a full-adder by chaining two half-adders together. 
// LIMITATIONS:
//    1. no addition except ++ in for loops
//    2. subtraction only for calculating indices in carrying logic or to find the last of the bits in order to calculatie carryOut and over flow (in AdderX)
//    3. no use of == or !=. use logic gates instead
//    4. no if statements, figure out how to do it with logic gates

public class Sim2_FullAdder {
  public RussWire carryIn, a, b; // inputs
  public RussWire sum, carryOut; // outputs

  public Sim2_HalfAdder primaryHalfAdder;
  public Sim2_HalfAdder carryHalfAdder;

  public void execute() {
    primaryHalfAdder.a.set(a.get());
    primaryHalfAdder.b.set(b.get());
    primaryHalfAdder.execute();

    carryHalfAdder.a.set(primaryHalfAdder.sum.get());
    carryHalfAdder.b.set(carryIn.get());
    carryHalfAdder.execute();

    sum.set(carryHalfAdder.sum.get());
    carryOut.set(primaryHalfAdder.carry.get() || carryHalfAdder.carry.get());
  }

  /**
   * Sim2_FullAdder is a class that simulates a full adder circuit using two half
   * adders.
   * It takes two input bits (a and b) and a carry-in bit, and produces a sum bit
   * and a carry-out bit.
   * 
   * The constructor initializes the necessary wires and creates two half adder
   * instances.
   * 
   * Wires:
   * - carryIn: The carry-in bit for the full adder.
   * - a: The first input bit.
   * - b: The second input bit.
   * - sum: The resulting sum bit.
   * - carryOut: The resulting carry-out bit.
   * 
   * Half Adders:
   * - primaryHalfAdder: The first half adder used in the full adder.
   * - carryHalfAdder: The second half adder used in the full adder.
   */
  public Sim2_FullAdder() {
    // Create the wires
    carryIn = new RussWire();
    a = new RussWire();
    b = new RussWire();
    sum = new RussWire();
    carryOut = new RussWire();

    // Create the half adders
    primaryHalfAdder = new Sim2_HalfAdder();
    carryHalfAdder = new Sim2_HalfAdder();
  }
}