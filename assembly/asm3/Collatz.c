int collatz_line(int val)
{
  if (val % 2 == 1) // is the value odd?
  {
    printf("%d\n", val);
    return val;
  }
  printf("%d", val);
  int cur = val;
  while (cur % 2 == 0)
  {
    cur /= 2;
    printf(" %d", cur);
  }
  printf("\n");
  return cur;
}

void collatz(int val)
{
  int cur = val;
  int calls = 0;
  cur = collatz_line(cur);

  while (cur != 1)
  {
    cur = 3 * cur + 1;
    cur = collatz_line(cur);
    calls++;
  }
  printf("collatz(%d) completed after %d calls to collatz_line().\n", val, calls);
  printf("\n");
}