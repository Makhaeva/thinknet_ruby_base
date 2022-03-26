require_relative "station"
require_relative "route"
require_relative "cargo_train"
require_relative "cargo_carriage"
require_relative "passenger_train"
require_relative "passenger_carriage"


MENU = [{type: :create, title: "new station", action: :create_new_station},
        {type: :create, title: "new train", action: :create_new_train},
        {type: :create, title: "route: create and add/remove stations", action: :manage_route},
        {type: :manage, title: "train: assign a route", action: :set_route_to_train},
        {type: :manage, title: "train: add / remove carriages", action: :manage_carriges},
        {type: :act, title: "move train (ahead or back)", action: :move_train},
        {type: :show, title: "all stations", action: :show_stations}, 
        #{type: :show, title: "all routes", action: :show_routes},
        {type: :show, title: "trains (all and at the station)", action: :show_existing_trains}]

  def uniq? (class_name, new_id, id_title)
    all_instances_id = []
    class_name.all.each {|i| all_instances_id << i.send(id_title)}
    all_instances_id.none?{|i| i == new_id}
  end
  

  def create_new_station
    print "Enter the name of new station: "
    station_name = gets.chomp
    if uniq?(Station, station_name, "name")
      Station.new(station_name)
    else
      puts "The station with name #{station_name} already exists."
    end
  end
 

  def create_new_train
    print "Enter the name of new train: "
    train_number = gets.chomp.to_sym
    
    if uniq?(Train, train_number, "number")
      puts "Choose:"
      puts "1 - to create passenger train" 
      puts "2 - to create cargo train"
      user_choice = gets.chomp.to_i

      case user_choice
      when 1
        PassengerTrain.new(train_number)
      when 2
        CargoTrain.new(train_number)
      else
        puts "Undefined train type. Train was not created!"
      end

    else
      puts "The train with number #{train_number.to_s} already exists."
    end 
  end


  def create_new_route
    puts "There are following stations:"
    show_stations
    
    print "Choose number to the first station of route: "
    first_station = gets.chomp.to_i
    print "last station: "
    last_station = gets.chomp.to_i

    new_route = Route.new(Station.all[first_station - 1], Station.all[last_station - 1]) #if (first_station > 1 && last_station <= Station.all.length)
  end


  def edit_route
    route = selected_current_route

    puts "The route #{route.first_station.name} - #{route.last_station.name}"
    puts "has following stations:"
    route.stations.each_with_index {|st, i| puts "#{i + 1}. #{st.name}"}
    
    puts "Enter 1 - to add station"
    puts "      2 - to delete station from the route."
    action_name = (gets.chomp.to_i == 2 ? :delete_station : :add_station)
    
    if action_name == :delete_station
      puts "Choose the number of station from list above: "
      station = route.stations[gets.chomp.to_i - 1]

      print "Do you want to delete #{station.name} from route? (y/n) "
      return nil if gets.chomp.include?('n')
    else
      station = selected_current_station
      
      print "Do you want to add #{station.name} to route? (y/n) "
      return nil if gets.chomp.include?('n')
    end
    route.send(action_name, station)
  end


  def manage_route
    puts "Enter 1 - to create route"
    puts "      2 - to edit route"
    user_choice = gets.chomp.to_i 
    
    case user_choice
    when 1
      create_new_route
    when 2
      edit_route
    end
  end


  def manage_carriges
    cur_train = selected_current_train

    puts "Enter 1 - to attach carriage"
    puts "      2 - to unhook carriage: "
    user_choice = gets.chomp.to_i
    
    case user_choice
    when 1
      cur_train.type == "cargo" ? (carriage = CargoCarriage.new) : (carriage = PassangerCarriage.new)
      cur_train.attach_carriage(carriage)
    when 2
      count_of_carriages = cur_train.carriages.length
      puts "Train #{cur_train.number.to_s} has #{count_of_carriages} carriages."
      print "Enter the number of carriage which you'd like to unhook: "
      unhook_carriage_number = gets.chomp.to_i
      cur_train.unhook_carriage(cur_train.carriages[unhook_carriage_number - 1]) if unhook_carriage_number <= count_of_carriages
    end
  end

  def set_route_to_train
    cur_train = selected_current_train
    cur_route = selected_current_route
    cur_train.route = cur_route
  end


  def move_train
    cur_train = selected_current_train

    puts "Enter 1 - to move train ahead"
    puts "      2 - to go back"
    user_choice = gets.chomp.to_i
    
    case user_choice
    when 1
      cur_train.go_ahead
    when 2
      cur_train.go_back
    end
  end


  def show_stations
    Station.all.each_with_index {|st, i| puts "#{i + 1}. #{st.name}"}
  end
  

  def show_routes
    Route.all.each_with_index {|r, i| puts "#{i + 1}. #{r.first_station.name}  -  #{r.last_station.name}"}
  end


  def show_trains
    Train.all.each {|t| puts "#{t.number.to_s} - #{t.type}"}
  end

  def show_existing_trains
    puts "Enter 1 - to show all existing trains"
    puts "      2 - to show trains in the station"
    user_choice = gets.chomp.to_i
    
    case user_choice
    when 1
      puts "There are following stations:"
      show_trains
    when 2
      station = selected_current_station
      puts "Enter trains type ('cargo', 'passenger')"
      puts "if you'd like to show same trains."  
      type = gets.chomp.to_sym 

      type == :cargo || type == :passenger ? station.trains(type.to_s): station.trains
    end
  end

  def selected_current_station
    puts "There are following stations:"
    show_stations

    print "Choose the station's number: "
    station_number = gets.chomp.to_i
    cur_station = Station.all[station_number - 1] if station_number <= Station.all.length && station_number > 0
  end


  def selected_current_train
    puts "There are following trains:"
    show_trains
 
    print  "Choose the train's number from list above: "
    train_number = gets.chomp.to_sym
    cur_train = (Train.all.select {|t| t.number == train_number}).first
  end


  def selected_current_route
    puts "There are following routes:"
    show_routes

    print "Choose the number of route: "
    route_number = gets.chomp.to_i 
    cur_route = Route.all[route_number - 1] if route_number <= Route.all.length && route_number > 0
  end


  loop do
    puts "Choose, what would you like to do"
    puts
    puts "Create:"
    MENU.each_with_index {|h, i| puts "#{i + 1} - #{h[:title]}" if h[:type] == :create}
    puts
    puts "Manage:"
    MENU.each_with_index {|h, i| puts "#{i + 1} - #{h[:title]}" if [:manage, :act].include?(h[:type])}
    puts
    puts "Show:"
    MENU.each_with_index {|h, i| puts "#{i + 1} - #{h[:title]}" if h[:type] == :show}
    puts "0 - for exit."
    

    break if (user_choice = gets.chomp.to_i).zero?
    send(MENU[user_choice - 1][:action]) if (user_choice <= MENU.length and user_choice > 0) unless user_choice.zero?
    
    puts "Enter any key for continue or '0' for exit"
    break if gets.chomp.to_sym == "0".to_sym

  end

