import java.io.*;
import java.util.Observable;
import java.util.ArrayList;

class keyActions{

	public static final String RIGHT = "\033[C";
	public static final String LEFT = "\033[D";
	public static final String DEL = "\033[P";
	public static final String ADD = "\033[@";
}



public class Line extends Observable{

	public ArrayList<Character> line;
	private int cursorPosition;
	private boolean insert;
	private String action;
	
	public Line(){
		this.line = new ArrayList<>();
		this.cursorPosition = 0;
		this.insert = false;
		this.action = "";
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
				this.action = "" + c;
			}else{
				this.line.add(this.cursorPosition, c);
				this.cursorPosition += 1;
				this.action = keyActions.ADD + c;
			}
		}else{
			this.line.add(this.cursorPosition, c);
			this.cursorPosition += 1;
			this.action = keyActions.ADD + c;
		}
		super.setChanged();
		super.notifyObservers(this.action);
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
			this.action = keyActions.LEFT;
			this.cursorPosition -= 1;
		}
		super.setChanged();
		super.notifyObservers(this.action);
	}
	
	public void right(){
		if(this.cursorPosition < this.line.size()){
			this.action = keyActions.RIGHT;
			this.cursorPosition += 1;
		}
		super.setChanged();
		super.notifyObservers(this.action);
	}
	
	public void home(){
		this.cursorPosition = 0;
		this.action = "\033[" + this.line.size() + "D";
		super.setChanged();
		super.notifyObservers(this.action);
	}
	
	public void end(){
		this.action = "\033[" + (this.line.size() - this.cursorPosition) + "C";
		this.cursorPosition = this.line.size();
		super.setChanged();
		super.notifyObservers(this.action);
	}
	
	public void backspace(){
		if(this.cursorPosition > 0 && this.line.size() > 0 && (this.cursorPosition <= this.line.size())){
			this.line.remove(this.cursorPosition-1);
			this.left();
			this.action = keyActions.DEL;
		}
		super.setChanged();
		super.notifyObservers(this.action);
	}
	
	public void del(){
		if(this.line.size() > 0 && (this.cursorPosition < this.line.size() - 1)){
			this.line.remove(this.cursorPosition);
			this.action = keyActions.DEL;
		}
		super.setChanged();
		super.notifyObservers(this.action);
	}
}
