using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.Net.Sockets;
using System.Net;

namespace Server
{
    public partial class Server : Form
    {
        public Server()
        {
            CheckForIllegalCrossThreadCalls = false;
            InitializeComponent();
        }

        Socket server, client;
        IPEndPoint ipe;
        Thread ListenConnectThread, ClientThread;
        bool connect = true;
        NotifyIcon notifyIcon = new NotifyIcon();

        public void LayIP()
        {
            IPHostEntry host = Dns.GetHostEntry(Dns.GetHostName());
            foreach (IPAddress diachi in host.AddressList)
            {
                if (diachi.AddressFamily == AddressFamily.InterNetwork)
                {
                    cboIP.Items.Add(diachi);
                }
            }

            cboIP.SelectedIndex = 0;
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            LayIP();
            notifyIcon.Visible = true;
            notifyIcon.Icon = SystemIcons.Application;
            notifyIcon.BalloonTipIcon = ToolTipIcon.Error;
            notifyIcon.BalloonTipTitle = "Chat Server";
        }

        private void btnListen_Click(object sender, EventArgs e)
        {
            try
            {
                ipe = new IPEndPoint(IPAddress.Parse(cboIP.SelectedItem.ToString()), Convert.ToInt32(txtPort.Text));
                server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

                server.Bind(ipe);
                server.Listen(3);

                connect = true;

                ListenConnectThread = new Thread(new ThreadStart(ListenConnect));
                ListenConnectThread.IsBackground = true;
                ListenConnectThread.Start();

                ShowConnect();
            }
            catch (Exception ex)
            {
                //MessageBox.Show("Loi Listen_Click");
                notifyIcon.BalloonTipText = "Loi Listen_Click";
                notifyIcon.ShowBalloonTip(500);
            }
        }

        public void ListenConnect()
        {
            while (true)
            {
                try
                {
                    //client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                    client = server.Accept();

                    ClientThread = new Thread(ListenData);
                    ClientThread.IsBackground = true;
                    ClientThread.Start(client);

                    //txtMain.AppendText("Chap nhan ket noi tu " + client.RemoteEndPoint.ToString() + "\n");
                    txtMain.AppendText("Chap nhan ket noi\n");
                    txtMain.ScrollToCaret();

                    // huy thread lang nghe, vi chi cho 1 client den
                    //ListenConnectThread.Abort();
                }
                catch (Exception exp)
                {
                    MessageBox.Show(exp.ToString());
                    //notifyIcon.BalloonTipText = "Loi ListenConnect: MAT KET NOI";
                    //notifyIcon.ShowBalloonTip(500);
                    ListenConnectThread.Abort();
                }
            }
        }

        public void ListenData(object obj)
        {
            //Socket clientSK = (Socket)obj;
            while (true)
            {
                try
                {
                    if (client.Connected)
                    {
                        byte[] buff = new byte[1024];
                        int recv = client.Receive(buff);
                        if (recv > 0)
                        {
                            //HamGiaiMa(buff);
                            //txtMain.AppendText("Client: "+Encoding.UTF8.GetString(buff)+"\n");
                            txtMain.AppendText("Client: " + Encoding.ASCII.GetString(buff).ToString() + "\n");
                            //txtMain.AppendText("Client: " + buff.ToString() + "\n");
                            txtMain.ScrollToCaret();
                            //MessageBox.Show(recv.ToString());
                        }
                        else
                        {
                            connect = false;
                            DisposeSocket();
                            ClientThread.Abort();
                        }
                    }
                    else
                    {
                        connect = false;
                        DisposeSocket();
                        ClientThread.Abort();
                    }

                    //if (recv > 1)
                    //{
                    //    //HamGiaiMa(buff);
                    //    //txtMain.AppendText("Client: "+Encoding.UTF8.GetString(buff)+"\n");
                    //    txtMain.AppendText("Client: " + Encoding.ASCII.GetString(buff) + "\n");
                    //    txtMain.ScrollToCaret();
                    //    //MessageBox.Show(recv.ToString());
                    //}
                    //else
                    //{
                    //    connect = false;
                    //    DisposeSocket();
                    //    ClientThread.Abort();
                    //}
                }
                catch (Exception exp)
                {
                    //MessageBox.Show("Mat ket noi");
                    notifyIcon.BalloonTipText = "MAT KET NOI";
                    notifyIcon.ShowBalloonTip(500);
                    ClientThread.Abort();
                }
            }
        }

        public void HamGiaiMa(byte[] buff)
        {
            int A, B, C, D;
            Packet.Packet.EncodingPacket(out A, out B, out C, out D, buff);
            txtMain.AppendText("Mode: " + A + ",Type Control: " + B + ",Address: " + C + ",Data: " + D + "\n");
            txtMain.ScrollToCaret();
        }



        



        private void btnSend_Click(object sender, EventArgs e)
        {
            try
            {
                if (!IsConnect(server))
                {
                    MessageBox.Show("Chua ket noi");
                }
                else
                {
                    //byte A, B, C, D;
                    //A = Byte.Parse(numMode.Value.ToString());
                    //B = Byte.Parse(numTypeControl.Value.ToString());
                    //C = Byte.Parse(numAddress.Value.ToString());
                    //D = Byte.Parse(numData.Value.ToString());

                    //byte[] packet = new byte[1024];

                    //Packet.Packet.Convert4BytesToPacket(A, B, C, D, ref packet);

                    //byte[] sendMsg = Encoding.UTF8.GetBytes(txtMsg.Text);
                    byte[] sendMsg = Encoding.ASCII.GetBytes(txtMsg.Text);

                    client.Send(sendMsg);

                    //client.Send(packet);

                    txtMain.AppendText("Server: " + txtMsg.Text + "\n");
                    txtMain.ScrollToCaret();

                    Thread.Sleep(100);
                }
            }
            catch (Exception ex)
            {
                if (server.Connected)
                {
                    //MessageBox.Show("Loi Send_Click");
                    notifyIcon.BalloonTipText = "Loi Send_Click";
                    notifyIcon.ShowBalloonTip(500);
                }
                else
                {
                    //MessageBox.Show("Chua co ket noi tu Client");
                    notifyIcon.BalloonTipText = "Chua co ket noi tu Client";
                    notifyIcon.ShowBalloonTip(500);
                }
            }
        }

        public bool IsConnect(Socket sk)
        {
            bool part1 = sk.Poll(1000, SelectMode.SelectRead);
            bool part2 = (sk.Available == 0);
            if (part1 && part2)
            {
                return false;
            }
            return true;
        }

        private void btnDisconnect_Click(object sender, EventArgs e)
        {
            try
            {
                ////gửi 1 byte để xác nhận disconnect
                //byte[] buff = new byte[1];
                //buff[0] = 0;
                //client.Send(buff);

                connect = false;
                DisposeSocket();
                ListenConnectThread.Abort();
            }
            catch
            {
                connect = false;
                DisposeSocket();
                ListenConnectThread.Abort();
                //MessageBox.Show("Chua ket noi");
                notifyIcon.BalloonTipText = "Chua ket noi";
                notifyIcon.ShowBalloonTip(500);
            }
        }

        public void DisposeSocket()
        {
            try
            {
                //server.Shutdown(SocketShutdown.Both);
                server.Close();
                client.Close();
                client.Dispose();
                ipe = null;
                ShowConnect();
            }
            catch (Exception)
            {
                ShowConnect();
                ListenConnectThread.Abort();
                notifyIcon.BalloonTipText = "Chua ket noi";
                notifyIcon.ShowBalloonTip(500);                
            }
            

            //if (server.Connected)
            //{
            //    server.Shutdown(SocketShutdown.Both);
            //    server.Close();
            //    client.Close();
            //    ipe = null;
            //    ShowConnect();
            //}
            //else
            //{
            //    server.Close();
            //    client.Close();
            //    ipe = null;
            //    ShowConnect();
            //}
        }

        private void ShowConnect()
        {
            if (!connect)
            {
                btnListen.Text = "Start";
                btnListen.Enabled = true;
                btnDisconnect.Enabled = false;
                btnSend.Enabled = false;
                cboIP.Enabled = true;
                txtPort.Enabled = true;
            }
            else
            {
                btnListen.Text = "Connected";
                btnListen.Enabled = false;
                btnDisconnect.Enabled = true;
                btnSend.Enabled = true;
                cboIP.Enabled = false;
                txtPort.Enabled = false;
            }
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            txtMain.Clear();
        }
    }
}
