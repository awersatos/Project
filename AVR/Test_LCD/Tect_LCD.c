/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 19.09.2012
Author  : 
Company : 
Comments: 


Chip type               : ATtiny2313A
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313a.h>
#include <delay.h>

// Declare your global variables here
//*******************************************************************************************************************
void lcd_com(unsigned char p)
{
PORTD.0=0;
//delay_ms(100);
    /*
PORTD.1=1; //Enable
PORTB=p;
delay_ms(1);
PORTD.1=0;   //Enable
        */
       
PORTD.1=1; //Enable       
PORTB &= 0x0F;
PORTB |= (p & 0xF0);
delay_ms(1);       
PORTD.1=0; //Enable  
delay_ms(1);
PORTD.1=1; //Enable 
PORTB &= 0x0F;
PORTB |= (p << 4);
delay_ms(1);
PORTD.1=0; //Enable
delay_ms(1); 
     
}


void lcd_dat(unsigned char p)
{
PORTD.0=1;
//delay_ms(100);
   /*
delay_ms(100);
PORTD.1=1; //Enable
PORTB=p;
delay_ms(1);
PORTD.1=0;   //Enable
     */
PORTD.1=1; //Enable       
PORTB &= 0x0F;
PORTB |= (p & 0xF0);
delay_ms(1);       
PORTD.1=0; //Enable  
delay_ms(1);
PORTD.1=1; //Enable 
PORTB &= 0x0F;
PORTB |= (p << 4);
delay_ms(1);
PORTD.1=0; //Enable
     
}

void lcd_init(void)
{
lcd_com(0x33);
delay_ms(5);
lcd_com(0x32);
lcd_com(0x2C);
lcd_com(0x08);

lcd_com(0x0D);
lcd_com(0x01);
}
//******************************************************************************************************************
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
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTD=0x00;
DDRD=0x03;

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
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

delay_ms(15);
lcd_init();  //�������������
// ������ ������
lcd_dat(0x42); //�
lcd_dat(0x61); //�
lcd_dat(0xBD); //�
lcd_dat(0xC7); //�
lcd_dat(0x2D); //-
lcd_dat(0xBC); //�
lcd_dat(0x65); //�
lcd_dat(0xBB); //�
lcd_dat(0xBA); //�
lcd_dat(0xB8); //�
lcd_dat(0xB9); //�
//**********************************************************************************************
lcd_com(0xC0);  // ������ ������

lcd_dat(0x79); //�
lcd_dat(0xC1); //�
lcd_dat(0x61); //�
lcd_dat(0x63); //�
lcd_dat(0xBF); //�
lcd_dat(0xC3); //�
lcd_dat(0xB9); //�
lcd_dat(0x20); //SP
lcd_dat(0xBE); //�
lcd_dat(0x6F); //�
lcd_dat(0x70); //�
lcd_dat(0x6F); //�
lcd_dat(0x63); //�
lcd_dat(0xB5); //�
lcd_dat(0xBD); //�
lcd_dat(0x6F); //�
lcd_dat(0xBA); //�
//**********************************************************************************************
lcd_com(0x94);  // ������ ������

lcd_dat(0x63); //�
lcd_dat(0x20); //SP
lcd_dat(0xB7); //�
lcd_dat(0x65); //�
lcd_dat(0xBB); //�
lcd_dat(0xB5); //�
lcd_dat(0xBD); //�
lcd_dat(0xC3); //�
lcd_dat(0xBC); //�
lcd_dat(0x20); //SP
lcd_dat(0xBE); //�
lcd_dat(0xC7); //�
lcd_dat(0xBF); //�
lcd_dat(0x61); //�
lcd_dat(0xC0); //�
lcd_dat(0xBA); //�
lcd_dat(0x6F); //�
lcd_dat(0xBC); //�
//**********************************************************************************************
lcd_com(0xD4);  // ��������� ������

lcd_dat(0xB8); //�
lcd_dat(0x20); //SP
lcd_dat(0x78); //�
lcd_dat(0xB3); //�
lcd_dat(0x6F); //�
lcd_dat(0x63); //�
lcd_dat(0xBF); //�
lcd_dat(0xB8); //�
lcd_dat(0xBA); //�
lcd_dat(0x6F); //�
lcd_dat(0xBC); //�
lcd_dat(0x20); //SP
lcd_dat(0xBA); //�
lcd_dat(0x70); //�
lcd_dat(0xC6); //�
lcd_dat(0xC0); //�
lcd_dat(0xBA); //�
lcd_dat(0x6F); //�
lcd_dat(0xBC); //�
while (1)
      {
      // Place your code here

      }
}
