module brainfuck.optimaizer;
import brainfuck.vmoperators,
       brainfuck.dlinkedlist;
import std.array;
import core.memory;

void bracketOprimaize(DLinkedList!vmOperator ops) {

  ops.Node*[] leftstack;

  foreach (op; ops) {

    if (op.type == 6) {
      leftstack ~= ops.parentList.thisNode;
    } else if (op.type == 7 && leftstack.length != 0) {
      ops.Node* left = leftstack[$ - 1];
      leftstack.popBack();

      ops.Node* right = ops.parentList.thisNode;

      ops.Node* newNode = cast(ops.Node*)GC.malloc(ops.Node.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);

      newNode.value    = right.value;
      newNode.nextNode = left.nextNode;
      left.nextNode = newNode;

      ops.Node* newNode2 = cast(ops.Node*)GC.malloc(ops.Node.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
      newNode2.value    = left.value;
      newNode2.nextNode = right.nextNode;
      right.nextNode = newNode2;
    }

  }
}
