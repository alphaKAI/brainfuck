module brainfuck.operatorTable;
import std.algorithm.searching,
       std.algorithm.iteration,
       std.string,
       std.range;

class OperatorTable {
  private string[string] table;
  private static immutable string[] operators = [">", "<", "+", "-", ".", ",", "[", "]"];

  this(string[string] _table) {
    foreach(key, value; _table) {
      if (validKey(key)) {
        table[key] = value;
      } else {
        throw new Error("Invalid operator \"" ~ key ~ "\" was given.");
      }
    }
  }

  this() {
    foreach (key; operators) {
      table[key] = key;
    }
  }

  public string lookupTable(string key) {
    if (keyExists(key)) {
      return table[key];
    } else {
      throw new Error("Undefined Operator \"" ~ key ~ "\" was given.");
    }
  }

  public static string[] removeTrash(string key) {
    return key.split("").filter!(x => validKey(x)).array;
  }

  private bool keyExists(string key) {
    return table.keys.canFind(key);
  }

  private static bool validKey(string key) {
    return operators.canFind(key);
  }
}
