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
  elements = collect_elements(file_stats)
  long_list = generate_body(elements)
  total_block_number = elements.map { _1[:block] }.inject { |total, block| total + block }
  total_block = "total #{total_block_number}"
  [total_block, long_list].join("\n")
end

def file_stats_for_long_format(file_stats)
  file_stats.map do |file|
    file_mode_number = file[:stat].mode.to_s(8).slice(-3, 3)
    {
      block: file[:stat].blocks,
      file_type: check_file_type(file[:stat].ftype),
      owner_permission: owner_and_group_permission(file[:stat].setuid?, file_mode_number[0]),
      group_permission: owner_and_group_permission(file[:stat].setgid?, file_mode_number[1]),
      other_users_permission: other_users_permission(file[:stat].sticky?, file_mode_number[2]),
      hard_link: file[:stat].nlink.to_s,
      uid: Etc.getpwuid(file[:stat].uid).name,
      gid: Etc.getgrgid(file[:stat].gid).name,
      size: file[:stat].size.to_s,
      mtime: format_mtime(file[:stat]),
      name: file[:name],
      symlink: show_symlink(file[:name])
    }
  end
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

def check_max_length(element)
  element.max_by(&:length).length
end

def generate_body(elements)
  max_hard_link_length = check_max_length(elements.map { _1[:hard_link] })
  max_uid_length = check_max_length(elements.map { _1[:uid] })
  max_gid_length = check_max_length(elements.map { _1[:gid] })
  max_size_length = check_max_length(elements.map { _1[:size] })
  elements.map do |element|
    [
      [
        element[:file_type],
        element[:owner_permission],
        element[:group_permission],
        element[:other_users_permission]
      ].join,
      element[:hard_link].rjust(max_hard_link_length + 1),
      element[:uid].ljust(max_uid_length + 1),
      element[:gid].ljust(max_gid_length + 1),
      element[:size].rjust(max_size_length),
      element[:mtime], element[:name], element[:symlink]
    ].join(' ').rstrip
  end
end

def format_mtime(stat)
  date_modified = stat.mtime
  Date.parse(date_modified.to_s) < Date.today << 6 ? date_modified.strftime('%_m %_d %_5Y') : date_modified.strftime('%_m %_d %H:%M')
end

def show_symlink(filename)
  "-> #{File.readlink(filename)}" if FileTest.symlink?(filename)
end

puts main
