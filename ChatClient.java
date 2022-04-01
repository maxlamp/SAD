import java.io.*;

public class ChatClient {
    
    private MySocket sc;

    public ChatClient( int port, String host){
        this.sc = MySocket(port,host);

        //Input Thread 
        new Thread() {
            public void run(){
              String line;
              try{
                while((line=sc.readString())!=null){
                    sc.writeString(line);
                }
               sc.close();
              }catch(IOException ex){
                ex.printStackTrace();
                }
    
            }
         }.start();
        //Output Thread
        new Thread() {
            public void run(){
              String line;
              while((line=sc.readString())!=null){
                  sc.writeString(line);
              }
            }
         }.start();
    }

}
