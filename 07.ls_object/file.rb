# frozen_string_literal: true

require 'etc'

module Ls
  class File
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

    THREE_PERMISSION_TRIADS =
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

    EXECUTABLE = 'x'

    def initialize(filename)
      @name = filename
      @stat = File.lstat(filename)
      @mode_number = @stat.mode.to_s(8).slice(-3, 3)
    end

    def block
      @stat.blocks
    end

    def file_type
      FILETYPE_SYMBOLIC_NOTATION[@stat.ftype]
    end

    def owner_permission
      owner_and_group_permission(@stat.setuid?, @mode_number[0])
    end

    def group_permission
      owner_and_group_permission(@stat.setgid?, @mode_number[1])
    end

    def other_users_permission
      three_permission_chars = change_to_symbolic_notation(@mode_number[2]).dup
      if @stat.sticky? && three_permission_chars[2] == EXECUTABLE
        three_permission_chars[2] = 't'
        # three_permission_chars.sub(/x/, 't')
      elsif @stat.sticky?
        three_permission_chars[2] = 'T'
        # xしか想定してないが、r,wが-だとそこもTになってしまう
        # three_permission_chars.sub(/-/, 'T')
      else
        three_permission_chars
      end
    end

    def hard_link
      @stat.nlink.to_s
    end

    def uid
      Etc.getpwuid(@stat.uid).name
    end

    def gid
      Etc.getgrgid(@stat.gid).name
    end

    def size
      @stat.size.to_s
    end

    def last_modified_on
      date_modified = @stat.mtime
      Date.parse(date_modified.to_s) < Date.today << 6 ? date_modified.strftime('%_m %_d %_5Y') : date_modified.strftime('%_m %_d %H:%M')
    end

    def symbolic_link
      File.readlink(@name) if FileTest.symlink?(@name)
    end

    private

    def owner_and_group_permission(set_id, permission_number)
      three_permission_chars = change_to_symbolic_notation(permission_number).dup
      if set_id && three_permission_chars[2] == EXECUTABLE
        three_permission_chars[2] = 's'
        # three_permission_chars.sub(/x/, 's')
      elsif set_id
        three_permission_chars[2] = 'S'
        # xしか想定してないが、r,wが-だとそこもSになってしまう
        # three_permission_chars.sub(/-/, 'S')
      else
        three_permission_chars
      end
    end

    def change_to_symbolic_notation(permission_number)
      THREE_PERMISSION_TRIADS[permission_number]
    end
  end
end
