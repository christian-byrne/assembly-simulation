/* Simulates a physical NOT gate.
 *
 * Author: Christian Byrne
 */

public class Sim1_NOT {
	/**
	 * Executes the NOT operation.
	 * 
	 * This method takes the input value and performs the logical NOT operation on
	 * it.
	 * The result is then set as the output value.
	 */
	public void execute() {
		out.set(!in.get());
	}

	public RussWire in; // input
	public RussWire out; // output

	/**
	 * Sim1_NOT class represents a NOT gate in a binary simulation.
	 * It has an input wire and an output wire.
	 */
	public Sim1_NOT() {
		in = new RussWire();
		out = new RussWire();
	}
}
