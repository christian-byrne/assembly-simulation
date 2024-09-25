/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Christian Byrne
 */

public class Sim1_2sComplement {
	/**
	 * Executes the 2's complement operation on the input.
	 * 
	 * This method performs the 2's complement operation on the input by negating
	 * each bit of the input and adding 1 to the result.
	 * It sets the input for the adder, where adder.a is the negated input and
	 * adder.b is set to 1 for 2's complement.
	 * The method then executes the adder to perform the addition.
	 * Finally, it copies the result from the adder to the output.
	 */
	public void execute() {
		// Set input for adder: adder.a should be the negated input, and adder.b = 1 for
		// 2's complement
		for (int i = 0; i < 32; i++) {
			adder.a[i].set(!in[i].get()); // Negate the input for 2's complement
		}

		// Set the least significant bit of adder.b to 1 to add the 1 for 2's complement
		adder.b[0].set(true); // This is the "add 1" step for 2's complement
		// Set the rest of adder.b to 0
		for (int i = 1; i < 32; i++) {
			adder.b[i].set(false);
		}

		adder.execute();

		for (int i = 0; i < 32; i++) {
			out[i].set(adder.sum[i].get());
		}
	}

	public RussWire[] in;
	public RussWire[] out;
	public Sim1_ADD adder;

	/**
	 * Sim1_2sComplement class represents a 2's complement circuit.
	 * It is used to perform 2's complement operation on a 32-bit binary number.
	 * The resulting output represents the 2's complement of the input number.
	 */
	public Sim1_2sComplement() {
		in = new RussWire[32];
		out = new RussWire[32];
		adder = new Sim1_ADD();

		for (int i = 0; i < 32; i++) {
			in[i] = new RussWire();
			out[i] = new RussWire();
		}

	}
}
