module brainfuck.optimaizer;
import brainfuck.vmoperators,
       brainfuck.dlinkedlist;
import std.array;
import core.memory;

void bracketOprimaize(DLinkedList!vmOperator ops) {

  ops.Node*[] leftstack;

  for(ops.parentList.thisNode = ops.parentList.firstNode;
      ops.parentList.thisNode != null; ops.parentList.thisNode = ops.parentList.thisNode.nextNode) {
    ops.Node* pc = ops.parentList.thisNode;
    
    if (ops.parentList.thisNode.value.type == 6) {
      leftstack ~= pc;
    } else if (ops.parentList.thisNode.value.type == 7 && leftstack.length != 0) {
      ops.Node* left = leftstack[$ - 1];
      leftstack.popBack();

      ops.Node* right = pc;

      left.pair  = right;
      right.pair = left;
    }
  }
}
