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
      loop do
        temp = @root_node << Tree::TreeNode.new("VARIABLE_DECLARATION (#{@token_value})", @token_value)
        temp << Tree::TreeNode.new('VARIABLE_TYPE (INT)', KeyId::INT)
        expect(KeyId::VAR)
        expect(KeyId::ASSIGNMENT)
        if accept(KeyId::VAR) || accept(KeyId::NUMBER)
        else raise 'init: Wrong symbol'
        end
        break unless accept(KeyId::COMMA)
      end
      expect(KeyId::EOL)
      init
    end
    statement
  end

  def self.factor
    if accept(KeyId::VAR)
    elsif accept(KeyId::NUMBER)
    elsif accept(KeyId::ROUND_L_BRACE)
      node = expression
      expect(KeyId::ROUND_R_BRACE)
    else
      raise 'Factor: Wrong symbol'
    end

    node
  end

  def self.term
    factor
    factor while accept(KeyId::MULTIPLY) || accept(KeyId::DIV)
    node
  end

  def self.expression
     if accept(KeyId::PLUS) || accept(KeyId::MINUS) 
       next_token
     end
    node = term
    term while accept(KeyId::PLUS) || accept(KeyId::MINUS)
    # p node
    # p node.left
    # p node.right
    # puts
    # NodeVisitor.preorder(node)
    node
  end

  def self.condition
    expression
    if accept(KeyId::COMPARISON)
      expression
    else
      raise 'Condition: invalid operator'
    end
  end

  def self.statement
    if accept(KeyId::VAR)
      expect(KeyId::ASSIGNMENT)
      expression
      expect(KeyId::EOL)
    elsif accept(KeyId::IF)
      expect(KeyId::ROUND_L_BRACE)
      node = condition
      expect(KeyId::ROUND_R_BRACE)
      expect(KeyId::L_BRACE)
      statement until accept(KeyId::R_BRACE)
      if accept(KeyId::ELSE)
        if accept(KeyId::IF)
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
    # init unless @arr.empty?
    init
    @root_node << Tree::TreeNode.new('END', 'end')
    @root_node.print_tree
  end
end
