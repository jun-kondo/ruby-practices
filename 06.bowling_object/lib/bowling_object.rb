#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'
require_relative 'mark_parser'

frames = MarkParser.new(ARGV[0]).parse_mark
game = Game.new(frames)
puts game.score
