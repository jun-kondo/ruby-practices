# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(result_marks)
    @frames = build_frames(result_marks)

  end

  def score
    score = 0
    @frames.each_with_index do |frame, index|
      score +=
        if frame.strike?
          strike_bonus(index) + 10
        elsif frame.spare?
          spare_bonus(index) + 10
        else
          frame.score
        end
      break score if index == 9
    end
  end

  private

  def build_frames(result_marks)
    shots = []
    result_marks.each do |mark|
      if mark == 'X'
        shots << 10
        shots << 0
      else
        shots << mark.to_i
      end
    end
    frames = []
    shots.each_slice(2) { |s| frames << s }
    # separated_shots = separate(shots)
    frames.map { |s| Frame.new(*s) }
  end

  def strike_bonus(index)
    if @frames[index + 1].strike?
      @frames[index + 2].first_shot_score + 10
    else
      @frames[index + 1].score
    end
  end

  def spare_bonus(index)
    @frames[index + 1].first_shot_score
  end

  def next_frame(index)
    @frames[index + 1]
  end

  def separate(shots)
    frames = []
    shots.map do |shot|
      frames << [] if next_frame?(frames)
      frame = frames.last
      frame << shot
    end
  end

  def next_frame?(frames)
    frame = frames.last
    !last_frame?(frames) && (frames.empty? || strike?(frame) || frame.size == 2)
  end

  def last_frame?(frames)
    frames.size == 10
  end

  def strike?(frame)
    frame[0] == 10 || frame[0] == 'X'
  end
end
