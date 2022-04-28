class Room

	def initialize (id, roomName, creatorName)
		@id = id
		@roomName = roomName
		@creator = creatorName
		@participants = Array.new
		@participants << creatorName
		@messages = Array.new
	end
	
	def getRoomDetails (client)
		client.puts "Room #{@roomName}\n"
		client.puts "-----------------------\n"
		client.puts "Room ID: #{@id}\n"
		client.puts "-----------------------\n"
		client.puts "Created by: #{@creator}\n"
		client.puts "-----------------------\n"
		client.puts "Participants: \n"
		@participants.each do |participant|
			client.puts "--> #{participant}\n"
			client.puts "- - - - - - - - - - \n"
		end
	end
	
	def getRoomName
		@roomName
	end
	
	def addParticipants(participant)
		@participants << participant
	end
	
	def contains(participant)
		@participants.include?(participant)
	end
	
	def addMessage(username, message)
		@messages << "#{username}: #{message}\n"
	end
	
	def printMessage
		@messages.last
	end
end
