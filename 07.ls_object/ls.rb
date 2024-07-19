#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/ls_command'
require_relative 'lib/ls_file'
require_relative 'lib/ls_short_format'
require_relative 'lib/ls_long_format'

ls = LsCommand.new(ARGV)
files = ls.filenames_order.map { |filename| LsFile.new(filename) }
puts ls.format_class_new(files).output
