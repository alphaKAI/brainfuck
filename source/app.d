import brainfuck.virtualMachine,
       brainfuck.repl,
       brainfuck.operatorTable;
import std.stdio,
       std.file;

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
      vm.process(readText(fileName));
    } else {
      writeln("File not found such a file : ", fileName);
    }
  }
}
