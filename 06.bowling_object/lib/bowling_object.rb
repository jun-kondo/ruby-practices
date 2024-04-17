#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'
require_relative 'bowling_result_parser'

parsed_results = BowlingResultParser.new(ARGV[0]).parse_result
game = Game.new(parsed_results)
puts game.score
