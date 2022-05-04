require 'gtk3'
require_relative 'Client'

class CLoginView < Gtk::Window

	def initialize 
		super
		
		#css
		css = Gtk::CssProvider.new
		style_prov = Gtk::StyleProvider::PRIORITY_USER
		css.load_from_path('./css.css')
		
		#Window
		Gtk::Window.new("Users")
		set_title('Client')
		set_size_request(800,400)
		set_resizable(false)
		set_border_width(10)
		style_context.add_provider(css,style_prov)
		
		#Creem un box
		@hbox = Gtk::Box.new(:vertical, 3)
		@hbox.set_size_request(100,50)		
		@hbox.set_homogeneous(true)

		#Label
		@label = Gtk::Label.new("Introduce your username")
		@label.style_context.add_provider(css,style_prov)
		
		#TextView
		@text=Gtk::TextView.new()
		@text.set_size_request(100,10)
		@text.style_context.add_provider(css,style_prov)
		
		#Creem el boto
		@button=Gtk::Button.new(label:'Send')
		@button.signal_connect('clicked') {login}
		@button.set_size_request(50,50)
		@button.style_context.add_provider(css,style_prov)
		
		#Afegim tot a la box i depsres a la window
		@hbox.pack_start(@label)
		@hbox.pack_start(@text)
		#@hbox.pack_start(@button)
		add(@hbox)
		
	end
	
	def changelabel
		@label.set_text('This user is not available. Please try again with another username')
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
