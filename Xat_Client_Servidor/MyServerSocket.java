import java.io.IOException;
import java.net.ServerSocket;


public class MyServerSocket extends ServerSocket{
    
    private ServerSocket serverSocket;
    private int port;

    public MyServerSocket(int port) throws IOException{
        this.port = port;
        try {
           serverSocket = new ServerSocket(port); 
           System.out.println("Waiting for connection in port "+ String.valueOf(port));
        } catch (IOException e) {
            System.out.println("Error while trying to connect");
            e.printStackTrace();
        }
    }

    public MySocket accept() throws IOException{
        MySocket s = null;
        try {
            s = (MySocket) serverSocket.accept();
            System.out.println("Connection established at port " +String.valueOf(this.port));
        } catch (IOException e) {
            System.out.println("Error en acceptar el socket");
            e.printStackTrace();
        }
        return s;
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
