#$LOAD_PATH << '.'

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
        @i=0
        @rooms = Hash.new
        #@co[:rooms] = @rooms
        #@request = nil #definim aquesta variable per tal de poder rebre missatges
        #@response = nil #definim aquesta variable per tal de poder enviar missatges
        finestraLog

    end

    def send
        @request = Thread.new do	
            	@msg = @win2.getText
            	@roomactual.addMessage(@username,@msg)
            	@win2.setText(@roomactual.getMessage)
            	updateMis(@roomactual.getRoomName)
        	@server.puts('room/#{@roomactual}/name/#{@username}/#{@msg}')
               @win2.borrar
               puts @msg
               @msg = nil     	
        end 
        
    end

    def listen
        @response = Thread.new do
            loop {
                msg = @server.gets.chomp
                if msg != nil
                
                	if msg.split('/')[0]=='room'
                	
                	@rooms.each do room
		        	if msg.split('/')[1]==room
	   				room.addMessage(msg.split('/')[3],msg.split('/')[4])
	   				if room == @roomactual
	   				updateViewMis
	   				else
	   				updateViewRooms
	   				end
		        	end
                	end
			               
                	puts "#{msg}"
         		end
                end 
            }
        end
    end
    
    def login
    
    	msg=@win.getText
    	@server.puts("login/#{msg}")
    	resp=@server.gets.chomp
	    	
	    	if resp == 'Usuari disponible'
		    	@username=msg	
			puts msg
			@win.destroy
			finestraUsr
			listen
			@response.join    	
	    	else
	    		@win.changelabel
	    	end
	
    end 
    
    def finestraLog
    	@win=CLoginView.new
    	@button=Gtk::Button.new(label:'Login')
	@button.signal_connect('clicked') {login}
	@button.set_size_request(10,10)
	@win.addThing(@button)
        @win.signal_connect('destroy') { Gtk.main_quit }
        @win.show_all
        Gtk.main
    end
    def finestraUsr
    
    	@win2 = ClientGUI.new
    	@button=Gtk::Button.new(label:'Send')
	@button.signal_connect('clicked') {enviar}
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
	
	@win2.signal_connect('destroy') { Gtk.main_quit }
	
	@win2.show_all
	Gtk.main

    end
    def updateRooms
    
    end
    def updateMis(s)
    @rooms.each do room
	if room.getRoomName==s
	@win2.setText(room.getMessage)	  
    	end
    end
    end
    def joinroom
   
    	@wjoin = JoinView.new
    	@bjoin = Gtk::Button.new(label: 'Join')
    	@bjoin.signal_connect('clicked') {joinforbutton}
    	@wjoin.addBoto(@bjoin)
    	@wjoin.signal_connect('destroy') {Gtk.main_quit}
    	@wjoin.show_all
    	Gtk.main
    	
    end
    def createroom
    	@wc = CreateView.new
    	@bc = Gtk::Button.new(label: 'Create')
    	@bc.signal_connect('clicked') {createforbutton}
    	@wc.addBoto(@bc)
    	@wc.signal_connect('destroy') {Gtk.main_quit}
    	@wc.show_all
    	Gtk.main
    end
    def addroom(r)
    	s=r.getRoomName
   	@b= Gtk::Button.new(label: s)
   	@b.signal_connect('clicked') {updateMis(s)}
   	@win2.addListRooms(@b,@i)
	@i=@i+1;
    end
   
    def enviar
    	send
  	@request.join
  	@request.exit
    end
    
    def joinforbutton
    		join=@wjoin.getText
    		@server.puts("join/#{join}/name/#{@username}")
    		resp=@server.gets.chomp
	    	if resp =='No rooms'
	    	@wjoin.changelabel('Encara no hi ha cap room, crean una')
	    	elsif  resp == 'No existeix'
	    	@wjoin.changelabel('Aquesta room no existeix')
	    	elsif resp.split('/')[0] == 'Ok'
	    	@wjoin.destroy
	    	room = Room.new(@rooms.length, join, resp.split('/')[1])
	    	addroom(room)
	    	end 
    
    end
    def createforbutton
    		create=@wc.getText
    		@server.puts("create/#{create}/name/#{@username}")
    		resp=@server.gets.chomp
	    	if resp =='Ok'
	    	@wc.destroy
	    	room = Room.new(@rooms.length, create, @username)
	    	addroom(room)
	    	@roomactual=room
	    	end 
    end
    
end

if __FILE__ == $0

	server = TCPSocket.open("localhost", 5050)
	Client.new(server)
end
