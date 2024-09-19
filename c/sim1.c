/* Implementation of a 32-bit adder in C.
 *
 * Author: Christian Byrne
 */

#include "sim1.h"

/**
 * Executes the add operation.
 *
 * @param obj A pointer to the Sim1Data object.
 */
void execute_add(Sim1Data *obj)
{
	int initial_carry = obj->isSubtraction ? 1 : 0; // Start with 1 if subtraction, otherwise 0
	int bit_a, bit_b, result_bit;
	int carry = initial_carry;

	// Reset sum field before adding
	obj->sum = 0;

	for (int bit_pos = 0; bit_pos < 32; ++bit_pos)
	{
		// Extract current bits from the operands 'a' and 'b'
		bit_a = (obj->a >> bit_pos) & 1;
		bit_b = (obj->b >> bit_pos) & 1;

		// Negate b's bits if it's a subtraction
		if (obj->isSubtraction)
		{
			bit_b = (~bit_b) & 1;
		}

		// Full adder logic for the current bit
		result_bit = (bit_a ^ bit_b ^ carry); // Sum bit
		obj->sum |= (result_bit << bit_pos);	// Place the bit in the correct position

		// Update carry for next iteration
		carry = (bit_a & bit_b) | ((bit_a ^ bit_b) & carry);
	}

	// Set sign-related flags
	obj->aNonNeg = (obj->a & (1 << 31)) == 0;			// Non-negative check for 'a'
	obj->bNonNeg = (obj->b & (1 << 31)) == 0;			// Non-negative check for 'b'
	obj->sumNonNeg = (obj->sum & (1 << 31)) == 0; // Non-negative check for the sum

	// Carry out flag
	obj->carryOut = carry;

	// Overflow detection: different logic for addition vs. subtraction
	int sign_a = (obj->a >> 31) & 1;
	int sign_b = (obj->b >> 31) & 1;
	int sign_sum = (obj->sum >> 31) & 1;

	if (obj->isSubtraction)
	{
		// Overflow in subtraction: if signs of 'a' and 'b' differ, and sum sign differs from 'a'
		obj->overflow = (sign_a != sign_b) && (sign_a != sign_sum);
	}
	else
	{
		// Overflow in addition: if signs of 'a' and 'b' are the same, but the sum has a different sign
		obj->overflow = (sign_a == sign_b) && (sign_a != sign_sum);
	}
}
