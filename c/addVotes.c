// include boolean
#include <stdbool.h>

// declare purpleCount and yellowCount variables from other files
extern int purpleCount;
extern int yellowCount;

void addVotes(int purpleVotesAdd, int yellowVotesAdd)
{
  int preState = getElectionState();
  purpleCount += purpleVotesAdd;
  yellowCount += yellowVotesAdd;
  int postState = getElectionState();
  if (preState == -1)
    return;
  if (postState == 2)
    printf("TIED!!!\n");
  if (preState == 2)
    return; 
  else if (postState != preState)
  {
    if (postState == 0)
    {
      printf("Purple pulls ahead!  purple: %d   yellow: %d\n", purpleCount, yellowCount);
    }
    else
    {
      prinf("Yellow pulls ahead!  purple: %d   yellow: %d\n", purpleCount, yellowCount);
    }
  }
}

int getElectionState()
{
  if (purpleCount == 0 && yellowCount == 0)
  {
    return -1;
  }
  if (purpleCount > yellowCount)
  {
    return 0;
  }
  else if (yellowCount > purpleCount)
  {
    return 1;
  }
  return 2;
}
