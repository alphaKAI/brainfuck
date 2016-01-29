module brainfuck.virtualMachine;

import brainfuck.virtualMemory,
       brainfuck.operatorTable;
import std.stdio;

class VirtualMachine {
  private VirtualMemory!string code;
  private VirtualMemory!ubyte memory;
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
    code    = new VirtualMemory!string;
    memory  = new VirtualMemory!ubyte;
  }

  public void process(string input) {
    string[] _code = opTable.compile(input);
    code.reallocate(_code.length);
    memory.reallocate(_code.length);

    code = _code;

    for (ulong index; index < code.size; index++) {
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
          write(cast(char)(memory[memoryIndex]));
          break;

        case ",":
          string buf;
          while((buf = readln()) == null || !buf.length){}
          memory[memoryIndex] = cast(ubyte)buf[0];
          break;

        case "[":
          if (memory[memoryIndex] == 0) {
            int depth;

            for (index++; depth > 0 || code[index] != "]"; index++) {
              if (code[index] == "[") {
                depth++;
              } else if (code[index] == "]") {
                depth--;
              }
            }
          }
          break;

        case "]":
          if (memory[memoryIndex] != 0) {
            int depth;

            for (index--; depth > 0 || code[index] != "["; index--) {
              if (code[index] == "]") {
                depth++;
              } else if (code[index] == "[") {
                depth--;
              }
            }

            index--;
          }
          break;

        default: break;
      }
    }

    code.free;
    memory.free;
    memoryIndex = 0;
  }
}
