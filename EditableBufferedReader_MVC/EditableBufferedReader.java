import java.io.*;

class command{

	public static final int ESC = 27; 	// --> ^[
	public static final int LEFT = 37; 	// --> ^[[D
	public static final int RIGHT = 39; 	// --> ^[[C
	public static final int HOME = 36; 	// --> ^[[H
	public static final int END = 35; 	// --> ^[[F
	public static final int INS = 45; 	// --> ^[[2~
	public static final int DEL = 46; 	// --> ^[[3~
	public static final int BACKSPACE = 8; 	// --> ^H
	public static final int ENTER = 13; 	// --> ^M
	
}

class EditableBufferedReader extends BufferedReader{

	private Line line;
	private Console console;

	public EditableBufferedReader(Reader in){
		super(in);
		this.console= new Cosnole();
		this.line = new Line(console);
	}
	
	public void setRaw(){
		try{
			String[] cmd = {"/bin/sh", "-c", "stty -echo raw </dev/tty"};
			Runtime.getRuntime().exec(cmd).waitFor();
		}catch (Exception e){
			System.out.println("Something went wrong");
		}
	}

	public void unsetRaw(){
		try{
			String[] cmd = {"/bin/sh", "-c", "stty echo cooked </dev/tty"};
			Runtime.getRuntime().exec(cmd).waitFor();
		}catch (Exception e){
			System.out.println("Something went wrong");
		}
	}
	
	@Override
	public int read() throws IOException{
		int character;
		if((character = super.read()) != command.ESC){
			return character;
		}
		
		switch(character = super.read()){
			case '[':
				switch (character = super.read()){
					case 'D':
						return character = command.LEFT;
					case 'C':
						return character = command.RIGHT;
					case 'H':
						return character = command.HOME;
					case 'F':
						return character = command.END;
					case '2':
						if((character = super.read()) == '~'){
							return character = command.INS;
						}else{
							return character = '2';
						}
					case '3':
						if((character = super.read()) == '~'){
							return character = command.DEL;
						}else{
							return character = '3';
						}
					default:
						return character;
				} 		
		
		}
		return character;
	}
	
	@Override
	public String readLine() throws IOException{
		char character;
		try{
			this.setRaw();
			while((character =  (char) this.read()) != command.ENTER){
				switch(character){
					case (char) command.LEFT:
						//updateViewLeftArrow(line);
						this.line.left();
						break;
					case (char) command.RIGHT:
						//updateViewRightArrow(line);
						this.line.right();
						break;
					case (char) command.HOME:
						//updateViewHomeKey(line);
						this.line.home();
						break;
					case (char) command.END:
						//updateViewEndKey(line);
						this.line.end();
						break;
					case (char) command.INS:
						this.line.insertMode();
						break;
					case (char) command.DEL:
						//updateViewDelKey(line);
						this.line.del();
						break;
					case (char) command.BACKSPACE:
						//updateViewBackspaceKey(line);
						this.line.backspace();
						break;
					default:
						this.line.addChar(character);
						//updateViewAddChar(line, character);
						break;
						
				}
			}
		this.unsetRaw();
		}catch (IOException e){
			e.printStackTrace();
		}
		return this.line.getLine();
		
	}
	/*
	public void updateViewLeftArrow(Line line){
		if(line.getPosition() > 0){
			System.out.print("\033[D");
		}
	}
	
	public void updateViewRightArrow(Line line){
		if(line.getPosition() < line.getLength()){
			System.out.print("\033[C");
		}
	}
	
	public void updateViewHomeKey(Line line){
		System.out.print("\033[" + line.getPosition() + "D");
	}
	
	public void updateViewEndKey(Line line){
		System.out.print("\033[" + (line.getLength() - line.getPosition()) + "C");
	}
	
	public void updateViewInsertKey(Line line){
		if(line.getPosition() > 0){
			System.out.print("\033[D");	
		}
	}
	
	public void updateViewDelKey(Line line){
		if(line.getLength() > 0 && (line.getPosition() < line.getLength() - 1)){
			System.out.print("\033[C");
			System.out.print("\033[P");
			System.out.print("\033[D");
		}
	}
	
	public void updateViewBackspaceKey(Line line){
		if(line.getPosition() > 0 && line.getLength() > 0 && (line.getPosition() <= line.getLength())){
			System.out.print("\033[D");
			System.out.print("\033[P");
		}
	}
	
	public void updateViewAddChar(Line line, char c){
		if(line.getInsert() || line.getPosition() == line.getLength()){
			System.out.print(c);
		}else{
			System.out.print("\033[@" + c);
		}
	}*/
}
