class Main

  def initialize(options)
    @input = options[:input]
    @analyzer = options[:analyze]
  end

  def run
    data = FileReader.read(@input)
    p data.split.map(&:chomp)
  end
end
