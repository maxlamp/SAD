import java.net.*;
import java.io.*;

public class MySocket{
    
    public Socket socket;
    BufferedReader input;
    PrintWriter output;

    public MySocket(int port, String host){
        try {
            this.socket = new Socket(host,port);
            this.input = new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
            this.output = new PrintWriter(this.socket.getOutputStream());
        } catch (Exception e) {
            System.out.println("Error al iniciar el socket");
        }
    }
    public MySocket(Socket s){
        try {
            this.socket = s;
            this.input = new BufferedReader(new InputStreamReader(this.socket.getInputStream()));
            this.output = new PrintWriter(this.socket.getOutputStream());
        } catch (Exception e) {
            System.out.println("Error al iniciar el socket");
        }
    }

    public void close() throws IOException{
       try {
         this.input.close();
         this.output.close();
         this.socket.close();
       } catch (Exception e) {
           //TODO: handle exception
       } 
    }

    public String readString(){
        String s = null;
        try {
            s = this.input.readLine();
        } catch (Exception e) {
            
        }
        return s;
    }
    public void writeString(String s){
        this.output.println(s);
    }
}