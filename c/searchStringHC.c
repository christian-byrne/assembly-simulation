int searchSequence(const char *wordArray, char char1, char char2, char char3, char char4, char char5)
{
    const char *current = wordArray;
    int index = 0;
    while (*current != '\0')
    {
        if (current[0] == char1 &&
            current[1] == char2 &&
            current[2] == char3 &&
            current[3] == char4 &&
            current[4] == char5)
        {
            return index; // Match found, return index
        }
        current++;
        index++;
    }
    return -1;
}