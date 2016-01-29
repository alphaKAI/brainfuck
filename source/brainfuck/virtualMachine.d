module brainfuck.virtualMachine;

import brainfuck.virtualMemory,
       brainfuck.operatorTable;
import std.algorithm.searching,
       std.array,
       std.stdio,
       std.string,
       std.conv;

immutable primitiveStrage = false;

class VirtualMachine {
  static if (primitiveStrage) {
    string[] code;
    ubyte[] memory;
    int[int] brackets;
  } else {
    private VirtualMemory!string code;
    private VirtualMemory!ubyte memory;
    private VirtualMemory!int brackets;
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
      code.length   = 30000;
      memory.length = 30000;
    } else {
      code     = new VirtualMemory!string;
      memory   = new VirtualMemory!ubyte;
      brackets =new VirtualMemory!int;
    }
  }

  public void process(string input) {
    string[] _code = opTable.compile(input);
    static if (!primitiveStrage) {
      code.reallocate(_code.length);
      memory.reallocate(_code.length);
      brackets.reallocate(_code.length);
    } else {
      code.length     = _code.length;
      memory.length   = _code.length;
    }

    code = _code;

    // Optimization
    int[] leftstack;
    int pc;
    for (int i; i < code.length; i++) {
      string c = code[i];
      if (!canFind(opTable.operators, c)) {
        continue;
      }

      if (c == "[") {
        leftstack ~= pc;
      } else if (c == "]" && leftstack.length != 0) {
        int left = leftstack[$ - 1];
        leftstack.popBack();
        int right = pc;
        brackets[left] = right;
        brackets[right] = left;
      }
      pc++;
    }

    for (int index; index < code.length; index++) {
      switch (code[index]) {
        case ">":
          memoryIndex++;
          break;

        case "<":
          memoryIndex--;
          break;

        case "+":
          ++memory[memoryIndex];
          break;

        case "-":
          --memory[memoryIndex];
          break;

        case ".":
          write(memory[memoryIndex].to!char);
          stdout.flush();
          break;

        case ",":
          string buf;
          while((buf = readln()) == null || !buf.length){}
          memory[memoryIndex] = cast(ubyte)buf[0];
          break;

        case "[":
          if (memory[memoryIndex] == 0) {
            index = brackets[index];
          }
          break;

        case "]":
          if (memory[memoryIndex] != 0) {
            index = brackets[index];
          }
          break;

        default: break;
      }
    }

    static if (!primitiveStrage) {
      code.free;
      memory.free;
    }
    memoryIndex = 0;
  }
}
