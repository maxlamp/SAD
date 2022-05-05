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
    		nickName = client.gets.chomp.to_sym
                @connections[:clients].each do |other_name, other_client|
                    if nickName == other_name
                        client.puts "This username already exist\n"
                        Thread.kill self
                    elsif client == other_client
                    	client.puts "This client is already running\n"
                        Thread.kill self
                    end
                end
                puts "#{nickName} has joined the chat. #{client}\n"
                @connections[:clients][nickName] = client
                done = false
                while done == false
	                client.puts "Would you like to join/create a room? (join/create): "
        		ans = client.gets.chomp
        		if ans == "create"
        			done = createRoom(client, nickName)	
     			elsif ans == "join"
     				done = joinRoom(client, nickName)
     			else 
     				client.puts "Pleas,choose one of the valids options (join/create)\n"
     			end
       		end 
       		availableCommands(client)	
       	        listen_user_messages(nickName, client)
            end
        }.join
    end

    def listen_user_messages (username, client)
        loop{
            msg = client.gets.chomp
            if msg == "Join another room"
            	client.puts "Here you have the list of available rooms:\n"
            	roomList(client)
            	client.puts "Choose the room you want to join: "
            	roomName = client.gets.chomp.to_sym
            	@connections[:rooms].each do |room, participants|
            		if room.getRoomName == roomName
            			participants << client
            			@connections[:rooms][room] = participants
            			client.puts "You have successfuly been added to the room #{roomName}!\n"
            		end
            	end
            elsif msg == "Leave room"
            	client.puts "Here you have a list with the rooms that you are in:\n"
            	@connections[:rooms].each do |room, participants|
            		participants.each do |participant|
            			if participant == client
            				client.puts "- #{room.getRoomName}\n"
            			end
            		end
            	end
            	client.puts "Introduce the name of the room that you want to leave: "
            	roomName = client.gets.chomp.to_sym
            	@connections[:rooms].each do |room, participants|
            		if room.getRoomName == roomName
            			participants.each do |participant|
            				if participant == client
            					participants.delete(client)
            					@connections[:rooms][room] = participants
            				end
            			end
            		end
            	end
            	client.puts "You have been successfuly removed from the room #{roomName}!\n"
            elsif msg != "Join another room" || msg != "Leave room"
	     	@connections[:rooms].each do |room, participants|
	     	  	if room.contains(username)
	            		room.addMessage(username, msg)
	            		participants.each do |p|
	            			unless p == client
	            				p.puts "#{room.printMessage}"
	            			end
	            		end
	            	end
	        end
	    end	            
        }
    end
    
    def createRoom(client, creatorName)
    	client.puts "Please type in the name of the room you want to create: "
       	roomName = client.gets.chomp.to_sym
     	room = Room.new(@rooms.length, roomName, creatorName)
     	participants = Array.new
     	participants << client
     	@connections[:rooms][room] = participants
     	puts "The room #{roomName} has been created by #{creatorName}"
     	roomList(client)
     	return true
    end
    
    def joinRoom(client, userName)
    	if @connections[:rooms].empty?
		client.puts "You can't join any room because no rooms have been created yet!\n"
		return false
	else
		client.puts "Here you have the list of availabke rooms: "
		roomList(client)
		client.puts "Which room would you like to join? Type in the room name please: "
		roomName = client.gets.chomp.to_sym
		@connections[:rooms].each do |room, participants|
			if room.getRoomName == roomName
				participants << client
				room.addParticipants (userName)
				@connections[:rooms][room] = participants
				client.puts "You have been added to the room #{roomName}. Enjoy your chatting!\n"
			end
		end
		return true
    	end
    end
    
    def roomList(client)
    	@connections[:rooms].each do |room, participants|
        	room.getRoomDetails(client)
    	end
    end
    
    def availableCommands(client)
        client.puts "Here you have a list of available commands: \n"
     	client.puts "------------------------------------------\n"
     	client.puts "1. If you want to join another room, you have to type 'Join another room' and then introduce the room name you want to join \m"
    	client.puts "2. If you want to leave one room, you have to type 'Leave room' and then introduce the room that you want to leave\n"
    end
      
end
server = Server.new("localhost", 5050)

