require_relative "train"

class PassengerTrain < Train
  def self.all 
    @@all_passanger_trains ||= []
  end

  def self.clear
    @@all_passanger_trains.clear
  end
  

  def initialize(number)
    super(number, type = "passenger")
    self.class.all << self
    @@all_train_instances << self
  end
  
end