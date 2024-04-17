# frozen_string_literal: true

class BowlingResultParser
  def initialize(result)
    @result = result
  end

  def parse_result
    all_pins = []
    @result.split(',').each do |mark|
      if mark == 'X'
        all_pins << 10
        all_pins << 0
      else
        all_pins << mark.to_i
      end
    end
    separate(all_pins)
  end

  private

  def separate(all_pins)
    separated_pins = []
    all_pins.each_slice(2) { |pins| separated_pins << pins }
    separated_pins
  end
end
