class Station
  attr_reader :name
  attr_writer :trains

  def initialize(name)
    @name = name
    @trains = []
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