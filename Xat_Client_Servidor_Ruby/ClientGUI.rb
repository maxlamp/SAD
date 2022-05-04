require 'gtk3'

class ClientGUI < Gtk::Window

	def initialize 
		super
		#css
		
		css = Gtk::CssProvider.new
		style_prov = Gtk::StyleProvider::PRIORITY_USER
		css.load_from_path('./css.css')
	
		#Window
		Gtk::Window.new("Usuaris")
		set_title('Ruby chat interface')
		set_size_request(800,400)
		set_default_size(800,400)
		set_resizable(false)
		set_border_width(10)
		set_default_geometry(800,400)
		style_context.add_provider(css,style_prov)
		
		#Creem un grid
		@grid=Gtk::Grid.new
		@grid.set_column_homogeneous(true)
		@grid.set_row_homogeneous(true)
		@grid.set_row_spacing(10)
		@grid.set_column_spacing(10)
	
		#Label
		@msgs=Gtk::Label.new()
		@msgs.set_size_request(200,370)
		@msgs.set_xalign(0.1)
		@msgs.set_yalign(0.1)
		@msgs.style_context.add_provider(css,style_prov)
		@grid.attach(@msgs,2,0,3,4)
	
		#TextView
		@text=Gtk::TextView.new()
		@text.set_size_request(20,10)
		@text.style_context.add_provider(css,style_prov)
		@grid.attach(@text,0,4,4,1)	
			

		#List de buttons
		@list=Gtk::ListBox.new
		@list.set_size_request(200,370)
		@list.style_context.add_provider(css,style_prov)
		@grid.attach(@list,0,1,2,3)
		
		#Notificaions
		#@notifi = Gtk::Label.new('hola')
		#@notifi.style_context.add_provider(css,style_prov)
		#@grid.attach(@notifi,0,2,1,1)
		
		
		add(@grid)
	end
	
	def addButtonSend(b)
		@grid.attach(b,4,4,1,1)	
	end
	
	def addButtonJoin(b)
		@grid.attach(b,0,0,1,1)
	end
	
	def addButtonCreate(b)
		@grid.attach(b,1,0,1,1)
	end
	
	def addListRooms(b,i)
		@list.insert(b,i)
		show_all
	end
	
	def getText
		return @text.buffer.text
	end
	
	def borrar
		@text.buffer.delete(@text.buffer.start_iter,@text.buffer.end_iter)
	end
	
	def setText(s) 
		@msgs.set_text(s)
	end
	def remove (a)
		@list.remove(a)
		show_all
	end

end

if __FILE__ == $0
	
	win = ClientGUI.new
	win.signal_connect('destroy') { Gtk.main_quit }
	win.show_all
	Gtk.main

end
