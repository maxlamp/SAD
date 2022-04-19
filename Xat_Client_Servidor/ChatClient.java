import java.io.*;
import java.util.Scanner;

public class ChatClient {
  public static void main(String[] args) {
    final MySocket socket;
    final BufferedReader in;
    final PrintWriter out;
    final Scanner sc = new Scanner(System.in);
    try {
      socket = new MySocket("localhost", 5050);
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
              System.out.println("Server: " + msg);
              msg = in.readLine();
            }
            System.out.println("Server out of service");
            out.close();
            socket.close();
            sc.close();
          } catch (IOException e) {
            e.printStackTrace();
          }
        }

      });

      receiver.start();
      System.out.println("//CLIENT JOINED//");
    } catch (IOException e) {
      e.printStackTrace();
    }
  }
}
