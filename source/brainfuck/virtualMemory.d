module brainfuck.virtualMemory;

import std.conv;
import core.memory;

ref class VirtualMemory(T) {
  private T* memory;
  private immutable ulong defaultMemorySize = 300000;
  private size_t memorySize;

  this(size_t size = defaultMemorySize) {
    memorySize = size;
    initMemory;
  }
  
  private void initMemory() {
    if (memorySize != defaultMemorySize) {
      allocate(memorySize);
      syncMemorySize(memorySize);
    } else {
      allocate(defaultMemorySize);
      syncMemorySize(defaultMemorySize);
    }
  }

  private void syncMemorySize(size_t size) {
    memorySize = size;
  }

  public void allocate(size_t size) {
    memory = cast(T*)GC.malloc(size * T.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    syncMemorySize(size);
  }

  public void extendSize(size_t size) {
    size_t eSize = GC.extend(memory, memorySize + size, size);
    //Error Handling
    syncMemorySize(memorySize + eSize);
  }

  public void reallocate(size_t size) {
    //Need to Error Handler
    GC.realloc(memory, size * T.sizeof, GC.BlkAttr.NO_SCAN | GC.BlkAttr.APPENDABLE);
    syncMemorySize(size);
  }

  public void free() {
    GC.free(memory);
    memory = null;

    syncMemorySize(0);
  }

  @property ulong length(){
    return size;
  }
  @property ulong size() {
    return memorySize;
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
      foreach(i, e; data) {
        memory[i] = e;
      }
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
