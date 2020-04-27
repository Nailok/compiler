# frozen_string_literal: true

module LexAnalyzer
  @reserved = { plus: '+', minus: '-', divider: '/', multiplier: '*',
              assignment: '=', comparsion: '==',lesser: '<', greater: '>',
              lesser_or_equal: '<=', greater_or_equal: '>=', case: 'case',
              when: 'when', string: '"' }

  def self.analyze(data)
    i = 0
    token = {}

    
    data.split(' ') do |item|
      @reserved.each do |key, value|
        if item.include?(value)
          p item
          token.merge!(key: item) 
         end 
      end
      i += 1
    end
    p token
  end

  def self.check_string(string)
    string.scan(/\D/).empty?
  end
end
