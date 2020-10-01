module Translator
  def self.var?(v)
    if SynAnalyzer.variables.include?(v)
      print "&#{v}& "
    else
      print "#{v} "
    end
  end

  def self.init(node)
    if node['type'] == 'int'
      puts "&#{node['name']}&"

      node.values[2..-2].each do |val|
        if val.is_a?(Array)
          val.flatten!

          val.each do |v|
            var?(v)
          end
        else
          var?(val)
        end
      end
      puts
    end
  end

  def self.condition(node)
    if node['string_type'] == 'condition'
      node.values[2..-2].each do |val|
        if val.is_a?(Array)
          val.flatten!

          val.each do |v|
            var?(v)
          end
        else
          var?(val)
        end
      end
    elsif node['string_type'] == 'condition_open'
      puts
      print 'IF '
    elsif node['string_type'] == 'condition_sign'
      print node['value'].to_s + " "
    elsif node['string_type'] == 'condition_close'
      print "THEN "
    end
  end

  def self.statement(node)
    if node['string_type'] == 'if-body_open'
      print "BEGIN "
      puts
    elsif node['string_type'] == 'if-body_close'
      puts
      print "END "
    elsif node['string_type'] == 'else-body_open'
      print "ELSE BEGIN "
      puts
    elsif node['string_type'] == 'else-body_close'
      print "END "
    end
  end

  def self.assignment(node)
    if node['string_type'] == 'assignment'
      print "&#{node['name']}& := "
      node.values[2..-2].each do |val|
        if val.is_a?(Array)
          val.flatten!

          val.each do |v|
            var?(v)
          end
        else
          var?(val)
        end
      end

    end
 
  end

  def self.translate(tree)
    tree.each do |node|
      init(node)
      condition(node)
      assignment(node)
      statement(node)

      # puts "Init var: " + init(node).to_s if init(node) != false
    end
    puts
  end
end
