import java.net.Socket;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.IOException;

public class MySocket extends Socket{

    private Socket socket;
    private BufferedReader input;
    private PrintWriter output;
    
    public MySocket(String host, int port) throws IOException{
        try {
            socket = new Socket(host,port);
            input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            output = new PrintWriter(socket.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public MySocket(Socket s) throws IOException{
        try {
            socket = s;
            input = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            output = new PrintWriter(socket.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void close() throws IOException{
       try {
         this.input.close();
         this.output.close();
         this.socket.close();
       } catch (IOException e) {
           e.printStackTrace();
       } 
    }

    public String readString() throws IOException{
        String s = null;
        try {
            s = this.input.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return s;
    }
    public void writeString(String s){
        this.output.println(s);
    }

    public void flush(){
        this.output.flush();
    }
}