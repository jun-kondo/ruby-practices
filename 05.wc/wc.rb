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
    options = argv[:options]
    file_names = argv[:file_names]
    counter_list = counter(file_names, options)
    calc_total(counter_list).map do |list|
      low = ['']
      list[:count].each_value { |v| low << v.to_s.rjust(7) }
      low << list[:file_name]
      low.join(' ')
    end.join("\n")
  end

  def calc_total(counter_list)
    if counter_list.size > 1
      total_amount = { file_name: 'total', count: {} }
      counter_list.map do |low|
        low[:count].each_key do |k|
          total_amount[:count][k] = counter_list.map { _1[:count][k] }.inject(:+)
        end
      end
      counter_list << total_amount
    else
      counter_list
    end
  end

  def counter(file_names, options)
    file_names.map do |file_name|
      File.open(file_name) do |f|
        words = f.readlines
        if options.value?(true)
          optional_count(words, options, file_name)
        else
          {
            file_name:,
            count: {
              line: words.map { |w| w.count("\n") }.inject(:+),
              word: words.join.split.size,
              byte: words.join.bytesize
            }
          }
        end
      end
    end
  end

  def optional_count(words, options, file_name)
    low = { file_name:, count: {} }
    low[:count][:line] = words.map { |w| w.count("\n") }.inject(:+) if options['l']
    low[:count][:word] = words.join.split.size if options['w']
    low[:count][:byte] = words.join.bytesize if options['c']
    low
  end
end

wc = WcCommand.new
puts wc.main
