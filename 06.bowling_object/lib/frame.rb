# frozen_string_literal: true

# require_relative 'shot'

class Frame
  STRIKE_SCORE = 10
  def initialize(shots)
    @first_shot = shots[0]
    @second_shot = shots[1]
  end

  def score
    [@first_shot, @second_shot].sum
  end

  def first_shot_score
    @first_shot
  end

  def strike?
    @first_shot == STRIKE_SCORE
  end

  def spare?
    (@first_shot + @second_shot) == STRIKE_SCORE
  end
end
