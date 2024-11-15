int stringStartsWith(char *string, char *prefix)
{
  int i = 0;
  while (string[i] != '\0' && prefix[i] != '\0')
  {
    if (string[i] != prefix[i])
    {
      return 0;
    }
    i++;
  }
  if (prefix[i] == '\0')
  {
    return 1;
  }
  return 0;
}

int stringSearch5(char *string, char char1, char char2, char char3, char char4, char char5)
{
  // Construct array from the 5 characters
  char array[5] = {char1, char2, char3, char4, char5};

  int i = 0;
  while (string[i] != '\0')
  {
    if (stringStartsWith(&string[i], array))
    {
      return i;
    }
    i++;
  }
  return -1;
}