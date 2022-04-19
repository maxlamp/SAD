import java.net.Socket;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class MySocket extends Socket {

    private Socket socket;

    public MySocket(String host, int port) throws IOException {
        try {
            this.socket = new Socket(host, port);
            if (socket.isBound()) {
                System.out.println("Connected at port " + port);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public MySocket(Socket s) {
        this.socket = s;
    }

    public OutputStream getOutputStream() {
        try {
            return this.socket.getOutputStream();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public InputStream getInputStream() {
        try {
            return socket.getInputStream();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void close() throws IOException {
        try {
            this.socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}