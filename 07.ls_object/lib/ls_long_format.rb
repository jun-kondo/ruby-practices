# frozen_string_literal: true

class LsLongFormat
  INITIAL_LENGTH_VALUE = 0

  def initialize(files)
    @files = files
    @max_lengths = calculate_max_lengths
  end

  def output
    [total_block, generate_long_format_matrix].join("\n")
  end

  private

  def total_block
    "total #{total_block_count}"
  end

  def total_block_count
    @files.sum(&:block_count)
  end

  def generate_long_format_matrix
    @files.map { |file| generate_long_format_row(file) }
  end

  def generate_long_format_row(file)
    [
      [
        file.file_type_and_all_permissions,
        file.extended_attributes_notation
      ].join,
      file.hard_link.rjust(@max_lengths[:hard_link]),
      [
        file.uid_name.ljust(@max_lengths[:uid_name]),
        file.gid_name.ljust(@max_lengths[:gid_name]),
        file.size.rjust(@max_lengths[:size])
      ].join('  '),
      file.last_modified_on, file.name, file.symbolic_link
    ].join(' ').rstrip
  end

  def calculate_max_lengths
    max_lengths = {
      hard_link: INITIAL_LENGTH_VALUE,
      uid_name: INITIAL_LENGTH_VALUE,
      gid_name: INITIAL_LENGTH_VALUE,
      size: INITIAL_LENGTH_VALUE
    }
    @files.each_with_object(max_lengths) do |file, lengths|
      update_max_length(lengths, :hard_link, file.hard_link)
      update_max_length(lengths, :uid_name, file.uid_name)
      update_max_length(lengths, :gid_name, file.gid_name)
      update_max_length(lengths, :size, file.size)
    end
  end

  def update_max_length(lengths, key, value)
    lengths[key] = [lengths[key], value.length].max
  end
end
