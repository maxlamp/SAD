import java.io.*;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedReader;


public class contarColumnes {
	public static void main(String[] args) {
		//desde terminal es tput cols
		String[] cmd = {"/bin/sh","-c","tput cols 2> /dev/tty"};
		ProcessBuilder p = new ProcessBuilder(cmd);
		try {
			Process pr = p.start();
			BufferedReader r = new BufferedReader(new InputStreamReader(pr.getInputStream()));
			String cols = r.readLine();
			System.out.println(cols);
		
		} catch(IOException ex){
			System.out.println("Error");
		}
		
	}
}

