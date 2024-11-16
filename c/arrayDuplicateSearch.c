int arrayDuplicateSearch(int *array, int length, int target)
{
  int lastMatchIndex = -1;

  for (int i = 0; i < length; i++)
  {
    if (array[i] == target)
    {
      if (lastMatchIndex != -1) // two consecutive matches
      {
        return lastMatchIndex; // return index of first match
      }
      else
      {
        lastMatchIndex = i; // only one consecutive match
      }
    }
    else
    {
      lastMatchIndex = -1; // no match, reset lastMatchIndex
    }
  }
  return -1; // no match found
}

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

int stringSearch2(char *string, char targetChar)
{
  // Construct array with two target characters
  char array[2] = {targetChar, targetChar};

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

int hasSubstring(char *string, char *substring)
{
  int i = 0;
  while (string[i] != '\0')
  {
    if (stringStartsWith(&string[i], &substring))
    {
      return i;
    }
    i++;
  }
  return -1;
}

int findConsecutiveMatch(const int *array, int arrayLength, int targetValue)
{
  int currentIndex = 0;
  int adjustedLength = arrayLength - 1;
  while (currentIndex < adjustedLength)
  {
    int currentInt = array[currentIndex];
    int nextInt = array[currentIndex + 1];
    if (currentInt == targetValue)
    {
      if (nextInt == targetValue)
      {
        return currentIndex; // Return index of first match
      }
    }
    currentIndex++;
  }
  return -1;
}