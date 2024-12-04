BSTNode *bst_search(BSTNode *node, int key)
{
  BSTNode *cur = node;
  while (cur != NULL)
  {
    if (cur->key == key)
      return cur;
    if (key < cur->key)
      cur = cur->left;
    else
      cur = cur->right;
  }
  return NULL;
}

int bst_count(BSTNode *node)
{
  if (node == NULL)
    return 0;
  return bst_count(node->left) + 1 + bst_count(node->right);
}

void bst_in_order_traversal(BSTNode *node)
{
  if (node == NULL)
    return;
  bst_in_order_traversal(node->left);
  printf("%d\n", node->key);
  bst_in_order_traversal(node->right);
}

void bst_pre_order_traversal(BSTNode *node)
{
  if (node == NULL)
    return;
  printf("%d\n", node->key);
  bst_pre_order_traversal(node->left);
  bst_pre_order_traversal(node->right);
}

BSTNode *bst_insert(BSTNode *root, BSTNode *newNode)
{
  if (root == NULL)
    return newNode;
  if (newNode->key < root->key)
    root->left = bst_insert(root->left, newNode);
  else
    root->right = bst_insert(root->right, newNode);
  return root;
}

BSTNode *bst_delete(BSTNode *root, int key)
{
  if (root == NULL)
    return NULL;
  if (key < root->key)
  {
    root->left = bst_delete(root->left, key);
    return root;
  }
  if (root->key < key)
  {
    root->right = bst_delete(root->right, key);
    return root;
  }
  // delete, case 1: node is a leaf.
  if (root->left == NULL && root->right == NULL)
    return NULL;
  // delete, case 2: node has a single child
  if (root->left == NULL)
    return root->right;
  if (root->right == NULL)
    return root->left;
  // delete, case 3: the node has two children
  BSTNode *replace = root->right;
  while (replace->left != NULL)
    replace = replace->left;
  root->right = bst_delete(root->right, replace->key); // could be changed
  replace->left = root->left;
  replace->right = root->right;
  return replace;
}