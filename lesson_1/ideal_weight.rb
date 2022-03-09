# lesson_1.1: Ideal weight

puts "Для определения идеального веса введите, пожалуйста"
print "имя: "
user_name = gets.chomp.capitalize
print "рост: "
user_height = gets.to_i

ideal_weight = (user_height - 110) * 1.15

if ideal_weight <= 0
  print "#{user_name}, Ваш вес уже оптимальный."
else 
  print "#{user_name}, Ваш идеальный вес  - #{'%.2f' % ideal_weight} киллограмм."
end