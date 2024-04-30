#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'file'
require_relative 'short_format'
require_relative 'long_format'

ls = LsCommand.new(ARGV)
files = ls.filenames_order.map { |filename| Ls::File.new(filename) }
puts ls.format_mode.new(files).output
