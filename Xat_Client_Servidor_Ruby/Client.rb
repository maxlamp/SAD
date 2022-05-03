$LOAD_PATH << '.'

require 'socket'
require 'gtk3'
require 'thread'
require_relative 'CLoginView'
require_relative 'ClientGUI'
require_relative 'Room'
require_relative 'JoinView'
require_relative 'CreateView'

class Client
    
    def initialize(server) #definim una funció d'inicialització a partir d'una instància del servidor
        @server = server
        @username = nil
        @roomactual = nil
        @i = 0
        @rooms = Hash.new
        @msgs = Array.new
        finestraLog
    end

    def send
       @request = Thread.new do
      		if @roomactual == nil
      			@win2.setText('Afegeix una room primer!')
      			@win2.borrar
      		else
      			@msg = @win2.getText
            		@roomactual.addMessage(@username, @msg)
            		@win2.setText(@roomactual.getMessage)
        		@server.puts("room/#{@roomactual.getRoomName}/name/#{@username}/#{@msg}")
                	@win2.borrar
                	@msg = nil 
      		
      		end	    	
       end    
    end

    def listen
        @response = Thread.new do
        puts "entro al thread//#{@response}" 
            loop {
                msg = @server.gets.chomp
                if msg == nil
                	puts 'misatge nul'
                end
                if msg != nil          
                	if msg.split('/')[0] == 'room'
                		@rooms.each_key do |room|
		        		if msg.split('/')[1] == room.getRoomName
	   					room.addMessage(msg.split('/')[3],msg.split('/')[4])
	   					if room.getRoomName == @roomactual.getRoomName
	   						updateMis(@roomactual.getMessage)
	   					else
	   						updateViewRooms
	   					end
		        		end
                		end
         		end
                end 
            }
        end
        return @response
    end
    
    def login    
    		msg = @win.getText
    		@server.puts("login/#{msg}")
    		resp = @server.gets.chomp	    	
	    	if resp == 'Usuari disponible'
		    	@username = msg	
			finestraUsr
			if @rooms != nil
				@rooms.each_key do |r|
					addRoom(r)
				end
			end
	    	else
	    		@win.changelabel
	    	end
    end 
    
    def finestraLog
    	@win = CLoginView.new
    	@button = Gtk::Button.new(label:'Login')
	@button.signal_connect('clicked') {login}
	@button.set_size_request(10,10)
	@win.addThing(@button)
        @win.signal_connect('destroy') { @win.destroy }
        @win.show_all
        Gtk.main

    end
    
    def finestraUsr
       	@win.destroy  
    	@win2 = ClientGUI.new
    	@button = Gtk::Button.new(label:'Send')
	@button.signal_connect('clicked') {send}
	@button.set_size_request(10,10)
	@win2.addButtonSend(@button)
	
	#boto create
	@bcreate = Gtk::Button.new(label:'Create')
	@bcreate.signal_connect('clicked') {createroom}
	@win2.addButtonCreate(@bcreate)

	#boto join
	@bjoin	= Gtk::Button.new(label:'Join')
	@bjoin.signal_connect('clicked') {joinroom}
	@win2.addButtonJoin(@bjoin)
	
	#listen
	@win2.signal_connect('destroy') {Gtk.main_quit}
	@win2.show_all
	Gtk.main_iteration

    end
    
    def updateMis(msg)
	@win2.setText(msg)	  	
    end
   
    def joinroom
    	@wjoin = JoinView.new
    	@bjoin = Gtk::Button.new(label: 'Join')
    	@bjoin.signal_connect('clicked') {joinRoomButton}
    	@wjoin.addBoto(@bjoin)
    	@wjoin.signal_connect('destroy') {@wjoin.destroy}
    	@wjoin.show_all
    	Gtk.main_iteration
    	
    end
    def createroom
    	@wc = CreateView.new
    	@bc = Gtk::Button.new(label: 'Create')
    	@bc.signal_connect('clicked') {createRoomButton}
    	@wc.addBoto(@bc)
    	@wc.signal_connect('destroy') {@wc.destroy}
    	@wc.show_all
    	Gtk.main_iteration

    end
    def addroom(r)
   	@b = Gtk::Button.new(label: r)
   	@b.signal_connect('clicked') {
   	@rooms.each_key do |room|
		if room.getRoomName == r  
			@roomactual = room
			updateMis(@roomactual.getMessage)
		end      		
		        		
       end
   	
   	}
   	@win2.addListRooms(@b,@i)
	@i = @i + 1;
    end
    
    def joinRoomButton
    	if @roomactual == nil
    		t = listen
    	else
    		@rooms.each do |room, thread|
    			if room.getRoomName == @roomactual.getRoomName
    				thread.kill
    				t = listen
    			end
    		end
    	end
    	roomName = @wjoin.getText
    	@server.puts("join/#{roomName}/name/#{@username}")
    	resp = @server.gets.chomp
	if resp =='No rooms'
	    	@wjoin.changelabel('There are no rooms created yet. Please, create one!')
    	elsif  resp == 'No existeix'
	    	@wjoin.changelabel('There is no room with such name. Please try again!')
	elsif resp.split('/')[0] == 'Ok' 
		if @roomactual == resp.split('/')[1] #per evitar que el mateix creador d'una sala pugui fer un 'join' a la mateixa sala
		
	    	else
	    		@wjoin.destroy
	    		addroom(resp.split("/")[1])
	    		@roomactual = Room.new(@rooms.length, resp.split("/")[1], @username)
	    		@rooms.store(@roomactual,t)
	    		updateMis(@roomactual.getMessage)
    		end
    	end
    end
    
    def createRoomButton
    	if @roomactual == nil
    		t = listen
    	else
    		@rooms.each do |room, thread|
    			if room.getRoomName == @roomactual.getRoomName
    				thread.kill
    				t = listen
    			end
    		end
    	end
    		create = @wc.getText
    		@server.puts("create/#{create}/name/#{@username}")
    		resp = @server.gets.chomp
	    	if resp == 'Fail'
	    		@wc.changelabel("There is a room with this name. Pleas try again with another name, thank you!")
	    	else	
	    		@wc.destroy
	    		addroom(resp)
	    		@roomactual  = Room.new(@rooms.length, create, @username)
			@rooms.store(@roomactual,t)
	    		updateMis(@roomactual.getMessage)
	    	end 
    end
end

if __FILE__ == $0
	server = TCPSocket.open("localhost", 5050)
	Client.new(server)
	#Gtk.main
end
