/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Christian Byrne
 */

public class Sim1_SUB {
	/**
	 * Executes the subtraction operation by negating the b input, adding -b and a
	 * using an adder, and copying the result to the sum.
	 */
	public void execute() {
		// Negate the b input (i.e., compute -b)
		for (int i = 0; i < 32; i++) {
			negator.in[i].set(b[i].get());
		}
		negator.execute();

		// Add -b and a using the adder
		for (int i = 0; i < 32; i++) {
			adder.a[i].set(a[i].get());
			adder.b[i].set(negator.out[i].get());
		}
		adder.execute();

		for (int i = 0; i < 32; i++) {
			sum[i].set(adder.sum[i].get());
		}
	}

	// inputs
	public RussWire[] a, b;

	// output
	public RussWire[] sum;

	public Sim1_ADD adder;
	public Sim1_2sComplement negator;

	/**
	 * Sim1_SUB class represents a subtractor component in a binary simulator.
	 * It performs subtraction operation on two 32-bit binary numbers.
	 * The subtractor uses an adder and a 2's complement negator to perform the
	 * subtraction.
	 * The result of the subtraction is stored in the sum array.
	 */
	public Sim1_SUB() {
		adder = new Sim1_ADD();
		negator = new Sim1_2sComplement();
		a = new RussWire[32];
		b = new RussWire[32];
		sum = new RussWire[32];

		for (int i = 0; i < 32; i++) {
			a[i] = new RussWire();
			b[i] = new RussWire();
			sum[i] = new RussWire();
		}
	}
}
