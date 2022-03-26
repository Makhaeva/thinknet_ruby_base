require_relative "carriage"

class Train
  attr_accessor :carriages, :speed
  attr_reader :number, :type, :route

  def self.all
    @@all_train_instances ||= []
  end

  def self.clear
    @@all_train_instances.clear
  end

  def initialize(number, type)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    self.class.all << self
  end

  def stop
    self.speed = 0
  end

  def attach_carriage(carriage)
    self.carriages << carriage if speed.zero? and carriage.type == self.type
  end

  def unhook_carriage(carriage)
    self.carriages.delete(carriage) if speed.zero?
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

