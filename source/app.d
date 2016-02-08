import brainfuck.virtualMachine,
       brainfuck.repl,
       brainfuck.parser,
       brainfuck.operatorTable,
       brainfuck.vmoperators;
import std.string,
       std.stdio,
       std.file,
       std.conv;

immutable useNewVM = true;

void main(string[] args) {
  VirtualMachine vm;
  REPL repl;

  if (args.length == 1) {
    repl = new REPL;
    repl.repl;
  } else if (args.length == 2) {
    string fileName = args[1];
    if (exists(fileName)) {
      vm = new VirtualMachine;
      OperatorTable opTable = new OperatorTable;

      static if (useNewVM) {
        vm.vmExec(parser(opTable.compile(readText(fileName)).join.to!(char[])));
      } else {
        vm.process(readText(fileName));
      }
    } else {
      writeln("File not found such a file : ", fileName);
    }
  }
}
