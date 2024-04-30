# frozen_string_literal: true
#

class LongFormat
  def initialize(files)
    @files = files
  end

  # ターミナル出力メソッド
  # elementsが@filenamesになる
  # def long_listing
  def output
    # file_stats = filenames.map do |filename|
    #   { name: filename, stat: File.lstat(filename) }
    # end
    # elements = file_stats_for_long_format(file_stats)
    # long_format
    # long_list = generate_long_format_rows
    # total_block_number = elements.map { _1[:block] }.inject { |total, block| total + block }
    # total_block_number = @filenames.map(&:block_count).inject(:+)
    # total_block = "total #{total_block_number}"
    [total_block, generate_long_format_matrix].join("\n")
  end

  def total_block
    "total #{total_block_count}"
  end

  def total_block_count
    # @files.map(&:block_count).inject(:+)
    @files.map(&:block_count).sum
  end

  def generate_long_format_matrix
    # max_hard_link_length = check_max_length(elements.map { _1[:hard_link] })
    # max_uid_length = check_max_length(elements.map { _1[:uid] })
    # max_gid_length = check_max_length(elements.map { _1[:gid] })
    # max_size_length = check_max_length(elements.map { _1[:size] })
    # 上4つメモ化
    @files.map { |file| generate_long_format_row(file) }
  end

  def generate_long_format_row(file)
    # 行を出力
    # ハッシュのキーを参照しているのを、インスタンス変数もしくはゲッターに変更する
    [
      # パーミッションのシンボリック表記
      [
        # element[:file_type],
        # file.file_type,
        # element[:owner_permission],
        # file.owner_permission_triad,
        # element[:group_permission],
        # file.group_permission_triad,
        # element[:other_users_permission]
        # file.other_users_permission_triad,
        file.file_type_and_all_permissions,
        # 拡張属性を' '空文字で表示
        file.extended_attributes_notation
      ].join,
      # element[:hard_link].rjust(max_hard_link_length + 1),
      # 拡張属性を空文字にしたので+1は不要になった
      file.hard_link.rjust(max_hard_link_length),
      [
        # element[:uid].ljust(max_uid_length),
        file.uid_name.ljust(max_uid_name_length),
        # element[:gid].ljust(max_gid_length),
        file.gid_name.ljust(max_gid_name_length),
        # element[:size].rjust(max_size_length)
        file.size.rjust(max_size_length)
        # hoge  hoge  1234とする
        # 空白二文字で連結
      ].join('  '),
      # element[:mtime], element[:name], element[:symlink]
      file.last_modified_on, file.name, file.symbolic_link
    ].join(' ').rstrip
  end

  def max_hard_link_length
    # mapの中でハッシュのキーを参照にしているがインスタンス変数を参照する
    # @max_hard_link_length ||= check_max_length(@filenames.map { _1[:hard_link] })
    @max_hard_link_length ||= check_max_length(@files.map(&:hard_link))
  end

  def max_uid_name_length
    # mapの中でハッシュのキーを参照にしているがインスタンス変数を参照する
    # @max_uid_name_length ||= check_max_length(@filenames.map { _1[:uid] })
    @max_uid_name_length ||= check_max_length(@files.map(&:uid_name))
  end

  def max_gid_name_length
    # mapの中でハッシュのキーを参照にしているがインスタンス変数を参照する
    # @max_gid_name_length ||= check_max_length(@filenames.map { _1[:gid] })
    @max_gid_name_length ||= check_max_length(@files.map(&:gid_name))
  end

  def max_size_length
    # mapの中でハッシュのキーを参照にしているがインスタンス変数を参照する
    # @max_size_length ||= check_max_length(@filenames.map { _1[:size] })
    @max_size_length ||= check_max_length(@files.map(&:size))
  end

  def check_max_length(strings)
    strings.max_by(&:length).length
  end
end
