/* Simulates a physical AND gate.
 *
 * Author: Christian Byrne
 */

public class Sim1_AND {
	/**
	 * Executes the AND operation on the input values and sets the output
	 * accordingly.
	 */
	public void execute() {
		out.set(
				a.get() && b.get());
	}

	public RussWire a, b; // inputs
	public RussWire out; // output

	/**
	 * Represents a logical AND gate in the Sim1 simulation.
	 * This gate takes two inputs, a and b, and produces an output, out,
	 * which is the logical AND of the inputs.
	 */
	public Sim1_AND() {
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
	}
}
