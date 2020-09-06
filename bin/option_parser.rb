# frozen_string_literal: true

require 'optparse'

# parse options
class OptionParser
  @options = {}
  def self.parse
    OptionParser.new do |parser|
      parser.on('-i', '--input=FILE',
                'File to analyze')
      parser.on('-l', '--analyzer=ANALYZER',
                'Run lexical analyzer')
      parser.on('-h', '--help', 'Prints this help') do
        exit
      end
    end.parse!(into: @options)
    @options
  end
end
