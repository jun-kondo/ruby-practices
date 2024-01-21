#!/usr/bin/env ruby
require 'date'
require 'optparse'

# コマンドラインオプション設定(デフォルト値は今日の年と月)
params = ARGV.getopts("m:", "y:", "m:#{Date.today.mon}", "y:#{Date.today.year}")
month = params["m"].to_i
year = params["y"].to_i

# 月の最初の日にちを取得
start_date = Date.new(year, month, 1)

# 月の最終日を取得
end_date = Date.new(year, month, -1)

# 月と年を取得
header = "#{start_date.mon}月 #{start_date.year}"
puts header.center(20)
# すべての曜日を取得
puts "日 月 火 水 木 金 土"

margin_space = Array.new(start_date.wday, "  ")

# すべての日付を配列で作成
all_days = (start_date.day..end_date.day).to_a

# 配列の要素を文字列型に変更、各要素を右寄せ
# 1日ではないかつ、日曜日の日付の場合日付の前に改行文字を入れて改行
calendar_formatted = all_days.map do |day|
                       date = Date.new(start_date.year, start_date.mon, day)
                       day != 1 && date.sunday? ? "\n" + day.to_s.rjust(2) : day.to_s.rjust(2)
                     end

# 余白と日付の配列を連結
calendar = margin_space + calendar_formatted

# カレンダーを表示
puts calendar.join(" ")

