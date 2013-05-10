require 'csv'
require 'sunlight/congress'
require 'erb'
require 'date'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def clean_phone(phone)
  phone.to_s.gsub!(/[^\d]/, "")
    if phone.length == 10
      phone
    #If the phone number is 11 digits and the first number is 1, trim the 1 and use the first 10 digi  
    elsif ((phone.length == 11) && (phone.chars.first == "1"))
      phone.sub!(/\A1/, "")
    else
      "0000000000"
    end
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"
  
  filename = "output/thanks_#{id}.html"
  
  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

def peak_times(time)
  #makes array of all of the hours of registration
  array = Array(time).map { |t| DateTime.strptime(t, '%m/%d/%Y %H:%M').hour}
 #makes hash of :time => number of instances
   result = Hash.new(0)
    array.each do |t|
      result[t] += 1  
    end
    puts result.keys.reverse
  end

puts "EventManager Initialized!"
puts "top registration times in descending order"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone = clean_phone(row[:homephone])
  time = row[:regdate]
  
  legislators = legislators_by_zipcode(zipcode)
  
  form_letter = erb_template.result(binding)
  
  save_thank_you_letters(id,form_letter)
  
  peak_times(time)
  
end


