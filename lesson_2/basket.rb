# lesson 2.6: Basket

puts "Данная программа выводит покупательскую корзину"
puts

puts "Введите последовательно название товара, цену за единицу и количество. "
puts "После добавления всех товаров введите 'Стоп' вместо наименования товара "

hash_basket = Hash.new

loop do 
	print "наименование: "
	title = gets.chomp
	break if title.capitalize == "Стоп"
	if hash_basket[title.to_sym].nil?
		print "цена: "
		pr = gets.chomp.to_f
		print "количество: "
		quant = gets.chomp.to_f

		hash_basket[title.to_sym] = {price: pr, quantity: quant}
		puts
	else
		puts "Данный товар уже есть в корзине. "
		puts "Добавить еще некоторое количество данного товара (да/нет)?"
		answer = gets.chomp.downcase
		if answer == "да"
			print "количество: "
			quant = gets.chomp.to_f
			hash_basket[title.to_sym][:quantity] += quant
			puts
		end
	end
end

total_cost = 0

hash_basket.each do |k, hv|
	cost = 0
	print "#{k}: "
	puts "#{hv[:price]} руб. * #{hv[:quantity]} шт.  =  #{cost += (hv[:price] * hv[:quantity]).round(2)} руб."
	total_cost += cost
end

puts
puts "Итоговая сумма: #{total_cost}"
