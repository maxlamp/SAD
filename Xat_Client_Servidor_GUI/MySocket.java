import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.*;

public class MySocket extends Socket {
    private Socket sc;

    public MySocket(String host, int port) {

        try {
            this.sc = new Socket(host, port);
        } catch (IOException ex) {
            System.err.println(ex);
        }
    }

    public MySocket(Socket socket) {
        this.sc = socket;
    }

    public void MyConnect(SocketAddress endpoint) {

        try {
            this.sc.connect(endpoint);
        } catch (IOException ex) {
            System.err.println(ex);
        }
    }

    public InputStream MyGetInputStream() {
        try {
            return sc.getInputStream();
        } catch (IOException ex) {
            System.err.println(ex);
        }
        return null;

    }

    public OutputStream MyGetOutputStream() {

        try {
            return sc.getOutputStream();
        } catch (IOException ex) {
            System.err.println(ex);
        }
        return null;
    }

    @Override
    public void close() {
        try {
            sc.close();
        } catch (IOException ex) {
            System.err.println(ex);
        }
    }

}