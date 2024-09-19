#include <stdio.h>
#include <limits.h>
#include <stdbool.h>
#include <stdlib.h>
#include "sim1.h"

void printf_binary(char *prefix, int val);
void print_sim1_data(Sim1Data* data, int isSubtraction) {
  printf("Decimal:\n");
	printf("    %11d\n", data->a);
	printf("  %c %11d\n", isSubtraction ? '-' : '+', data->b);
	printf(" --------------\n");
	printf("    %11d\n", data->sum);
	printf("  aNonNeg=%d, bNonNeg=%d, sumNonNeg=%d\n", data->aNonNeg, data->bNonNeg, data->sumNonNeg);
	printf("  carryOut=%d\n", data->carryOut);
	printf("  overflow=%d\n", data->overflow);
	printf("\n");

	printf       ("Binary:\n");
	printf_binary("    ", data->a);
	printf_binary("  + ", ~data->b + 1);
	printf       (" -------------------------------------------\n");
	printf_binary("    ", data->sum);
  printf       ("\n\n --------------------------------------------------------------------------------------\n");
};

void test_add(int a, int b) {
  Sim1Data* data = calloc(sizeof(Sim1Data), 1);
  
  data->a = a;
  data->b = b;
  data->isSubtraction = 0;

  execute_add(data);

  print_sim1_data(data, 0);
}

void test_sub(int a, int b) {
  Sim1Data* data = calloc(sizeof(Sim1Data), 1);
  
  data->a = a;
  data->b = b;
  data->isSubtraction = 1;

  execute_add(data);

  print_sim1_data(data, 1);
}

int main() {
  // add test cases here
  test_add(1, -2);
  test_add(2, -3);
  test_add(-3, -3);
  test_add(INT_MAX, 1);
  test_add(INT_MAX, INT_MIN);
  test_add(INT_MIN, -1);
  test_add(0xCFFFFFFF, 0xCFFFFFFF);
  test_add(0, -1);
  test_add(-1, -1);
  test_add(INT_MIN, -INT_MIN);
  test_add(0, 0);
  test_add(INT_MAX, 0);
  test_add(INT_MAX, INT_MAX);
  test_add(INT_MIN, 500);
  test_add(INT_MAX, -INT_MAX);
  test_add(32, 64);
  test_add(0xC0000000, 0xC0000000);
  test_add(3333, 2222);
  test_add(-3333, 2222); 
  test_add(INT_MIN, 0x80000000);
  test_add(INT_MAX, -INT_MIN);
  test_add(INT_MIN, INT_MAX);
  test_add(-32768, -1);
  test_add(INT_MAX, 0xFFFFFFFE);
  test_add(INT_MAX, 0xFFFFFFFF);
  test_add(INT_MAX, 0xFFFFFFFD);
  test_add(-3, 5);
  test_add(-69, 69);
  test_add(0, 10);
  test_add(INT_MAX, -2);
  test_add(-3, INT_MIN);
  test_add(INT_MAX, 1);
  test_sub(INT_MAX, INT_MAX);
  test_sub(INT_MAX, 0);
  test_sub(0, INT_MAX);
  test_sub(INT_MAX, -2);
  test_sub(-3, INT_MIN);
  test_sub(INT_MAX, 1);
  test_sub(INT_MAX, 0xFFFFFFFE);
  test_sub(INT_MAX, 0xFFFFFFFF);
  test_sub(INT_MAX, 0xFFFFFFFD);
  test_sub(INT_MIN, -1);
  test_sub(INT_MIN, INT_MAX);
  test_sub(1, 1);
  test_sub(0, 0);
  test_sub(-5, 5);
  test_sub(-1, 4);
  test_sub(1, -1999);
  test_sub(0, INT_MIN);
  test_sub(55555, 55555);
  test_sub(55555, -69);
  test_sub(-55555, 69);
  test_sub(55555, 666666);

  return 0;
}

void printf_binary(char *prefix, int val) {
	int i;

	printf("%s", prefix);

	for (i=31; i>=0; i--)
	{
		printf("%d", (val >> i) & 0x1);

		if (i%4 == 0 && i != 0)
			printf(" ");
	}

	printf("\n");
}