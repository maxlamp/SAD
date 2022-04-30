require 'gtk3'
require_relative 'Client'

class CLoginView<Gtk::Window

	def initialize 
	super
	#Window
	Gtk::Window.new("Usuaris")
	set_title('Client')
	set_size_request(800,400)
	set_resizable(false)
	set_border_width(10)
	
	#Creem un box
	@hbox = Gtk::Box.new(:vertical, 3)
	@hbox.set_size_request(100,50)		
	@hbox.set_homogeneous(true)

	#Label
	@label = Gtk::Label.new('Introdueix el nom dusuari')
	
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
	#@hbox.pack_start(@button)
	add(@hbox)
		
	end
	
	def changelabel
		@label.set_text('Lusuari no esta disponible, proba un altre usuari')
		show_all
	end
	
	def getText
		return @text.buffer.text
	end
	def addThing(b)
		 @hbox.pack_start(b)
	end

end

if __FILE__ == $0
	
	win = CLoginView.new
	win.signal_connect('destroy') { Gtk.main_quit }
	win.show_all
	Gtk.main

end
