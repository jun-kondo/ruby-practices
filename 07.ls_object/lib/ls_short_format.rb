# frozen_string_literal: true

class LsShortFormat
  COL_COUNT = 3

  def initialize(files)
    @files = files
    @file_count = files.size
  end

  def output
    generate_filenames_matrix.map { |row| row.join(' ') }.join("\n")
  end

  private

  def generate_filenames_matrix
    arrange_filenames.each_slice(row_count).map { |divided_names| generate_filenames_row(divided_names) }.transpose
  end

  def arrange_filenames
    @files.map { |file| multibyte_ljust(file) }
  end

  def row_count
    (@file_count % @col_count).zero? ? @file_count / @col_count : @file_count.fdiv(@col_count).ceil
  end

  def generate_filenames_row(filenames)
    filenames + Array.new((row_count - filenames.size), '')
  end

  def multibyte_ljust(file, padding: ' ')
    file.name + padding * padding_size(file)
  end

  def padding_size(file)
    max_length_filename_width - file.display_name_width
  end

  def max_length_filename_width
    max_name_length_file.display_name_width
  end

  def max_name_length_file
    @files.max_by(&:display_name_width)
  end
end
