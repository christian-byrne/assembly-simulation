#include <stdio.h>

int main()
{
  int foo = 3;                            // Equivalent to .word 3
  char caseIsImportant[4] = {0, 0, 0, 0}; // Equivalent to .byte 0, .byte 0, .byte 0, .byte 0

  // Use foo as an index to access caseIsImportant
  char loaded_byte = caseIsImportant[foo]; // caseIsImportant[3]

  // Print the character corresponding to the loaded byte
  printf("%c", loaded_byte);

  return 0;
}
