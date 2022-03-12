# lesson 2.4: Hash with vovels

puts "Данная программа заполняет хеш гласными буквами с их порядковыми номерами в алфавите"
puts

alph = ('a'..'z').to_a
vovels = %w(a e i o u y)

vov_hash = Hash.new
alph.each_with_index do |letter, order|
	vov_hash[letter.to_sym] = (order + 1)  if vovels.include?(letter) 
end

puts "Ordinal number of vovel letter in the alphabet:"
vov_hash.each do |letter, order|
	puts "#{letter.to_s} - #{order}" 
end