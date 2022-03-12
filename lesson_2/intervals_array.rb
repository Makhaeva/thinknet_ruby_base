# lesson 2.2: Array with interval of integer 

puts "Данная программа заполняет массив числами от 10 до 100 с шагом 5"
puts

arr = (10..100).step(5).to_a

puts "Result: "
arr.each {|a| print "#{a} " } 

 