import java.io.*;
import java.util.Observable;

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


public class Console extends Observer {
    
    public Line line;

    public Console(){
    }
    
    @Override
    public void update(Observable ob, Object o){
        Command com =o;
        switch(com){
            case (char) command.LEFT:
            System.out.print("\033[D");		
			break;
			case (char) command.RIGHT:
			System.out.print("\033[C");			
			break;
			case (char) command.HOME:
			System.out.print("\033[" + line.getPosition() + "D");		
			break;
			case (char) command.END:
			System.out.print("\033[" + (line.getLength() - line.getPosition()) + "C");			
			break;
			case (char) command.INS:
			System.out.print("\033[D");
			break;
			case (char) command.DEL:
			System.out.print("\033[C");
			System.out.print("\033[P");
			System.out.print("\033[D");
			break;
			case (char) command.BACKSPACE:
			System.out.print("\033[D");
			System.out.print("\033[P");
			break;
			default:
            //aixo no esta be perq aqui nomes va coses de observer
			if(line.getInsert() || line.getPosition() == line.getLength()){
                System.out.print(c);
            }else{
                System.out.print("\033[@" + c);
            }
			break;

        }

    }

}
