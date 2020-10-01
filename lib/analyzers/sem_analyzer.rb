# Semantic analyzer
module SemAnalyzer
  @variables = []

  def self.insert(key, value)
    @var_params = {}
    @var_params[key] = value

    @variables << @var_params
  end

  def self.print
    puts @variables
  end

  def self.fill_tables(tree)
    fill_table(tree)
    print
    fill_all_vars(tree)
  end

  def self.fill_table(tree)
    tree.each do |node|
      insert(node['name'], node['value']) if node['type'] == 'int'
    end
  end

  def self.check_uninitialized_vars
    res = (SynAnalyzer.variables.to_a - SynAnalyzer.int_variables.to_a)
    if  (SynAnalyzer.variables.to_a - SynAnalyzer.int_variables.to_a).empty?
    else
      raise 'Vars are not initialized: ' + res.to_s
    end
  end

  def self.check_vars(tree)
    check_uninitialized_vars

    tree.each do |node|
      insert(node['name'], node['value']) if node['type'] == 'int'

      node.values.each do |val|
        if val.is_a?(Array)
          val.flatten!

          val.each do |v|
            next unless SynAnalyzer.variables.include?(v)
            if @variables.find { |hash| hash.key?(v) }
            else
              raise 'Variable ' + v.to_s + ' is not initialized'
            end
          end

        elsif SynAnalyzer.variables.include?(val)
          if @variables.find { |hash| hash.key?(val.to_s) }
          else
            raise 'Variable ' + node['name'] + ' is not initialized'
          end
        end
      end
    end
  end
end
