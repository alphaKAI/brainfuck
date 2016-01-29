module brainfuck.repl;

import brainfuck.virtualMemory,
       brainfuck.operatorTable,
       brainfuck.virtualMachine;
import std.stdio,
       std.string;

class REPL {
  private VirtualMachine vm;

  this(OperatorTable table) {
    vm = new VirtualMachine(table);
  }

  this() {
    vm = new VirtualMachine;
  }

  void repl() {
    writeln("You can exit the REPL with exit");

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
