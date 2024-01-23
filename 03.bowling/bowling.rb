#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'bowling_methods'

score = ARGV[0]

scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

puts culc_score(frames)
