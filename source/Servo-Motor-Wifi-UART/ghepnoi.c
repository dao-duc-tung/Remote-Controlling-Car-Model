/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 18-Dec-2015
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <stdint.h>
#include <string.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#define WLeft_1 PORTC.4
#define WLeft_2 PORTC.3
#define WRight_1 PORTC.2
#define WRight_2 PORTD.7
#define LedTest PORTD.6

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

int i; // running variable
char AP[15]; // Save IP Address of Access Point
char STA[15]; // save IP Address of Station Point
int l_ap, l_sta; //the length of IP of AP and STA
int cmd[3]; // save command to exec
char LCD_Buff[16]; // buffer of LCD

// prototype
void Exec_Cmd(int mode);
int Get_Cmd(char c);

void Control_mode0(int dir, int state);
void Control_mode1(int state);
void Control_mode5();
void ShowIP();

// mode 0
void Stop();
void Forward();
void Backward();
void Straight();
void Left(); 
void Right();

// mode 1
//void Stop();
//void Forward();
//void Backward();
void Turn_Left();
void Turn_Right();   

// External Interrupt 0 service routine
//interrupt [EXT_INT0] void ext_int0_isr(void){
//
//    // Place your code here
//    //putchar('2'); // send command to ESP
//    //Control_mode2(); // receiver data from ESP
//    LedTest = 1;
////    delay_ms(2000);
////    LedTest = 0;    
//}

// Get IP Server on ESP and display to LCD
interrupt [EXT_INT1] void ext_int1_isr(void){

    // Place your code here 
    LedTest = 1;
    ShowIP();
    LedTest = 0; 
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0xF0;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=T State0=T 
PORTC=0x00;
DDRC=0x1C; //C2 (Right 1),3 (Left 2),4 (Left 1): output

// Port D initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=0 State4=0 State3=T State2=T State1=0 State0=P 
PORTD=0x09;
DDRD=0xF2; //D1 (TxD),4 (OC1B - Reserved),5 (OC1A),6 (led test),7 (Right 2): output; D0 (RxD), D3 (INT1): input

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: Fast PWM top=ICR1
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA2;
TCCR1B=0x1A;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x4E;
ICR1L=0x20;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT2: Off
GICR|=0x80;
MCUCR=0x08;
GIFR = 0xC0;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x33;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 5
// RD - PORTC Bit 6
// EN - PORTC Bit 7
// D4 - PORTA Bit 3
// D5 - PORTA Bit 2
// D6 - PORTA Bit 1
// D7 - PORTA Bit 0
// Characters/line: 16
lcd_init(16);
lcd_clear();
lcd_gotoxy(0,0);
lcd_puts("Ninja Way");

// Global enable interrupts
#asm("sei")

LedTest = 0;
OCR1A = 700;
delay_ms(1000);
OCR1A = 1150;
Control_mode0(0,0);

while (1)
      {
        // Place your code here
        cmd[0] = Get_Cmd(getchar()); // get MODE
        Exec_Cmd(cmd[0]); // Executing                    
      }
}

// mode 0, 1
// byte 0: mode
// byte 1: mode 0: dir  , mode 1: x    , mode 2: ..
// byte 2: mode 0: state, mode 1: state, mode 2: ..

// mode 2: after get the first byte of data through UART into cmd[0] (value = 2 --> mode 2)
// the next 2 bytes: a one digit number -- the number of bytes of the number of bytes of the IP address, Subnet Mask, respectively (just only equal 1) 
// the next bytes: the 2 numbers of bytes of the IP address, Subnet Mask, respectively (just only is a one or two digit number) 
// the next bytes: the IP address, Subnet Mask of Server on ESP, respectively
// For examlpe: an array of bytes when mode 2 is activated
// 2 2 2 1 1 1 3 1 9 2 . 1 6 8 . 4 . 1 2 5 5 . 2 5 5 . 2 5 5 .0
// Explaining:
// 192.168.4.1 includes 11 bytes, 255.255.255.0 includes 13 bytes
// 11 is a number including 2 bytes, and 13 is too 
 
// mode 0: direct by 2 front wheels
// mode 1: direct by 2 behind wheels
// mode 2: print IP ESP to LCD
// mode 4: disconnect wifi - process in ESP   
void Exec_Cmd(int mode){
    switch(mode){
        case 0: for(i = 1; i < 3; i++) cmd[i] = Get_Cmd(getchar()); Control_mode0(cmd[1], cmd[2]); break;
        case 1: for(i = 1; i < 3; i++) cmd[i] = Get_Cmd(getchar()); Control_mode1(cmd[2]);         break;
        case 5: {      
            Control_mode5();                       
        }break;
        default: ;  
    }
}

// Sub 48 for getting the number in Binary, not in ASCII
int Get_Cmd(char c){
    return c - 48;    
}

//
void Control_mode0(int dir, int state){
    switch(dir){
        case 0: Straight(); break;               
        case 1: Left(); break;
        case 2: Right(); break;
        default: Straight(); break;       
    }
    
    switch(state){
        case 0: Stop(); break;
        case 1: Forward(); break;
        case 2: Backward(); break;
        default: Stop(); break;
    }    
}

// 0: Stop, 1: Go Forward, 2: Go Backward, 3: Turn Left, 4: Turn Right
void Control_mode1(int state){
    switch(state){
        case 0: Stop(); break;
        case 1: Forward(); break;
        case 2: Backward(); break;
        case 3: Turn_Left(); break;
        case 4: Turn_Right(); break;
        default: Stop(); break;
    }
}

//
void Control_mode5(){
    char len_len_ap, len_len_sta; // the number of bytes of the number of bytes of the IP address, Subnet Mask, respectively (just only equal 1)
    char len_ap[2], len_sta[2]; // the number of bytes of the IP address, Subnet Mask, respectively (just only is a one or two digit number) 
    
            
    len_len_ap = Get_Cmd(getchar());
    len_len_sta = Get_Cmd(getchar());       
            
    for(i = 0; i < len_len_ap; i++) len_ap[i] = Get_Cmd(getchar());
    for(i = 0; i < len_len_sta; i++) len_sta[i] = Get_Cmd(getchar());
            
    if(len_len_ap == 1) l_ap = len_ap[0];
    else l_ap = len_ap[1] + len_ap[0] * 10;
    if(len_len_sta == 1) l_sta = len_sta[0];
    else l_sta = len_sta[1] + len_sta[0] * 10;
            
    for(i = 0; i < l_ap; i++) { AP[i] = getchar();}
    for(i = 0; i < l_sta; i++) { STA[i] = getchar();}    

    ShowIP();                
}

void ShowIP(){
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_puts("IP AP and");
    lcd_gotoxy(0,1);
    lcd_puts("IP STA");
    delay_ms(2000);
    lcd_clear();
    
    lcd_gotoxy(0,0);
    for(i = 0; i < l_ap; i++) lcd_putchar(AP[i]);
    
    lcd_gotoxy(0,1);
    for(i = 0; i < l_sta; i++) lcd_putchar(STA[i]);
    
    delay_ms(2000);
    lcd_clear();
    lcd_puts("Ninja Way");  
}

void Stop(){
    WLeft_1 = 0;
    WLeft_2 = 0;
    WRight_1 = 0;
    WRight_2 = 0;
}

void Forward(){
    WLeft_1 = 0;
    WLeft_2 = 1;
    WRight_1 = 0;
    WRight_2 = 1;
}

void Backward(){
    WLeft_1 = 1;
    WLeft_2 = 0;
    WRight_1 = 1;
    WRight_2 = 0;
}

void Straight(){
    OCR1A = 1150;
}

void Left(){
    OCR1A = 700;
}

void Right(){
    OCR1A = 1520;
}

void Turn_Left(){
    WLeft_1 = 0;
    WLeft_2 = 1;
    WRight_1 = 1;
    WRight_2 = 0;    
}

void Turn_Right(){
    WLeft_1 = 1;
    WLeft_2 = 0;
    WRight_1 = 0;
    WRight_2 = 1;
}