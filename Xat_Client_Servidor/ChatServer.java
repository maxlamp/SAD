import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.util.Scanner;

public class ChatServer {
    public static void main(String[] args) {
        final MySocket socket;
        final BufferedReader in;
        final PrintWriter out;
        final Scanner sc = new Scanner(System.in);

        try {
            MyServerSocket serverSocket = new MyServerSocket(5050);
            socket = serverSocket.accept();
            out = new PrintWriter(socket.getOutputStream());
            in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            Thread sender = new Thread(new Runnable() {
                String msg;

                @Override
                public void run() {
                    while (true) {
                        msg = sc.nextLine();
                        out.println(msg);
                        out.flush();
                    }
                }
            });
            sender.start();

            Thread receiver = new Thread(new Runnable() {
                String msg;

                @Override
                public void run() {
                    try {
                        msg = in.readLine();
                        while (msg != null) {
                            System.out.println("Client: " + msg);
                            msg = in.readLine();
                        }
                        System.out.println("Client disconnected");
                        sc.close();
                        socket.close();
                        serverSocket.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });

            receiver.start();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
