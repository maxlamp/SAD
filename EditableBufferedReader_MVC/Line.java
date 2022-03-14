import java.io.*;
import java.util.*;


class Line{

	public ArrayList<Character> line;
	private int cursorPosition;
	private boolean insert;
	
	public Line(){
		this.line = new ArrayList<>();
		this.cursorPosition = 0;
		this.insert = false;
	}
	
	public int getPosition(){
		return this.cursorPosition;
	}
	
	public int getLength(){
		return this.line.size();
	}
	
	public boolean getInsert(){
		return this.insert;
	}	
	
	public void insertMode(){
		this.insert = !this.insert;
	}
	
	public void addChar(char c){
		if(this.insert){
			if(this.cursorPosition < this.line.size()){
				this.line.set(this.cursorPosition, c);
				this.cursorPosition += 1;
			}else{
				this.line.add(this.cursorPosition, c);
				this.cursorPosition += 1;
			}
		}else{
			this.line.add(this.cursorPosition, c);
			this.cursorPosition += 1;
		}
	}
	public String getLine(){
		String s = "";
		for(int i = 0; i < this.getLength(); i++){
			int aux = this.line.get(i);
			s+= (char) aux;
		}
		
		return s;
	}
	
	public void left(){
		if(this.cursorPosition > 0){
			this.cursorPosition -= 1;
		}
	}
	
	public void right(){
		if(this.cursorPosition < this.line.size()){
			this.cursorPosition += 1;
		}
	}
	
	public void home(){
		this.cursorPosition = 0;
	}
	
	public void end(){
		this.cursorPosition = this.line.size();
	}
	
	public void backspace(){
		if(this.cursorPosition > 0 && this.line.size() > 0 && (this.cursorPosition <= this.line.size())){
			this.line.remove(this.cursorPosition-1);
			this.left();
		}
	}
	
	public void del(){
		if(this.line.size() > 0 && (this.cursorPosition < this.line.size() - 1)){
			this.line.remove(this.cursorPosition + 1);
		}
	}
}
