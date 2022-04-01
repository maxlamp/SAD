import java.io.IOException;

public class ChatServer {
   
    private MyServerSocket ss;
    private MySocket sc;

    public ChatServer(int port){
        
        this.ss = new MyServerSocket(port);
       
        while(true){
            this.sc = ss.accept();
            new Thread() {
                public void run(){
                  String line;
                  while((line=sc.readString())!=null){
                      sc.writeString(line);
                  }
                  try {
                    sc.close();
                } catch (IOException e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
                }
                
             }.start(); 
        }
    }

    //Crec que sha dafegir algun metode main
}
