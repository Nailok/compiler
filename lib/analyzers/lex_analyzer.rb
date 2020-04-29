# frozen_string_literal: true

module LexAnalyzer
  @symbols = { plus: '+', minus: '-', divider: '/', multiplier: '*',
               assignment: '=', comparsion: '==', lesser: '<', greater: '>',
               lesser_or_equal: '<=', greater_or_equal: '>=', eol: ';',
               isTrue: '?', isFalse: ':', brace_open: '{', brace_close: '}',
               bracket_open: '(', bracket_close: ')' }

  @words = { if: 'if', else: 'else', int: 'int' }

  def self.analyze(data)
    sym = {}
    arr = []
    value = {}
    data.each_line do |line|
      word = ''
      line.chomp!
      chars = line.split('')
      chars.each do |char|
        next if char == ' '

        if @symbols.value?(char)
          key = @symbols.key(char)
          p key
          sym[key] = char
          arr.push(sym)
          sym.clear
        elsif letter?(char)
          word += char
          end
        if @words.value?(word)
          key = @words.key(word)
          sym[key] = word
          arr.push(sym)
          sym.clear
        end
      end
    end
    p arr
  end

  def self.letter?(lookAhead)
    lookAhead =~ /[[:alpha:]]/
  end

  def self.numeric?(lookAhead)
    lookAhead =~ /[[:digit:]]/
  end
end
