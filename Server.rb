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
                client.puts "Would you like to join/create a room? (join/create/no): "
        	ans = client.gets.chomp
        	if ans == "create"
        		client.puts "Please type in the name of the room you want to create: "
       			roomName = client.gets.chomp.to_sym
     			room = Room.new(@rooms.length, roomName, nickName)
     			participants = Array.new
     			participants << client
     			@connections[:rooms][room] = participants
     			puts "The room #{roomName} has been created by #{nickName}"
     			roomList(client)	
     		elsif ans == "join"
     			client.puts "Here you have the list of availabke rooms: "
     			roomList(client)
     			client.puts "Which room would you like to join? Type in the room name please: "
     			roomName = client.gets.chomp.to_sym
     			@connections[:rooms].each do |room, participants|
     				if room.getRoomName == roomName
     					participants << client
     					room.addParticipants (nickName)
     					@connections[:rooms][room] = participants
     					client.puts "You have been added to the room #{roomName}. Enjoy your chatting!\n"
     				end
     			end
     		else
      			client.puts "Connection estabilshed. Thank you for joining! Happy chatting\n"
       		end
                listen_user_messages(nickName, client)
            end
        }.join
    end

    def listen_user_messages (username, client)
        loop{
            msg = client.gets.chomp
            @connections[:rooms].each do |room, participants|
            	if room.contains(username)
            		participants.each do |p|
            			unless p == client
            				p.puts "#{username.to_s}: #{msg}"
            			end
            		end
            	end
            end
        }
    end
    
    def roomList(client)
    	@connections[:rooms].each do |room, participants|
        	room.getRoomDetails(client)
    	end
    end
    
end
server = Server.new("localhost", 5050)

