/**
 * NAME: Christian P. Byrne
 * DATE: 2024-10-09
 * DESC: 8-input multiplexer (MUX) with 3 control bits. Each input is a single bit.
 */

/**
 * Models an 8-input multiplexer (MUX), where each input is a single bit.
 * It has 8 inputs and 3 control bits, which determine which input is selected.
 * Element 0 of the control array represents the least significant bit (LSB)
 * of the control input.
 */
public class Sim3_MUX_8by1 {

  // 3-bit control input
  public RussWire[] control;
  // 8 single-bit inputs
  public RussWire[] in;
  // Single-bit output
  public RussWire out;

  /**
   * Executes the multiplexer logic, selecting one of the 8 inputs
   * based on the 3-bit control signal and setting it to the output.
   */
  public void execute() {
    // Create inverted versions of the control bits.
    boolean notS0 = !control[0].get();
    boolean notS1 = !control[1].get();
    boolean notS2 = !control[2].get();

    // Compute the conditions for selecting each input.
    boolean select0 = notS2 && notS1 && notS0;
    boolean select1 = notS2 && notS1 && control[0].get();
    boolean select2 = notS2 && control[1].get() && notS0;
    boolean select3 = notS2 && control[1].get() && control[0].get();
    boolean select4 = control[2].get() && notS1 && notS0;
    boolean select5 = control[2].get() && notS1 && control[0].get();
    boolean select6 = control[2].get() && control[1].get() && notS0;
    boolean select7 = control[2].get() && control[1].get() && control[0].get();

    // Combine all selection conditions to determine the final output.
    out.set(
        (select0 && in[0].get()) ||
            (select1 && in[1].get()) ||
            (select2 && in[2].get()) ||
            (select3 && in[3].get()) ||
            (select4 && in[4].get()) ||
            (select5 && in[5].get()) ||
            (select6 && in[6].get()) ||
            (select7 && in[7].get()));
  }

  /**
   * Initializes the 8-input MUX with 3 control lines and one output.
   */
  public Sim3_MUX_8by1() {
    control = new RussWire[3];
    for (int i = 0; i < 3; i++) {
      control[i] = new RussWire();
    }

    in = new RussWire[8];
    for (int i = 0; i < 8; i++) {
      in[i] = new RussWire();
    }

    out = new RussWire();
  }
}
