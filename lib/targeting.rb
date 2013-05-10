require 'csv'
require 'sunlight/congress'
require 'erb'
require 'date'


def time_targeting(regdate)
  @time_array = regdate.map { |t| DateTime.strptime(t, '%m/%d/%Y %H:%M').hour}
  result = Hash.new(0)
  @time_array.each { |t| result[t] +=1 } 
end

def day_targeting(regdate)
  @day_array = regdate.map { |t| DateTime.strptime(t, '%m/%d/%Y %H:%M').wday}
  result = Hash.new(0)
  @day_array.each { |t| result[t] +=1 }
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
#contents.map do |row|
  #@times = row[:regdate]
  #end
  
contents.map do |row|
  @regdate = row[:regdate]
  #@peak_times = time_targeting(regdate)
  #@peak_days = day_targeting(row[:regdate])
#puts @peak_times
end
  puts time_targeting(@regdate)
  ##puts peak_days


