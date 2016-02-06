module brainfuck.vmoperators;

enum vmAdd = '+',
     vmSub = '-',
     vmRight = '>',
     vmLeft  = '<',
     vmDot   = '.',
     vmComma = ',',
     vmRBracket = '[',
     vmLBracket = ']';

struct vmOperator {
  public int type;
  public vmOperator* pair;
}
  /*
  public static int loopType = -1;//0 = right, 1 = left
  public static char operator;
  public static vmLoop* pair;

  public void set(int type) {
    if (type == 0 || type == 1) {
      loopType = type;
      if (type == 0) {
        operator = '[';
      } else {
        operator = ']';
      }
    } else {
      throw new Error("Unknow Loop type");
    }
  }

  public static void operate(ulong* memory, ulong* memoryIndex, vmOperator* thisOp) {
    bool flag;
    if (loopType == 0 && memory[*memoryIndex] == 0) {
      flag = true;
    } else if (loopType == 1 && memory[*memoryIndex] != 0) {
      flag = true;
    }

    if (flag) {
      thisOp = pair.next;
    } else {
      return;
    }
  }*/

/*
class vmAdd : vmOperator {
  public static immutable char operator = '+';
  public static vmOperator* next;
  public static vmOperator* prev;

  public static void operate(ulong* memory, ulong* memoryIndex) {
    (*memoryIndex)++;
  }
}

class vmSub : vmOperator {
  public static immutable char operator = '-';
  public static vmOperator* next;
  public static vmOperator* prev;
  
  public static void operate(ulong* memory, ulong* memoryIndex) {
    (*memoryIndex)--;
  }
}

class vmRight : vmOperator {
  public static immutable char operator = '>';
  public static vmOperator* next;
  public static vmOperator* prev;

  public static void operate(ulong* memory, ulong* memoryIndex) {
    memory[*memoryIndex]++;
  }
}

class vmLeft : vmOperator {
  public static immutable char operator = '<';
  public static vmOperator* next;
  public static vmOperator* prev;
 
  public static void operate(ulong* memory, ulong* memoryIndex) {
    memory[*memoryIndex]--;
  }
}

class vmDot : vmOperator {
  public static immutable char operator = '.';
  public static vmOperator* next;
  public static vmOperator* prev;

  public static void operate(ulong* memory, ulong* memoryIndex) {
    import std.stdio, std.conv;
    write(memory[*memoryIndex].to!char);
    stdout.flush();
  }
}

class vmComma : vmOperator {
  public static immutable char operator = ',';
  public static vmOperator* next;
  public static vmOperator* prev;

  public static void operate(ulong* memory, ulong* memoryIndex) {
    import std.stdio, std.conv;
    string buf;
    while((buf = readln()) == null || !buf.length){}
    memory[*memoryIndex] = cast(ubyte)buf[0];
  }
}*/
