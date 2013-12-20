/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : SD-N
Version : 0
Date    : 12.08.2011
Author  : Alexandr Gordejchik
Company : NTS
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 3,686400 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <stdio.h>
#include <delay.h>
#include <string.h>
#define CR 0xD     // ����������� ��������� ��������
#define LF 0xA
#define ctrl_Z 0x1A
                          
 char z;
//eeprom char eebuffer[56];
unsigned char i;
 char NR[10];
//char *n;
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{ /*
delay_us(200);
if (PIND.3==0) {
if (z==0)
{z=128;}
else {z=0;}
 //PORTB.4=1;
  PORTB.3=1;
  delay_ms(500);
 while(PIND.3==0);
PORTB.4=0;
  PORTB.3=0;}  */
}

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
#define RX_BUFFER_SIZE 56
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
//***********************************************************************************************************
void UART_Transmit(char data) // ������� �������� ������� ����� UART
{  
while (!(UCSRA & (1<<UDRE))) {};
UDR=data;
}

//**********************************************************************************************************
       void SEND_Str(flash char *str) {        // ������� �������� ������
        while(*str) { 
       UART_Transmit(*str++);
      
    };
    delay_ms(20);
}

//**********************************************************************************************************
void CLEAR_BUF(void)   // ������� ������� ������� ������
{
for (i=0;i<RX_BUFFER_SIZE;i++) {
      rx_buffer[i]=0;
    };
   rx_wr_index=0;
}
//**********************************************************************************************************
  char TEST_OK(void)     // ������� �������� ������ �� �� �������
  {
  char c;
  char *d;
  char OK[]="OK";
  d=strstr(rx_buffer, OK);
  c=*d;
 CLEAR_BUF();
   return c; 

  }
//**********************************************************************************************************
  char REG_NET(void)   // ������� �������� ����������� � ����
  {
  char c;
  char *d;
  char REG[]="+CREG:";
  d=strstr(rx_buffer, REG);
  d=d+9;
  c=*d;
  CLEAR_BUF();
  return c;
  }
//**********************************************************************************************************
char SET_NR(void) // ������� ���������� ����������� ������ � SIM �����
{
char c;
char *d;
d=strstr(rx_buffer, ",\"+7");
if (d==NULL){c=0;
          return c;}
    d=d+4;      
for (i=0;i<10;i++)
   {
   NR[i]=*d;
   d=d++;
   } 
  CLEAR_BUF();
  c=1;
  return c;  
}
//**********************************************************************************************************
char TEST_ERROR(void)
{
char *d;
d=strstr(rx_buffer, "ERROR");
 CLEAR_BUF();
 return *d;
}
//**********************************************************************************************************
// ������� ��������� ���������� �� ������ ������� USART 
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

 //*************************************************************************
 // ������� ���������� ������� �� ������ ������
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
//***************************************************************************



// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=Out 
// State7=T State6=T State5=T State4=0 State3=0 State2=T State1=T State0=1 
PORTB=0x01;
DDRB=0x19;

// Port D initialization
// Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State6=1 State5=T State4=1 State3=T State2=T State1=T State0=T 
PORTD=0x50;
DDRD=0x50;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Low level
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x40;
MCUCR=0x00;
EIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x01;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

// Global enable interrupts
#asm("sei")
      PORTB.0=0;     //��������� ������
      delay_ms(1000);
      PORTB.0=1;
      delay_ms(250); 
      z=1;
while (1)
      {
     // while(z==0);
       
      
       
      while(PIND.2==0){ PORTB.3=1;}
      PORTB.3=0;
     
       
    //  delay_ms(3000); 
      
      PORTD.6=0;  // �������� �����
      PORTD.4=0;
      while(PIND.5==1); 
      
m1:      SEND_Str("AT\r"); 
      
      if (TEST_OK()==0) goto m1 ;
      
     
m2:    SEND_Str("AT+CREG?\r");
          
      if (REG_NET()!='1')
      {
      delay_ms(1000);
      goto m2;
      }  
    //  z='R';
m3:      SEND_Str("AT+CPBF=\"N\"\r");
      if (SET_NR()==0) goto m3;
      
m4:      SEND_Str("AT+CMGF=1\r");
       if (TEST_OK()==0) goto m4 ;
       
m5:       SEND_Str("AT+CMGS=\"+7");  // ���� ������ SMS
       for (i=0; i<10; i++)
      {UART_Transmit(NR[i]);}
      SEND_Str("\",145\r"); 
      
      if (strrchr(rx_buffer, '>')==NULL)
      {CLEAR_BUF();
      goto m5;}
      CLEAR_BUF();    
      
      SEND_Str("DOOR OPEN\x1A");     // ���� ������ SMS
      
      if (TEST_ERROR()=='E') goto m5; 
       PORTD.4=1;
       PORTD.6=1;
      
      //SEND_Str("AT+CPOF\r"); 
     /* delay_ms(10000);
     
      PORTB.0=0;
      delay_ms(1000);
      PORTB.0=1;  
      
      delay_ms(2000);
       #asm("cli")
      for (i=0; i<56; i++)    // ������ ������ ������ � eeprom
      {eebuffer[i]=rx_buffer[i];} */
      PORTB.4=1;
      #asm("sei")
      while(PIND.2==1);
      PORTB.4=0;
      

      }
}
 