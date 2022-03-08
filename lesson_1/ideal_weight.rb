puts "Введите, пожалуйста"
print "ваше имя:"
user_name = gets.chomp.capitalize!

print "рост:"
user_height = gets.chomp.to_i

res = (user_height - 110) * 1.15

print "#{user_name}, "
if res <= 0:
  print "Ваш вес уже оптимальный."
else 
  print "Ваш идеальный вес  - #{res} киллограмм."