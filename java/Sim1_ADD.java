/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Christian Byrne
 */

public class Sim1_ADD {
	/**
	 * Executes the addition operation on two binary numbers.
	 * 
	 * This method performs addition on two binary numbers represented by arrays of
	 * bits. It iterates through each bit of the numbers, computes the sum bit and
	 * carry out for the current bit, and updates the sum array accordingly. It also
	 * determines the final carry out and sets it in the carryOut variable.
	 * Additionally, it checks for overflow by comparing the sign of the result with
	 * the signs of the inputs and sets the overflow variable accordingly.
	 */
	public void execute() {
		boolean carryIn = false; // Initialize carryIn for the least significant bit (bit 0).
		for (int i = 0; i < 32; i++) {
			boolean a_bit = a[i].get();
			boolean b_bit = b[i].get();

			// Compute the sum bit and carry out for the current bit
			boolean sum_bit = a_bit ^ b_bit ^ carryIn;
			sum[i].set(sum_bit);
			carryIn = (a_bit && b_bit) || (a_bit && carryIn) || (b_bit && carryIn);
		}

		// Set the final carryOut after the loop ends
		carryOut.set(carryIn);

		// Overflow occurs when the sign of the result does not match the sign of the
		// inputs.
		boolean a_sign = a[31].get();
		boolean b_sign = b[31].get();
		boolean sum_sign = sum[31].get();

		boolean overflow_bit = (a_sign && b_sign && !sum_sign) || (!a_sign && !b_sign && sum_sign);
		overflow.set(overflow_bit);
	}

	// inputs
	public RussWire[] a, b;

	// outputs
	public RussWire[] sum;
	public RussWire carryOut, overflow;

	/**
	 * Sim1_ADD class represents an adder.
	 */
	public Sim1_ADD() {
		/*
		 * Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a = new RussWire[32];
		b = new RussWire[32];
		sum = new RussWire[32];

		for (int i = 0; i < 32; i++) {
			a[i] = new RussWire();
			b[i] = new RussWire();
			sum[i] = new RussWire();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}
