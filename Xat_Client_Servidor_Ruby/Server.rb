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
    		
    		#format del que enviem option/----/name/---/msg
    		loop{
    		
    		total = client.gets.chomp()
    		option = total.split('/')
                
                case option[0]
                	when 'login'
                		#option[1] <--> nickName
	                	l=true
	                 	@connections[:clients].each do |other_name, other_client|
	                    		if option[1] == other_name
	                        		client.puts "This username already exist\n"
	                        		l = false
	                    		elsif client == other_client
	                    			client.puts "This client is already running\n"
	                    			l = false
	                    		end
	                	end
	                	if l
	               			puts "#{option[1]} has joined the chat. #{client}\n"
	                		client.puts 'Usuari disponible'
	                		@connections[:clients][option[1]] = client
	                	end
	                	
	                when 'join'                
	                	if @connections[:rooms].empty?
	     			 	client.puts "No rooms"
	    	 		else
	    	 			roomName = option[1]
	    	 			@connections[:rooms].each do |room, participants|
	    	 				if room.getRoomName == roomName
	    	 					participants << client
	    	 					room.addParticipants (option[1])
	    	 					@connections[:rooms][room] = participants
	    	 					puts "#{option[3]} has joined the room #{roomName}\n"
	    	 					client.puts "Ok/#{room.getRoomName}"
	    	 			         else
	    	 			         	client.puts 'No existeix'
	    	 			         end
	    	 			end
	    	 		end
	    	 			            
	                when 'create'		             
	                	exists = false  
			       	roomName = option[1]
			       	
			       	@connections[:rooms].each do |room, participants|
	    	 			if room.getRoomName == roomName
	    	 				client.puts "Fail"
	    	 				exists = true
	    	 		        end
	    	 		end
	    	 		
	    	 		if !exists 
	    	 			room = Room.new(@rooms.length, roomName, option[3])
		     			participants = Array.new
		     			participants << client
		     			@connections[:rooms][room] = participants
		     			puts "The room #{roomName} has been created by #{option[3]}"
		     			client.puts(room.getRoomName)  
                		end
                
	                when 'room'	
		                #msg <--> option[4]
		                #username <--> option[3]	                 
		            	@connections[:rooms].each do |room, participants|
		           	 	if room.contains(option[3]) and room.getRoomName == option[1]
			            		room.addMessage(option[3], option[4])
			            		participants.each do |c|
			            			unless c == client
								puts "#{option[3]} has sent a message to #{c} // Message: #{option[4]}"
								c.puts(getRoomMessages(room.getRoomName))
	            					end
	            				end
	            			end
	           	 	end
	           	 	
	                end
	         	}
	            end
	        }.join
    end
    
    def roomList
    	rooms = Array.new
    	@connections[:rooms].each_key do |room|
    		rooms << room.getRoomName
    	end
    	return rooms
    end
    
    def getRoomMessages(roomName)
    	@connections[:rooms].each do |room, participants|
    		if room.getRoomName == roomName
			return room.getMessages
	        end
	end
    end    
end

if __FILE__ == $0 
server = Server.new("localhost", 5050)
end
