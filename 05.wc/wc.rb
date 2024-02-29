#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

class WcCommand
  def initialize
    @options = ARGV.getopts('lwc')
    @file_names = ARGV
  end

  def display_word_count
    counts = @file_names.empty? ? count_stdin_content : count_file_content
    add_total_amount_low(counts) if counts.size > 1
    display_lows(counts).join("\n")
  end

  private

  def add_total_amount_low(counts)
    total_amount_low = { file_name: 'total', amount: {} }
    counts.map do |count|
      count[:amount].each_key do |k|
        total_amount_low[:amount][k] = counts.sum { _1[:amount][k] }
      end
    end
    counts << total_amount_low
  end

  def count_file_content
    @file_names.map do |file_name|
      contents = File.readlines(file_name)
      generate_count(contents, file_name)
    end
  end

  def count_stdin_content
    contents = $stdin.to_a
    [generate_count(contents)]
  end

  def generate_count(contents, file_name = nil)
    count = { file_name:, amount: {} }
    if @options.value?(true)
      count_line(contents, count) if @options['l']
      count_word(contents, count) if @options['w']
      count_byte(contents, count) if @options['c']
    else
      count_line(contents, count)
      count_word(contents, count)
      count_byte(contents, count)
    end
    count
  end

  def count_line(contents, count)
    count[:amount][:line] = contents.sum { |w| w.count("\n") }
  end

  def count_word(contents, count)
    count[:amount][:word] = contents.join.split.size
  end

  def count_byte(contents, count)
    count[:amount][:byte] = contents.join.bytesize
  end

  def display_lows(counts)
    counts.map do |count|
      low = ['']
      count[:amount].each_value { |v| low << v.to_s.rjust(7) }
      low << count[:file_name]
      low.join(' ')
    end
  end
end

wc = WcCommand.new
puts wc.display_word_count
