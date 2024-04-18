# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(results)
    @frames = results.map { |shots| Frame.new(shots) }
  end

  def score
    score = 0
    10.times do |index|
      if @frames[index].strike?
        score += strike_bonus(index)
      elsif @frames[index].spare?
        score += spare_bonus(index)
      end
      score += @frames[index].score
    end
    score
  end

  private

  def strike_bonus(index)
    if next_frame(index).strike?
      after_next_frame(index).first_shot_score + next_frame(index).score
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
