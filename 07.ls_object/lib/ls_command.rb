# frozen_string_literal: true

require 'optparse'

class LsCommand
  NO_FLAGS = 0

  def initialize(argv)
    @argv = argv
  end

  def format_mode_class
    options['l'] ? LsLongFormat : LsShortFormat
  end

  def filenames_order
    options['r'] ? filenames.reverse : filenames
  end

  private

  def filenames
    Dir.glob('*', flags)
  end

  def options
    @options ||= @argv.getopts('arl')
  end

  def flags
    options['a'] ? File::FNM_DOTMATCH : NO_FLAGS
  end
end
