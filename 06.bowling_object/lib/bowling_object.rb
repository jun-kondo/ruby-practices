#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

result_marks = ARGV[0].split(',')
game = Game.new(result_marks)
puts game.score
