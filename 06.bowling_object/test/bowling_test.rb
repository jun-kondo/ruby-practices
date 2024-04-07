# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/mark_parser'

class BowlingTest < Minitest::Test
  def test_score139
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 139, game.score
  end

  def test_score164
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 164, game.score
  end

  def test_score107
    mark = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 107, game.score
  end

  def test_score134
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 134, game.score
  end

  def test_score144
    mark = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 144, game.score
  end

  def test_score300
    mark = 'X,X,X,X,X,X,X,X,X,X,X,X'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 300, game.score
  end

  def test_score292
    mark = 'X,X,X,X,X,X,X,X,X,X,X,2'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 292, game.score
  end

  def test_score50
    mark = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    frames = MarkParser.new(mark).parse_mark
    game = Game.new(frames)
    assert_equal 50, game.score
  end
end
