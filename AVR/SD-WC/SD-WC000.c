/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : SD-WC
Version : 1
Date    : 16.10.2011
Author  : Alexandr Gordejchik
Company : NTS
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 3,686400 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <spi.h>

#define CR 0xD     // ����������� ��������� ��������
#define LF 0xA
#define ctrl_Z 0x1A

typedef union{                     // ����������� ������������ ���� DATA
		unsigned int data;
		unsigned char byte[2];
		struct{
			unsigned char b0:1;
			unsigned char b1:1;
			unsigned char b2:1;
			unsigned char b3:1;
			unsigned char b4:1;
			unsigned char b5:1;
			unsigned char b6:1;
			unsigned char b7:1;
			unsigned char b8:1;
			unsigned char b9:1;
			unsigned char b10:1;
			unsigned char b11:1;
			unsigned char b12:1;
			unsigned char b13:1;
			unsigned char b14:1;
			unsigned char b15:1;
		} Bit;
	}DATA;
                    // ����������� ���������� ����������
char z;          //���������� ������� ������ 
unsigned char i; //�������
char NR[12];     // ������ ����������� ������
unsigned char SPI_buffer[64];
unsigned char pktlen;
char Error;
//eeprom unsigned int STATE[5];
eeprom char eebuffer[255];
flash unsigned char CH=81;  //����� ������
flash unsigned char SW=9;  //�������� �������
// �������� ��� ������������� �����
                                                               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
        flash unsigned char tbl_frame[30]  = {0x30,0x98,0x90,  //48  1  0  0  1  1  0 0 0 0 0 0 0 0 0 0 0 15:13 - 5 ���� ��������� 12:11 - ������-����� 64 ���� {Reg55[15:0],Reg54[15:0],Reg53[15:0],Reg52[15:0]} 10:8 - ������� 4 ���� 7:6 - NRZ ����������� ������� 5:4 - �� ������������ ���������������� ����������� 3,2,1,0 - �� ����� ������ ���������
                                              0x31,0xFF,0x8F,  //49  1  1  1  1  1  1 1 1 1 0 0 0 1 1 1 1 15:8 - ������������ �������� 2 �� 7 - ���� �������� � ������ ��� 5:0 - BDATA1 �������� ����� 15 us
                                              0x32,0x80,0x28,  //50  1  0  0  0  0  0 0 0 0 0 1 0 1 0 0 0 15:8 � 7:0 �������� ��� ������ � ������ TX
                                              0x33,0x80,0x56,  //51  1  0  0  0  0  0 0 0 0 1 0 1 0 1 1 0 15:8 - RX ������ 7 - MISO � �������������� ��������� 6:0 - ���� ��� ����������
                                              0x34,0x4E,0xF6,  //52  0  1  0  0  1  1 1 0 1 1 1 1 0 1 1 0  ���� �������������
                                              0x35,0xF6,0xF5,  //53  1  1  1  1  0  1 1 0 1 1 1 1 0 1 0 1  ���� �������������
                                              0x36,0x18,0x5C,  //54  0  0  0  1  1  0 0 0 0 1 0 1 1 1 0 0  ���� �������������
                                              0x37,0xD6,0x51,  //55  1  1  0  1  0  1 1 0 0 1 0 1 0 0 0 1  ���� �������������
                                              0x38,0x44,0x44,  //56  0  1  0  0  0  1 0 0 0 1 0 0 0 1 0 0  7 - PKF-flag ������� ������� ��������
                                              0x39,0xA0,0x00}; //57  1  0  1  0  0  0 0 0 0 0 0 0 0 0 0 0  15 - ������������ CRC 14 -�� ������������ ��������� 13 - ������ ���� �������� ����� ������ 7:0 - CRC (???????????)

		// �������� ��� ������������� �����������               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
		flash unsigned char tbl_rfinit[54]  = {0x09,0x21,0x01,  //9   0  0  1  0  0  0 0 1 0 0 0 0 0 0 0 1
											   0x00,0x35,0x4D,  //0   0  0  0  1  1  1 1 1 0 0 0 0 0 0 0 1
											   0x02,0x1F,0x01,  //2   0  0  0  1  1  1 1 1 0 0 0 0 0 0 0 1
											   0x04,0xBC,0xF0,  //4   1  0  1  1  1  1 0 0 1 1 1 1 0 0 0 0
											   0x05,0x00,0xA1,  //5   0  0  0  0  0  0 0 0 1 0 1 0 0 0 0 1
											   0x07,0x12,0x4C,  //7   0  0  0  1  0  0 1 0 0 1 0 0 1 1 0 0 13:9 - �������� 8- TX mode 7- RX mode 6:0 - ������� (2402+76)
											   0x08,0x80,0x00,  //8   1  0  0  0  0  0 0 0 0 0 0 0 0 0 0 0
											   0x0C,0x80,0x00,  //12  1  0  0  0  0  0 0 0 0 0 0 0 0 0 0 0
											   0x0E,0x16,0x9B,  //14  0  0  0  1  0  1 1 0 1 0 0 1 1 0 1 1
											   0x0F,0x90,0xAD,  //15  1  0  0  1  0  0 0 0 1 0 1 0 1 1 0 1
											   0x10,0xB0,0x00,  //16  1  0  1  1  0  0 0 0 0 0 0 0 0 0 0 0
											   0x13,0xA1,0x14,  //19  1  0  1  0  0  0 0 1 0 0 0 1 0 1 0 0
											   0x14,0x81,0x91,  //20  1  0  0  0  0  0 0 1 1 0 0 1 0 0 0 1
											   0x16,0x00,0x02,  //22  0  0  0  0  0  0 0 0 0 0 0 0 0 0 1 0
											   0x18,0xB1,0x40,  //24  1  0  1  1  0  0 0 1 0 1 0 0 0 0 0 0
											   0x19,0xA8,0x0F,  //25  1  0  1  0  1  0 0 0 0 0 0 0 1 1 1 1
											   0x1A,0x3F,0x04,  //26  0  0  1  1  1  1 1 1 0 0 0 0 0 1 0 0
											   0x1C,0x58,0x00}; //28  0  1  0  1  1  0 0 0 0 0 0 0 0 0 0 0

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
#define RX_BUFFER_SIZE 255
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_counter;
#else
unsigned int rx_wr_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

//********************************************************************************************
void LightDiode(unsigned char n) // ������� ���������� �����������
{
 switch (n)
 {
 case 0:
			{
			PORTC.4=0;
            PORTC.5=0;	
				break;
			} 
 case 1:
			{
			PORTC.4=1;
            PORTC.5=0;		
				break;
			} 
 case 2:
			{
			PORTC.4=0;
            PORTC.5=1;		
				break;
 case 3:
			{
			PORTC.4=1;
            PORTC.5=1;		
				break;
			} 			}             
 }

}
//***********************************************************************************************************
void UART_Transmit(char data) // ������� �������� ������� ����� UART
{  
while (!(UCSRA & (1<<UDRE))) {};
UDR=data;
}

//**********************************************************************************************************
       void SEND_Str(flash char *str) {        // ������� �������� ������  �� ���� ������
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
  i=0;      
  while(i<12)
  {
  NR[i++]=*d;
   d=d-1;
   NR[i++]=*d;
   d=d+3;
  } 
  NR[10]='F';
  CLEAR_BUF();
  c=1;
  return c;  
}
//**********************************************************************************************************
unsigned char SPI_SEND(unsigned char data)  // ��������/������� ����  �� SPI
{
SPDR = data;
		while (!(SPSR & (1<<SPIF)));
		return SPDR;
}

//*******************************************************************************************
//�������� � ������� ���������� ��������
	void TR24_Wrtie(unsigned char reg,unsigned int data)
	{
		union U
		{
			unsigned int buf;
			unsigned char b[2];
		};
       union U dat;
		dat.buf=data;

		PORTB.2=0;       // SPI_SS ON
		SPI_SEND(reg);    //�������
		delay_us(2);
		SPI_SEND(dat.b[1]);   //������� �����
		delay_us(2);
		SPI_SEND(dat.b[0]);   //������� �����
		delay_us(2);
		PORTB.2=1;     // SPI_SS OFF

	}//end writeByte
//*******************************************************************************************	
 //������ �� �������� ����������
	unsigned int TR24A_Read(unsigned char reg)
	{
		union U
		{
			unsigned int buf;
			unsigned char b[2];
		};
           union U dat;
		PORTB.2=0;       // SPI_SS ON
		SPI_SEND(reg |0x80);   //������� ��� ���������� ��������
		delay_us(2);
		dat.b[1]=SPI_SEND(0x0FF);
		delay_us(2);
		dat.b[0]=SPI_SEND(0x0FF);
		delay_us(2);
		PORTB.2=1;     // SPI_SS OFF

		return dat.buf;
	}//end readByte
//******************************************************************************************* 
//������������� ����������
	void TR24A_INIT(void)
	{
		
		union U
		{
			unsigned int data;     //�������� ��������
			unsigned char b[2];
		}; 
        union U dt;
                /*
		chanel=76;   //����� �� ���������
		swallow=9;    //�������� ������� �� ���������
		Error.byte=0; //�������� ��� ������
		ProgCRC=0;    //����������� CRC ����
		TrState=0;    //���������� ����� ������ ����������, ���������� ��� ������ ������
                  */
		//reset();

		unsigned char i;
        PORTB.0=0;      // ����� ���������� ����� ��������������
     delay_ms(10);
     PORTB.0=1;
     delay_ms(5); 
		for(i=0;i<30;i=i+3)				//������������� �����
		{
			dt.b[1]=tbl_frame[i+1];
			dt.b[0]=tbl_frame[i+2];
			TR24_Wrtie(tbl_frame[i],dt.data);
		}

		delay_ms(5);
		for(i=0;i<54;i=i+3)		       //������������� �����������
		{
			dt.b[1]=tbl_rfinit[i+1];
			dt.b[0]=tbl_rfinit[i+2];
			TR24_Wrtie(tbl_rfinit[i],dt.data);
		}
           Error='N';
		//��������� ������������ ������������� ����������

		for(i=0;i<54;i=i+3)
		{
			dt.data=TR24A_Read(tbl_rfinit[i]);

			if(dt.b[1]!=tbl_rfinit[i+1])
			{
				Error='E';
			}
			else if(dt.b[0]!=tbl_rfinit[i+2])
			{
				Error='E';
			}

		}

		for(i=0;i<30;i=i+3)
		{
			dt.data=TR24A_Read(tbl_frame[i]);

			if(dt.b[1]!=tbl_frame[i+1])
			{
				Error='E';
			}
			else if(dt.b[0]!=tbl_frame[i+2])
			{
				Error='E';
			}
		}

	}//end init
//*************************************************************************************************
//����� ������ ������
	void TR24A_RX(void)
	{
		DATA buf;


		buf.data=TR24A_Read(0x07);
		buf.byte[1]=(SW<<1);
		buf.byte[0]=CH;
		buf.Bit.b8=0;
		buf.Bit.b7=1;

		TR24_Wrtie(0x07,buf.data);  // ������� � ����� RX, ������ �����
		delay_us(10);

	}//end ReciveMode
//*******************************************************************************************
//������� � ����� �������� ������
	void TR24A_TX(void)
	{
		DATA buf;

		buf.data=TR24A_Read(0x07);
		buf.byte[1]=(SW<<1);
		buf.byte[0]=CH;
		buf.Bit.b8=1;
		buf.Bit.b7=0;

		TR24_Wrtie(0x07,buf.data);  

	}//end TransmitMode    
//*********************************************************************************************
//����� �����
  unsigned char TR24A_RXPKT(void)
  {
   unsigned char len; //������ ������
   unsigned char j;   //�������

  PORTB.2=0;       // SPI_SS ON  
  
  SPI_SEND(0x50|(1<<7));   //reg80
  delay_us(3);
  len=SPI_SEND(0xFF);
  for(j=0;j<len;j++)  //�������� �����
		{
			delay_us(3);
			SPI_buffer[j] = SPI_SEND(0xFF);
		} 
 PORTB.2=1;     // SPI_SS OFF  
 return len;
 
  }      
//******************************************************************************************
   //������� �������� ������
 void TR24A_TXPKT(void)
 { 

 
   TR24_Wrtie(0x52,0x8000);
      
      PORTB.2=0;       // SPI_SS ON
      delay_us(3);
      SPI_SEND(0x50);
      delay_us(3); 
      SPI_SEND(pktlen);
      for (i=0;i<pktlen;i++)
     {
       delay_us(3); 
      SPI_SEND(SPI_buffer[i]);
    };

      PORTB.2=1;       // SPI_SS OFF 
      
      delay_us(3); 
       TR24A_TX();
 }
//********************************************************************************************
  // ������ ������ � SPI ������
 void Write_SPI_buffer(flash char *str)
 {
  i=0;
  while(*str)
  {
  SPI_buffer[i++]=*str++;
  
  }
  pktlen=i;
  }
//********************************************************************************************
 void USART_ON(void)   //��������� USART
  {
   PORTD.4=0;
   PORTD.5=0;
   while(PIND.6==1);
  } 
//*******************************************************************************************
 void USART_OFF(void)   //����������� USART
 {
 PORTD.4=1;
 PORTD.5=1;
 }
//********************************************************************************************
//============================================================================================
// ���������� �� ������ ������
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
     GICR=0x00; //������ ������� ���������� 
   LightDiode(3);
   delay_ms(6);
    
 pktlen=TR24A_RXPKT();
  
if (pktlen!=0)
  {   
   for (i=0;i<pktlen;i++)   
   {
     eebuffer[i]=SPI_buffer[i];
   };  
   
   if (strstr(SPI_buffer,"CHANGE")!=NULL)
   {
    if(z==0) {z=1;} 
    else {z=0;}
   }
   
   if(z==0)
   {
    Write_SPI_buffer("Status-IDLE");
   }
   
  else
   {
    Write_SPI_buffer("Status-SECUR");
   }
    delay_ms(30); 
    TR24A_TXPKT(); 

    while(PIND.3==0); 
   delay_ms(100); 
   GIFR=0x80;    //����� ����� ���������� 
   GICR=0x80;   // ���������� ����������
 }
 TR24A_RX();              // ������ � ����� RX
}
//*******************************************************************************************

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
 
//=============================================================================================
//*****************************�������� ������� ���������*************************************
//===============================================================================================

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=Out 
// State7=T State6=T State5=0 State4=T State3=0 State2=1 State1=T State0=1 
PORTB=0x05;
DDRB=0x2D;

// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=Out 
// State6=T State5=0 State4=0 State3=T State2=1 State1=T State0=1 
PORTC=0x05;
DDRC=0x35;

// Port D initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=1 State4=1 State3=T State2=P State1=T State0=T 
PORTD=0x34;
DDRD=0x30;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

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
// INT1 Mode: Rising Edge
GICR|=0x80;
MCUCR=0x0C;
GIFR=0x80;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 115200
UCSRA=0x00;
UCSRB=0x98;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x01;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI Type: Master
// SPI Clock Rate: 28,800 kHz
// SPI Clock Phase: Cycle Half
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x57;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;
 // Global enable interrupts
#asm("sei")
 
LightDiode(1);    //������ ���������
/************** ******************* ��������� ������*****************************************/
m0: PORTC.0=0;       // ��������� ������
 delay_ms(1000);
 PORTC.0=1;
 delay_ms(250);
 if (PINC.1==0) goto m0;   // �������� ��������� ������  
 USART_ON() ; //  ��������� USART
         
m1:      SEND_Str("AT\r");  // �������� ������ ������
      
      if (TEST_OK()==0) goto m1 ;
        LightDiode(0);
         
m2:    SEND_Str("AT+CREG?\r");   // �������� ����������� � ����
          
      if (REG_NET()!='1')
      {
      delay_ms(1000);
      goto m2;
      }  
  
    
m3:      SEND_Str("AT+CPBF=\"N\"\r");  // ���������� ����������� ������ � SIM �����
      if (SET_NR()==0) goto m3;      // �������������� ������ � PDU ������
  USART_OFF() ;  //  ���������� USART
  LightDiode(0); 
//==========================================================================================  
//*************************��������� ����������**********************************************
  LightDiode(3);
mx0: TR24A_INIT();  // ������������� ����������
     if(Error=='E') goto mx0;   // ���� ������������� �������� ������� � ������
     TR24A_RX();              // ������ � ����� RX
  
     for (i=0;i<64;i++) {
     eebuffer[i]=0xFF;
    };

 
//============================================================================================  

 z=1; // ��������� ������ ������
  

while (1)
      { 

       while((PIND.2==1)||(z==0))  // ���� ���� ����� �������
       { 
       if (z==0){LightDiode(0);}
       else {LightDiode(2);}
       }
       while((PIND.2==0) || (z==0) )           // ���� ���� ����� �������
       {
       if (z==0){LightDiode(0);}
       else {LightDiode(1);}
       }  
       
       USART_ON() ;
m4:    SEND_Str("AT+CMGF=0\r");     // ��������� PDU ������ 
       if (TEST_OK()==0) goto m4 ; 
       
       
       
       
m5:   SEND_Str("AT+CMGS=39\r");  //    ���� ������� �������� ���������
     
      if (strrchr(rx_buffer, '>')==NULL)
      {CLEAR_BUF();
      goto m5;}
      CLEAR_BUF();    
      
      SEND_Str("0001000B91");     // ���� �������� PDU
      
      for(i=0;i<12;i++)            // ���� ������
      {UART_Transmit(NR[i]);}
      
       SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // ���� ������ ��������� 
       CLEAR_BUF();
      
          /*
      SEND_Str("AT+CPBF=\"N\"\r");
      delay_ms(1000);
       #asm("cli")
      for (i=0; i<255; i++)    // ������ ������ ������ � eeprom
      {eebuffer[i]=rx_buffer[i];} 
              */
      }
}
