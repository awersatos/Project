/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Brelok
Version : 1
Date    : 20.10.2011
Author  : Alexandr Gordejchik
Company : NTS
Comments: 


Chip type               : ATtiny2313A
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313a.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>

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

union U            //����������� 2 ����������
		{
			unsigned int buf;
			unsigned char b[2];
		};
                    /*���������� ���������� ����������*/
unsigned char i; //�������
char SPI_buffer[32]={"BRELOK-SEND\x00"};  // ������ ������
//char SPI_buffer2[12];

unsigned char pktlen;
char Error; //���� ������  
//eeprom char eebuffer[64];
flash unsigned char CH=78; //����� ������ 
flash unsigned char SW=9; // �������� �������
   
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
//*******************************************************************************************
void LightDiode(unsigned char n) // ������� ���������� �����������
{
 switch (n)
 {
 case 0:
			{
			PORTB.3=0;
            PORTB.4=0;	
				break;
			} 
 case 1:
			{
			PORTB.3=1;
            PORTB.4=0;		
				break;
			} 
 case 2:
			{
			PORTB.3=0;
            PORTB.4=1;		
				break;
 case 3:
			{
			PORTB.3=1;
            PORTB.4=1;		
				break;
			} 			}             
 }

}
//*********************************************************************************************
// ������� �������� ������� �� SPI
unsigned char SPI_SEND(unsigned char data)
{
 USIDR=data;      // �������� ������ � ��������� �������
 USISR=(1<<USIOIF);  // ������� ����� ������������ � 4-������� ��������
 TIFR |= (1<<OCF0A);   // ������� ����� ���������� �� ���������� �������
 TIMSK |= (1<<OCIE0A); // ���������� ���������� �� ����������
 while(USISR.USIOIF==0); //�������� ����� �������� �����
 TIMSK=0x00;     //������ ����������
 return USIDR; // ������� ������
}
//***********************************************************************************************
//�������� � ������� ���������� ��������
	void TR24_Wrtie(unsigned char reg,unsigned int data)
	{
		
       union U dat;
	  dat.buf=data;

		PORTB.1=0;       // SPI_SS ON
		SPI_SEND(reg);    //�������
		delay_us(2);
		SPI_SEND(dat.b[1]);   //������� �����
		delay_us(2);
		SPI_SEND(dat.b[0]);   //������� �����
		delay_us(2);
		PORTB.1=1;     // SPI_SS OFF

	}//end writeByte
//**********************************************************************************************
 //������ �� �������� ����������
	unsigned int TR24A_Read(unsigned char reg)
	{

           union U dat;
		PORTB.1=0;       // SPI_SS ON
		SPI_SEND(reg |0x80);   //������� ��� ���������� ��������
		delay_us(2);
		dat.b[1]=SPI_SEND(0x0FF);
		delay_us(2);
		dat.b[0]=SPI_SEND(0x0FF);
		delay_us(2);
		PORTB.1=1;     // SPI_SS OFF

		return dat.buf;
	}//end readByte
//*********************************************************************************************
//������������� ����������
    void TR24A_INIT(void)
    {
    	        union U dt;
                /*
		chanel=76;   //����� �� ���������
		swallow=9;    //�������� ������� �� ���������
		Error.byte=0; //�������� ��� ������
		ProgCRC=0;    //����������� CRC ����
		TrState=0;    //���������� ����� ������ ����������, ���������� ��� ������ ������
                  */
	 unsigned char i; 
       
            
		for(i=0;i<30;i=i+3)				//������������� �����
		{
			dt.b[1]=tbl_frame[i+1];
			dt.b[0]=tbl_frame[i+2];
			TR24_Wrtie(tbl_frame[i],dt.buf);
		}

		delay_ms(5);
		for(i=0;i<54;i=i+3)		       //������������� �����������
		{
			dt.b[1]=tbl_rfinit[i+1];
			dt.b[0]=tbl_rfinit[i+2];
			TR24_Wrtie(tbl_rfinit[i],dt.buf);
		}
           Error='N';
		//��������� ������������ ������������� ����������

		for(i=0;i<54;i=i+3)
		{
			dt.buf=TR24A_Read(tbl_rfinit[i]);

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
			dt.buf=TR24A_Read(tbl_frame[i]);

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
//********************************************************************************************
//������� � ����� �������� �����
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
//******************************************************************************************** 

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
//********************************************************************************************
//����� �����
  unsigned char TR24A_RXPKT(void)
  {
   unsigned char len; //������ ������
   unsigned char j;   //�������

  PORTB.1=0;       // SPI_SS ON  
  
  SPI_SEND(0x50|(1<<7));   //reg80
  delay_us(3);
  len=SPI_SEND(0xFF);
  for(j=0;j<len;j++)  //�������� �����
		{
			delay_us(3);
			SPI_buffer[j] = SPI_SEND(0xFF);
		} 
  
  PORTB.1=1;     // SPI_SS OFF 
  return len;
  }      

       
//*********************************************************************************************
 //�������� ������
 void TR24A_TXPKT(void)
 {  
      TR24_Wrtie(0x52,0x8000); // ����� �������
      
      PORTB.1=0;       // SPI_SS ON
      delay_us(3);
      SPI_SEND(0x50);
      delay_us(3); 
      SPI_SEND(pktlen);
      for (i=0;i<pktlen;i++)
     {
       delay_us(3); 
      SPI_SEND(SPI_buffer[i]);
    };

      PORTB.1=1;       // SPI_SS OFF 
      TR24A_TX(); 
      delay_us(3);
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
// ���������� �� ���������� �������
interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{
USICR |= (1<<USITC); // ������� ��������� ��������

}
//***********************************************************************************************

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
// Func7=Out Func6=Out Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=0 State6=0 State5=T State4=0 State3=0 State2=1 State1=1 State0=T 
PORTB=0x06;
DDRB=0xDE;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=P State2=P State1=T State0=T 
PORTD=0x0C;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 4000,000 kHz
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
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Three Wire (SPI)
// Clock source: Reg.=ext. neg. edge, Cnt.=USITC
// USI Counter Overflow Interrupt: Off
USICR=0x1E;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

// Global enable interrupts
#asm("sei")
//============================================================================================
//*************************��������� ����������**********************************************
  LightDiode(3); 
    delay_ms(500);
  mx0:    PORTB.1=0;      // ����� ���������� ����� ��������������
      delay_ms(10);
      PORTB.1=1;
      delay_ms(5);   
       TR24A_INIT();  // ������������� ����������
       if(Error=='E') goto mx0;   // ���� ������������� �������� ������� � ������  
         
     //LightDiode(0); 
      
//=============================================================================================     
while (1)
      {
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
           
  Write_SPI_buffer("BRELOK"); 
   TR24A_TXPKT() ;
    for (i=0;i<25;i++)
    {
     if(PINB.0==1) break;
     delay_ms(1);
    }; 
  
 //  while(PINB.0==0); 
   
   TR24A_RX();
   for (i=0;i<25;i++)
    {
     if(PINB.0==1) break;
     delay_ms(1);
    };

     if(PINB.0==1)
     {  pktlen=TR24A_RXPKT();
      if (strstr(SPI_buffer,"DEVICE")!=NULL)
   {             
                       
 //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++     
      
  if(PIND.2==0) Write_SPI_buffer("CHANGE");
  /* if(PIND.3==0)*/ else Write_SPI_buffer("READ");
  
  TR24A_TXPKT() ;
                
   for (i=0;i<25;i++)
    {
     if(PINB.0==1) break;
     delay_ms(1);
    };
 // while(PINB.0==0);
  
   TR24A_RX(); 
    for (i=0;i<25;i++)
    {
     if(PINB.0==1) break;
     delay_ms(1);
    };

     if(PINB.0==1)
   {  
  // delay_ms(6);
      pktlen=TR24A_RXPKT();
     if(pktlen!=0) 
  {         
     
     if (strstr(SPI_buffer,"Status")!=NULL)
     {
      if(strstr(SPI_buffer,"SECUR")!=NULL) { LightDiode(2);
                                            while(1);
                                            }
                                            
        if(strstr(SPI_buffer,"IDLE")!=NULL) { LightDiode(1);
                                            while(1);
                                            }                                     
     }
     }
          }
//+++++++++++  
     
   }    
 }     
     
 //+++++++++++++
     // delay_ms(100);
      goto mx0;
      }   
      
}
