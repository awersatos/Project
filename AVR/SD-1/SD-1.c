/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Evaluation
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
#define UDRE 5
#define RXC 7
#define CR 0xD
#define LF 0xA
#define ctrl_Z 0x1A
flash char msms[]="at+cmgf=1";
// ќбъ€вление и инициализаци€ массива ввода номера
flash char nsms[]="at+cmgs=+79139243999,145";
// ќбъ€вление и инициализаци€ массива текста SMS
flash char tsms[]="door open";
unsigned char i;
unsigned char rdata;
void UART_Transmit(char data)
{  
while (!(UCSRA & (1<<UDRE))) {};
UDR=data;
}

char UART_Receive(void)
{ while (!(UCSRA & (1<<RXC)));
  return UDR;
  }
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
PORTB.3=0;
PORTB.4=1;

PORTB.0=0;
PORTD.6=0;
delay_ms(2000);
PORTB.0=1;
PORTD.4=0;
while(PIND.5==1) {};
PORTB.4=0;
delay_ms(2000);
m1: UART_Transmit('a');
    UART_Transmit('t');
    UART_Transmit(CR);
    
rdata=UART_Receive();
if (rdata!=CR) {goto m1;}
rdata=UART_Receive();
if (rdata!=LF) {goto m1;}
rdata=UART_Receive();
if (!((rdata=='O') || (rdata=='o'))) {goto m1;} ;
 rdata=UART_Receive();
if (!((rdata=='K') || (rdata=='k'))) {goto m1;}
PORTB.3=1;
delay_ms(200);

m2: for (i=0; i<11; i++)
 {UART_Transmit(msms[i]);}
 UART_Transmit(CR);
 
rdata=UART_Receive();
if (rdata!=CR) {goto m2;}
rdata=UART_Receive();
if (rdata!=LF) {goto m2;}
rdata=UART_Receive();
if (!((rdata=='O') || (rdata=='o'))) {goto m2;}
 rdata=UART_Receive();
if (!((rdata=='K') || (rdata=='k'))) {goto m2;}
PORTB.3=0;
PORTB.4=1;

for (i=0; i<24; i++)
 {UART_Transmit(nsms[i]);}
 UART_Transmit(CR);
 for (i=0; i<11; i++)
 {UART_Transmit(tsms[i]);}
 UART_Transmit(ctrl_Z);
 PORTB.4=0;
 
 





}

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
UCSRB=0x18;
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
 PORTB.3=1;
while (1)
      {
      // Place your code here

      }
}
