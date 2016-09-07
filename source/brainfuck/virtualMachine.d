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

import core.memory;

/*
  RESULT OF BENCHMARK(examples/bench.b)
  Envrionment : MacBookPro Retina mid 2014(CPU: i5 2.6 GHz(2C, 4T), RAM: 16GB)
                DMD 2.070

  NEWVM
    USEING DLinkedList and raw Pointer (default) : 5.49s (fastest)
    USEING primitiveStrage  option               : not available - new vm only support default way
    USEING usevirtualmemory option               : not available - new vm only support default way
  OLDVM
    USEING Raw Pointer (default)                 : 7.57s  (fastest)
    USEING primitiveStrage  option               : 8.80s  (middle)
    USEING usevirtualmemory option               : 18.78s (slowest)
 */
// YOU CAN'T to be true primitiveStrage and primitivePointer at the same time.

immutable primitiveStrage  = false; // depricated
immutable useVirtualMemory = false; // depricated

class VirtualMachine {
  static if (primitiveStrage) {
    char[]   code;
    ubyte[]  memory;
    int[int] brackets;
  } else static if (useVirtualMemory) {
    private VirtualMemory!char  code;
    private VirtualMemory!ubyte memory;
    private VirtualMemory!int   brackets;
  } else {
    char*    code;
    ubyte*   memory;
    int[int] brackets;
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
    static if (useVirtualMemory){
      code     = new VirtualMemory!char;
      memory   = new VirtualMemory!ubyte;
      brackets = new VirtualMemory!int;
    }
  }

  static if (!primitiveStrage && !useVirtualMemory) {
    public void vmExec(DLinkedList!vmOperator ops) {
      bracketOprimaize(ops);

      enum defaultMemorySize = 300000;

      if (ops.length > defaultMemorySize) {
        code   = cast(char*) GC.malloc(ops.length *  char.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
        memory = cast(ubyte*)GC.malloc(ops.length * ubyte.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
      } else {
        code   = cast(char*) GC.malloc(300000 *  char.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
        memory = cast(ubyte*)GC.malloc(300000 * ubyte.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
      }

      for(ops.parentList.thisNode = ops.parentList.firstNode;
          ops.parentList.thisNode != null;
          ops.parentList.thisNode = ops.parentList.thisNode.nextNode) {
        vmOperator op = ops.parentList.thisNode.value;
        //write(op.type);
        switch (op.type) {
          case 0:
            memoryIndex++;
            break;

          case 1:
            memoryIndex--;
            break;

          case 2:
            memory[memoryIndex]++;
            break;

          case 3:
            memory[memoryIndex]--;
            break;

          case 4:
            write(memory[memoryIndex].to!char);
            stdout.flush();
            break;

          case 5:
            char[] buf = stdin.rawRead(new char[1]);
            if (buf.empty) {
              memory[memoryIndex] = cast(char)(-1);
            } else {
              memory[memoryIndex] = buf[0];
            }
            break;

          case 6:
            if (memory[memoryIndex] == 0) {
              ops.parentList.thisNode = ops.parentList.thisNode.pair;
            }

            break;

          case 7:
            if (memory[memoryIndex] != 0) {
              ops.parentList.thisNode = ops.parentList.thisNode.pair;
            }

            break;

          default: break;
        }
      }

      GC.free(code);
      GC.free(memory);
    }
  }

  public void process(string input) {
    string[] _code = opTable.compile(input);

    static if (primitiveStrage) {
      code.length   = _code.length;
      memory.length = _code.length;
    } else static if (useVirtualMemory) {
      code.reallocate(_code.length);
      memory.reallocate(_code.length);
      brackets.reallocate(_code.length);
    } else {
      code   = cast(char*) GC.malloc(300000 *  char.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
      memory = cast(ubyte*)GC.malloc(300000 * ubyte.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
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
          char[] buf = stdin.rawRead(new char[1]);
          if (buf.empty) {
            memory[memoryIndex] = cast(char)(-1);
          } else {
            memory[memoryIndex] = buf[0];
          }
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
    } else static if (useVirtualMemory) {
      code.free;
      memory.free;
    } else {
      GC.free(code);
      GC.free(memory);
    }

    memoryIndex = 0;
  }
}
