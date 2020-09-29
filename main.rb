# frozen_string_literal: true

# Main class
class Main
  def initialize(options)
    @input = options[:input]
    @analyzer = options[:analyze]
  end

  def run
    data = FileReader.read(@input)
    p 'CODE: '
    puts data
    puts '____________________________________'
    analyzed = LexAnalyzer.analyze(data)
    # puts analyzed
    LexAnalyzer.print_array(analyzed)
    tree = SynAnalyzer.program(analyzed)
    SemAnalyzer.fill_all_vars(tree)

    SemAnalyzer.print
  end
end
