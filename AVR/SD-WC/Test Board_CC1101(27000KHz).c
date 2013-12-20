/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Test Board_CC1101(26800KHz)
Version : 1
Date    : 06.05.2012
Author  : Alexandr Gordejchik
Company : NTS
Comments: 


Chip type               : ATtiny44
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 64
*****************************************************/

#include <tiny44.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>



//++++++++++++ ����������� �����-������� ����������+++++++++++++++++++++++++++++++++++++++++++++++++++++
#define SRES 0x30 //����� ����������
#define SIDLE 0x36 //������� � ����� IDLE
#define SCAL 0x33   // ���������� ���������� �����������
#define SRX 0x34   // ������� � ����� RX
#define STX 0x35   // ������� � ����� TX
#define SFRX 0x3A  // ������� RX FIFO
#define SFTX 0x3B  // ������� TX FIFO
#define SNOP 0x3D  // ������ �����-�������
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 // ������ ������������� ��������� (������� ���� - �����, ������� - ��������)
flash unsigned int init[35]=
{
 0x000E, //0 IOGFG2 ����������� �������
 0x0206, //1 IOGFG0 �����-�������� ������
 0x06FF, //2 PKTLEN ������ ������
 0x0704, //3 PKRCTRL1 �������� ������
 0x0805, //4 PKRCTRL0 �������� ������
 0x0901, //5 ADDR ����� ����������
 0x0A2F, //6 CHANNR ����� ������
 0x0B06, //7 FSCTRL1 ��������� �������� ����������� �������
 0x0C00, //8 FSCTRL0 ��������� �������� ����������� �������
 0x0D10, //9 FREQ2 �������� ������� �������
 0x0E09, //10 FREQ1 �������� ������� �������
 0x0F7B, //11 FREQ0 �������� ������� �������
 0x1085, //12 MDMCFG4 ������������ ������
 0x1178, //13 MDMCFG3 ������������ ������
 0x1203, //14 MDMCFG2 ������������ ������
 0x1302, //15 MDMCFG1 ������������ ������
 0x14E5, //16 MDMCFG0 ������������ ������
 0x1514, //17 DEVIATION ��������
 0x1730, //18 MCSM1 ������������ �������� �������� �����
 0x1818, //19 MCSM0 ������������ �������� �������� �����
 0x1916, //20 FOCCFG ����������� ������ �������
 0x1A6C, //21 BSCFG ������������ ��������� �������������
 0x1BC0, //22 AGCCTRL2 ���������� ��������� ������
 0x1C00, //23 AGCCTRL1 ���������� ��������� ������ 
 0x1DB2, //24 AGCCTRL0 ���������� ��������� ������
 0x21B6, //25 FREND1 ��������� ��������� ������
 0x2210, //26 FREND0 ��������� ����������� ������
 0x23E9, //27 FSCAL3 ��������� ���������� ����������� �������
 0x242A, //28 FSCAL2 ��������� ���������� ����������� �������
 0x2500, //29 FSCAL1 ��������� ���������� ����������� ������� 
 0x261F, //30 FSCAL0 ��������� ���������� ����������� �������
 0x2959, //31 FSTEST �������� ����������� �������
 0x2C81, //32 TEST2
 0x2D35, //33 TEST1
 0x2E09  //34 TEST0
};
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
union U      // ����������� �����������
		{
			unsigned int buf;
			unsigned char b[2];
		};  
                      
//union U data;

// ����������� ���������� ����������
unsigned char i;   //�������� �������
//eeprom unsigned char ST;
 unsigned char STAT[16];
//*******************************************************************************************
//*******************************************************************************************
//*******************������� ��� ������ � �����������*****************************************
//============================================================================================
// ������� �������� ������� �� SPI
unsigned char SPI_SEND(unsigned char data)
{
 USIDR=data;      // �������� ������ � ��������� �������
 USISR=(1<<USIOIF);  // ������� ����� ������������ � 4-������� ��������
 TIFR0 |= (1<<OCF0A);   // ������� ����� ���������� �� ���������� �������
 TIMSK0 |= (1<<OCIE0A); // ���������� ���������� �� ����������
 while(USISR.USIOIF==0); //�������� ����� �������� �����
 TIMSK0=0x00;     //������ ����������
 return USIDR; // ������� ������ 
 }

//*******************************************************************************************
 void RESET_TR(void) //����� ���������� �� ��������� �������
{
USICR=0x00; //���������� SPI
PORTA.4=1; //������������� 1 �� SCK
PORTA.5=0;  // ������������� 0 �� MOSI
PORTA.3=0; // SPI_SS ON
delay_us(1);
PORTA.3=1; // SPI_SS OFF
delay_us(40);
USICR=0x1A; //��������� SPI
PORTA.3=0; // SPI_SS ON
while(PINA.6==1); //���� 0 �� MISO
SPI_SEND(SRES);
PORTA.3=1; // SPI_SS OFF
}
//*******************************************************************************************
void WRITE_REG( unsigned int reg) // ������� ������ ��������
{  union U dat;
PORTA.3=0; // SPI_SS ON
while(PINA.6==1); //���� 0 �� MISO
 
 dat.buf=reg;
 SPI_SEND(dat.b[1]);  //����� �������� 
 SPI_SEND(dat.b[0]);  //�������� �������� 
 PORTA.3=1; // SPI_SS OFF
}
//********************************************************************************************
unsigned char READ_REG(unsigned char adr)  // ������� ������ ��������
{  unsigned char reg;
   PORTA.3=0; // SPI_SS ON
   while(PINA.6==1); //���� 0 �� MISO   
   SPI_SEND(adr | 0x80);   // ������� ��� ���������� ��������  
   reg= SPI_SEND(0x00);
   return reg; 
   PORTA.3=1; // SPI_SS OFF 
}
//**********************************************************************************************
 void INIT_TR(void) //������� ������������� ����������
 {
 
 
  for (i=0;i<35;i++)
   {
    WRITE_REG(init[i]);
    };
    
    
  
 }
//********************************************************************************************
void WRITE_PATABLE(void)    //������ ������� ��������
{
PORTA.3=0; // SPI_SS ON
   while(PINA.6==1); //���� 0 �� MISO  
WRITE_REG(0x3EC0);         //������ �������� �������� �������� ����������� +1dbm
   PORTA.3=1; // SPI_SS OFF 
}
//*********************************************************************************************
void STROB(unsigned char strob)  //������ �����-�������
{
PORTA.3=0; // SPI_SS ON
 while(PINA.6==1); //���� 0 �� MISO 
 SPI_SEND(strob);
  PORTA.3=1; // SPI_SS OFF
}
//******************************************************************************************
unsigned char STATUS(void)
{ unsigned char st;
PORTA.3=0; // SPI_SS ON
while(PINA.6==1); //���� 0 �� MISO
st=SPI_SEND(SNOP);
PORTA.3=1; // SPI_SS OFF
return st; 
}
//*******************************************************************************************
//===========================����������======================================================
// Timer 0 output compare A interrupt service routine
interrupt [TIM0_COMPA] void timer0_compa_isr(void)    //���������� �� ���������� �������
{
USICR |= (1<<USITC); // ������� ��������� ��������

}

//============================================================================================
//+++++++++++++++++++�������� ������� ��������� ++++++++++++++++++++++++++++++++++++++++++++++
//=============================================================================================
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
// Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=0 State6=T State5=0 State4=0 State3=1 State2=0 State1=T State0=T 
PORTA=0x08;
DDRA=0xBC;

// Port B initialization
// Func3=In Func2=In Func1=In Func0=In 
// State3=T State2=T State1=P State0=P 
PORTB=0x03;
DDRB=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 8000,000 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x01;
TCNT0=0x00;
OCR0A=0x1F;
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
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-11: Off
MCUCR=0x00;
GIMSK=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x02;

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;

// Universal Serial Interface initialization
// Mode: Three Wire (SPI)
// Clock source: Reg.=ext. pos. edge, Cnt.=USITC
// USI Counter Overflow Interrupt: Off
USICR=0x1A;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR0=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
      
      PORTA.2=1; //��������� 1 
      PORTA.7=0; //��������� 2
      delay_ms(1000);
      
      RESET_TR(); 
      delay_ms(10);     
      INIT_TR();
      WRITE_PATABLE(); 
m:      STROB(SIDLE);
      STROB(SFRX);
      STROB(SFTX);
      STROB(SRX); 
      delay_ms(1);
      STAT[0]=STATUS(); 
      PORTA.2=0; //��������� 1 
      PORTA.7=1; //��������� 2 
      
      while(1) {  
      while(PINA.0==0); 
       
      // STAT[0]=READ_REG(0x72);
               
      while(PINA.0==1);
       PORTA.3=0; // SPI_SS ON
      while(PINA.6==1); //���� 0 �� MISO 
      SPI_SEND(0xFF);
     for(i=0;i<11;i++) 
      {
      STAT[i]=SPI_SEND(0x00);
      }
       PORTA.3=1; // SPI_SS OFF
      if (strstr(STAT,"SEXONIX")!=NULL) 
      {PORTA.2=1; //��������� 1 
      PORTA.7=0; }//��������� 2
       
      for (i=0;i<16;i++)
      
      {STAT[i]=0x00;}
      
      delay_ms(100); 
      goto m;
      // while(1); 
       
              /*
              
       PORTA.2=1; //��������� 1 
      PORTA.7=0; //��������� 2 
      while(PINA.0==1);
      PORTA.2=0; //��������� 1 
      PORTA.7=1; //��������� 2 
               */
      }
      //while(1);
      }
}
