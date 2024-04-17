# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/game'
require_relative '../lib/bowling_result_parser'

class BowlingTest < Minitest::Test
  def test_score139
    result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 139, game.score
  end

  def test_score164
    result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 164, game.score
  end

  def test_score107
    result = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 107, game.score
  end

  def test_score134
    result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 134, game.score
  end

  def test_score144
    result = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 144, game.score
  end

  def test_score300
    result = 'X,X,X,X,X,X,X,X,X,X,X,X'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 300, game.score
  end

  def test_score292
    result = 'X,X,X,X,X,X,X,X,X,X,X,2'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 292, game.score
  end

  def test_score50
    result = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    parsed_results = BowlingResultParser.new(result).parse_result
    game = Game.new(parsed_results)
    assert_equal 50, game.score
  end
end
