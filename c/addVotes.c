// include boolean
#include <stdbool.h>

// declare purpleCount and yellowCount variables from other files
extern int purpleCount;
extern int yellowCount;

void addVotes(int purpleVotesAdd, int yellowVotesAdd) {

  int preState;
  if (purpleCount > yellowCount) {
    preState = 0;
  } else if (yellowCount > purpleCount) {
    preState = 1;
  } else {
    preState = 2;
  }
  
  purpleCount += purpleVotesAdd;
  yellowCount += yellowVotesAdd;

  int postState;
  if (purpleCount > yellowCount) {
    postState = 0;
  } else if (yellowCount > purpleCount) {
    postState = 1;
  } else {
    postState = 2;
  }

  if (postState == 2) {
    printf("TIED!!!\n");
  } else if (postState != preState) {
    if (postState == 0) {
      printf("Purple pulls ahead!  purple: %d   yellow: %d\n", purpleCount, yellowCount);
    } else {
      prinf("Yellow pulls ahead!  purple: %d   yellow: %d\n", purpleCount, yellowCount);
    }
  }

}