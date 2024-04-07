# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1])
  end

  def score
    [@first_shot.score, @second_shot.score].sum
  end

  def first_shot_score
    @first_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    (@first_shot.score + @second_shot.score) == 10
  end
end
