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
        {type: :show, title: "all route's stations", action: :show_route_detail},
        #{type: :show, title: "all stations", action: :show_stations}, 
        #{type: :show, title: "all routes", action: :show_routes},
        #{type: :show, title: "trains (all and at the station)", action: :show_existing_trains},
        {type: :show, title: "trains in the station", action: :show_station_trains}]

  def uniq? (class_name, new_id, id_title)
    all_instances_id = []
    class_name.all.each {|i| all_instances_id << i.send(id_title)}
    all_instances_id.none?{|i| i == new_id}
  end
  
  def simple_create_station(station_name)
    Station.new(station_name)
  end

  def create_new_station
    print "Enter the name of new station: "
    station_name = gets.chomp
    if uniq?(Station, station_name, "name")
      simple_create_station(station_name)
    else
      puts "The station with name #{station_name} already exists."
    end
  end
 

  def create_new_train
    loop do
      print "Enter the number of new train: "
      train_number = gets.chomp.to_sym
    
      if uniq?(Train, train_number, "number")
        puts "Choose:"
        puts "1 - to create passenger train" 
        puts "2 - to create cargo train"
        user_choice = gets.chomp.to_i

        case user_choice
        when 1
          return PassengerTrain.new(train_number)
        when 2
          return CargoTrain.new(train_number)
        else
          puts "Undefined train type. Train was not created!"
        end
      else
        puts "The train with number #{train_number.to_s} already exists."
      end 
    end
  end


  def create_new_route
    puts "There are following stations:"
    show_stations
    stations_list_length = Station.all.length
    
    puts "Choose number from list above  or  enter new stations name"
    print "first station: " 
    first_station = gets.chomp
    print "last station: "
    last_station = gets.chomp

    first_station_exists = (first_station.to_i > 0  &&  first_station.to_i <= stations_list_length)
    last_station_exists = (last_station.to_i > 0  &&  last_station.to_i <= stations_list_length)
    
    f_st = first_station_exists ? Station.all[first_station.to_i - 1] : simple_create_station(first_station) 
    l_st = last_station_exists ? Station.all[last_station.to_i - 1] : simple_create_station(last_station)

    new_route = Route.new(f_st, l_st)
  end

  def show_route_detail
    route = selected_current_route
    puts "The route #{route.first_station.name} - #{route.last_station.name}"
    puts "has following stations:"
    show_route_stations(route)
  end

  def show_route_stations(route)
    route.stations.each_with_index {|st, i| puts "#{i + 1}. #{st.name}"}
  end



  def edit_route
    route = selected_current_route

    puts "Enter 1 - add station to route"
    puts "      2 - delete station from the route"
    puts "      3 - delete route"
    puts "      any other key - for exit"

    user_choice = gets.chomp.to_i
    case user_choice
    when 0
      return 
    when 1
      station = selected_current_station
      route.add_station(station)
    when 2
      puts "Choose station number from the list below: "
      show_route_stations(route)

      station_number = gets.chomp
      if station_number.to_i > 1  &&  station_number.to_i < route.stations.length    #enter the number and it isn't first or last station of route
        station = route.stations[station_number.to_i - 1] 
        route.delete_station(station)
      end
    when 3
      Route.delete(route)
    end
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
      carriage =  cur_train.type == "cargo" ? CargoCarriage.new :  PassangerCarriage.new
      cur_train.attach_carriage(carriage)
    when 2
      puts "Train #{cur_train.number.to_s} has #{cur_train.carriages.length} carriages."
      print "Enter the number of carriage which you'd like to unhook: "
      unhook_carriage_number = gets.chomp
      unhook_exists = unhook_carriage_number.to_i > 0  && unhook_carriage_number.to_i <= cur_train.carriages.length
      
      cur_train.unhook_carriage(cur_train.carriages[unhook_carriage_number.to_i - 1]) if unhook_exists
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

  def show_station_trains
    station = selected_current_station
    
    puts "Enter trains type ('cargo', 'passenger')  or  press any key to show all trains"
    type = gets.chomp.to_sym 
    type == :cargo || type == :passenger ? station.trains(type.to_s): station.trains
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
      show_station_trains
    end
  end


  def selected_current_station
    puts "There are following stations:"
    show_stations
    stations_list_length = Station.all.length
    
    print "Choose number from list above  or  enter new stations name: "
    station_number = gets.chomp
    station_exists = station_number.to_i > 0  &&  station_number.to_i <= stations_list_length
    
    cur_station = station_exists ? Station.all[station_number.to_i - 1] : simple_create_station(station_number)
  end


  def selected_current_train
    puts "There are following trains:"
    show_trains
 
    print  "Choose the number from list above   or   press any key to create new: "
    train_number = gets.chomp

    cur_train = (Train.all.select {|t| t.number == train_number.to_sym}).first || create_new_train
  end


  def selected_current_route
    puts "There are following routes:"
    show_routes
    print "Choose the number of route    or    press any key to create new: "
    route_number = gets.chomp
    route_exists = route_number.to_i > 0  &&  route_number.to_i <= Route.all.length

    cur_route = route_exists ? Route.all[route_number.to_i - 1] : create_new_route
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

