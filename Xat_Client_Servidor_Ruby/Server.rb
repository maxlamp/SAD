$LOAD_PATH << '.'

require "socket"
require "./Room"

class Server
    
    def initialize(ip, port)
        @server = TCPServer.open(ip,port)
	@connections = Hash.new
        @rooms = Hash.new
        @clients = Hash.new
        @connections[:server] = @server
        @connections[:rooms] = @rooms
        @connections[:clients] = @clients
        run
    end

    def run
        loop {
            Thread.start(@server.accept) do |client|
    		
    		#fromat del que enviem option/----/name/---/msg
    		loop{
    		
    		total = client.gets.chomp()
    		option = total.split('/')
                
                case option[0]
                
                when 'login'
                nickName=option[1]
                l=true
                 @connections[:clients].each do |other_name, other_client|
                    if nickName == other_name
                        client.puts "This username already exist\n"
                        l=false
                    elsif client == other_client
                    	client.puts "This client is already running\n"
                    	l=false
                    end
                end
                if l
                puts "#{nickName} has joined the chat. #{client}\n"
                client.puts 'Usuari disponible'
                @connections[:clients][nickName] = client
                end
                when 'join'
                if @connections[:rooms].empty?
     		 	client.puts "No rooms"
     		 else
     			#client.puts "Here you have the list of availabke rooms: "
     			#roomList(client)
    	 		#client.puts "Which room would you like to join? Type in the room name please: "
     			roomName = option[1]
     			@connections[:rooms].each do |room, participants|
     				if room.getRoomName == roomName
     					participants << client
     					room.addParticipants (nickName)
     					@connections[:rooms][room] = participants
     					client.puts "Ok/#{room.getCreator}"
     			         
     			         else
     			         	client.puts 'No existeix'
     			         end
     			         
     			end
     		
     		end
                
                when 'create'
               
	       	roomName = option[1]
	     		room = Room.new(@rooms.length, roomName, option[3])
	     		participants = Array.new
	     		participants << client
	     		@connections[:rooms][room] = participants
	     		puts "The room #{roomName} has been created by #{option[3]}"
	     		client.puts 'Ok' 
	     		roomList(client)
                
                when 'room'
                msg = option[4]
                username = option[3] 
            	@connections[:rooms].each do |room, participants|
           	 	if room.contains(username) and room.getRoomName == option[1]
            		room.addMessage(username, msg)
            		participants.each do |p|
		    			#unless p == client
		    			p.puts "room/#{option[1]}/name/#{username}/#{msg}"
		    			puts "#{username}/#{msg}"
		    			#end
            			end
            		end
           	 end
                
                
                end
               
         	}
            end
        }.join
    end
    
    def roomList(client)
    	@connections[:rooms].each do |room, participants|
        room.getRoomDetails(client)
    	end
    end
    def rlist
    
    
    end
    
end

if __FILE__ == $0 
server = Server.new("localhost", 5050)
end
