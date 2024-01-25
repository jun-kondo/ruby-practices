#!/usr/bin/env ruby
# frozen_string_literal: true

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

def strike_bonus(frames, index)
  if frames[index + 1][0] == 10
    frames[index + 2][0] + 10
  else
    frames[index + 1].sum
  end
end

def spare_bonus(frames, index)
  frames[index + 1][0]
end

def calc_score(frames)
  score = 0
  frames.each_with_index do |frame, index|
    score +=
      if frame[0] == 10
        strike_bonus(frames, index) + 10
      elsif frame.sum == 10
        spare_bonus(frames, index) + 10
      else
        frame.sum
      end
    break score if index == 9
  end
end

puts calc_score(frames)
