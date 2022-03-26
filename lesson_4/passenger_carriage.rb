require_relative "carriage"

class PassangerCarriage < Carriage
  
  def initialize
    super("passenger")
  end
end