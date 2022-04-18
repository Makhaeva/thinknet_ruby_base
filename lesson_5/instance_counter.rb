module InstanceCounter
  def self.included(base)
    base.extend ClassMethod
    base.include InstanceMethod
  end

  module ClassMethod
    #def all
    #  @@class_instances ||= []
    #end

    def instances
      @@instances_count ||= 0
    end

    def instances_count_up()
      (defined? @@instances_count).nil? ? @@instances_count = 1 : @@instances_count += 1 
    end
  end

  module InstanceMethod
    protected
    def register_instance
      self.class.instances_count_up 
      #self.class.all << self
    end
  end
end