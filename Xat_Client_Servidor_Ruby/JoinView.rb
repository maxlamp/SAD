require 'gtk3'
require_relative 'Client'

class JoinView<Gtk::Window

	def initialize 
	super
	#Window
	Gtk::Window.new("Join")
	set_title('Join')
	set_size_request(400,200)
	set_resizable(false)
	set_border_width(10)
	
	#Creem un box
	@hbox = Gtk::Box.new(:vertical, 3)
	@hbox.set_size_request(100,50)		
	@hbox.set_homogeneous(true)

	#Label
	@label = Gtk::Label.new('Introdueix el nom de la room on vols entrar')
	
	#TextView
	@text=Gtk::TextView.new()
	@text.set_size_request(100,10)
		
	#Creem el boto
	@button=Gtk::Button.new(label:'Send')
	@button.signal_connect('clicked') {login}
	@button.set_size_request(50,50)
	
	#Afegim tot a la box i depsres a la window
	@hbox.pack_start(@label)
	@hbox.pack_start(@text)
	
	add(@hbox)
		
	end
	def addBoto(e)
	@hbox.pack_start(e)
	end
	def changelabel(s)
	@label.set_text(s)
	show_all
	end
	def getText
		return @text.buffer.text
	end
end

if __FILE__ == $0
	
	win = JoinView.new
	win.signal_connect('destroy') { Gtk.main_quit }
	win.show_all
	Gtk.main

end
