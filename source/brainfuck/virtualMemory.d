module brainfuck.virtualMemory;

import std.conv;

class VirtualMemory(T) {
  private T[] memory;
  private immutable ulong defaultMemorySize = 300000;
  private ulong memorySize;

  this(ulong size) {
    memorySize = size;
    initMemory;
  }

  this() {
    memorySize = defaultMemorySize;
    initMemory;
  }

  public void allocate(ulong size) {
    memory.length = size;
    syncMemorySize;
  }

  public void expandSize(ulong size) {
    memory.length += size;
    syncMemorySize;
  }

  public void reallocate(ulong size) {
    free;
    memory.length = size;
    syncMemorySize;
  }

  public void free() {
    memory = [];
    syncMemorySize;
  }

  @property ulong size() {
    return memorySize;
  }

  private void syncMemorySize() {
    memorySize = memory.length;
  }

  private void initMemory() {
    if (memorySize != defaultMemorySize) {
      memory.length = memorySize;
      syncMemorySize;
    } else {
      memory.length = defaultMemorySize;
      syncMemorySize;
    }
  }

  void opIndexAssign(T value, size_t index) {
    if (memorySize < index) {
      throw new Error("Invalid index - out of memory. Memory size is " ~ memorySize.to!string ~ " but you orderd " ~ index.to!string);
    } else {
      memory[index] = value;
    }
  }
  
  T opIndex(size_t index) {
    if (memorySize < index) {
      throw new Error("invalid index - out of memory. memory size is " ~ memorySize.to!string ~ " but you orderd " ~ index.to!string);
    } else {
      return memory[index];
    }
  }

  void opAssign(T[] data) {
    if (memorySize < data.length) {
      throw new Error("Can't assign such a large data to memory. MemorySize is " ~ memorySize.to!string ~ " but you gave " ~ data.length.to!string);
    } else {
      memory = data;
    }
  }

  void opIndexUnary(string op)(size_t index) if (op == "++"){
    if (memorySize < index) {
      throw new Error("invalid index - out of memory. memory size is " ~ memorySize.to!string ~ " but you orderd " ~ index.to!string);
    } else {
      memory[index]++;
    }
  }

  void opIndexUnary(string op)(size_t index) if (op == "--"){
    if (memorySize < index) {
      throw new Error("invalid index - out of memory. memory size is " ~ memorySize.to!string ~ " but you orderd " ~ index.to!string);
    } else {
      memory[index]--;
    }
  }
}
