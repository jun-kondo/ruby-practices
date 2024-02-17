# frozen_string_literal: true

require 'optparse'

class WcCommand
  def initialize; end

  def argv
    {
      options: ARGV.getopts('lwc'),
      file_names: ARGV
    }
  end

  def main
    # options = argv[:options]
    file_names = argv[:file_names]
    counter_list = counter(file_names)
    calc_total(counter_list).map do |list|
      [
        list[:line].to_s.rjust(8),
        list[:word].to_s.rjust(7),
        list[:byte].to_s.rjust(7),
        list[:file_name]
      ].join(' ')
    end.join("\n")
  end

  def calc_total(counter_list)
    if counter_list.size > 1
      total_amount = {
        line: counter_list.map { _1[:line] }.inject(:+),
        word: counter_list.map { _1[:word] }.inject(:+),
        byte: counter_list.map { _1[:byte] }.inject(:+),
        file_name: 'total'
      }
      counter_list << total_amount
    else
      counter_list
    end
  end

  def counter(file_names)
    file_names.map do |file_name|
      File.open(file_name) do |f|
        words = f.readlines
        {
          line: words.map { |w| w.count("\n") }.inject(:+),
          word: words.join.split.size,
          byte: words.join.bytesize,
          file_name:
        }
      end
    end
  end
end

wc = WcCommand.new
puts wc.main
