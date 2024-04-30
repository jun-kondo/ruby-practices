# frozen_string_literal: true

require_relative 'short_format'
# require_relative 'long_format'
require 'optparse'

class LsCommand
  # CURRENT_DIRECTORY = '*'
  NO_FLAGS = 0

  def initialize(argv)
    @argv = argv
  end

  # def run
  #   # クラス間の従属関係になってるので外に出す
  #   format_mode.new(filenames_order).output
  # end

  def format_mode
    options['l'] ? LongFormat : ShortFormat
  end

  def filenames_order
    options['r'] ? filenames.reverse : filenames
  end

  private

  # これをdirectoryクラスに移しては?
  def filenames
    # filenames = Dir.glob('*', flags, base: base_directory_path)
    Dir.glob('*', flags)
  end

  def options
    @options ||= @argv.getopts('arl')
    # options = argv.getopts('arl')
    # argv要らないと思う。
    # [argv, options]
  end

  def flags
    options['a'] ? File::FNM_DOTMATCH : NO_FLAGS
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
