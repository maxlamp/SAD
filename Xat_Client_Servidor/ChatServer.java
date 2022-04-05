import java.io.IOException;
import java.util.Scanner;

public class ChatServer {
    public static void main(String[] args){
        final MyServerSocket serverSocket;
        final MySocket socket;
        final Scanner sc = new Scanner(System.in);
        
        try{
            serverSocket = new MyServerSocket(5000);
            socket = serverSocket.accept();
                
            Thread sender = new Thread(new Runnable() {
                String msg;
                
                @Override
                public void run(){
                    while(true){
                        msg = sc.nextLine();
                        socket.writeString(msg);
                        socket.flush();
                    }
                }
                
            });
            sender.start();

            Thread receiver = new Thread( new Runnable() {
                String msg;

                @Override
                public void run(){
                    try{
                        msg = socket.readString();
                        while(msg != null){
                            System.out.println("Client: "+msg);
                            msg = socket.readString();
                        }
                        System.out.println("Client disconnected");
                        sc.close();
                        serverSocket.close();
                    }catch(IOException e){
                        e.printStackTrace();
                    }
                }
            });
            receiver.start();
             
        }catch(IOException e){
            e.printStackTrace();        
        }
    }

}
