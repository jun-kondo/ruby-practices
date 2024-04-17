# frozen_string_literal: true

class BowlingResultParser
  STRIKE_MARK = 'X'
  STRIKE_SCORE = 10
  AFTER_STRIKE = 0
  def initialize(result)
    @result = result
  end

  def parse_result
    all_pins = []
    @result.split(',').each do |mark|
      if mark == STRIKE_MARK
        all_pins << STRIKE_SCORE
        all_pins << AFTER_STRIKE
      else
        all_pins << mark.to_i
      end
    end
    separate(all_pins)
  end

  private

  def separate(all_pins)
    all_pins.each_slice(2).to_a
  end
end
