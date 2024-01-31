#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  file_names = Dir.glob('*')

  arranged_file_names = arrange_names(file_names)

  file_names_lists = create_lists(arranged_file_names)

  output(file_names_lists)
end

def display_file_width(str)
  str.size + str.chars.count { |char| !char.ascii_only? }
end

def arrange_names(names)
  max_word = names.max { |a, b| display_file_width(a) <=> display_file_width(b) }
  names.sort.map do |name|
    if name.ascii_only?
      name.ljust(display_file_width(max_word) + 1)
    else
      name.ljust(max_word.size + 1)
    end
  end
end

def create_lists(arranged_names, col: 3)
  row = arranged_names.size <= col ? 1 : arranged_names.size / col + 1
  arranged_names.each_slice(row).map { |divided_names| divided_names + Array.new((row - divided_names.size), '') }.transpose
end

def output(names_lists)
  names_lists.each { |names_list| names_list.each { |name| name == names_list.last ? puts(name) : print(name) } }
end

main
