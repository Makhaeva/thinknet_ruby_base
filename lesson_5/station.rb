class Station
  attr_reader :name
  attr_writer :trains
  @@class_instances = []

  def self.all
    @@class_instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@class_instances << self
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