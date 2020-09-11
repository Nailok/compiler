require 'ruby-enum'
class KeyId 
  include Ruby::Enum
  define :ARITHMETIC, 'ARITHMETIC'
  define :COMPARISON, 'COMPARISON'
  define :EOL, 'EOL'
  define :BRACE, 'BRACE'
  define :STATEMENT, 'STATEMENT'
  define :INT, 'INT'
  define :TERNARY, 'TERNARY'
end
