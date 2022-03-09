# lesson_1.2: Triangles area

puts "Данная программа вычисляет площадь треугольника."
puts

print "Введите основание: "
a = gets.to_f
print "Введите высоту: "
h = gets.to_f


area = 0.5 * a * h
print "Площадь треугольника равна #{'%.2f' % area}"
