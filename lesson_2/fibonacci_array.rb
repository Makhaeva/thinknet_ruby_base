# lesson 2.3: Array with Fibonacci numbers

puts "Данная программа заполняет массив числами Фиббоничи (до 100)"
puts

arr_fib = [0, 1]

while (new_f_num = (arr_fib[-1] + arr_fib[-2])) < 100 do
	arr_fib << new_f_num
end

puts "Result: "
arr_fib.each {|a| print "#{a} "} 