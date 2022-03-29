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
