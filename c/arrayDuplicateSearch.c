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