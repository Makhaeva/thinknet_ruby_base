class Route
  attr_reader :first_station, :last_station, :stations
  
  def self.all
    @@all_route_instanses ||= []
  end

  def self.clear
    @@all_route_instanses.clear
  end

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @stations = [first_station, last_station]
    self.class.all << self
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
