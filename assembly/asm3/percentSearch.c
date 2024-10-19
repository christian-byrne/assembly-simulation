int percentSearch(char *str)
{
  int i = 0;
  while (str[i] != '\0')
  {
    if (str[i] == '%')
    {
      return i;
    }
    i++;
  }
  return -1;
}