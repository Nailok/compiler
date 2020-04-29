# frozen_string_literal: true

class Tokenizer
  STRING = %r{"(?:[^"\\]|\\(?:["\\/bfnrt]|u[0-9a-fA-F]{4}))*"}.freeze
  NUMBER = /-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/.freeze
  TRUE   = /true/.freeze
  FALSE  = /false/.freeze
  NULL   = /null/.freeze

  def initialize(io)
    @ss = StringScanner.new io.read
  end

  def next_token
    return if @ss.eos?

    if text = @ss.scan(STRING) then [:STRING, text]
    elsif text = @ss.scan(NUMBER) then [:NUMBER, text]
    elsif text = @ss.scan(TRUE)   then [:TRUE, text]
    elsif text = @ss.scan(FALSE)  then [:FALSE, text]
    elsif text = @ss.scan(NULL)   then [:NULL, text]
    else
      x = @ss.getch
      [x, x]
    end
  end
end
