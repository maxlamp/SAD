require 'gtk3'
require_relative 'Client'

class JoinView < Gtk::Window

	def initialize 
		super
		#css
		css = Gtk::CssProvider.new
		style_prov = Gtk::StyleProvider::PRIORITY_USER
		css.load_from_path('./css.css')
		
		#Window
		Gtk::Window.new("Join")
		set_title('Join')
		set_size_request(400,200)
		set_resizable(false)
		set_border_width(10)
		style_context.add_provider(css,style_prov)
		
		#Creem un box
		@hbox = Gtk::Box.new(:vertical, 3)
		@hbox.set_size_request(100,50)		
		@hbox.set_homogeneous(true)

		#Label
		@label = Gtk::Label.new('Introduce the name of the room that you want to join')
		@label.style_context.add_provider(css,style_prov)
		
		#TextView
		@text=Gtk::TextView.new()
		@text.set_size_request(100,10)
		@text.style_context.add_provider(css,style_prov)
		
		#Creem el boto
		@button=Gtk::Button.new(label:'Join')
		@button.signal_connect('clicked') {login}
		@button.set_size_request(50,50)
		@button.style_context.add_provider(css,style_prov)

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
