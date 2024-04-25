# frozen_string_literal: true

class ShortFormat
  COL_SIZE = 3
  # SPACE_CHARACTER = ' '
  # SPACE_CHAR_COUNT_BETWEEN_FILENAMES = 1

  def initialize(filenames)
    @filenames = filenames
  end

  def output
    # create_filenames_matrix(arrange_filenames).map(&:join).join("\n")
    create_filenames_matrix(arrange_filenames).map { |row| row.join(' ') }.join("\n")
  end

  private

  def create_filenames_matrix(arranged_names)
    arranged_names.each_slice(row_size).map { |divided_names| divided_names + Array.new((row_size - divided_names.size), '') }.transpose
  end

  def row_size
    file_size = @filenames.size
    @row_size ||= (file_size % COL_SIZE).zero? ? file_size / COL_SIZE : file_size.fdiv(COL_SIZE).ceil
  end

  def arrange_filenames
    @filenames.map { |filename| multibyte_ljust(filename) }
  end

  def multibyte_ljust(filename, padding: ' ')
    filename + padding * ljust_padding_count(filename)
  end

  def ljust_padding_count(filename)
    max_length_filename_width - display_file_width(filename)
  end

  def max_length_filename_width
    @max_length_filename_width ||= display_file_width(max_length_filename)
  end

  def max_length_filename
    @max_length_filename ||= @filenames.max_by { |a| display_file_width(a) }
  end

  def display_file_width(filename)
    filename.size + filename.chars.count { |char| !char.ascii_only? }
  end
end
