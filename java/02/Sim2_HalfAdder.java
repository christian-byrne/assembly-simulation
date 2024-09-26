// NAME: 
//    Christian Byrne
// PROGRAM DESCRIPTION:
//    Implements a half-adder logic gate with two inputs and two outputs. 
// LIMITATIONS:
//    1. no addition except ++ in for loops
//    2. subtraction only for calculating indices in carrying logic or to find the last of the bits in order to calculatie carryOut and over flow (in AdderX)
//    3. no use of == or !=. use logic gates instead
//    4. no if statements, figure out how to do it with logic gates

public class Sim2_HalfAdder {
  public RussWire a, b; // inputs
  public RussWire sum, carry; // output

  public void execute() {
    sum.set(a.get() ^ b.get());
    carry.set(a.get() && b.get());
  }

  /**
   * Sim2_HalfAdder is a class that simulates a half adder circuit.
   * A half adder is a combinational circuit that performs the addition of two
   * bits.
   * It has two inputs, 'a' and 'b', and produces two outputs, 'sum' and 'carry'.
   * 
   * The constructor initializes the wires for the inputs and outputs.
   */
  public Sim2_HalfAdder() {
    // Create the wires
    a = new RussWire();
    b = new RussWire();
    sum = new RussWire();
    carry = new RussWire();
  }
}
