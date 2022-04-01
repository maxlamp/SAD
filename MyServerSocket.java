import java.net.*;


public class MyServerSocket {
    
    ServerSocket socket;

    public MyServerSocket(int port){
        
        try {
           this.socket = new ServerSocket(port); 
        } catch (Exception e) {
            //TODO: handle exception
        }
    }

    public MySocket accept(){
        MySocket s = null;
        try {
            Socket sc = socket.accept();
            s = MySocket(sc);
        } catch (Exception e) {
           System.out.println("Error en acceptar el socket");
        }
        return s;
    }
    public void close(){
        try {
            this.socket.close();
        } catch (Exception e) {
            //TODO: handle exception
        }
    }
}
