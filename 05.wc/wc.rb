# frozen_string_literal: true

def main
  file_name = 'word_count.txt'
  File.open(file_name) do |f|
    words = f.readlines
    line = words.map { |w| w.count("\n")}.inject(:+)
    word = words.join.split.size
    byte = words.join.bytesize
    [
      line.to_s.rjust(8),
      word.to_s.rjust(7),
      byte.to_s.rjust(7),
      file_name
    ].join(' ')
  end
end

puts main
