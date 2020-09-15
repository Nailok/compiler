require_relative '../../bin/token.rb'
require_relative '../../bin/key_id.rb'

# Syntax analyzer module
module SynAnalyzer
  @current_tok = Token.new('', '')
  @token_type = @current_tok.type.to_s
  @arr = []

  def self.next_token
    unless @arr.empty?
      temp = @arr.shift
      @current_tok = Token.new(temp.keys[0], temp.values[0])
      @token_type = @current_tok.type.to_s
      @token_value = @current_tok.value.upcase
    end
  end

  def self.present_in_token?(value)
    return true if @token_type == value || @token_value == value

    false
  end

  def self.accept(value)
    if present_in_token?(value)
      p 'Value: ' + value + ' accepted.'
      next_token
      return true
    end
    false
  end

  def self.expect(value)
    return true if accept(value)

    puts 'EXPECT: ' + value
    raise 'Wrong value...'
  end

  def self.assigment; end

  def self.init
    if accept(KeyId::INT)
      loop do
        expect(KeyId::VAR)
        expect(KeyId::ASSIGNMENT)
        if accept(KeyId::VAR)
        elsif accept(KeyId::NUMBER)
        else raise 'init: Wrong symbol'
        end
        break unless accept(KeyId::COMMA)
      end
      expect(KeyId::EOL)
      init
      # else
      # p 'BREAK OUT RECURSION'
      # # nil
    end
    statement
  end

  def self.factor
    if accept(KeyId::VAR)
    elsif accept(KeyId::NUMBER)
    elsif accept(KeyId::ROUND_L_BRACE)
      expression
      expect(KeyId::ROUND_R_BRACE)
    else
      raise 'Factor: Wrong symbol'
    end
  end

  def self.term
    factor
    while accept(KeyId::MULTIPLY) || accept(KeyId::DIV)
      # next_token
      factor
    end
  end

  def self.expression
    next_token if accept(KeyId::PLUS) || accept(KeyId::MINUS)
    term
    while accept(KeyId::PLUS) || accept(KeyId::MINUS)
      # next_token
      term
    end
  end

  def self.condition
    expression
    if accept(KeyId::COMPARISON)
      # next_token
      expression
    else
      raise 'Condition: invalid operator'
    end
  end

  def self.statement
    if accept(KeyId::VAR)
      expect(KeyId::ASSIGNMENT)
      expression
      # expect(KeyId::EOL)
    elsif accept(KeyId::IF)
      expect(KeyId::ROUND_L_BRACE)
      condition
      expect(KeyId::ROUND_R_BRACE)
      expect(KeyId::L_BRACE)
      until accept(KeyId::R_BRACE)
        expression
        expect(KeyId::EOL)
      end
      if accept(KeyId::ELSE)
        if accept(KeyId::IF)
          expect(KeyId::ROUND_L_BRACE)
          condition
          expect(KeyId::ROUND_R_BRACE)
          expect(KeyId::L_BRACE)
          until accept(KeyId::R_BRACE)
            expression
            expect(KeyId::EOL)
          end
        end
      elsif accept(KeyId::L_BRACE)
        statement
        expect(KeyId::R_BRACE)
      end
    end
  end

  def self.ternary
    condition
  end

  # else
  # expect(KeyId::L_BRACE)
  # while !accept(KeyId::R_BRACE)
  # expression
  # expect(KeyId::EOL)
  # end
  # expect(KeyId::R_BRACE)
  # end

  # def self.statement
  # if accept(KeyId::IF)
  # if accept(KeyId::ROUND_L_BRACE)
  # condition
  # expect(KeyId::ROUND_R_BRACE)
  # elsif accept('?')
  # expression
  # expect(':')
  # expression
  # end
  # end
  # end

  # def self.expression
  # expect(KeyId::VAR)
  # expect(KeyId::ASSIGNMENT)
  # loop do
  # if accept(KeyId::VAR) || accept(KeyId::NUMBER)
  # expect(KeyId::ARITHMETIC)
  # if accept(KeyId::VAR) || accept(KeyId::NUMBER)
  # else raise 'expression: Wrong symbol'
  # end
  # else raise 'expression: Wrong symbol'
  # end
  # break unless accept(KeyId::COMMA)
  # end
  # end

  def self.program(arr)
    @arr = arr
    next_token
    init unless @arr.empty?
    # statement
  end
end
