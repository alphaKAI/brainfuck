module brainfuck.repl;

import brainfuck.operatorTable,
       brainfuck.virtualMachine,
       brainfuck.parser,
       brainfuck.vmoperators;
import std.stdio,
       std.string,
       std.conv;

immutable useNewVM = true;

class REPL {
  private VirtualMachine vm;
  private OperatorTable opTable;

  this(OperatorTable table) {
    vm = new VirtualMachine(table);
    opTable = table;
  }

  this() {
    vm = new VirtualMachine;
    opTable = new OperatorTable;
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

      if (stdin.eof) {
        return;
      }

      static if (useNewVM) {
        vm.vmExec(parser(opTable.compile(input).join.to!(char[])));
      } else {
        vm.process(input);
      }
    }
  }
}
