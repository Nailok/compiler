# frozen_string_literal: true

module FileReader
  def self.read(path)
    file = File.open(path)
    data = file.read
  end
end
