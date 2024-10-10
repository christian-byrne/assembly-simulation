/**
 * NAME: Christian P. Byrne
 * DATE: 2024-10-09
 * DESC: Simulates an n-bit Arithmetic Logic Unit (ALU) using an array of ALU
 * elements. The ALU can perform various operations like AND, OR, ADD,
 * LESS, and XOR based on a 3-bit operation code (`aluOp`)
 */

/**
 * Represents an n-bit Arithmetic Logic Unit (ALU) using an array of ALU
 * elements.
 */
public class Sim3_ALU {

  // Array of ALU elements, one for each bit of the inputs
  public Sim3_ALUElement[] aluElements;

  // Inputs
  public RussWire[] aluOp; // 3-bit ALU operation input, element 0 is the LSB
  public RussWire bNegate; // Negate the B input flag for subtraction
  public RussWire[] a; // n-bit input A
  public RussWire[] b; // n-bit input B

  // Outputs
  public RussWire[] result; // n-bit output result of the ALU operations

  /**
   * Executes the ALU operations by iterating through all ALU elements.
   * Handles the carry propagation between bits and sets the final result.
   */
  public void execute() {
    // Initialize the carry-in based on the bNegate flag (used for subtraction).
    boolean curCarryIn = bNegate.get();
    boolean addResult = false;

    // Execute each ALU element's first pass.
    for (int i = 0; i < aluElements.length; i++) {
      // Set the ALU operation code for the current element.
      for (int j = 0; j < aluOp.length; j++) {
        aluElements[i].aluOp[j].set(aluOp[j].get());
      }

      // Set the other inputs for the ALU element.
      aluElements[i].bInvert.set(bNegate.get());
      aluElements[i].a = a[i];
      aluElements[i].b = b[i];

      // Set the carry-in from the previous element's carry-out.
      aluElements[i].carryIn.set(curCarryIn);

      // Execute the first pass for the current ALU element.
      aluElements[i].execute_pass1();

      // Update the carry-in for the next element and store the add result.
      curCarryIn = aluElements[i].carryOut.get();
      addResult = aluElements[i].addResult.get();
    }

    // Set the `less` input of the least significant bit (LSB) to the add result of
    // the MSB.
    aluElements[0].less.set(addResult);

    // Set the `less` inputs of all other ALU elements to false.
    for (int i = 1; i < aluElements.length; i++) {
      aluElements[i].less.set(false);
    }

    // Execute the second pass for each ALU element and copy the result.
    for (int i = 0; i < aluElements.length; i++) {
      aluElements[i].execute_pass2();
      result[i].set(aluElements[i].result.get());
    }
  }

  /**
   * Constructs an n-bit ALU with the specified number of bits.
   * Initializes the ALU elements, inputs, and outputs.
   *
   * @param n The number of bits for the ALU.
   */
  public Sim3_ALU(int n) {
    // Initialize the array of ALU elements.
    aluElements = new Sim3_ALUElement[n];
    for (int i = 0; i < n; i++) {
      aluElements[i] = new Sim3_ALUElement();
    }

    // Initialize the 3-bit ALU operation control.
    aluOp = new RussWire[3];
    for (int i = 0; i < 3; i++) {
      aluOp[i] = new RussWire();
    }

    // Initialize the negate flag for the B input.
    bNegate = new RussWire();

    // Initialize the n-bit input arrays for A and B.
    a = new RussWire[n];
    for (int i = 0; i < n; i++) {
      a[i] = new RussWire();
    }

    b = new RussWire[n];
    for (int i = 0; i < n; i++) {
      b[i] = new RussWire();
    }

    // Initialize the n-bit result array.
    result = new RussWire[n];
    for (int i = 0; i < n; i++) {
      result[i] = new RussWire();
    }
  }
}
