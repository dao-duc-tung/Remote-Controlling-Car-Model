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
using System.Net;
using System.Net.Sockets;
using System.Collections;

namespace Client
{
    public partial class Client : Form
    {
        char dir = '0';
        char state = '0';
        char mode = '0';

        public Client()
        {
            CheckForIllegalCrossThreadCalls = false;
            InitializeComponent();
        }

        Socket client;
        IPEndPoint ipe;
        Thread ConnectThread, ListenDataThread;
        bool connect = false;
        NotifyIcon notifyIcon = new NotifyIcon();

        private void Client_Load(object sender, EventArgs e)
        {
            notifyIcon.Visible = true;
            notifyIcon.Icon = SystemIcons.Application;
            notifyIcon.BalloonTipIcon = ToolTipIcon.Error;
            notifyIcon.BalloonTipTitle = "Chat Client";
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {
            ipe = new IPEndPoint(IPAddress.Parse(txtIPServer.Text), Convert.ToInt32(txtPort.Text));
            client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

            connect = true;

            ConnectThread = new Thread(new ThreadStart(ConnectServer));
            ConnectThread.IsBackground = true;
            ConnectThread.Start();

            ShowConnect();
        }

        public void ConnectServer()
        {
            while (true)
            {
                try
                {
                    client.Connect(ipe);

                    if (client.Connected)
                    {
                        ListenDataThread = new Thread(ListenData);
                        ListenDataThread.IsBackground = true;
                        ListenDataThread.Start(client);

                        ConnectThread.Abort();
                    }
                    else
                    {
                        continue;
                    }
                }
                catch (Exception exp)
                {
                    continue;

                    ////MessageBox.Show("Loi ConnectServer: KHONG KET NOI DUOC DEN SERVER");
                    //notifyIcon.BalloonTipText = "Loi ConnectServer: KHONG KET NOI DUOC DEN SERVER";
                    //notifyIcon.ShowBalloonTip(500);
                    //ConnectThread.Abort();
                }
            }

        }

        public void ListenData(object obj)
        {
            //Socket sk = (Socket)obj;
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
                            //txtMain.AppendText("Server: " + Encoding.UTF8.GetString(buff) + "\n");
                            txtMain.AppendText("Server: " + Encoding.ASCII.GetString(buff).ToString() + "\n");
                            txtMain.ScrollToCaret();
                        }
                        else
                        {
                            connect = false;
                            DisposeSocket();
                            ListenDataThread.Abort();
                        }
                    }
                    else
                    {
                        connect = false;
                        DisposeSocket();
                        ListenDataThread.Abort();
                    }

                    //if (recv > 1)
                    //{
                    //    //HamGiaiMa(buff);
                    //    //txtMain.AppendText("Server: " + Encoding.UTF8.GetString(buff) + "\n");
                    //    txtMain.AppendText("Server: " + Encoding.ASCII.GetString(buff) + "\n");
                    //    txtMain.ScrollToCaret();
                    //}
                    //else
                    //{
                    //    connect = false;
                    //    DisposeSocket();
                    //    ListenDataThread.Abort();
                    //}

                    //txtMain.AppendText(System.Text.Encoding.UTF8.GetString(buff));
                    //txtMain.ScrollToCaret();
                }
                catch (Exception exp)
                {
                    connect = false;
                    DisposeSocket();

                    //MessageBox.Show("Mat ket noi");
                    notifyIcon.BalloonTipText = "Mat ket noi";
                    notifyIcon.ShowBalloonTip(500);

                    ListenDataThread.Abort();
                }

            }
        }

        private void HamGiaiMa(byte[] buff)
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
                if (!IsConnect(client))
                {
                    //MessageBox.Show("Chua ket noi");
                    notifyIcon.BalloonTipText = "Chua ket noi";
                    notifyIcon.ShowBalloonTip(500);
                }
                else
                {
                    //byte A, B, C, D;
                    //A = Byte.Parse(numMode.Value.ToString());
                    //B = Byte.Parse(numTypeControl.Value.ToString());
                    //C = Byte.Parse(numAddress.Value.ToString());
                    //D = Byte.Parse(numData.Value.ToString());

                    //byte[] packet = new byte[1024];
                    //buff = System.Text.Encoding.UTF8.GetBytes(textChat);

                    //Packet.Packet.Convert4BytesToPacket(A, B, C, D, ref packet);
                    //client.Send(packet);

                    //byte[] sendMsg = Encoding.UTF8.GetBytes(txtMsg.Text);
                    byte[] sendMsg = Encoding.ASCII.GetBytes(txtMsg.Text);


                    client.Send(sendMsg);

                    txtMain.AppendText("Client: " + txtMsg.Text + "\n");
                    txtMain.ScrollToCaret();

                    lblTest.Text = sendMsg.Length.ToString();

                    Thread.Sleep(100);
                }
            }
            catch (Exception ex)
            {
                if (client.Connected)
                {
                    //MessageBox.Show("Loi Send_Click");
                    notifyIcon.BalloonTipText = "Loi Send_Click";
                    notifyIcon.ShowBalloonTip(500);
                }
                else
                {
                    //MessageBox.Show("Chua co ket noi voi Server");
                    notifyIcon.BalloonTipText = "Chua co ket noi voi Server";
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
                ConnectThread.Abort();
            }
            catch
            {
                connect = false;
                DisposeSocket();
                ConnectThread.Abort();
                //MessageBox.Show("Chua ket noi");
                notifyIcon.BalloonTipText = "Chua ket noi";
                notifyIcon.ShowBalloonTip(500);
            }
        }

        public void DisposeSocket()
        {
            try
            {
                client.Shutdown(SocketShutdown.Both);
                client.Close();
                ipe = null;
                ShowConnect();
            }
            catch (Exception)
            {
                ShowConnect();
                ConnectThread.Abort();
                notifyIcon.BalloonTipText = "Chua ket noi";
                notifyIcon.ShowBalloonTip(500);
            }


            //if (client.Connected)
            //{
            //    client.Shutdown(SocketShutdown.Both);
            //    client.Close();
            //    ipe = null;
            //    ShowConnect();
            //}
            //else
            //{
            //    client.Close();
            //    ipe = null;
            //    ShowConnect();
            //}
        }

        private void ShowConnect()
        {
            if (!connect)
            {
                btnConnect.Text = "Start";
                btnConnect.Enabled = true;
                btnDisconnect.Enabled = false;
                btnSend.Enabled = false;
                btnSendTextBox1.Enabled = false;
                btnGetIPServer.Enabled = false;
                btnMode.Enabled = false;
                txtIPServer.Enabled = true;
                txtPort.Enabled = true;
                txtMsg.Enabled = false;
                txtMsg1.Enabled = false;
            }
            else
            {
                btnConnect.Text = "Connected";
                btnConnect.Enabled = false;
                btnDisconnect.Enabled = true;
                btnSend.Enabled = true;
                btnSendTextBox1.Enabled = true;
                btnGetIPServer.Enabled = true;
                btnMode.Enabled = true;
                txtIPServer.Enabled = false;
                txtPort.Enabled = false;
                txtMsg.Enabled = true;
                txtMsg1.Enabled = true;
            }
        }

        public void SendMsg(byte[] msg)
        {
            try
            {
                if (!IsConnect(client))
                {
                    notifyIcon.BalloonTipText = "Chua ket noi";
                    notifyIcon.ShowBalloonTip(500);
                }
                else
                {
                    //char[] temp = { '1', '1' };
                    //byte[] sendMsg = Encoding.ASCII.GetBytes(temp);


                    client.Send(msg);

                    txtMain.AppendText("Client: " + Encoding.ASCII.GetString(msg) + "\n");
                    txtMain.ScrollToCaret();

                    lblTest.Text = msg.Length.ToString();

                    Thread.Sleep(100);
                }
            }
            catch (Exception ex)
            {
                //
            }
        }

        int _Up = 0, _Down = 0, _Left = 0, _Right = 0;
        private void txtMain_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Up && _Down == 0 && _Up == 0)
            {
                _Up++;
                state = '1';
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnUp.BackColor = Color.Purple;
            }
            if (e.KeyCode == Keys.Down && _Up == 0 && _Down == 0)
            {
                _Down++;
                state = '2';
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnDown.BackColor = Color.Purple;
            }
            if (e.KeyCode == Keys.Left && _Right == 0 && _Left == 0)
            {
                _Left++;
                dir = '1';
                state = (mode == '1') ? '3' : state;
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnLeft2.BackColor = Color.Purple;
            }
            if (e.KeyCode == Keys.Right && _Left == 0 && _Right == 0)
            {
                _Right++;
                dir = '2';
                state = (mode == '1') ? '4' : state;
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnRight2.BackColor = Color.Purple;
            }
        }

        private void txtMain_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Up)
            {
                _Up = 0;
                state = '0';
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnUp.BackColor = default(Color);
            }
            if (e.KeyCode == Keys.Down)
            {
                _Down = 0;
                state = '0';
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnDown.BackColor = default(Color);
            }
            if (e.KeyCode == Keys.Left)
            {
                _Left = 0;
                dir = '0';
                state = (mode == '1') ? '0' : state;
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnLeft2.BackColor = default(Color);
            }
            if (e.KeyCode == Keys.Right)
            {
                _Right = 0;
                dir = '0';
                state = (mode == '1') ? '0' : state;
                char[] temp = { mode, dir, state };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                btnRight2.BackColor = default(Color);
            }
        }

        private void btnSendTextBox1_Click(object sender, EventArgs e)
        {
            byte[] msg = new byte[3];
            msg = Encoding.ASCII.GetBytes(txtMsg1.Text);
            SendMsg(msg);
            //MessageBox.Show(Encoding.ASCII.GetString(msg));
        }

        private void btnMode_Click(object sender, EventArgs e)
        {
            if (mode == '0')
            {
                char[] temp = { mode, '0', '0' };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                mode = '1';
                btnMode.Text = "Mode 1";
            }
            else
            {
                char[] temp = { mode, '0', '0' };
                byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
                SendMsg(sendMsg);
                mode = '0';
                btnMode.Text = "Mode 0";
            }
        }

        private void btnGetIPServer_Click(object sender, EventArgs e)
        {
            char[] temp = { '2' };
            byte[] sendMsg = Encoding.ASCII.GetBytes(temp);
            SendMsg(sendMsg);
        }
    }
}
