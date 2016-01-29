module brainfuck.interpreter;

import brainfuck.virtualMemory,
       brainfuck.operatorTable,
       brainfuck.virtualMachine;
import std.stdio,
       std.string;

class Interpreter {
  private OperatorTable opTable;
  private VirtualMachine vm;

  this(OperatorTable table) {
    opTable = table;
    vm = new VirtualMachine(table);
  }

  this() {
    opTable = new OperatorTable;
    vm = new VirtualMachine;
  }

  void interpreter() {
    while (true) {
      write("=> ");
      string input = readln.chomp;
      
      if (input == "exit") {
        writeln("Exit interpreter");
        return;
      }

      vm.process(input);
    }
  }
}
