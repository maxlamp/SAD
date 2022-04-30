require 'gtk3'

class ClientGUI < Gtk::Window

	def initialize 
		super
		#Window
		Gtk::Window.new("Usuaris")
		set_title('Ruby chat interface')
		set_size_request(800,400)
		set_default_size(800,400)
		set_resizable(false)
		set_border_width(10)
		set_default_geometry(800,400)
		
		#Creem un grid
		@grid=Gtk::Grid.new
		@grid.set_column_homogeneous(true)
		@grid.set_row_homogeneous(true)
		@grid.set_row_spacing(10)
		@grid.set_column_spacing(10)
	
		#TextView de moment label
		@msgs=Gtk::Label.new()
		@msgs.set_size_request(200,370)
		#@msgs.set_editable(false)
		#@msgs.set_cursor_visible(false)
		@grid.attach(@msgs,2,0,3,4)
	
		#TextView
		@text=Gtk::TextView.new()
		@text.set_size_request(20,10)
		@grid.attach(@text,0,4,4,1)	
			

		#List de buttons
		@list=Gtk::ListBox.new
		@list.set_size_request(200,370)
		@grid.attach(@list,0,1,2,3)
		
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
	
end

if __FILE__ == $0
	
	win = ClientGUI.new
	win.signal_connect('destroy') { Gtk.main_quit }
	win.show_all
	Gtk.main

end
