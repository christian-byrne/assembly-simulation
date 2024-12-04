    # AUTHOR:       Christian Byrne
    # FILE:         asm6.s
    # COURSE:       CSc 252
    # PROGRAM DESC: This program contains the implementation of a binary search
    #               tree in MIPS assembly. The program provides functions to
    #               initialize a node, search for a key, count the number of
    #               nodes, perform in-order and pre-order traversals, insert a
    #               node, and delete a node.


.data
    .globl  bst_init_node
    .globl  bst_search
    .globl  bst_count
    .globl  bst_in_order_traversal
    .globl  bst_pre_order_traversal
    .globl  bst_insert
    .globl  bst_delete

.text

    # -------------------------------------------------------------------------- #
    #                                3.1 Init Node                               #
    # -------------------------------------------------------------------------- #

bst_init_node:
    # Initializes a node with a key and NULL left and right children.
    #
    # ```c
    # void bst_init_node(BSTNode *node, int key)
    # {
    #   node->key = key
    #   node->left = NULL;
    #   node->right = NULL;
    # };
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    sw      $a1,                        0($a0)                  # node->key = key
    sw      $zero,                      4($a0)                  # node->left = NULL
    sw      $zero,                      8($a0)                  # node->right = NULL

    # Epilogue
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

    # -------------------------------------------------------------------------- #
    #                                 3.2 Search                                 #
    # -------------------------------------------------------------------------- #

bst_search:
    # Searches for a key in a binary search tree.
    #
    # ```c
    # BSTNode *bst_search(BSTNode *node, int key)
    # {
    #   BSTNode *cur = node;
    #   while (cur != NULL)
    #   {
    #     if (cur->key == key)
    #       return cur;
    #     if (key < cur->key)
    #       cur = cur->left;
    #     else
    #       cur = cur->right;
    #   }
    #   return NULL;
    # }
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    # Load arguments
    add     $t0,                        $zero,      $a0         # t0 = node

    # Initialize variables
    add     $t3,                        $zero,      $t0         # t3 = cur = node

SearchLoop:
    beq     $t3,                        $zero,      ReturnNull  # if (cur == NULL) return NULL
    lw      $t2,                        0($t3)                  # t2 = cur->key
    beq     $t2,                        $a1,        ReturnCur   # if (cur->key == key) return cur
    slt     $t1,                        $a1,        $t2         # t1 = key < cur->key ? 1 : 0
    bne     $t1,                        $zero,      SearchLeft  # if (key < cur->key) goto SearchLeft
    j       SearchRight

ReturnNull:
    add     $v0,                        $zero,      $zero       # return NULL
    j       SearchEpilogue

ReturnCur:
    add     $v0,                        $zero,      $t3         # return cur
    j       SearchEpilogue

SearchLeft:
    lw      $t3,                        4($t3)                  # cur = cur->left
    j       SearchLoop

SearchRight:
    lw      $t3,                        8($t3)                  # cur = cur->right
    j       SearchLoop

SearchEpilogue:
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

    # -------------------------------------------------------------------------- #
    #                                 3.3 Count                                  #
    # -------------------------------------------------------------------------- #

bst_count:
    # Counts the number of nodes in a binary search tree.
    #
    # ```c
    # int bst_count(BSTNode *node)
    # {
    #   if (node == NULL)
    #     return 0;
    #   return bst_count(node->left) + 1 + bst_count(node->right);
    # }
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    # Save $sX registers being used
    addiu   $sp,                        $sp,        -20         # Allocate space for saved regs
    sw      $s0,                        0($sp)                  # Save s0
    sw      $s1,                        4($sp)                  # Save s1
    sw      $s2,                        8($sp)                  # Save s2
    sw      $s3,                        12($sp)                 # Save s3
    sw      $s4,                        16($sp)                 # Save s4

    # Load arguments
    add     $s0,                        $zero,      $a0         # s0 = node

    # Check if node is NULL
    beq     $s0,                        $zero,      CountZero   # if (node == NULL) return 0

    # Initialize variables
    lw      $s1,                        4($s0)                  # s1 = node->left
    lw      $s2,                        8($s0)                  # s2 = node->right

    # Count left subtree
    add     $a0,                        $s1,        $zero       # a0 = node->left
    jal     bst_count                                           # bst_count(node->left)
    add     $s1,                        $v0,        $zero       # s3 = left_count

    # Count right subtree
    add     $a0,                        $s2,        $zero       # a0 = node->right
    jal     bst_count                                           # bst_count(node->right)
    add     $s2,                        $v0,        $zero       # s4 = right_count

    # Return the total count
    add     $t6,                        $s1,        $s2         # t6 = left_count + right_count
    addi    $v0,                        $t6,        1           # return left_count + right_count + 1
    j       CountEpilogue

CountZero:
    add     $v0,                        $zero,      $zero       # return 0
    j       CountEpilogue

CountEpilogue:
    # Restore $sX registers
    lw      $s0,                        0($sp)                  # Restore s0
    lw      $s1,                        4($sp)                  # Restore s1
    lw      $s2,                        8($sp)                  # Restore s2
    lw      $s3,                        12($sp)                 # Restore s3
    lw      $s4,                        16($sp)                 # Restore s4
    addiu   $sp,                        $sp,        20          # Free space for saved regs

    # Epilogue
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

    # -------------------------------------------------------------------------- #
    #                          3.4 In-Order Traversal                            #
    # -------------------------------------------------------------------------- #

bst_in_order_traversal:
    # Performs an in-order traversal of a binary search tree.
    #
    # ```c
    # void bst_in_order_traversal(BSTNode *node)
    # {
    #   if (node == NULL)
    #     return;
    #   bst_in_order_traversal(node->left);
    #   printf("%d\n", node->key);
    #   bst_in_order_traversal(node->right);
    # }
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    # Save $sX registers being used
    addiu   $sp,                        $sp,        -16         # Allocate space for saved regs
    sw      $s0,                        0($sp)                  # Save s0
    sw      $s1,                        4($sp)                  # Save s1
    sw      $s2,                        8($sp)                  # Save s2
    sw      $s3,                        12($sp)                 # Save s3

    # Load arguments
    add     $s0,                        $zero,      $a0         # s0 = node
    beq     $s0,                        $zero,      ITEpilogue  # if (node == NULL) return

    # Initalize variables
    lw      $s1,                        0($s0)                  # s1 = node->key
    lw      $s2,                        4($s0)                  # s2 = node->left
    lw      $s3,                        8($s0)                  # s3 = node->right

    # Traverse left subtree
    addi    $a0,                        $s2,        0           # a0 = node->left
    jal     bst_in_order_traversal                              # bst_in_order_traversal(node->left)

    # Print the node's key
    add     $a0,                        $zero,      $s1         # a0 = node->key
    addi    $v0,                        $zero,      1           # Print node->key
    syscall

    # Print a newline
    addi    $a0,                        $zero,      10          # a0 = '\n'
    addi    $v0,                        $zero,      11          # Print '\n'
    syscall

    # Traverse right subtree
    addi    $a0,                        $s3,        0           # a0 = node->right
    jal     bst_in_order_traversal                              # bst_in_order_traversal(node->right)

ITEpilogue:
    # Restore $sX registers
    lw      $s0,                        0($sp)                  # Restore s0
    lw      $s1,                        4($sp)                  # Restore s1
    lw      $s2,                        8($sp)                  # Restore s2
    lw      $s3,                        12($sp)                 # Restore s3
    addiu   $sp,                        $sp,        16          # Free space for saved regs

    # Epilogue
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

    # -------------------------------------------------------------------------- #
    #                          3.4 Pre-Order Traversal                           #
    # -------------------------------------------------------------------------- #

bst_pre_order_traversal:
    # Performs a pre-order traversal of a binary search tree.
    #
    # ```c
    # void bst_pre_order_traversal(BSTNode *node)
    # {
    #   if (node == NULL)
    #     return;
    #   printf("%d\n", node->key);
    #   bst_pre_order_traversal(node->left);
    #   bst_pre_order_traversal(node->right);
    # }
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    # Save $sX registers being used
    addiu   $sp,                        $sp,        -20         # Allocate space for saved regs
    sw      $s0,                        0($sp)                  # Save s0
    sw      $s1,                        4($sp)                  # Save s1
    sw      $s2,                        8($sp)                  # Save s2
    sw      $s3,                        12($sp)                 # Save s3

    # Load arguments
    add     $s0,                        $zero,      $a0         # s0 = node
    beq     $s0,                        $zero,      PTEpilogue  # if (node == NULL) return

    # Print the node's key
    lw      $a0,                        0($s0)                  # a0 = node
    addiu   $v0,                        $zero,      1           # Print node->key
    syscall

    # Print a newline
    addi    $a0,                        $zero,      10          # a0 = '\n'
    addiu   $v0,                        $zero,      11          # Print '\n'
    syscall

    # Initalize variables
    lw      $s1,                        0($s0)                  # s1 = node->key
    lw      $s2,                        4($s0)                  # s2 = node->left
    lw      $s3,                        8($s0)                  # s3 = node->right

    # Traverse left subtree
    addi    $a0,                        $s2,        0           # a0 = node->left
    jal     bst_pre_order_traversal                             # bst_pre_order_traversal(node->left)

    # Traverse right subtree
    addi    $a0,                        $s3,        0           # a0 = node->right
    jal     bst_pre_order_traversal                             # bst_pre_order_traversal(node->right)

PTEpilogue:
    # Restore $sX registers
    lw      $s0,                        0($sp)                  # Restore s0
    lw      $s1,                        4($sp)                  # Restore s1
    lw      $s2,                        8($sp)                  # Restore s2
    lw      $s3,                        12($sp)                 # Restore s3
    addiu   $sp,                        $sp,        20          # Free space for saved regs

    # Epilogue
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

    # -------------------------------------------------------------------------- #
    #                                 3.5 Insert                                 #
    # -------------------------------------------------------------------------- #

bst_insert:
    # Inserts a key into a binary search tree.
    #
    # ```c
    # BSTNode *bst_insert(BSTNode *root, BSTNode *newNode)
    # {
    #   if (root == NULL)
    #     return newNode;
    #   if (newNode->key < root->key)
    #     root->left = bst_insert(root->left, newNode);
    #   else
    #     root->right = bst_insert(root->right, newNode);
    #   return root;
    # }
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    # Save $sX registers being used
    addiu   $sp,                        $sp,        -28         # Allocate space for saved regs
    sw      $s0,                        0($sp)                  # Save s0
    sw      $s1,                        4($sp)                  # Save s1
    sw      $s2,                        8($sp)                  # Save s2
    sw      $s3,                        12($sp)                 # Save s3
    sw      $s4,                        16($sp)                 # Save s4
    sw      $s5,                        20($sp)                 # Save s5
    sw      $s6,                        24($sp)                 # Save s6

    # Load arguments
    add     $s0,                        $zero,      $a0         # s0 = root
    add     $s1,                        $zero,      $a1         # s1 = newNode
    beq     $s0,                        $zero,      InsertNew   # if (root == NULL) return newNode

    # Initialize variables
    lw      $s2,                        0($s0)                  # s2 = root->key
    lw      $s3,                        0($s1)                  # s3 = newNode->key
    lw      $s4,                        4($s0)                  # s4 = root->left
    lw      $s5,                        8($s0)                  # s5 = root->right

    # Compare keys
    slt     $t0,                        $s3,        $s2         # t0 = newNode->key < root->key ? 1 : 0
    bne     $t0,                        $zero,      InsertLeft  # if (newNode->key < root->key) goto InsertLeft
    j       InsertRight

InsertNew:
    add     $v0,                        $zero,      $s1         # return newNode
    j       IEpilogue

InsertLeft:
    addi    $a0,                        $s4,        0           # a0 = root->left
    addi    $a1,                        $s1,        0           # a1 = newNode
    jal     bst_insert                                          # root->left = bst_insert(root->left, newNode)
    sw      $v0,                        4($s0)                  # root->left = bst_insert(root->left, newNode)
    add     $v0,                        $zero,      $s0         # return root
    j       IEpilogue

InsertRight:
    addi    $a0,                        $s5,        0           # a0 = root->right
    addi    $a1,                        $s1,        0           # a1 = newNode
    jal     bst_insert                                          # root->right = bst_insert(root->right, newNode)
    sw      $v0,                        8($s0)                  # root->right = bst_insert(root->right, newNode)
    add     $v0,                        $zero,      $s0         # return root
    j       IEpilogue

IEpilogue:
    # Restore $sX registers
    lw      $s0,                        0($sp)                  # Restore s0
    lw      $s1,                        4($sp)                  # Restore s1
    lw      $s2,                        8($sp)                  # Restore s2
    lw      $s3,                        12($sp)                 # Restore s3
    lw      $s4,                        16($sp)                 # Restore s4
    lw      $s5,                        20($sp)                 # Restore s5
    lw      $s6,                        24($sp)                 # Restore s6
    addiu   $sp,                        $sp,        28          # Free space for saved regs

    # Epilogue
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

    # -------------------------------------------------------------------------- #
    #                                 3.6 Delete                                 #
    # -------------------------------------------------------------------------- #

bst_delete:
    # Deletes a key from a binary search tree.
    #
    # ```c
    # BSTNode *bst_delete(BSTNode *root, int key)
    # {
    #   if (root == NULL)
    #     return NULL;
    #   if (key < root->key)
    #   {
    #     root->left = bst_delete(root->left, key);
    #     return root;
    #   }
    #   if (root->key < key)
    #   {
    #     root->right = bst_delete(root->right, key);
    #     return root;
    #   }
    #   // delete, case 1: node is a leaf.
    #   if (root->left == NULL && root->right == NULL)
    #     return NULL;
    #   // delete, case 2: node has a single child
    #   if (root->left == NULL)
    #     return root->right;
    #   if (root->right == NULL)
    #     return root->left;
    #   // delete, case 3: the node has two children
    #   BSTNode *replace = root->right;
    #   while (replace->left != NULL)
    #     replace = replace->left;
    #   root->right = bst_delete(root->right, replace->key); // could be changed
    #   replace->left = root->left;
    #   replace->right = root->right;
    #   return replace;
    # }
    # ```

    # Prologue
    addiu   $sp,                        $sp,        -24         # Allocate 24 bytes
    sw      $ra,                        0($sp)                  # Save return address
    sw      $fp,                        4($sp)                  # Save frame pointer
    addi    $fp,                        $sp,        20          # Set new frame pointer

    # Save $sX registers being used
    addiu   $sp,                        $sp,        -28         # Allocate space for saved regs
    sw      $s0,                        0($sp)                  # Save s0
    sw      $s1,                        4($sp)                  # Save s1
    sw      $s2,                        8($sp)                  # Save s2
    sw      $s3,                        12($sp)                 # Save s3
    sw      $s4,                        16($sp)                 # Save s4
    sw      $s5,                        20($sp)                 # Save s5
    sw      $s6,                        24($sp)                 # Save s6

    # Load arguments
    add     $s0,                        $zero,      $a0         # s0 = root
    beq     $s0,                        $zero,      RetNull     # if (root == NULL) return NULL

    # Initialize variables
    add     $s1,                        $zero,      $a1         # s1 = key
    lw      $s2,                        0($s0)                  # s2 = root->key
    lw      $s3,                        4($s0)                  # s3 = root->left
    lw      $s4,                        8($s0)                  # s4 = root->right

    # Compare keys
    slt     $t0,                        $s1,        $s2         # t0 = key < root->key ? 1 : 0
    bne     $t0,                        $zero,      DeleteLeft  # if (key < root->key) goto DeleteLeft
    slt     $t0,                        $s2,        $s1         # t0 = root->key < key ? 1 : 0
    bne     $t0,                        $zero,      DeleteRight # if (root->key < key) goto DeleteRight
    j       DeleteNode

RetNull:
    addi    $v0,                        $zero,      0           # return NULL
    j       DEpilogue

DeleteLeft:
    addi    $a0,                        $s3,        0           # a0 = root->left
    addi    $a1,                        $s1,        0           # a1 = key
    jal     bst_delete                                          # bst_delete(root->left, key)
    sw      $v0,                        4($s0)                  # root->left = bst_delete(root->left, key)
    add     $v0,                        $zero,      $s0         # return root
    j       DEpilogue

DeleteRight:
    addi    $a0,                        $s4,        0           # a0 = root->right
    addi    $a1,                        $s1,        0           # a1 = key
    jal     bst_delete                                          # bst_delete(root->right, key)
    sw      $v0,                        8($s0)                  # root->right = bst_delete(root->right, key)
    add     $v0,                        $zero,      $s0         # return root
    j       DEpilogue

DeleteNode:
    lw      $s3,                        4($s0)                  # s3 = root->left
    lw      $s4,                        8($s0)                  # s4 = root->right
    bne     $s3,                        $zero,      CheckChild  # if (root->left != NULL) goto CheckChild
    bne     $s4,                        $zero,      CheckChild  # if (root->right != NULL) goto CheckChild
    j       RetNull

RepLoop:
    lw      $t6,                        4($s4)                  # t6 = replace->left
    beq     $t6,                        $zero,      RepEnd
    lw      $s4,                        4($s4)                  # replace = replace->left
    j       RepLoop

CheckChild:
    beq     $s3,                        $zero,      RetRight    # if (root->left == NULL) goto RetRight
    beq     $s4,                        $zero,      RetLeft     # if (root->right == NULL) goto RetLeft
    j       RepLoop

RetLeft:
    lw      $v0,                        4($s0)                  # return root->left
    j       DEpilogue

RetRight:
    lw      $v0,                        8($s0)                  # return root->right
    j       DEpilogue

RepEnd:
    lw      $a0,                        8($s0)                  # a0 = root->right
    lw      $a1,                        0($s4)                  # a1 = replace->key
    jal     bst_delete                                          # bst_delete(root->right, replace->key)
    sw      $v0,                        8($s0)                  # root->right = bst_delete(root->right, replace->key)
    lw      $t5,                        8($s0)                  # reload root->right since s4 was changed
    sw      $s3,                        4($s4)                  # replace->left = root->left
    sw      $t5,                        8($s4)                  # replace->right = root->right
    add     $v0,                        $zero,      $s4         # return replace
    j       DEpilogue

DEpilogue:
    # Restore $sX registers
    lw      $s0,                        0($sp)                  # Restore s0
    lw      $s1,                        4($sp)                  # Restore s1
    lw      $s2,                        8($sp)                  # Restore s2
    lw      $s3,                        12($sp)                 # Restore s3
    lw      $s4,                        16($sp)                 # Restore s4
    lw      $s5,                        20($sp)                 # Restore s5
    lw      $s6,                        24($sp)                 # Restore s6
    addiu   $sp,                        $sp,        28          # Free space for saved regs

    # Epilogue
    lw      $ra,                        0($sp)                  # Restore return address
    lw      $fp,                        4($sp)                  # Restore frame pointer
    addiu   $sp,                        $sp,        24          # Free 24 bytes
    jr      $ra                                                 # Return

