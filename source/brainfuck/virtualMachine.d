module brainfuck.virtualMachine;

import brainfuck.virtualMemory,
       brainfuck.operatorTable,
       brainfuck.dlinkedlist,
       brainfuck.vmoperators,
       brainfuck.optimaizer;
import std.algorithm.searching,
       std.array,
       std.stdio,
       std.string,
       std.conv;

// DAFAULT IS USEING VIRTUALMEMORY BUT PRIMITIVE-STRAGE IS FASTHER AND PRIMITIVE-POINTER IS FASTEST
// YOU CAN'T to be true primitiveStrage and primitivePointer at the same time.
/*
  RESULT OF BENCHMARK(examples/bench.b)
  Envrionment : MacBookPro Retina mid 2014(CPU: i5 2.6 GHz(2C, 4T), RAM: 16GB)
                DMD 2.070

  USEING VirtualMemory class (default) : 18.54s (slowest)
  USEING primitiveStrage option        : 9.49s  (middle)
  USEING primitivePointer option       : 7.64s  (fastest)
 */
immutable primitiveStrage  = false;
immutable primitivePointer = false;

static if (primitivePointer) {
  import core.memory;
}

class VirtualMachine {
  static if (primitiveStrage) {
    char[]   code;
    ubyte[]  memory;
    int[int] brackets;
  } else static if (primitivePointer) {
    char*    code;
    ubyte*   memory;
    int[int] brackets;
  } else {
    private VirtualMemory!char  code;
    private VirtualMemory!ubyte memory;
    private VirtualMemory!int   brackets;
  }
  
  private OperatorTable opTable;
  private ulong memoryIndex;

  this(OperatorTable table) {
    opTable = table;
    initVM;
  }

  this() {
    opTable = new OperatorTable;
    initVM;
  }

  private void initVM() {
    static if (primitiveStrage) {
      code.length   = 300000;
      memory.length = 300000;
    } else static if (primitivePointer) {
      code   = cast(char*) GC.malloc(300000 *  char.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
      memory = cast(ubyte*)GC.malloc(300000 * ubyte.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    } else {
      code     = new VirtualMemory!char;
      memory   = new VirtualMemory!ubyte;
      brackets = new VirtualMemory!int;
    }
  }

  public void vmExec(DLinkedList!vmOperator ops) {
    bracketOprimaize(ops);
    
    GC.realloc(code,   ops.length *  char.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    GC.realloc(memory, ops.length * ubyte.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    
    for(ops.parentList.thisNode = ops.parentList.firstNode; ops.parentList.thisNode != null; ops.parentList.thisNode = ops.parentList.thisNode.nextNode) {
      vmOperator op = ops.parentList.thisNode.value;
      write(op.type);
      switch (op.type) {
        case 0:
          memoryIndex++;
          break;

        case 1:
          memoryIndex--;
          break;

        case 2:
          ++memory[memoryIndex];
          break;

        case 3:
          --memory[memoryIndex];
          break;

        case 4:
          write(memory[memoryIndex].to!char);
          stdout.flush();
          break;

        case 5:
          string buf;
          while((buf = readln()) == null || !buf.length){}
          memory[memoryIndex] = cast(ubyte)buf[0];
          break;

        case 6:
          if (memory[memoryIndex] == 0) {
            ops.parentList.thisNode = ops.parentList.thisNode.nextNode;
          } else {
            ops.parentList.thisNode = ops.parentList.thisNode.nextNode.nextNode;
          }
          break;

        case 7:
          if (memory[memoryIndex] != 0) {
            ops.parentList.thisNode = ops.parentList.thisNode.nextNode;
          } else {
            ops.parentList.thisNode = ops.parentList.thisNode.nextNode.nextNode;
          
          }
          break;
        default: break;
      }
    }
  }

  public void process(string input) {
    string[] _code = opTable.compile(input);

    static if (primitiveStrage) {
      code.length   = _code.length;
      memory.length = _code.length;
    } else static if (primitivePointer) {
      GC.realloc(code,   _code.length *  char.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
      GC.realloc(memory, _code.length * ubyte.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    } else {
      code.reallocate(_code.length);
      memory.reallocate(_code.length);
      brackets.reallocate(_code.length);
    }

    foreach(i, e; _code) {
      code[i] = e.to!char;
    }

    // Optimization
    int[] leftstack;
    int pc;
    
    for (size_t i; i < _code.length; i++) {
      char c = code[i];
      if (!canFind(opTable.operators, _code[i])) {
        continue;
      }

      if (c == '[') {
        leftstack ~= pc;
      } else if (c == ']' && leftstack.length != 0) {
        int left = leftstack[$ - 1];
        leftstack.popBack();
        
        int right = pc;

        brackets[left] = right;
        brackets[right] = left;
      }

      pc++;
    }

    for (int index; index < _code.length; index++) {
      switch (code[index]) {
        case '>':
          memoryIndex++;
          break;

        case '<':
          memoryIndex--;
          break;

        case '+':
          ++memory[memoryIndex];
          break;

        case '-':
          --memory[memoryIndex];
          break;

        case '.':
          write(memory[memoryIndex].to!char);
          stdout.flush();
          break;

        case ',':
          string buf;
          while((buf = readln()) == null || !buf.length){}
          memory[memoryIndex] = cast(ubyte)buf[0];
          break;

        case '[':
          if (memory[memoryIndex] == 0) {
            index = brackets[index];
          }
          break;

        case ']':
          if (memory[memoryIndex] != 0) {
            index = brackets[index];
          }
          break;

        default: break;
      }
    }

    static if (primitiveStrage) {
      code.length   = 0;
      memory.length = 0;
    } else static if (primitivePointer) {
      GC.free(code);
      GC.free(memory);

      code   = null;
      memory = null;
    } else {
      code.free;
      memory.free;
    }

    memoryIndex = 0;
  }
}
