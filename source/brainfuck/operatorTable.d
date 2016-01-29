module brainfuck.operatorTable;
import std.algorithm.searching,
       std.algorithm.iteration,
       std.string,
       std.range,
       std.conv;

class OperatorTable {
  private string[string] table;
  public static immutable string[] operators = [">", "<", "+", "-", ".", ",", "[", "]"];
  private bool useOriginalToken;

  this(string[string] _table) {
    foreach(key, value; _table) {
      if (validKey(key)) {
        table[value] = key;
      } else {
        throw new Error("Invalid operator \"" ~ key ~ "\" was given.");
      }
    }
    useOriginalToken = true;
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

  public string[] removeTrash(string key) {
    return key.split("").filter!(x => keyExists(x)).array;
  }

  public string[] compile(string input) {
    if (useOriginalToken) {
      return removeTrash(input.split("").filter!(x => table.keys.canFind(x)).map!(x => lookupTable(x)).join);
    } else {
      return removeTrash(input);
    }
  }

  private bool keyExists(string key) {
    return table.keys.canFind(key);
  }

  private bool validKey(string key) {
    return operators.canFind(key);
  }
}
