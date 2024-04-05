# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(*marks)
    @first_shot = Shot.new(marks[0])
    @second_shot = Shot.new(marks[1])
    # @third_shot = Shot.new(marks[2])
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
