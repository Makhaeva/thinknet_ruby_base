# lesson 2.1: Hash with month

puts "Данная программа выводит месяцы с количеством дней равным 30"
puts

months = {january: 31, february: 28, march: 31, april: 30, may: 31, june: 30,
july: 31, august: 31, september: 30, october: 31, november: 30, december: 31}

months.each do |name, t_days|
	puts name if t_days == 30
end
