# frozen_string_literal: true

# Main class
class Main
  def initialize(options)
    @input = options[:input]
    @analyzer = options[:analyze]
  end

  def run
    data = FileReader.read(@input)

    analyzed = LexAnalyzer.analyze(data)
    LexAnalyzer.print_array(analyzed)

    # analyzer = LexAnalyzer.new
    # analyzed_data = analyzer.analyze(data)
    # analyzed_data = LexAnalyzer.analyze(data)
  end
end
