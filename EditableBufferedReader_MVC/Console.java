import java.util.Observer;
import java.util.Observable;

public class Console implements Observer{
	
	@Override
	public void update(Observable o, Object arg){
		String action = (String) arg;
		
		if(action != "true" && o != null){
			System.out.print(action);
		}
	}
}
