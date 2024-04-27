#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_command'
require_relative 'short_format'

ls = LsCommand.new(ARGV)
puts ls.format_mode.new(ls.filenames_order).output
