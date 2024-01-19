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

# ストライクの後の2投分のスコア計算をする
# スコア配列とインデックスを引数で受け取る
def strike_bonus(frames, index)
  next_frame = frames[index + 1]
  # 次の投球もストライクだった場合、さらに次のフレームの一投目のスコアも加算
  if next_frame[0] == 10
    after_next_frame = frames[index + 2]
    next_frame[0] + after_next_frame[0]
  else # スペア、それ以外の場合
    next_frame.sum
  end
end

# スペアの後の次の投球分のスコア計算をする
# スコア配列とインデックスを引数で受け取る
def spare_bonus(frames, index)
  next_frame = frames[index + 1]
  next_frame[0]
end

def culc_score(frames)
  point = 0
  frames.each_with_index do |frame, index|
    if frame[0] == 10
      point += 10
      point += strike_bonus(frames, index)
    elsif frame.sum == 10
      point += 10
      point += spare_bonus(frames, index)
    else
      point += frame.sum
    end
    # 10フレーム目で終了しループから抜ける
    break if index == 9
  end
  point
end

puts culc_score(frames)
