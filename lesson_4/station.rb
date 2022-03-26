class Station
  attr_reader :name
  attr_writer :trains

  def self.all
    @@all_station_instanses ||= []
  end

  def self.clear
    @@all_station_instanses.clear
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.all << self
  end

  def trains(type = "all")
    if type != "all"
      @trains.each {|t| puts t.number if (t.type == type)}
    else
      @trains.each {|t| puts t.number}
    end
  end

  def take_train(train)
    self.trains << train
  end

  def send_train(train)
    @trains.delete(train) 
  end
end