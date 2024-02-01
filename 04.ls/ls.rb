#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  filenames = Dir.glob('*')
  arranged_filenames = arrange_filenames(filenames)
  filenames_matrix = create_filenames_matrix(arranged_filenames)
  output(filenames_matrix)
end

def display_file_width(str)
  str.size + str.chars.count { |char| !char.ascii_only? }
end

def mb_ljust(max_word_width, filename, padding: ' ', padding_size: 1)
  padding_size += max_word_width - display_file_width(filename)
  filename + padding * padding_size
end

def arrange_filenames(names)
  max_word = names.max_by { |a| display_file_width(a) }
  max_word_width = display_file_width(max_word)
  names.map { |name| mb_ljust(max_word_width, name) }
end

def create_filenames_matrix(arranged_names, col: 3)
  row = arranged_names.size <= col ? 1 : arranged_names.size / col + 1
  arranged_names.each_slice(row).map { |divided_names| divided_names + Array.new((row - divided_names.size), '') }.transpose
end

def output(filenames_matrix)
  filenames_matrix.each do |filenames|
    filenames.each { |filename| print filename }
    puts
  end
end

main
