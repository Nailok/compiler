require 'tree'

require_relative '../../bin/ast.rb'
require_relative '../../bin/token.rb'
require_relative '../../bin/key_id.rb'

# Syntax analyzer module
module SynAnalyzer
  @current_tok = Token.new('', '')
  @token_type = @current_tok.type.to_s
  @arr = []
  @errors = []
  @root_node = Tree::TreeNode.new('BEGIN', 'begin')
  @step = 0
  @tree = []

  def self.add_node(type, name, value, string_type)
    props = { 'type' => type, 'name' => name, 'value' => value, 'string_type' => string_type }
    @tree << props
  end

  def self.print_tree
    @tree.each do |node|
      puts node
    end
  end

  def self.inc_step
    @step += 1
    @step
  end

  def self.next_token
    unless @arr.empty?
      temp = @arr.shift

      @prev_tok = @current_tok
      @prev_type = @prev_tok.type.to_s
      @prev_value = @prev_tok.value.upcase

      @current_tok = Token.new(temp.keys[0], temp.values[0])
      @token_type = @current_tok.type.to_s
      @token_value = @current_tok.value.upcase
      @token_line = temp.values[1]
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

  def self.init
    if accept(KeyId::INT)
      expect(KeyId::VAR)
      temp_var = @prev_value
      expect(KeyId::ASSIGNMENT)
      if accept(KeyId::VAR) || accept(KeyId::NUMBER)
        add_node('int', temp_var, @prev_value, 'init')
      else raise 'init: Wrong symbol'
      end
      expect(KeyId::EOL)
      init
    end
    statement
  end

  def self.factor
    if accept(KeyId::VAR)
      @prev_value
    elsif accept(KeyId::NUMBER)
      @prev_value
    elsif accept(KeyId::ROUND_L_BRACE)
      expression
      expect(KeyId::ROUND_R_BRACE)
    else
      raise 'Factor: Wrong symbol'
    end
  end

  def self.term
    arr = []
    sign = @prev_value
    arr << factor
    arr << { 'operation' => @token_value } if @token_type == KeyId::ARITHMETIC

    while accept(KeyId::MULTIPLY) || accept(KeyId::DIV)
      arr << factor
      arr << { 'operation' => @token_value } if @token_type == KeyId::ARITHMETIC
    end
    arr
  end

  def self.expression(var)
    arr = []
    next_token if accept(KeyId::PLUS) || accept(KeyId::MINUS)
    arr << { 'value' => term }
    while accept(KeyId::PLUS) || accept(KeyId::MINUS)
      sign = @prev_value
      arr << { 'value' => term }
    end
    add_node('none', var, arr, 'expression')
    arr
  end

  def self.condition
    arr = []
    add_node('none', 'none', 'none', 'condition_open')
    left = expression('none')
    if accept(KeyId::COMPARISON)
      sign = @prev_value
      add_node('none', 'none', sign, 'condition')
      right = expression('none')
      add_node('none', 'none', 'none', 'condition_close')
    else
      raise 'Condition: invalid operator'
    end
  end

  def self.statement
    if accept(KeyId::VAR)
      temp_var = @prev_value
      expect(KeyId::ASSIGNMENT)
      expression(temp_var)
      expect(KeyId::EOL)
    elsif accept(KeyId::IF)
      expect(KeyId::ROUND_L_BRACE)
      condition
      expect(KeyId::ROUND_R_BRACE)
      expect(KeyId::L_BRACE)
      statement until accept(KeyId::R_BRACE)
      if accept(KeyId::ELSE)
        add_node('none', 'none', 'none', 'else')
        if accept(KeyId::IF)
          add_node('none', 'none', 'none', 'if')
          expect(KeyId::ROUND_L_BRACE)
          condition
          expect(KeyId::ROUND_R_BRACE)
        end
        expect(KeyId::L_BRACE)
        statement until accept(KeyId::R_BRACE)
      elsif accept(KeyId::L_BRACE)
        statement
        expect(KeyId::R_BRACE)
      end
    end
  end

  def self.program(arr)
    @arr = arr
    next_token
    init until @arr.empty?

    print_tree
    return @tree
  end
end
