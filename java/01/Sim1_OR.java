/* Simulates a physical OR gate.
 *
 * Author: Christian Byrne
 */

public class Sim1_OR {
	/**
	 * Executes the OR operation on the input values and sets the output
	 * accordingly.
	 */
	public void execute() {
		out.set(
				a.get() || b.get());
	}

	public RussWire a, b;
	public RussWire out;

	/**
	 * Represents a logical OR gate in the Sim1 circuit simulation.
	 * This gate takes two inputs (a and b) and produces an output (out) based on
	 * the OR operation.
	 */
	public Sim1_OR() {
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
	}
}
