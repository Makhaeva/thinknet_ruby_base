# lesson 1.4: Quadratic equation

puts "Данная программа вычисляет корни квадратного уравнения."
puts

puts "Введите значения коэффициентов"
print "a: "
a = gets.to_i
print "b: "
b = gets.to_i
print "c: "
c = gets.to_i

d = b ** 2 - 4 * a * c

if d < 0
	puts "Уравнение не имеет корней."
elsif d == 0
	puts "Уравнение имеет один корень: #{'%.2f' % (-0.5 * b / a)}"
else
	sq_d = Math.sqrt(d)
	puts "Корень 1: #{'%.2f' % ((- b + sq_d) / (2 * a))}"
	puts "Корень 2: #{'%.2f' % ((- b - sq_d) / (2 * a))}"
end	
	