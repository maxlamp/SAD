import java.io.IOException;
import java.net.ServerSocket;


public class MyServerSocket extends ServerSocket{
    
    private ServerSocket serverSocket;
    private MySocket socket;

    public MyServerSocket(int port) throws IOException{
        this.serverSocket = new ServerSocket(port); 
        System.out.println("Waiting for connection in port "+ String.valueOf(port));
    }

    public MySocket accept() throws IOException{
        try {
            this.socket = new MySocket(serverSocket.accept());
        } catch (Exception e) {
            System.out.println("Error en acceptar el socket");
            e.printStackTrace();
        }
        return this.socket;
    }

    public void close() throws IOException{
        try {
            this.serverSocket.close();
        } catch (Exception e) {
            System.out.println("Server closing connection");
            e.printStackTrace();
        }
    }
}
