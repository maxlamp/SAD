import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.net.InetSocketAddress;
import java.nio.channels.Selector;
import java.nio.channels.SelectionKey;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;

class NIOServer implements Runnable {
    final Selector selector;
    final static int PORT = 3000;
    final ServerSocketChannel SSChannel;
    HashMap<String, ServerHandler> usersMap;

    NIOServer(int port) throws IOException {
        selector = Selector.open();
        SSChannel = ServerSocketChannel.open();
        SSChannel.socket().bind(new InetSocketAddress(port));
        SSChannel.configureBlocking(false);
        SelectionKey selkey = SSChannel.register(selector, SelectionKey.OP_ACCEPT);
        selkey.attach(new Acceptor());
        usersMap = new HashMap<String, ServerHandler>();
    }

    public static void main(String[] args) {
        try {
            new Thread(new NIOServer(PORT)).start();
            System.out.println("SERVER RUNNING ON PORT: " + PORT);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public void run() {
        try {
            while (!Thread.interrupted()) {
                selector.select();
                Iterator<SelectionKey> iterator = selector.selectedKeys().iterator();
                while (iterator.hasNext()) {
                    SelectionKey selkey = (SelectionKey) iterator.next();
                    iterator.remove();
                    Runnable runnable = (Runnable) selkey.attachment();
                    if (runnable != null)
                        runnable.run();
                }
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    class Acceptor implements Runnable {
        public void run() {
            try {
                int numBytes = 0;
                SocketChannel channel = SSChannel.accept();
                ByteBuffer readBuff = ByteBuffer.allocate(1024);
                numBytes = channel.read(readBuff);
                if (channel != null && numBytes != -1) {
                    byte[] bytes;
                    readBuff.flip();
                    bytes = new byte[readBuff.remaining()];
                    readBuff.get(bytes, 0, bytes.length);
                    System.out.println(bytes);

                    String nickName = (new String(bytes, Charset.forName("ISO-8859-1"))).trim();
                    String hasNick = (!usersMap.containsKey(nickName) ? "true" : "false");

                    if (hasNick == "true") {
                        System.out.println(channel.toString() + ": Nick assigned = " + nickName);
                        usersMap.put(nickName, new ServerHandler(selector, channel, nickName, usersMap));
                        System.out.println("Welcome " + nickName + "!!");
                        String nickNames = usersMap.keySet().toString();
                        nickNames = nickNames.replace("[", "");
                        nickNames = nickNames.replace("]", "");
                        nickNames = nickNames.replace(", ", "-");
                        String nickList = nickNames;
                        usersMap.forEach((k, v) -> {
                            try {
                                v.channel
                                        .write(ByteBuffer.wrap(("user " + nickName + " joined the chat\n").getBytes()));
                                v.channel.write(ByteBuffer.wrap(("updateUser-" + nickList + "\n").getBytes()));
                            } catch (IOException ex) {
                                ex.printStackTrace();
                            }
                        });
                    } else {
                        channel.close();
                    }

                } else {
                    channel.close();
                }

            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}