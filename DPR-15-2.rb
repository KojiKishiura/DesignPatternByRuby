require 'rubygems'
require 'runt'

mondays = Runt::DIWeek.new(Runt::Monday)
wedneesday = Runt::DIWeek.new(Runt::Wednesday)
fridays = Runt::DIWeek.new(Runt::Friday)

p fridays.include?(Date.new(2015,12,25))


description