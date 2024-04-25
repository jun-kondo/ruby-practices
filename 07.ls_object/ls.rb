#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_command'

puts LsCommand.new(ARGV).run
