require_relative "carriage"
require_relative "manufacturer"

class Train
  include Manufacturer
  attr_accessor :carriages, :speed
  attr_reader :number, :type, :route

  @@class_instances = []

  def self.find(number)
    @@class_instances.each {|t| t.number == number ? t : nil}
  end

  def initialize(number, type)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    @@class_instances << self
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

  def stop
    self.speed = 0
  end

  def cur_station
    return unless route

    route.stations[@cur_station_index]
  end

  def prev_station
    return unless route

    route.stations[@cur_station_index - 1] if @cur_station_index > 0
  end

  def next_station
    return unless route

    route.stations[@cur_station_index + 1] if @cur_station_index < (route.stations.length - 1)
  end

end

