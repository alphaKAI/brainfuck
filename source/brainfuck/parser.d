module brainfuck.parser;
import std.string,
       std.stdio,
       std.conv;

import brainfuck.vmoperators,
       brainfuck.dlinkedlist;
import core.memory;
import std.conv,
       std.algorithm;
DLinkedList!vmOperator parser(char[] chars) {
  DLinkedList!vmOperator vmol = new DLinkedList!vmOperator;
  foreach (c; chars) {
    vmOperator top;
    switch (c) {
      case vmRight:
        top.type = 0;
        vmol.addNode(top);
        break;
      case vmLeft:
        top.type = 1;
        vmol.addNode(top);
        break;
      case vmAdd:
        top.type = 2;
        vmol.addNode(top);
        break;
      case vmSub:
        top.type = 3;
        vmol.addNode(top);
        break;
      case vmDot:
        top.type = 4;
        vmol.addNode(top);
        break;
      case vmComma:
        top.type = 5;
        vmol.addNode(top);
        break;
      case vmRBracket:
        top.type = 6;
        vmol.addNode(top);
        break;
      case vmLBracket:
        top.type = 7;
        vmol.addNode(top);
        break;
      default: break;
    }
  }
  
  return vmol;
}
