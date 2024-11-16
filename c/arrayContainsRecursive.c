int arrayContains(char *array, char *subarray)
{
  if (subarray[0] == '\0')
  {
    return array;
  }
  if (array[0] == subarray[0])
  {
    return arrayContains(&array[1], &subarray[1]);
  }
  return -1;
}

int stringSearch2(char *string, char targetChar)
{
  char array[2] = {targetChar, targetChar};
  return arrayContains(string, array);
}

int stringSearch5(char *string, char char1, char char2, char char3, char char4, char char5)
{
  char array[5] = {char1, char2, char3, char4, char5};
  return arrayContains(string, array);
}