/* Testcase for 252 Sim 1.
 *
 * Author: Tatiana Rastoskueva
 */
import java.lang.Math;

public class Test_04_trADD
{
	public static void main(String[] args)
	{
		Sim1_ADD p = new Sim1_ADD();

		p.a[ 0].set(false);
		p.a[ 1].set(false);
		p.a[ 2].set(false);
		p.a[ 3].set(false);
		p.a[ 4].set(true);
		p.a[ 5].set(true);
		p.a[ 6].set(false);
		p.a[ 7].set(false);
		p.a[ 8].set(false);
		p.a[ 9].set(false);
		p.a[10].set(true);
		p.a[11].set(false);
		p.a[12].set(false);
		p.a[13].set(false);
		p.a[14].set(true);
		p.a[15].set(false);
		p.a[16].set(true);
		p.a[17].set(true);
		p.a[18].set(false);
		p.a[19].set(true);
		p.a[20].set(false);
		p.a[21].set(true);
		p.a[22].set(false);
		p.a[23].set(false);
		p.a[24].set(false);
		p.a[25].set(false);
		p.a[26].set(true);
		p.a[27].set(false);
		p.a[28].set(true);
		p.a[29].set(true);
		p.a[30].set(true);
		p.a[31].set(true);

		p.b[ 0].set(false);
		p.b[ 1].set(false);
		p.b[ 2].set(false);
		p.b[ 3].set(false);
		p.b[ 4].set(true);
		p.b[ 5].set(false);
		p.b[ 6].set(false);
		p.b[ 7].set(true);
		p.b[ 8].set(true);
		p.b[ 9].set(false);
		p.b[10].set(false);
		p.b[11].set(false);
		p.b[12].set(false);
		p.b[13].set(false);
		p.b[14].set(false);
		p.b[15].set(true);
		p.b[16].set(false);
		p.b[17].set(false);
		p.b[18].set(false);
		p.b[19].set(true);
		p.b[20].set(true);
		p.b[21].set(false);
		p.b[22].set(true);
		p.b[23].set(true);
		p.b[24].set(true);
		p.b[25].set(false);
		p.b[26].set(false);
		p.b[27].set(true);
		p.b[28].set(false);
		p.b[29].set(true);
		p.b[30].set(true);
		p.b[31].set(true);


		p.execute();

		System.out.printf("  ");
		print_bits(p.a);
		System.out.print("\n");

		System.out.printf("+ ");
		print_bits(p.b);
		System.out.printf("\n");

		System.out.printf("----------------------------------\n");

		System.out.printf("  ");
		print_bits(p.sum);
		System.out.printf("\n");

		System.out.printf("\n");
		System.out.printf("  carryOut = %c\n", bit(p.carryOut.get()));

		System.out.printf("  overflow = %c\n", bit(p.overflow.get()));

		System.out.printf("\nDecimal===========================\n");
		System.out.printf("  ");
		System.out.printf(""+get_decimal(p.a));
		System.out.printf("\n");

		System.out.printf("+ ");
		System.out.printf(""+get_decimal(p.b));
		System.out.printf("\n");

		System.out.printf("----------------------------------\n");
		System.out.printf("  ");
		System.out.printf(""+get_decimal(p.sum));
		System.out.printf("\n");
	}

	public static void print_bits(RussWire[] bits)
	{
		for (int i=31; i>=0; i--)
		{
			if (bits[i].get())
				System.out.print("1");
			else
				System.out.print("0");
		}
	}

	public static int get_decimal(RussWire[] bits)
	{
		int result = 0;
		for (int i = 0; i < 31; i++)
		{
			if (bits[i].get())
				result += Math.pow(2, i);
			
		}
		if (bits[31].get())
			result -= Math.pow(2, 31);
		return result;
	}

	public static char bit(boolean b)
	{
		if (b)
			return '1';
		else
			return '0';
	}
}

