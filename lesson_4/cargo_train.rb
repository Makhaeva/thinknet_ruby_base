require_relative "train"

class CargoTrain < Train
  
  def self.all 
    @@all_cargo ||= []
  end


  def self.clear
    @@all_cargo.clear
  end
  

  def initialize(number)
    super(number, type = "cargo")
    self.class.all << self
    @@all_train_instances << self
  end
  
end