# Semantic analyzer
module SemAnalyzer
  @variables = []

  def self.insert(key, value, position)
    @var_params = {}
    @var_params[key] = value
    @var_params['position'] = position

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
    puts '___________________________________________________'
    tree.each do |node|
      insert(node["name"], node["value"], i) if node["type"] == 'int'
      i += 1
    end
  end

  def self.fill_all_vars(tree)
    i = 0
    tree.each do |node|
      insert(node["name"], node["value"], i) if node["type"] == 'int'
      i += 1
      if node["name"] != 'none'
        if h = @variables.find { |hash| hash.key?(node["name"]) }
        else 
          raise "Variable " + node["name"] + " is not initialized" 
        end
        @variables.each do |elem|
          
          # puts node.assoc(elem["name"]) 
          # puts elem
          # puts
         # if node.assoc(elem["name"]) == nil
           # raise 'Variable is not initialized'
         # end
        end
      end 
    end
  end
end
