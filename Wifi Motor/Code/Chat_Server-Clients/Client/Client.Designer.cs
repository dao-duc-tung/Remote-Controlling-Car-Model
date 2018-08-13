namespace Client
{
    partial class Client
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Client));
            this.label1 = new System.Windows.Forms.Label();
            this.txtIPServer = new System.Windows.Forms.TextBox();
            this.btnConnect = new System.Windows.Forms.Button();
            this.txtMain = new System.Windows.Forms.TextBox();
            this.btnSend = new System.Windows.Forms.Button();
            this.btnDisconnect = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.txtPort = new System.Windows.Forms.TextBox();
            this.txtMsg = new System.Windows.Forms.TextBox();
            this.lblTest = new System.Windows.Forms.Label();
            this.btnUp = new System.Windows.Forms.Button();
            this.btnDown = new System.Windows.Forms.Button();
            this.btnLeft2 = new System.Windows.Forms.Button();
            this.btnRight2 = new System.Windows.Forms.Button();
            this.txtMsg1 = new System.Windows.Forms.TextBox();
            this.btnSendTextBox1 = new System.Windows.Forms.Button();
            this.btnMode = new System.Windows.Forms.Button();
            this.btnGetIPServer = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 13);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(51, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "IP Server";
            // 
            // txtIPServer
            // 
            this.txtIPServer.Location = new System.Drawing.Point(70, 10);
            this.txtIPServer.Name = "txtIPServer";
            this.txtIPServer.Size = new System.Drawing.Size(90, 20);
            this.txtIPServer.TabIndex = 1;
            this.txtIPServer.Text = "192.168.4.1";
            // 
            // btnConnect
            // 
            this.btnConnect.Location = new System.Drawing.Point(375, 181);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(75, 23);
            this.btnConnect.TabIndex = 2;
            this.btnConnect.Text = "Connect";
            this.btnConnect.UseVisualStyleBackColor = true;
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // txtMain
            // 
            this.txtMain.Location = new System.Drawing.Point(16, 36);
            this.txtMain.Multiline = true;
            this.txtMain.Name = "txtMain";
            this.txtMain.Size = new System.Drawing.Size(272, 170);
            this.txtMain.TabIndex = 3;
            this.txtMain.KeyDown += new System.Windows.Forms.KeyEventHandler(this.txtMain_KeyDown);
            this.txtMain.KeyUp += new System.Windows.Forms.KeyEventHandler(this.txtMain_KeyUp);
            // 
            // btnSend
            // 
            this.btnSend.Enabled = false;
            this.btnSend.Location = new System.Drawing.Point(294, 210);
            this.btnSend.Name = "btnSend";
            this.btnSend.Size = new System.Drawing.Size(75, 40);
            this.btnSend.TabIndex = 5;
            this.btnSend.Text = "Send";
            this.btnSend.UseVisualStyleBackColor = true;
            this.btnSend.Click += new System.EventHandler(this.btnSend_Click);
            // 
            // btnDisconnect
            // 
            this.btnDisconnect.Enabled = false;
            this.btnDisconnect.Location = new System.Drawing.Point(294, 181);
            this.btnDisconnect.Name = "btnDisconnect";
            this.btnDisconnect.Size = new System.Drawing.Size(75, 23);
            this.btnDisconnect.TabIndex = 10;
            this.btnDisconnect.Text = "Disconnect";
            this.btnDisconnect.UseVisualStyleBackColor = true;
            this.btnDisconnect.Click += new System.EventHandler(this.btnDisconnect_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(166, 13);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(26, 13);
            this.label2.TabIndex = 11;
            this.label2.Text = "Port";
            // 
            // txtPort
            // 
            this.txtPort.Location = new System.Drawing.Point(198, 9);
            this.txtPort.Name = "txtPort";
            this.txtPort.Size = new System.Drawing.Size(90, 20);
            this.txtPort.TabIndex = 2;
            this.txtPort.Text = "80";
            // 
            // txtMsg
            // 
            this.txtMsg.Enabled = false;
            this.txtMsg.Location = new System.Drawing.Point(16, 212);
            this.txtMsg.Multiline = true;
            this.txtMsg.Name = "txtMsg";
            this.txtMsg.Size = new System.Drawing.Size(272, 38);
            this.txtMsg.TabIndex = 22;
            // 
            // lblTest
            // 
            this.lblTest.AutoSize = true;
            this.lblTest.Location = new System.Drawing.Point(375, 212);
            this.lblTest.Name = "lblTest";
            this.lblTest.Size = new System.Drawing.Size(28, 13);
            this.lblTest.TabIndex = 23;
            this.lblTest.Text = "Test";
            // 
            // btnUp
            // 
            this.btnUp.Location = new System.Drawing.Point(345, 5);
            this.btnUp.Name = "btnUp";
            this.btnUp.Size = new System.Drawing.Size(46, 23);
            this.btnUp.TabIndex = 28;
            this.btnUp.Text = "Up";
            this.btnUp.UseVisualStyleBackColor = true;
            // 
            // btnDown
            // 
            this.btnDown.Location = new System.Drawing.Point(345, 34);
            this.btnDown.Name = "btnDown";
            this.btnDown.Size = new System.Drawing.Size(46, 23);
            this.btnDown.TabIndex = 29;
            this.btnDown.Text = "Down";
            this.btnDown.UseVisualStyleBackColor = true;
            // 
            // btnLeft2
            // 
            this.btnLeft2.Location = new System.Drawing.Point(294, 34);
            this.btnLeft2.Name = "btnLeft2";
            this.btnLeft2.Size = new System.Drawing.Size(41, 23);
            this.btnLeft2.TabIndex = 30;
            this.btnLeft2.Text = "Left";
            this.btnLeft2.UseVisualStyleBackColor = true;
            // 
            // btnRight2
            // 
            this.btnRight2.Location = new System.Drawing.Point(400, 34);
            this.btnRight2.Name = "btnRight2";
            this.btnRight2.Size = new System.Drawing.Size(50, 23);
            this.btnRight2.TabIndex = 31;
            this.btnRight2.Text = "Right";
            this.btnRight2.UseVisualStyleBackColor = true;
            // 
            // txtMsg1
            // 
            this.txtMsg1.Enabled = false;
            this.txtMsg1.Location = new System.Drawing.Point(294, 155);
            this.txtMsg1.Name = "txtMsg1";
            this.txtMsg1.Size = new System.Drawing.Size(75, 20);
            this.txtMsg1.TabIndex = 32;
            this.txtMsg1.Text = "400";
            // 
            // btnSendTextBox1
            // 
            this.btnSendTextBox1.Enabled = false;
            this.btnSendTextBox1.Location = new System.Drawing.Point(375, 153);
            this.btnSendTextBox1.Name = "btnSendTextBox1";
            this.btnSendTextBox1.Size = new System.Drawing.Size(75, 23);
            this.btnSendTextBox1.TabIndex = 33;
            this.btnSendTextBox1.Text = "Send txt1";
            this.btnSendTextBox1.UseVisualStyleBackColor = true;
            this.btnSendTextBox1.Click += new System.EventHandler(this.btnSendTextBox1_Click);
            // 
            // btnMode
            // 
            this.btnMode.Enabled = false;
            this.btnMode.Location = new System.Drawing.Point(294, 126);
            this.btnMode.Name = "btnMode";
            this.btnMode.Size = new System.Drawing.Size(64, 23);
            this.btnMode.TabIndex = 34;
            this.btnMode.Text = "Mode 0";
            this.btnMode.UseVisualStyleBackColor = true;
            this.btnMode.Click += new System.EventHandler(this.btnMode_Click);
            // 
            // btnGetIPServer
            // 
            this.btnGetIPServer.Enabled = false;
            this.btnGetIPServer.Location = new System.Drawing.Point(364, 126);
            this.btnGetIPServer.Name = "btnGetIPServer";
            this.btnGetIPServer.Size = new System.Drawing.Size(86, 23);
            this.btnGetIPServer.TabIndex = 35;
            this.btnGetIPServer.Text = "Get IP Server";
            this.btnGetIPServer.UseVisualStyleBackColor = true;
            this.btnGetIPServer.Click += new System.EventHandler(this.btnGetIPServer_Click);
            // 
            // Client
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(457, 262);
            this.Controls.Add(this.btnGetIPServer);
            this.Controls.Add(this.btnMode);
            this.Controls.Add(this.btnSendTextBox1);
            this.Controls.Add(this.txtMsg1);
            this.Controls.Add(this.btnRight2);
            this.Controls.Add(this.btnLeft2);
            this.Controls.Add(this.btnDown);
            this.Controls.Add(this.btnUp);
            this.Controls.Add(this.lblTest);
            this.Controls.Add(this.txtMsg);
            this.Controls.Add(this.txtPort);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnDisconnect);
            this.Controls.Add(this.btnSend);
            this.Controls.Add(this.txtMain);
            this.Controls.Add(this.btnConnect);
            this.Controls.Add(this.txtIPServer);
            this.Controls.Add(this.label1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Client";
            this.Text = "Client";
            this.Load += new System.EventHandler(this.Client_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtIPServer;
        private System.Windows.Forms.Button btnConnect;
        private System.Windows.Forms.TextBox txtMain;
        private System.Windows.Forms.Button btnSend;
        private System.Windows.Forms.Button btnDisconnect;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtPort;
        private System.Windows.Forms.TextBox txtMsg;
        private System.Windows.Forms.Label lblTest;
        private System.Windows.Forms.Button btnUp;
        private System.Windows.Forms.Button btnDown;
        private System.Windows.Forms.Button btnLeft2;
        private System.Windows.Forms.Button btnRight2;
        private System.Windows.Forms.TextBox txtMsg1;
        private System.Windows.Forms.Button btnSendTextBox1;
        private System.Windows.Forms.Button btnMode;
        private System.Windows.Forms.Button btnGetIPServer;
    }
}

