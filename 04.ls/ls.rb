#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def list_filenames(flags, options)
  filenames = Dir.glob('*', flags)
  filenames.reverse! if options['r']
  filenames
end

def main
  options = ARGV.getopts('arl')
  flags = options['a'] ? File::FNM_DOTMATCH : 0
  filenames = list_filenames(flags, options)
  options['l'] ? long_listing(filenames) : short_listing(filenames)
end

def display_file_width(str)
  str.size + str.chars.count { |char| !char.ascii_only? }
end

def mb_ljust(max_word_width, filename, padding: ' ', padding_size: 1)
  padding_size += max_word_width - display_file_width(filename)
  filename + padding * padding_size
end

def arrange_filenames(names)
  max_word = names.max_by { |a| display_file_width(a) }
  max_word_width = display_file_width(max_word)
  names.map { |name| mb_ljust(max_word_width, name) }
end

def create_filenames_matrix(arranged_names, col: 3)
  row = arranged_names.size <= col ? 1 : arranged_names.size / col + 1
  arranged_names.each_slice(row).map { |divided_names| divided_names + Array.new((row - divided_names.size), '') }.transpose
end

def short_listing(filenames)
  arranged_filenames = arrange_filenames(filenames)
  filenames_matrix = create_filenames_matrix(arranged_filenames)
  filenames_matrix.map(&:join).join("\n")
end

def long_listing(filenames)
  file_stats = filenames.map do |filename|
    { name: filename, stat: File.lstat(filename) }
  end
  stats = file_stats.map { |file| file[:stat] }
  max_sizes = check_max_stat_sizes(stats)
  long_list = generate_body(file_stats, max_sizes)
  total_block_number = stats.map(&:blocks).inject { |total, block| total + block }
  total_block = "total #{total_block_number}"
  [total_block, long_list].join("\n")
end

def check_file_type(type)
  {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }[type]
end

PERMISSION =
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

def output_normal_permission(permission_number)
  PERMISSION[permission_number]
end

def owner_and_group_permission(set_id, permission_number)
  permission = output_normal_permission(permission_number)
  if set_id && permission[2] == 'x'
    permission.sub(/x/, 's')
  elsif set_id
    permission.sub(/-/, 'S')
  else
    permission
  end
end

def other_users_permission(sticky, permission_number)
  permission = output_normal_permission(permission_number)
  if sticky && permission[2] == 'x'
    permission.sub(/x/, 't')
  elsif sticky
    permission.sub(/-/, 'T')
  else
    permission
  end
end

def check_max_stat_sizes(stats)
  max_size_owner = stats.max_by { |s| Etc.getpwuid(s.uid).name.size }
  max_size_group = stats.max_by { |s| Etc.getgrgid(s.gid).name.size }
  {
    max_nlink_size: stats.max_by { |s| s.nlink.to_s.size }.nlink.to_s.size,
    max_file_size: stats.max_by(&:size).size.to_s.size,
    max_size_owner_size: Etc.getpwuid(max_size_owner.uid).name.size,
    max_size_group_size: Etc.getgrgid(max_size_group.gid).name.size
  }
end

def generate_body(file_stats, max_sizes)
  file_stats.map do |file|
    file_mode_number = file[:stat].mode.to_s(8).slice(-3, 3)
    [
      [
        check_file_type(file[:stat].ftype),
        owner_and_group_permission(file[:stat].setuid?, file_mode_number[0]),
        owner_and_group_permission(file[:stat].setgid?, file_mode_number[1]),
        other_users_permission(file[:stat].sticky?, file_mode_number[2])
      ].join,
      file[:stat].nlink.to_s.rjust(max_sizes[:max_nlink_size] + 1),
      Etc.getpwuid(file[:stat].uid).name.ljust(max_sizes[:max_size_owner_size] + 1),
      Etc.getgrgid(file[:stat].gid).name.ljust(max_sizes[:max_size_group_size] + 1),
      file[:stat].size.to_s.rjust(max_sizes[:max_file_size]),
      show_date_modified(file[:stat]),
      file[:name],
      show_symlink(file[:name])
    ].join(' ').rstrip
  end
end

def show_date_modified(stat)
  date_modified = stat.mtime
  Date.parse(date_modified.to_s) < Date.today << 6 ? date_modified.strftime('%_m %_d %_5Y') : date_modified.strftime('%_m %_d %H:%M')
end

def show_symlink(filename)
  "-> #{File.readlink(filename)}" if FileTest.symlink?(filename)
end

puts main
