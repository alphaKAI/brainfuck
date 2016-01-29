import brainfuck.virtualMachine,
       brainfuck.interpreter,
       brainfuck.operatorTable;
import std.stdio,
       std.file;

void main(string[] args) {
  VirtualMachine vm;
  Interpreter interpreter;

  if (args.length == 1) {
    interpreter = new Interpreter;
    interpreter.interpreter;
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
