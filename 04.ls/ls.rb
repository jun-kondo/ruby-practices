#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def list_filenames(flags, options)
  filenames = Dir.glob('*', flags)
  filenames.reverse! if options['r']
  filenames
end

def main
  options = ARGV.getopts('arl')
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  filenames = list_filenames(flags, options)
  options['l'] ? long_listing(filenames) : short_listing(filenames)
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

def short_listing(filenames)
  arranged_filenames = arrange_filenames(filenames)
  filenames_matrix = create_filenames_matrix(arranged_filenames)
  filenames_matrix.map(&:join).join("\n")
end

puts main
