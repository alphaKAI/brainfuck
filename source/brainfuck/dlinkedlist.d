module brainfuck.dlinkedlist;
import std.stdio,
       core.memory;

class DLinkedList(T) {
  /* List Structure */
  struct Node {
    Node* prevNode = null;
    Node* nextNode = null;
    Node* pair     = null;
    T value;
  }

  struct List {
    Node* firstNode = null;
    Node* lastNode  = null;
    Node* thisNode  = null;
  }

  List* parentList = null;
  private size_t cursor;

  this() {
    parentList = cast(List*)GC.malloc(Node.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
  }

  ~this() {
  }

  void addNode(T newValue) {
    Node* newNode = cast(Node*)GC.malloc(Node.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    newNode.value    = newValue;
    newNode.nextNode = null;

    if(parentList.lastNode != null) {
      parentList.lastNode.nextNode = newNode;
      newNode.prevNode    = parentList.lastNode;
      parentList.lastNode = newNode;
    } else {
      parentList.firstNode = parentList.lastNode = newNode;
      newNode.prevNode     = null;
    }

    _length++;
  }

  void freeNode(Node *p) {
    if (p.prevNode !is null && p.nextNode !is null) {
      p.prevNode.nextNode = p.nextNode;
      p.nextNode.prevNode = p.prevNode;
    }

    GC.free(p);
    _length--;
  }

  void freeAllNode(Node *p) {
    if (p !is null) {
      freeAllNode(p.nextNode);
      GC.free(p);
      _length--;
    }
  }

  void freeList() {
    freeAllNode(parentList.firstNode);
    GC.collect;
  }

  size_t _length;

  @property size_t length() {
    return _length;
  }

  T[] toArray() {
    T[] array;
    size_t arraySize;

    arraySize = length;

    for(parentList.thisNode = parentList.firstNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.nextNode) {
      array ~= parentList.thisNode.value;
    }

    return array;
  }

  T[] toReArray() {
    T[] array;
    size_t arraySize;

    arraySize = length;

    for(parentList.thisNode = parentList.firstNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.nextNode) {
      arraySize++;
    }

    for(parentList.thisNode = parentList.lastNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.prevNode) {
      array ~= parentList.thisNode.value;
    }

    return array;
  }

  bool findNode(T key) { 
    for(parentList.thisNode = parentList.firstNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.nextNode) {
      if(compareElement(parentList.thisNode.value, key)) {
        return true;
      }
    }

    return false;
  }

  Node* pickupNode(Node* node) {
      Node* returnNode = null;
    for(parentList.thisNode = parentList.firstNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.nextNode) {
      if(parentList.thisNode == node) {
        returnNode = parentList.thisNode;
        break;
      }
    }

    return returnNode;
  }

  Node* pickupNode(T key) {
    Node* returnNode = null;
    for(parentList.thisNode = parentList.firstNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.nextNode) {
      if(compareElement(parentList.thisNode.value, key)) {
        returnNode = parentList.thisNode;
        break;
      }
    }

    return returnNode;
  }

  void printAll() {
    for(parentList.thisNode = parentList.firstNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.nextNode) {
      writeln(parentList.thisNode.value);
    }
  }

  void printReAll() {
    for(parentList.thisNode = parentList.lastNode; parentList.thisNode != null; parentList.thisNode = parentList.thisNode.prevNode) {
      writeln(parentList.thisNode.value);
    }
  }

  bool compareElement(T a, T b) {
    return a == b;
  }

  private bool flag;
  @property bool empty() {
    if (flag) {
      flag = false;
      return true;
    }

    if (parentList.thisNode == parentList.lastNode) {
      flag = true;
      return false;
    } else {
      return false;
    }
  }

  @property T front() {
    if (!flag && !empty && parentList.thisNode == null) {
      parentList.thisNode = parentList.firstNode;
    }

    return parentList.thisNode.value;
  }

  @property void popFront() {
    parentList.thisNode = parentList.thisNode.nextNode;
  }
  /* end of List struct implementation */
}
