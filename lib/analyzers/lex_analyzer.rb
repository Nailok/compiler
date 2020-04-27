# frozen_string_literal: true

module LexAnalyzer

  def self.analyze(data)
    @tokens = { plus: '+', minus: '-', divider: '/', multiplier: '*', assignment: '=', comparsion: '==',
                lesser: '<', greater: '>', lesser_or_equal: '<=', greater_or_equal: '>=', case: 'case',
                when: 'when', from_to: '..', from_to_exclude_last: '...', string: "\"" }
    i = 0

    data.split(' ') do |item|
      @tokens.each do |key, value|
        p "{#{key}: #{item}, line: #{i}}" if item.strip == key[value]
        p "{num: #{item}}, line: #{i}}" if check_string(item.strip)
        
      end
      i += 1
    end
  end

  def self.check_string(string)
    string.scan(/\D/).empty?
  end
end
