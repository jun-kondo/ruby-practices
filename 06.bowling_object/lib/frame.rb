# frozen_string_literal: true

# require_relative 'shot'

class Frame
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
    @first_shot == 10
  end

  def spare?
    (@first_shot + @second_shot) == 10
  end
end
