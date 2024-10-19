int letterTree(int step)
{
  int count = 0;
  int pos = 0;
  while (1) // we’ll break out manually, when required
  {
    char c = getNextLetter(pos);
    if (c == '\0') // this is literally *ZERO*
      break;
    for (int i = 0; i <= count; i++)
      printf("%c", c); // use syscall 11
    printf("\n");
    count++;
    pos += step;
  }
  return pos;
}