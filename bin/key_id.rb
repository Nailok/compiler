require 'ruby-enum'
class KeyId 
  include Ruby::Enum
  define :ARITHMETIC, 'ARITHMETIC'
  define :COMPARISON, 'COMPARISON'
  define :EOL, 'EOL'
  define :STATEMENT, 'STATEMENT'
  define :INT, 'INT'
  define :TERNARY, 'TERNARY'
  define :NUMBER, 'NUMBER'
  define :VAR, 'VAR'
  define :L_BRACE, 'L_BRACE'
  define :R_BRACE, 'R_BRACE'
  define :ROUND_R_BRACE, 'ROUND_R_BRACE'
  define :ROUND_L_BRACE, 'ROUND_L_BRACE'
  define :COMMA, 'COMMA'
end
