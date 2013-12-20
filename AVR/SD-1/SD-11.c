/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : SD-1
Version : 001
Date    : 27.06.2011
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
#include <delay.h>
#define CR 0xD
#define LF 0xA
#define ctrl_Z 0x1A
flash char msms[]="AT+CMGF=1";
//flash char csmp[]="AT+CSMP=17,167,0,0"  ;
// ���������� � ������������� ������� ����� ������
//flash char csms[]="AT+CSCA=" ;
//flash char csms1[]="+79037011111";
flash char csms2[]=",145" ;
flash char nsms[]="AT+CMGS=";
eeprom char nsms1[12] ;
flash char get[]="AT+CPBF=" ;
// ���������� � ������������� ������� ������ SMS
flash char tsms[]={0x44,0x4F,0x4F,0x52,0x20,0x4F,0x50,0x45,0x4E};
eeprom char eebuffer[72];
flash char off[]="AT+QPOWD=1";
unsigned char i;
unsigned char j;
char rdata;
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
#define RX_BUFFER_SIZE 72
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
//***********************************************************************************************************
void UART_Transmit(char data)
{  
while (!(UCSRA & (1<<UDRE))) {};
UDR=data;
}
//************************************************************************************************************
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
//***********************************************************************************************************
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here

}  

//************************************************************************************************************
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

//************************************************************************************************************
// Standard Input/Output functions
#include <stdio.h>

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
// State6=0 State5=T State4=0 State3=P State2=P State1=T State0=T 
PORTD=0x0C;
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
// INT0: Off
// INT1: On
// INT1 Mode: Low level
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x80;
MCUCR=0x00;
EIFR=0x80;

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
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x17;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

// Global enable interrupts
#asm("sei")
 // PORTB.3=1;
while (1)
 {
      // Place your code here
      PORTB.3=0;
PORTB.4=1;
//while(PIND.2==0);

PORTB.0=0;
PORTD.6=0;
delay_ms(1000);
PORTB.0=1;
//PORTD.4=0;
//while(PIND.5==1) {};
PORTB.4=0;
delay_ms(9000);
 #asm("sei")
m1:    UART_Transmit('a');
    UART_Transmit('t');
    UART_Transmit(CR);
     goto m1;
    
    delay_ms(3000) ;
      for (i=0; i<72; i++)
 {eebuffer[i]=rx_buffer[i];}
  PORTB.3=1; 
    
  while(1); 
    
    while(!((rdata=='O') || (rdata=='o')))
    {rdata=getchar();} 
    while(!((rdata=='K') || (rdata=='k')))
    {rdata=getchar();}
   delay_ms(200);
  
     for (i=0; i<72; i++)
 {eebuffer[i]=rx_buffer[i];}
  PORTB.3=1;   
  while(1);
     /*
   for (i=0; i<9; i++)
 {UART_Transmit(msms[i]);}
 UART_Transmit(CR);
   
delay_ms(6000);
  

for (i=0; i<8; i++)
 {UART_Transmit(get[i]);} 
  UART_Transmit(0x22);
   UART_Transmit(0x30); 
   // UART_Transmit('e');
    //UART_Transmit('t');
    UART_Transmit(0x22);
  UART_Transmit(CR); 
  rx_wr_index=0; 
  delay_ms(4000);
  
 
  
  i=0;
  while(rdata!=',')
  {rdata=rx_buffer[i++];}
  rdata=rx_buffer[i++];

  if (rdata==0x22)
  {for (j=0; j<12; j++){nsms1[j]=rx_buffer[i++];}}
  
for (i=0; i<8; i++)
 {UART_Transmit(csms[i]);}
  UART_Transmit(0x22); 
 for (i=0; i<12; i++)
 {UART_Transmit(csms1[i]);}
 UART_Transmit(0x22);
 for (i=0; i<4; i++)
 {UART_Transmit(csms2[i]);}
  UART_Transmit(CR); */
  
  delay_ms(200);
 for (i=0; i<8; i++)
 {UART_Transmit(nsms[i]);} 
   UART_Transmit(0x22);
  for (i=0; i<12; i++)
 {UART_Transmit(nsms1[i]);}
  UART_Transmit(0x22);
 for (i=0; i<4; i++)
 {UART_Transmit(csms2[i]);}
 UART_Transmit(CR); 
  delay_ms(200);
          
 for (i=0; i<9; i++)
  {UART_Transmit(tsms[i]);}

 
   delay_ms(4000);
 UART_Transmit(ctrl_Z);  
           
         
  
 // #asm("cli")
 /*for (i=0; i<10; i++)
 {UART_Transmit(off[i]);}
  UART_Transmit(CR);
 delay_ms(1000);   */
/* for (i=0; i<72; i++)
 {eebuffer[i]=rx_buffer[i];}
  PORTB.3=1;  */
         
    while(1);
    
 // while(PIND.2==1);
   //delay_ms(4500);
  // while(PIND.2==1);
      }
}
