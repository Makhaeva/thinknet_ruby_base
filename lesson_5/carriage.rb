require_relative "manufacturer"

class Carriage
  include Manufacturer
  attr_accessor :type

  def initialize(type)
    @type = type
  end

end