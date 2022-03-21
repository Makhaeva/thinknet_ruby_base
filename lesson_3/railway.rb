class Station
  attr_reader :name
  attr_writer :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    self.trains << train
  end

  def trains(type = "all")
    if type != "all"
      @trains.each {|t| puts t.number if (t.type == type)}
    else
      @trains.each {|t| puts t.number}
    end
  end

  def send_train(train)
    @trains.delete(train) 
  end
end




class Route
  attr_reader :first_station, :last_station, :stations

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [first_station, last_station]
  end

  def add_station(station)
    @stations << @stations.last
    @stations[-2] = station
  end

  def delete_station(station)
    return unless (station != @first_station) && (station != @last_station)

    @stations.delete(station)
  end
end




class Train
  attr_accessor :numb_wagons, :speed
  attr_reader :number, :type, :route

  def initialize(number, type, numb_wagons)
    @number = number
    @type = type
    @numb_wagons = numb_wagons
    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def attach_wagon
    self.numb_wagons += 1 if speed.zero?
  end

  def unhook_wagon
    self.numb_wagons -= 1 if speed.zero? and self.numb_wagons > 1
  end
  
  def route=(route)
    @route = route
    @cur_station_index = 0
    @route.first_station.take_train(self)
  end

  def cur_station
    return unless route

    route.stations[@cur_station_index]
  end

  def prev_station
    route.stations[@cur_station_index - 1] if @cur_station_index > 0
  end

  def next_station
    route.stations[@cur_station_index + 1] if @cur_station_index < (route.stations.length - 1)
  end

  def go_ahead
    return unless next_station

    cur_station.send_train(self)
    next_station.take_train(self)
    @cur_station_index += 1 
  end
  
  def go_back
    return unless prev_station

    cur_station.send_train(self)
    prev_station.take_train(self)
    @cur_station_index -= 1
  end
end




=begin
def test_seeds 
  puts "Проверяем классы СТАНЦИИ и МАРШРУТЫ"

  #класс Станции
  #создание
  st_len = Station.new("Ленинград")
  st_bal = Station.new("Балагое")
  st_pop = Station.new("Поповка")
  st_tv = Station.new("Тверь")
  st_him = Station.new("Химки")
  st_mos = Station.new("Москва")

  # class Route
  # работа с маршрутом - создать
  puts "Создадим маршруты:"
  puts "#{st_len.name} - #{st_mos.name}"
  r_len_mos = Route.new(st_len, st_mos)
  puts "#{st_bal.name} - #{st_tv.name}"
  r_bal_tv = Route.new(st_bal, st_tv) 
  puts "#{st_mos.name} - #{st_tv.name}"
  r_mos_tv = Route.new(st_mos, st_tv)
  puts "\n"
  
  #добавить станцию
  puts "В маршрут #{r_len_mos.first_station.name} - #{r_len_mos.last_station.name} добавлены станции:"
  puts "#{r_len_mos.add_station(st_bal).name}"
  puts "#{r_len_mos.add_station(st_pop).name}"
  puts "#{r_len_mos.add_station(st_tv).name}\n\n"
  print "В маршрут #{r_bal_tv.first_station.name} - #{r_bal_tv.last_station.name} добавлена станция:  "
  puts "#{r_bal_tv.add_station(st_pop).name}"
  print "В маршрут #{r_mos_tv.first_station.name} - #{r_mos_tv.last_station.name} добавлена станция:  "
  puts "#{r_mos_tv.add_station(st_him).name}\n\n"

  #удалить станцию
  puts "Из маршрута #{r_len_mos.first_station.name} - #{r_len_mos.last_station.name} удалаяем станции:"
  puts "#{r_len_mos.delete_station(st_bal).name}"
  puts "#{r_len_mos.delete_station(st_tv).name}"
  puts "Пытаемся удалить начальную станцию маршрута:"
  puts "#{st_len.name} - #{r_len_mos.delete_station(st_len)}\n"

  puts "Из маршрута #{r_mos_tv.first_station.name} - #{r_mos_tv.last_station.name} удалаяем станцию:"
  puts "#{r_mos_tv.delete_station(st_him).name}"
  
  # удалим несуществующую в маршруте станцию
  puts "Удаляем несуществующую станцию в маршруте #{st_bal.name} - #{st_tv.name}:"
  puts "#{st_mos.name} - #{r_bal_tv.delete_station(st_mos)}"
  puts "\n\n"

  #класс Поезда 
  puts "Проверяем класс ПОЕЗДА"
  # создание
  t1 = Train.new(123, "cargo", 10)
  t2 = Train.new(234, "passenger", 12)
  t3 = Train.new(9, "cargo", 15)
  t4 = Train.new(000, "cargo", 0)
  arr_tr = [t1, t2, t3]
  arr_one_tr = [t2]

  
  #выведем информацию по поезду - номер, типб количество вагонов
  
  arr_one_tr.each do |t|
    puts "Поезд №#{t.number}, тип #{t.type}." 
    puts "В составе #{t.numb_wagons} вагонов."
    

    #работа с вагонами: добавить, удалить, запросить количество 
    #работа со скоростью - запросить, нарастить, остановиться 
    print "Присоединяем вагон. "
    t.attach_wagon
    print "Вагонов стало:"
    puts "#{t.numb_wagons}"
    print "Нарастим скорость -  "
    t.speed = 80
    puts "#{t.speed} км/ч"
    print "Отсоединим вагон от движущегося состава: "
    t.unhook_wagon
    puts "#{t.numb_wagons}"
    
    print "Остановимся. "
    t.stop
    puts "В итоге скорость - #{t.speed} км/ч\n\n"


    #работа с маршрутом следования поезда - из ленинграда в москву
    #попробуем запросить текущую станцию если маршрут еще не установлен
    puts "Маршрут пока не установлен, запрашиваем станцию"
    puts "#{t.cur_station}"

    t.route = r_len_mos
    puts "Поезду №#{t.number} установилен маршрут #{t.route.first_station.name} - #{t.route.last_station.name}"
    print "Осторожно, двери закрываются! Следующая станция: "
    puts "#{t.next_station.name}"

    puts "Поехали!"
    t.go_ahead
    print "Остановка на станции: "
    puts "#{t.cur_station.name}"

    puts "А теперь вернемся назад!"
    t.go_back
    print "Остановка на станции: "
    puts "#{t.cur_station.name}"

    #попробуем отправить поезд на с начальной станции на предыдущую
    print "Пытаемся отправиться c начальной станции назад: "
    t.go_back
    puts "#{t.cur_station.name}\n\n"
  end


  # работа с поездами на станции
  # вывести все поезда
  t1.route = r_len_mos
  t3.route = r_len_mos

  puts "\n\n"

  #запросим поезда на начальньй станции маршрута - в Ленинграде
  puts "Запросим поезда - все и по типу (на одной станции)"
  puts "На станции #{st_len.name} находятся следующие поезда: "
  st_len.trains

  # вывести поезда по типу 
  puts "Среди них следующие являются грузовыми: "
  st_len.trains("cargo")

  #пытаемся отправить со станции несуществующий поезд
  puts "Отправляем поезд, которого нет на станции: " 
  st_len.send_train(t4)
end

test_seeds
=end


