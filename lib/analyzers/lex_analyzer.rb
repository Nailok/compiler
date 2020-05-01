# frozen_string_literal: true

module LexAnalyzer
  @symbols = { PLUS: '+', MINUS: '-', DIVIDER: '/', MULTIPLIER: '*',
               ASSIGNMENT: '=', COMPARSION: '==', LESSER: '<', GREATER: '>',
               LESSER_OR_EQUAL: '<=', GREATER_OR_EQUAL: '>=', EOL: ';',
               IS_TRUE: '?', IS_FALSE: ':', BRACE_OPEN: '{', BRACE_CLOSE: '}',
               BRACKET_OPEN: '(', BRACKET_CLOSE: ')' }

  @words = { IF: 'if', ELSE: 'else', INT: 'int' }

  def self.analyze(data)
    arr = []
    line_value = 1

    data.each_line do |line|
      i = 0
      word = ''
      line.chomp!
      char = line.split('')
      while i < line.length
        if @symbols.value?(char[i])
          push_to_array(arr, line_value, @symbols, char[i])

        elsif letter?(char[i])
          while letter?(char[i]) && i < line.length
            word += char[i]
            i += 1
          end
          if @words.value?(word)
            push_to_array(arr, line_value, @words, word)
            word = ''

          elsif !word.empty?
            push_var_to_array(arr, line_value, word)
            word = ''
          end
        end

        i += 1
      end
      line_value += 1
    end
    print_array(arr)
    arr
  end

  def self.push_var_to_array(arr, line_value, var)
    sym = {}
    sym[:ID] = var
    sym[:line] = line_value
    arr.push(sym)
  end

  def self.push_to_array(arr, line_value, hash, value)
    sym = {}
    key = hash.key(value)
    sym[key] = value
    sym[:line] = line_value
    arr.push(sym)
  end

  def self.print_array(arr)
    arr.each do |element|
      element.each do |k, v|
        if k != :line
          print "#{k} : '#{v}' , line: #{element[:line]}"
          puts ''
        end
      end
    end
  end

  def self.numeric?(char)
    char =~ /[0-9]/
  end

  def self.letter?(char)
    char =~ /[A-Za-z]/
  end
end
