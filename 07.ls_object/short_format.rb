# frozen_string_literal: true

class ShortFormat
  COL_COUNT = 3
  # SPACE_CHARACTER = ' '
  # SPACE_CHAR_COUNT_BETWEEN_FILENAMES = 1

  def initialize(files)
    @files = files
    @file_count = files.size
  end

  def output
    # create_filenames_matrix(arrange_filenames).map(&:join).join("\n")
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
    @row_count ||= (@file_count % COL_COUNT).zero? ? @file_count / COL_COUNT : @file_count.fdiv(COL_COUNT).ceil
  end

  def generate_filenames_row(filenames)
    filenames + Array.new((row_count - filenames.size), '')
  end

  # filenameクラスに出来そう
  def multibyte_ljust(file, padding: ' ')
    file.name + padding * padding_size(file)
  end

  # filenameクラスに出来そう
  # レシーバはファイルクラス
  def padding_size(file)
    max_length_filename_width - file.display_name_width
  end

  def max_length_filename_width
    @max_length_filename_width ||= max_name_length_file.display_name_width
  end

  # ファイルオブジェクトを返す
  def max_name_length_file
    @files.max_by(&:display_name_width)
  end

  # filenameクラスに出来そう
  # def display_file_width(filename)
  #   filename.size + filename.chars.count { |char| !char.ascii_only? }
  # end
end
