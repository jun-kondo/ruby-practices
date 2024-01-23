# frozen_string_literal: true

def strike_bonus(frames, index)
  if frames[index + 1][0] == 10
    frames[index + 2][0] + 10
  else
    frames[index + 1].sum
  end
end

def culc_score(frames)
  point = 0
  frames.each_with_index do |frame, index|
    point +=
      if frame[0] == 10
        strike_bonus(frames, index) + 10
      elsif frame.sum == 10
        frames[index + 1][0] + 10
      else
        frame.sum
      end
    break point if index == 9
  end
end
