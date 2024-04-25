# frozen_string_literal: true

require_relative 'short_format'
# require_relative 'long_format'
require 'optparse'

class LsCommand
  # CURRENT_DIRECTORY = '*'
  NO_FLAGS = 0

  def initialize(argv)
    @options = argv.getopts('arl')
  end

  def run
    decide_format.new(filenames).output
  end

  private

  # def argument_and_options(argv)
  #   options = argv.getopts('arl')
  #   # argv要らないと思う。
  #   [argv, options]
  # end

  def decide_format
    @options['l'] ? LongFormat : ShortFormat
  end

  # これをdirectoryクラスに移しては?
  def filenames
    # filenames = Dir.glob('*', flags, base: base_directory_path)
    filenames = Dir.glob('*', flags)
    @options['r'] ? filenames.reverse : filenames
  end

  def flags
    @options['a'] ? File::FNM_DOTMATCH : NO_FLAGS
  end

  # def directory_path(argv)
  #   argv.empty? ? nil : argv
  # end

  # def filenames
  #   if @options['r']
  #     Dir.glob('*', flags).reverse
  #   else
  #     Dir.glob('*', flags)
  #     # Dir.glob('*', flags, base: @argv)
  #   end
  # end
end
