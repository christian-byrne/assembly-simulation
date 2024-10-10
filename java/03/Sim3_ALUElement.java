/**
 * NAME: Christian P. Byrne
 * DATE: 2024-10-09
 * DESC: Simulates an Arithmetic Logic Unit (ALU) element. 
 *       Can perform AND, OR, ADD, LESS, and XOR operations.
 */

/**
 * Represents a single element of an ALU (Arithmetic Logic Unit).
 * The ALU can perform the following operations based on the `aluOp`:
 * 0 - AND
 * 1 - OR
 * 2 - ADD
 * 3 - LESS
 * 4 - XOR
 */
public class Sim3_ALUElement {

  // 3-bit ALU operation input, element 0 is the LSB
  public RussWire[] aluOp;
  // MUX for selecting the ALU result
  public Sim3_MUX_8by1 mux;

  // Input signals
  public RussWire bInvert; // Inverts the B input
  public RussWire a; // Single-bit input A
  public RussWire b; // Single-bit input B
  public RussWire carryIn; // Carry input for addition

  /**
   * Input value for the LESS operation when `aluOp == 3`.
   * This is only valid during the second pass (after all other operations),
   * so it should not be read during the first pass.
   */
  public RussWire less;

  // Outputs
  public RussWire result; // Output from this ALU element after selecting the operation result
  public RussWire addResult; // Result from the adder logic for this bit
  public RussWire carryOut; // Carry output from the adder for this bit

  /**
   * First pass of the ALU element execution.
   * When this is called, all inputs are set except for `less`.
   * This method handles the adder logic, including `bInvert` to support
   * subtraction.
   * Sets the `addResult` and `carryOut` outputs.
   * The `result` output is not set during this pass because `less` is not yet
   * known.
   */
  public void execute_pass1() {
    // Calculate the effective value of B based on the `bInvert` flag.
    boolean bValue = (bInvert.get() && !b.get()) || (!bInvert.get() && b.get());

    // Calculate the addition result for this bit.
    addResult.set(
        (a.get() && !bValue && !carryIn.get()) || // A and not B and not carryIn
            (!a.get() && bValue && !carryIn.get()) || // Not A and B and not carryIn
            (!a.get() && !bValue && carryIn.get()) || // Not A and not B and carryIn
            (a.get() && bValue && carryIn.get()) // A and B and carryIn
    );

    // Calculate the carry-out for this bit.
    carryOut.set(
        (a.get() && bValue) || // A and B
            (a.get() && carryIn.get()) || // A and carryIn
            (bValue && carryIn.get()) // B and carryIn
    );
  }

  /**
   * Second pass of the ALU element execution.
   * At this point, all inputs, including `less`, are valid.
   * This method sets the `result` output using the MUX based on the `aluOp`.
   */
  public void execute_pass2() {
    // Set the control bits for the MUX.
    mux.control[0].set(aluOp[0].get());
    mux.control[1].set(aluOp[1].get());
    mux.control[2].set(aluOp[2].get());

    // Calculate the effective value of B based on the `bInvert` flag.
    boolean bValue = (bInvert.get() && !b.get()) || (!bInvert.get() && b.get());

    // Set the inputs to the MUX based on ALU operations.
    mux.in[0].set(a.get() && bValue); // AND operation (opcode 0)
    mux.in[1].set(a.get() || bValue); // OR operation (opcode 1)
    mux.in[2].set(addResult.get()); // ADD operation (opcode 2)
    mux.in[3].set(less.get()); // LESS operation (opcode 3)
    mux.in[4].set((a.get() && !bValue) || (!a.get() && bValue)); // XOR operation (opcode 4)

    // Set the remaining MUX inputs to false (unused).
    mux.in[5].set(false);
    mux.in[6].set(false);
    mux.in[7].set(false);

    // Execute the MUX to select the correct operation result.
    mux.execute();

    // Set the final result output from the MUX.
    result.set(mux.out.get());
  }

  /**
   * Constructor for Sim3_ALUElement.
   * Initializes all inputs, outputs, and the MUX.
   */
  public Sim3_ALUElement() {
    // Initialize the 3-bit ALU operation control.
    aluOp = new RussWire[3];
    for (int i = 0; i < 3; i++) {
      aluOp[i] = new RussWire();
    }

    // Initialize the MUX and its inputs.
    mux = new Sim3_MUX_8by1();
    for (int i = 0; i < 8; i++) {
      mux.in[i] = new RussWire();
    }

    // Initialize other input wires.
    bInvert = new RussWire();
    a = new RussWire();
    b = new RussWire();
    carryIn = new RussWire();
    less = new RussWire();

    // Initialize output wires.
    result = new RussWire();
    addResult = new RussWire();
    carryOut = new RussWire();
  }
}
