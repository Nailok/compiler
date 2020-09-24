require 'awesome_print'

class AST
  attr_accessor :left, :operator, :right

  # def initialize(left, operator, right)
  # @left = left
  # @operator = operator
  # @right = right
  # end

  def self.show(node)
    return if node.nil?

    puts 'Operator: ' + node.operator
    puts 'Left: ' + node.left.value
    puts 'Right: ' + node.right.value
    show(node.left)
    show(node.right)
  end
end

class VarAST < AST
  attr_accessor :type, :value
  def initialize(type, value)
    @type = type
    @value = value
  end
end

class AssignAST < AST
  attr_accessor :var, :op, :value

  def initialize(var, value)
    @var = var
    @op = '='
    @value = value
  end
end

class NumAST < AST
  attr_accessor :type, :value
  def initialize(type, value)
    @type = type
    @value = value
  end
end

class IfAST < AST
  attr_accessor :block, :body

  def initialize(block, body)
    @block = block
    @body = body
  end
end

class IfConditionAST < AST
  attr_accessor :left, :cond, :right

  def initialize(left, cond, right)
    @left = left
    @cond = cond
    @right = right
  end
end

class IfBodyAST < AST
  attr_accessor :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end
end

class ExprAST < AST
  attr_accessor :left, :operator, :right
  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end

  def show
    puts 'Operator: = ' + @operator
    # puts "Left: + " + @left
    # puts "Right: + " + @right
  end
end

class NodeVisitor
  def self.visit(node)
    method_name = 'visit_' + node.class.to_s
    send(method_name, node)
  end

  def self.visit_ExprAST(node)
    # ap node
    puts node.operator
    # NodeVisitor.visit(node)
  end

  def self.visit_NumAST(node)
    puts node.value
  end

  def self.visit_VarAST(node)
    puts node.value
  end

  def self.preorder(node)
    return nil if node.nil?

    visit(node)
    preorder(node.left)
    preorder(node.right)
  end
end
