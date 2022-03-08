# lesson_1.2: Triangles square

puts "Данная программа вычисляет площадь треугольника."
puts "Введите значения (в см)."
print "основание: "
a = gets.to_f
print "высота: "
h = gets.to_f

puts
square = 0.5 * a * h
print "Площадь треугольника равна #{'%.2f' % square} квадратных сантиметров"