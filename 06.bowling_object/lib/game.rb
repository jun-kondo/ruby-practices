# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(frames)
    @frames = frames.map { |shots| Frame.new(shots) }
  end

  def score
    score = 0
    10.times do |index|
      score +=
        if @frames[index].strike?
          strike_bonus(index) + @frames[index].score
        elsif @frames[index].spare?
          spare_bonus(index) + @frames[index].score
        else
          @frames[index].score
        end
    end
    score
  end

  private

  def strike_bonus(index)
    if next_frame(index).strike?
      after_next_frame(index).first_shot_score + 10
    else
      next_frame(index).score
    end
  end

  def spare_bonus(index)
    next_frame(index).first_shot_score
  end

  def next_frame(index)
    @frames[index + 1]
  end

  def after_next_frame(index)
    @frames[index + 2]
  end
end
