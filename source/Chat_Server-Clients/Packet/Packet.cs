using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Packet
{
    public class Packet
    {
        private byte _mode;
        private byte _typeControl;
        private byte _address;
        private byte _data;

        public Packet()
        {
            this.Mode = 0;
            this.TypeControl = 0;
            this.Address = 0;
            this.Data = 0;
        }
        public Packet(byte mode, byte typeControl, byte address, byte data)
        {
            this.Mode = mode;
            this.TypeControl = typeControl;
            this.Address = address;
            this.Data = data;
        }
        public Packet(Packet pk)
        {
            this.Mode = pk.Mode;
            this.TypeControl = pk.TypeControl;
            this.Address = pk.Address;
            this.Data = pk.Data;
        }

        public byte Data
        {
            get { return _data; }
            set { _data = value; }
        }
        public byte Address
        {
            get { return _address; }
            set { _address = value; }
        }
        public byte TypeControl
        {
            get { return _typeControl; }
            set { _typeControl = value; }
        }
        public byte Mode
        {
            get { return _mode; }
            set { _mode = value; }
        }

        /// <summary>
        /// Nhận vào 4 trường ở dạng int, convert sang mảng 2 byte để truyền
        /// </summary>
        /// <param name="mode">chế độ - 3 bit</param>
        /// <param name="typeControl">loại thiết bị sẽ được đk - 3 bit</param>
        /// <param name="address">địa chỉ của loại thiết bị - 3 bit</param>
        /// <param name="data">dữ liệu truyền đi - 3 bit</param>
        /// <param name="packet">gói tin trả về sau khi được convert - 16 bit</param>
        public static void Convert4BytesToPacket(byte mode, byte typeControl, byte address, byte data, ref byte[] packet)
        {
            //Set bit 0-7
            for (int i = 0; i <= 6; i++)
            {
                Set(ref packet[0], i, Get(data, i));   //lay bit 0-6 cua D
            }
            Set(ref packet[0], 7, Get(address, 0));   //lay bit 0 cua C

            //Set bit 8-15
            Set(ref packet[1], 0, Get(address, 1));   //lay bit 1 cua C, set vao bit 0 cua packet[1] (tuc bit 8 cua packet)
            Set(ref packet[1], 1, Get(address, 2));   //lay bit 2 cua C, set vao bit 1 cua packet[1] (tuc bit 9 cua packet)

            Set(ref packet[1], 2, Get(typeControl, 0));   //tuong tu
            Set(ref packet[1], 3, Get(typeControl, 1));
            Set(ref packet[1], 4, Get(typeControl, 2));
            Set(ref packet[1], 5, Get(mode, 0));
            Set(ref packet[1], 6, Get(mode, 1));
            Set(ref packet[1], 7, Get(mode, 2));
        }

        public static void EncodingPacket(out int mode, out int typeControl, out int address, out int data, byte[] packet)
        {
            //data
            data = ReadLastNBits(packet[0], 7);
            
            //address
            byte tempC = 0;
            Set(ref tempC, 0, Get(packet[0], 7));   //set bit 7 packet[0] vao bit 0 cua tempC
            Set(ref tempC, 1, Get(packet[1], 0));   //set bit 0 packet[1] vao bit 1 cua tempC
            Set(ref tempC, 2, Get(packet[1], 1));   //set bit 1 packet[1] vao bit 2 cua tempC
            address = ReadLastNBits(tempC, 3);

            //typeControl
            byte tempB = 0;
            Set(ref tempB, 0, Get(packet[1], 2));
            Set(ref tempB, 1, Get(packet[1], 3));
            Set(ref tempB, 2, Get(packet[1], 4));
            typeControl = ReadLastNBits(tempB, 3);

            //mode
            mode = ReadFirstNBits(packet[1], 3);
        }

        public static int ReadFirstNBits(byte val, int n)
        {
            return val >> (8 - n);
        }

        public static int ReadLastNBits(byte val, int n)
        {
            byte mask = (byte)((1 << n) - 1);
            return val & mask;
        }

        public static void Set(ref byte aByte, int pos, bool value)
        {
            if (value)
            {
                //dùng OR để set bit 1
                aByte = (byte)(aByte | (1 << pos));
            }
            else
            {
                //đảo bit 0 -> 1 rồi AND để set bit 0
                aByte = (byte)(aByte & ~(1 << pos));
            }
        }

        public static bool Get(byte aByte, int pos)
        {
            //AND bit ở vị trí pos với 1 để get bit (0 = false, 1 = true)
            return ((aByte & (1 << pos)) != 0);
        }
    }
}