# lesson 2.5: Leap year

puts "Данная программа выводит, каким по счету является указанные день в году"
puts

leap_year_day = 0
arr_days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

puts "Введите последовательно числа - дня, месяца и года интересующей вас даты. "
print "день: "
day = gets.chomp.to_i
print "месяц: "
month = gets.chomp.to_i
print "год: "
year = gets.chomp.to_i

if year % 100 == 0 && year % 400 != 0
	leap_year_day = 0
elsif year % 4 == 0 
	leap_year_day = 1
end

count_d = day
count_d += leap_year_day if month > 2 
count_m = month - 1

while count_m >= 1
	count_d += arr_days_in_months[count_m - 1]
	count_m -= 1
end

puts
puts "You enter a date: #{day}.#{"0" if month < 10}#{month}.#{year}."
puts "It is a #{count_d} day since NY"






 