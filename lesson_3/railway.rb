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
    self.trains.delete(train) if trains.include? train 
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
    if (station != @first_station) && (station != @last_station)
      if @stations.include? station 
        self.stations.delete(station) 
      else
        puts "#{station.name} отсутствует на заданном маршруте"
      end
    else
      puts "Нельзя удалить начальную или конечную станцию маршрута"
    end
  end
end




class Train
  attr_accessor :numb_wagons, :speed, :cur_station 
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
    self.numb_wagons += 1 if self.speed == 0
  end

  def unhook_wagon
    self.numb_wagons -= 1 if self.speed == 0
  end
  
  def route=(route)
    @route = route
    self.cur_station = route.first_station
  end

  def go_ahead
    if self.route 
      if self.cur_station != self.route.last_station
        @cur_station.send_train(self)
        @cur_station = self.next_station
        @cur_station.take_train(self)
      else
        puts "Поезд находится на конечной станции маршрута!"
      end
    else
      puts "Для данного поезда не задан маршрут следования"
    end
  end
  
  def go_back
    if self.route 
      if self.cur_station != self.route.first_station
        self.cur_station.send_train(self)
        self.cur_station = self.prev_station
        self.cur_station.take_train(self)
      else
        puts "Поезд находится на начальной станции маршрута!"
      end
    else
      puts "Для данного поезда не задан маршрут следования"
    end
  end

  def prev_station
    if self.cur_station != self.route.first_station
      self.route.stations[self.route.stations.index(self.cur_station) - 1]
    else
      puts "Поезд находится на начальной станции маршрута!"
      self.route.first_station
    end
  end

  def next_station
    if self.route.stations.index(self.cur_station) < (self.route.stations.length - 1)
      self.route.stations[self.route.stations.index(self.cur_station) + 1]
    else
      puts "Поезд находится на конечной станции маршрута!"
      self.route.last_station
    end
  end
end

=begin
def test_seeds 
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
  r_len_mos = Route.new(st_len, st_mos)
  r_bal_tv = Route.new(st_bal, st_tv) 
  r_mos_tv = Route.new(st_mos, st_tv)
  
  #добавить станцию
  r_len_mos.add_station(st_bal)
  r_len_mos.add_station(st_pop)
  r_len_mos.add_station(st_tv)
  r_bal_tv.add_station(st_pop)
  r_mos_tv.add_station(st_him)

  #удалить станцию
  r_mos_tv.delete_station(st_him)
  r_len_mos.delete_station(st_bal)

  #класс Поезда 
  # создание
  t1 = Train.new(123, "cargo", 10)
  t2 = Train.new(234, "passenger", 12)
  t3 = Train.new(9, "cargo", 15)
  arr_tr = [t1, t2, t3]

  
  #вывести информацию по поезду - номер, типб количество вагонов
  arr_tr.each do |t|
    puts "Поезд №#{t.number}, тип #{t.type}." 
    puts "В составе #{t.numb_wagons} вагонов"
    
    #работа с вагонами: добавить, удалить, запросить количество 
    print "Присоединяем вагон. "
    t.attach_wagon
    print "Вагонов стало:"
    puts "#{t.numb_wagons}"
    print "Присоединим вагон к движущемуся составу"
    t.speed = 80
    t.attach_wagon
    print "Отсоединяем вагон. "
    t.unhook_wagon
    print "Итог:"
    puts "#{t.numb_wagons}"

    #работа со скоростью - запросить, нарастить, остановиться 
    puts "Текущая скорость - #{t.speed} км/ч"
    print "Нарастим. "
    t.speed = 30
    puts "Теперь скорость - #{t.speed} км/ч"
    print "Остановимся. "
    t.stop
    puts "В итоге скорость - #{t.speed} км/ч"

    #работа с маршрутом следования поезда - все пока из ленинграда в москву
    t.route = r_len_mos
    puts "Поезду №#{t.number} установилен маршрут #{t.route.first_station.name} - #{t.route.last_station.name}"
    print "Осторожно, двери закрываются! Следующая станция:"
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
    puts "Поезд следует по маршруту #{t.route.first_station.name} - #{t.route.last_station.name}"
    puts "Поезд находится на станции #{t.cur_station.name}."
    print "Отправимся на станцию назад: "
    t.go_back

  end

  # работа с поездами на станции
  # вывести все поезда
  puts "На станции #{st_len.name} находятся следующие поезда:"
  st_len.trains

  # вывести поезда по типу
  puts "На станции #{st_len.name} находятся следующие грузовые поезда:"
  st_len.trains("cargo")

end

test_seeds
=end
