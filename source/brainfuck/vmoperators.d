module brainfuck.vmoperators;

enum vmRight = '>',
     vmLeft  = '<',
     vmAdd   = '+',
     vmSub   = '-',
     vmDot   = '.',
     vmComma = ',',
     vmRBracket = '[',
     vmLBracket = ']';

struct vmOperator {
  public int type;
}

