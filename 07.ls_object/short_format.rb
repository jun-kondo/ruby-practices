# frozen_string_literal: true

class ShortFormat
  COL_COUNT = 3
  # SPACE_CHARACTER = ' '
  # SPACE_CHAR_COUNT_BETWEEN_FILENAMES = 1

  def initialize(filenames)
    @filenames = filenames
    @file_count = filenames.size
  end

  def output
    # create_filenames_matrix(arrange_filenames).map(&:join).join("\n")
    create_filenames_matrix(arrange_filenames).map { |row| row.join(' ') }.join("\n")
  end

  private

  def create_filenames_matrix(arranged_names)
    arranged_names.each_slice(row_count).map { |divided_names| divided_names + Array.new((row_count - divided_names.size), '') }.transpose
  end

  def row_count
    @row_count ||= (@file_count % COL_COUNT).zero? ? @file_count / COL_COUNT : @file_count.fdiv(COL_COUNT).ceil
  end

  def arrange_filenames
    @filenames.map { |filename| multibyte_ljust(filename) }
  end

  # filenameクラスに出来そう
  def multibyte_ljust(filename, padding: ' ')
    filename + padding * padding_size(filename)
  end

  # filenameクラスに出来そう
  def padding_size(filename)
    max_length_filename_width - display_file_width(filename)
  end

  def max_length_filename_width
    @max_length_filename_width ||= display_file_width(max_length_filename)
  end

  def max_length_filename
    @filenames.max_by { |filename| display_file_width(filename) }
  end

  # filenameクラスに出来そう
  def display_file_width(filename)
    filename.size + filename.chars.count { |char| !char.ascii_only? }
  end
end
