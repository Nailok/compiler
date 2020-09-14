# frozen_string_literal: true

# module for lexical analyze
module LexAnalyzer
  @symbols = { ARITHMETIC: ['+', '-', '/', '*', '='],
               COMPARISON: ['==', '<', '>', '<=', '>='],
               EOL: [';'],
               TERNARY: ['?', ':'],
               L_BRACE: ['{'],
               R_BRACE: ['}'],
               ROUND_R_BRACE: [')'],
               ROUND_L_BRACE: ['('],
               COMMA: [','] }

  @words = {
    STATEMENT: %w[if else],
    INT: ['int']
  }

  def self.analyze(data)
    arr = []
    line_value = 1

    data.each_line do |line|
      i = 0
      word = ''
      line.chomp!
      char = line.split('')

      while i < line.length

        while char?(char[i]) && i < line.length
          word += char[i]
          i += 1
        end

        @words.each_key do |k|
          if @words[k].include?(word)
            push_to_array(arr, line_value, @words, word)
            word = ''
          end
        end

        if numeric?(word)
          push_to_array_with_key(arr, word, :NUMBER, line_value)

        elsif !word.empty?
          push_to_array_with_key(arr, word, :VAR, line_value)
        end

        if (i + 1 < line.length) && include_in_hash?(@symbols, char[i] + char[i + 1])
          push_to_array(arr, line_value, @symbols, char[i] + char[i + 1])
          i += 1
        else
          push_to_array(arr, line_value, @symbols, char[i])
        end
        word = ''
        i += 1
      end
      line_value += 1
    end

    clear_array_from_garbage(arr)
    arr
  end

  def self.clear_array_from_garbage(arr)
    i = 0
    while i < arr.length
      if arr[i].length == 1
        arr.delete_at(i)
      elsif i += 1
      end
    end
  end

  def self.numeric?(str)
    Float(str)
  rescue StandardError
    false
  end

  def self.push_to_array_with_key(arr, var, key, line_value)
    sym = {}
    sym[key] = var
    sym[:line] = line_value
    arr.push(sym)
  end

  def self.push_to_array(arr, line_value, hash, value)
    sym = {}
    hash.each_key do |k|
      sym[k] = value if hash[k].include?(value)
    end

    sym[:line] = line_value
    arr.push(sym)
  end

  def self.include_in_hash?(hash, value)
    hash.each_key do |k|
      return true if hash[k].include?(value)
    end

    false
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

  def self.char?(char)
    char =~ /[0-9A-Za-z]/
  end
end
