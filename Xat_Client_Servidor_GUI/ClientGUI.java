import java.awt.Color;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.*;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStreamReader;

public class ClientGUI extends JFrame {
    public JFrame monguer = this;
    public static final int SERVER_PORT = 3000;
    public static final String SERVER_HOST = "localhost";
    public static String userName, lastLine = "initial";
    public static MySocket sc = new MySocket(SERVER_HOST, SERVER_PORT);
    public static JTextArea textRX, usersConnected;
    public static PrintWriter out = new PrintWriter(sc.MyGetOutputStream(), true);

    public ClientGUI() {
        initComponents();
        ClientGUI.RXthread reader = new RXthread();
        ClientGUI.userClose updater = new userClose();
        reader.execute();
        updater.execute();

    }

    class userClose extends SwingWorker<String, Object> {

        @Override
        protected String doInBackground() throws Exception {
            monguer.addWindowListener(new WindowAdapter() {
                @Override
                public void windowClosing(WindowEvent e) {
                    sc.close();
                    System.out.println("TANCANT CONNEXIÓ");
                    System.exit(0);
                }
            });
            return null;

        }

    }

    class RXthread extends SwingWorker<String, Object> {

        @Override
        protected String doInBackground() throws Exception {
            BufferedReader in = new BufferedReader(new InputStreamReader(sc.MyGetInputStream()));
            String msg;

            while ((msg = in.readLine()) != null) {
                System.out.println("User " + userName);
                System.out.println("lastLine " + lastLine);
                System.out.println("missatge" + msg);
                if (msg.contains(lastLine) && msg.contains("user")) {
                    userName = lastLine;
                    System.out.println("nickmsg");
                    String[] temp1 = msg.split("user ");
                    String[] temp2 = temp1[1].split(" joined");
                    System.out.println(temp2[0] + " : " + userName);
                    if (!temp2[0].equals(userName)) {
                        textRX.append(msg + "\n");
                    } else {
                        textRX.append("Hello user " + userName + " start Xating!" + "\n");
                    }

                } else if (msg.contains("updateUser")) {
                    String[] temp;
                    temp = msg.split("-");
                    usersConnected.setText("USERS:\n");
                    for (int i = 1; i < temp.length; i++) {
                        if (!temp[i].equals(userName)) {
                            usersConnected.append("- " + temp[i] + "\n");
                        } else {
                            usersConnected.append("-Me: " + temp[i] + "\n");
                        }
                    }
                } else {
                    System.out.println("msg");
                    textRX.append(msg + "\n");
                }
            }
            return msg;
        }

    }

    private void initComponents() {

        titleTextLabel = new javax.swing.JLabel();
        titleTextLabel.setText("WORLDWIDE XAT");

        textTX = new javax.swing.JTextField();
        textRX = new javax.swing.JTextArea();
        textRX.setText("Enter your username: ");
        textRX.setLineWrap(true);
        textRX.setWrapStyleWord(true);
        textRX.setEditable(false);
        textRX.setColumns(20);
        textRX.setRows(5);

        jScrollPane2 = new javax.swing.JScrollPane();
        jScrollPane2.setViewportView(textRX);

        usersConnected = new javax.swing.JTextArea();
        usersConnected.setLineWrap(true);
        usersConnected.setWrapStyleWord(true);
        usersConnected.setEditable(false);
        usersConnected.setText("USERS:\n");
        usersConnected.setForeground(Color.BLUE);
        usersConnected.setColumns(20);
        usersConnected.setRows(5);

        sendButton = new javax.swing.JButton();
        sendButton.setText("Send");
        sendButton.setForeground(Color.BLUE);
        sendButton.addActionListener((java.awt.event.ActionEvent evt) -> {
            sendButtonActionPerformed(evt, out);
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addGroup(layout.createSequentialGroup()
                                                .addGap(192, 192, 192)
                                                .addComponent(titleTextLabel, javax.swing.GroupLayout.PREFERRED_SIZE,
                                                        60, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addGroup(layout.createSequentialGroup()
                                                .addGap(18, 18, 18)
                                                .addComponent(usersConnected, javax.swing.GroupLayout.PREFERRED_SIZE,
                                                        200, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addGap(5, 5, 5)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addGroup(layout.createSequentialGroup()
                                                .addComponent(textTX, javax.swing.GroupLayout.PREFERRED_SIZE, 195,
                                                        javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                                .addComponent(sendButton, javax.swing.GroupLayout.PREFERRED_SIZE, 75,
                                                        javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 275,
                                                javax.swing.GroupLayout.PREFERRED_SIZE))

                                .addContainerGap(19, Short.MAX_VALUE)));
        layout.setVerticalGroup(
                layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addGap(7, 7, 7)
                                .addComponent(titleTextLabel)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addGroup(layout.createSequentialGroup()
                                                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 300,
                                                        Short.MAX_VALUE)
                                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                                .addGroup(layout
                                                        .createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                                        .addComponent(textTX, javax.swing.GroupLayout.PREFERRED_SIZE,
                                                                javax.swing.GroupLayout.DEFAULT_SIZE,
                                                                javax.swing.GroupLayout.PREFERRED_SIZE)
                                                        .addComponent(sendButton)))
                                        .addGroup(layout.createSequentialGroup()
                                                .addComponent(usersConnected, javax.swing.GroupLayout.PREFERRED_SIZE,
                                                        300, javax.swing.GroupLayout.PREFERRED_SIZE)
                                                .addGap(0, 0, Short.MAX_VALUE)))
                                .addContainerGap()));
        pack();
    }

    private void sendButtonActionPerformed(java.awt.event.ActionEvent evt, PrintWriter out) {
        String textToSend = textTX.getText();
        lastLine = textToSend;
        textTX.setText("");
        out.print(textToSend + "\n");
        out.flush();

        if (userName != null) {
            textRX.append("-" + userName + ": " + textToSend + "\n");
        } else
            textRX.append(textToSend + "\n");
    }

    public static void main(String args[]) {

        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(ClientGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ClientGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ClientGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ClientGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }

        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ClientGUI().setVisible(true);
            }
        });
    }

    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JButton sendButton;
    private javax.swing.JTextField textTX;
    private javax.swing.JLabel titleTextLabel;
}