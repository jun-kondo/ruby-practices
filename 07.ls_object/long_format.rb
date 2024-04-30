# frozen_string_literal: true

class LongFormat
  def initialize(files)
    @files = files
  end

  def output
    [total_block, generate_long_format_matrix].join("\n")
  end

  def total_block
    "total #{total_block_count}"
  end

  def total_block_count
    @files.map(&:block_count).sum
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
      file.hard_link.rjust(max_hard_link_length),
      [
        file.uid_name.ljust(max_uid_name_length),
        file.gid_name.ljust(max_gid_name_length),
        file.size.rjust(max_size_length)
      ].join('  '),
      file.last_modified_on, file.name, file.symbolic_link
    ].join(' ').rstrip
  end

  def max_hard_link_length
    @max_hard_link_length ||= check_max_length(@files.map(&:hard_link))
  end

  def max_uid_name_length
    @max_uid_name_length ||= check_max_length(@files.map(&:uid_name))
  end

  def max_gid_name_length
    @max_gid_name_length ||= check_max_length(@files.map(&:gid_name))
  end

  def max_size_length
    @max_size_length ||= check_max_length(@files.map(&:size))
  end

  def check_max_length(strings)
    strings.max_by(&:length).length
  end
end
