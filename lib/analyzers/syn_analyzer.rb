require_relative '../../bin/token.rb'
require_relative '../../bin/key_id.rb'

# Syntax analyzer module
module SynAnalyzer
  @current_tok = Token.new(':INT', '+')
  @token_type = @current_tok.type.to_s
  @i = 0
  @arr = []

  def self.next_token
    unless @arr.empty?
      temp = @arr.shift
      @current_tok = Token.new(temp.keys[0], temp.values[0])
      @token_type = @current_tok.type.to_s
    end
  end

  def self.accept(value)
    if @token_type == value
      p 'Value: ' + value + ' accepted.'
      next_token
      return true
    end
    false
  end

  def self.expect(value)
    return true if accept(value)

    raise 'Wrong value...'
  end

  def self.init
    if accept(KeyId::INT)
      expect(KeyId::VAR)
      expect(KeyId::ARITHMETIC)
      if accept(KeyId::VAR)
      elsif accept(KeyId::NUMBER)
      else raise 'init: Wrong symbol'
      end
      expect(KeyId::EOL)
      init
    else
      p 'BREAK OUT RECURSION'
      nil
    end
  end

  # def self.factor
  # if accept(KeyId::VAR)
  # elsif accept(KeyId::NUMBER)
  # elsif accept(KeyId::ROUND_L_BRACE)
  # expression
  # expect(KeyId::ROUND_R_BRACE)
  # else
  # raise 'Factor: syntax error'
  # end
  # end

  # def self.term
  # factor
  # while @token_type == KeyId::ARITHMETIC
  # next_token
  # puts 'Term: ' + @token_type
  # factor
  # end
  # end

  # def self.factor

  # end

  # def self.parse_expr; end

  # def self.parse_var_init; end

  # def self.parse_if_stmnt; end

  def self.program(arr)
    @arr = arr
    next_token
    init

    # expect(@token_type)
  end
end
