# frozen_string_literal: true

class MarkParser
  def initialize(mark)
    @mark = mark
  end

  def parse_mark
    shots = []
    @mark.split(',').each do |mark|
      if mark == 'X'
        shots << 10
        shots << 0
      else
        shots << mark.to_i
      end
    end
    frames = []
    shots.each_slice(2) { |frame| frames << frame }
    frames
  end
end
