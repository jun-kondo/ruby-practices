# frozen_string_literal: true

require 'etc'
require 'date'

class LsFile
  attr_reader :name

  FILETYPE_SYMBOLIC_NOTATION = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze
  PERMISSION_TRIADS =
    {
      '7' => 'rwx',
      '6' => 'rw-',
      '5' => 'r-x',
      '4' => 'r--',
      '3' => '-wx',
      '2' => '-w-',
      '1' => '--x',
      '0' => '---'
    }.freeze
  SPECIAL_PERMISSION =
    {
      'set_id' => {
        'executable' => 's',
        'not_executable' => 'S'
      },
      'sticky_bit' => {
        'executable' => 't',
        'not_executable' => 'T'
      }
    }.freeze
  EXECUTABLE = 'x'
  SPACE_CHARACTER = ' '
  HALF_YEAR = 6

  def initialize(name)
    @name = name
  end

  def block_count
    stat.blocks
  end

  def file_type_and_all_permissions
    [file_type, owner_permission_triad, group_permission_triad, other_users_permission_triad].join
  end

  def extended_attributes_notation
    SPACE_CHARACTER # 実装できなかったので空白文字で代用
  end

  def hard_link
    @hard_link ||= stat.nlink.to_s
  end

  def uid_name
    @uid_name ||= Etc.getpwuid(stat.uid).name
  end

  def gid_name
    @gid_name ||= Etc.getgrgid(stat.gid).name
  end

  def size
    @size ||= stat.size.to_s
  end

  def last_modified_on
    date_modified = stat.mtime
    Date.parse(date_modified.to_s) < Date.today << HALF_YEAR ? date_modified.strftime('%_m %_d %_5Y') : date_modified.strftime('%_m %_d %H:%M')
  end

  def symbolic_link
    "-> #{File.readlink(@name)}" if FileTest.symlink?(@name)
  end

  def display_name_width
    @name.size + @name.chars.count { |char| !char.ascii_only? }
  end

  private

  def stat
    @stat ||= File.lstat(@name)
  end

  def mode_number
    @mode_number ||= stat.mode.to_s(8).slice(-3, 3)
  end

  def file_type
    FILETYPE_SYMBOLIC_NOTATION[stat.ftype]
  end

  def owner_permission_triad
    convert_symbolic_notation(stat.setuid?, mode_number[0], 'set_id')
  end

  def group_permission_triad
    convert_symbolic_notation(stat.setgid?, mode_number[1], 'set_id')
  end

  def other_users_permission_triad
    convert_symbolic_notation(stat.sticky?, mode_number[2], 'sticky_bit')
  end

  def convert_symbolic_notation(is_set_id_or_sticky, permission_number, special_permission_type)
    three_permission_chars = PERMISSION_TRIADS[permission_number].dup
    if is_set_id_or_sticky && three_permission_chars[2] == EXECUTABLE
      three_permission_chars[2] = SPECIAL_PERMISSION[special_permission_type]['executable']
    elsif is_set_id_or_sticky
      three_permission_chars[2] = SPECIAL_PERMISSION[special_permission_type]['not_executable']
    end
    three_permission_chars
  end
end
