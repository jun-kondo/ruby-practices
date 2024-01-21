#!/usr/bin/env ruby
require 'date'
require 'optparse'

params = ARGV.getopts("m:", "y:", "m:#{Date.today.mon}", "y:#{Date.today.year}")
month = params["m"].to_i
year = params["y"].to_i

start_date = Date.new(year, month, 1)
end_date = Date.new(year, month, -1)

header = "#{start_date.mon}月 #{start_date.year}"
puts header.center(20)

puts "日 月 火 水 木 金 土"

calendar_formatted = (start_date..end_date).map do |date|
  day_to_string = date.day.to_s.rjust(2)
  date.day != 1 && date.sunday? ? "\n" + day_to_string : day_to_string
end

margin_space = Array.new(start_date.wday, "  ")

calendar = margin_space + calendar_formatted
puts calendar.join(" ")
