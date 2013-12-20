/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DS(NEW)
Version : 
Date    : 01.01.2002
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
 0x0006, //0 IOGFG2 ����������� �������
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
#define RX_BUFFER_SIZE 512
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256

#else
unsigned int rx_wr_index;
#endif
 char NR[12];     // ������ ����������� �����


     // ����������� ���������� ����������
char z;          //���������� ������� ������ 

unsigned int i; //�������

unsigned char SPI_buffer[64];
unsigned char *x;

eeprom unsigned char OP;


eeprom unsigned char COUNT;
eeprom unsigned char STAT[256];
//*******************************************************************************************
//+++++++++++++++�������+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//********************************************************************************************
void LightDiode(unsigned char n) // ������� ���������� �����������
{
 switch (n)
 {
 case 'T':
			{
			PORTC.4=0;
            PORTC.5=0;	
				break;
			} 
 case 'R':
			{
			PORTC.4=1;
            PORTC.5=0;		
				break;
			} 
 case 'G':
			{
			PORTC.4=0;
            PORTC.5=1;		
				break;
           }
 case 'O':
			{
			PORTC.4=1;
            PORTC.5=1;		
				break;
			} 			             
 }

}
//==================������� ��� ������ � �������============================================
//******************************************************************************************
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
  // #asm("wdr") 
   
}
//**********************************************************************************************************
  char TEST_OK(void)     // ������� �������� ������ �� �� �������
  {
  char c;
  char *d;
  char OK[]="OK";
  d=strstr(rx_buffer, OK);
  c=*d; 
 // #asm("wdr")
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
 // #asm("wdr")
  CLEAR_BUF();
  return c;
  }
//********************************************************************************************
void RESET_MODEM(void)    // ����� ������ 
 {//LightDiode('O');
  do { 

  if (PINC.1==0)  
  {
  PORTC.0=0;       // ��������� ������
  delay_ms(1000);
  PORTC.0=1;
  delay_ms(250);
   }  
   
   else
   {
    PORTC.2=0;       // ����� ������
  delay_ms(100);
  PORTC.2=1;
  delay_ms(1000);
   }   
   
    } while(PINC.1==0);   // �������� ��������� ������ 

   
    do{      SEND_Str("AT\r");  // �������� ������ ������
        // #asm("wdr")
      } while(TEST_OK()==NULL)  ; 
              
 do{   SEND_Str("AT+CREG?\r");   // �������� ����������� � ���� 
       // #asm("wdr")
      delay_ms(1000); 
     // #asm("wdr")   
      }while (REG_NET()!='1') ;  
      
              

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
// ������� �������� ��������
 void BALLANSE(void)
 {   unsigned char S;
   // char XY[2];
    unsigned char *s1, *s2;
    delay_ms(4000);
    CLEAR_BUF();
  do
   { if(OP==0) SEND_Str("AT+CUSD=1,\"*100#\"\r"); //������� ������� ��������
     else SEND_Str("AT+CUSD=1,\"*102#\"\r");
   delay_ms(500);
   #asm("wdr") 
    }while(TEST_OK()==0);
    for(i=0;i<5;i++)
    {
     if(strstr(rx_buffer, "+CUSD:")!=NULL) break;   //�������� ������ �� ������ 
     #asm("wdr")
     delay_ms(1000);
     #asm("wdr")
    }
    s1=strstr(rx_buffer, "04110430043B0430043D0441");
    if(s1!=NULL)
    {
    s2=strstr(rx_buffer, "0440");
    S=((s2-s1+4)/2)+13; 
   // sprintf(XY, "%02d", S); 
   // XX[0]=XY[0];
   // XX[1]=XY[1];
    
    printf("AT+CMGS=%02d\r",S) ;
    delay_ms(100);
    #asm("wdr")
     SEND_Str("0001000B91");     // ���� �������� PDU
      
      for(i=0;i<12;i++)            // ���� ������
      {UART_Transmit(NR[i]);}
      S=S-13;
      printf("0008%02X", S);
      s2=s2+4;
      do{
       UART_Transmit(*s1);
       s1++;
      }while(s1!=s2);
      UART_Transmit(0x1A);
             /*
      delay_ms(1000);
  for (i=0; i<256; i++)    // ������ ������ ������ � eeprom
      {eebuffer[i]=rx_buffer[i];} 
             */
      }
      CLEAR_BUF();
 }  
 //*********************************************************************************************
 char CALL(unsigned char nom)
 { unsigned char NOM[12];
   char *d1;
   char s;
switch (nom)
    {
     case 1:
			{
			    SEND_Str("AT+CPBF=\"N1\"\r");
				break;
			} 
             
     case 2:
			{
			    SEND_Str("AT+CPBF=\"N2\"\r");
				break;
			}        
            
     case 3:
			{
			    SEND_Str("AT+CPBF=\"N3\"\r");
				break;
			}        
            
     case 4:
			{
			    SEND_Str("AT+CPBF=\"N4\"\r");
				break;
			} 
                   
     case 5:
			{
			    SEND_Str("AT+CPBF=\"N5\"\r");
				break;
			} 
                   
     case 6:
			{
			    SEND_Str("AT+CPBF=\"N6\"\r");
				break;
			} 
                   
            
    } 
    delay_ms(100);
    d1=strstr(rx_buffer, ",\"+7");
    if(d1!=NULL)
    {
     d1=d1+2;
     for(i=0;i<12;i++)
      { NOM[i]=*d1;
       d1=d1+1;
      }
    } 
    
    else {s=0;
     return s; }
    CLEAR_BUF(); 
   SEND_Str("AT+CSTA=145\r"); 
   delay_ms(100);
   SEND_Str("AT*PSSTKI=1\r");
   delay_ms(100);
   SEND_Str("ATD\"");     
   for(i=0;i<12;i++) UART_Transmit(NOM[i]);
   SEND_Str("\";\r"); 
   delay_ms(15000); 
    CLEAR_BUF();
 }
 //**********************************************************************************************
  char SEND_SMS(unsigned char nom)
  
  {      //unsigned char NOM[12];
   //char *d;
   char s;
switch (nom)
    {
     case 1:
			{
			    SEND_Str("AT+CPBF=\"N1\"\r");
				break;
			} 
             
     case 2:
			{
			    SEND_Str("AT+CPBF=\"N2\"\r");
				break;
			}        
            
     case 3:
			{
			    SEND_Str("AT+CPBF=\"N3\"\r");
				break;
			}        
            
     case 4:
			{
			    SEND_Str("AT+CPBF=\"N4\"\r");
				break;
			} 
                   
     case 5:
			{
			    SEND_Str("AT+CPBF=\"N5\"\r");
				break;
			} 
                   
     case 6:
			{
			    SEND_Str("AT+CPBF=\"N6\"\r");
				break;
			} 
                   
            
    } 
    delay_ms(100);

   if(SET_NR()==0) {s=0; return s; } 

    do{SEND_Str("AT+CMGF=0\r");     // ��������� PDU ������ 
       }while(TEST_OK()==0); 
     
    do{ CLEAR_BUF();
     SEND_Str("AT+CMGS=39\r");  //    ���� ������� �������� ���������    
      }while (strrchr(rx_buffer, '>')==NULL);
      CLEAR_BUF();
     
      SEND_Str("0001000B91");     // ���� �������� PDU 
           
      for(i=0;i<12;i++)            // ���� ������
      {UART_Transmit(NR[i]);}      
       SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // ���� ������ ��������� 
        CLEAR_BUF();
       delay_ms(5000);
    
  }
 //==================������� ��� ������ � �����������============================================
 //*******************************************************************************************
 unsigned char SPI_SEND(unsigned char data)  // ��������/������� ����  �� SPI
{
SPDR = data;
		while (!(SPSR & (1<<SPIF)));
		return SPDR;
}


//********************************************************************************************
 void RESET_TR(void) //����� ���������� �� ��������� �������
{
SPCR=0x00; //���������� SPI
PORTB.5=1; //������������� 1 �� SCK
PORTB.3=0;  // ������������� 0 �� MOSI
PORTB.2=0; // SPI_SS ON
delay_us(1);
PORTB.2=1; // SPI_SS OFF
delay_us(40);
SPCR=0x50; //��������� SPI
PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
SPI_SEND(SRES);
PORTB.2=1; // SPI_SS OFF
}
//*******************************************************************************************
void WRITE_REG( unsigned int reg) // ������� ������ ��������
{  union U dat;
PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
 
 dat.buf=reg;
 SPI_SEND(dat.b[1]);  //����� �������� 
 SPI_SEND(dat.b[0]);  //�������� �������� 
PORTB.2=1; // SPI_SS OFF
}
//*******************************************************************************************
//********************************************************************************************
unsigned char READ_REG(unsigned char adr)  // ������� ������ ��������
{  unsigned char reg;
  PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
   SPI_SEND(adr | 0x80);   // ������� ��� ���������� ��������  
   reg= SPI_SEND(0x00);
   return reg; 
PORTB.2=1; // SPI_SS OFF
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
PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
WRITE_REG(0x3EC0);         //������ �������� �������� �������� ����������� +10dbm
  PORTB.2=1; // SPI_SS OFF 
}
//*********************************************************************************************
void STROB(unsigned char strob)  //������ �����-�������
{
PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
 SPI_SEND(strob);
  PORTB.2=1; // SPI_SS OFF 
}
//******************************************************************************************
unsigned char STATUS(void)  //��������� ������� ����������
{ unsigned char st;
PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
st=SPI_SEND(SNOP);
 PORTB.2=1; // SPI_SS OFF
return st; 
}
//********************************************************************************************
void SEND_PAKET(unsigned char pktlen) //������� �������� ������
{
  STROB(SIDLE);  //������� � ����� IDLE
  STROB(SFRX);  //������� ��������� ������
  STROB(SFTX); //������� ����������� ������
  delay_ms(1);
  PORTB.2=0; // SPI_SS ON
  while(PINB.4==1); //���� 0 �� MISO
  SPI_SEND(0x7F);   //�������� ������ �� ������
  SPI_SEND(pktlen); //������ ������ ������
  for (i=0;i<pktlen;i++)  //������ ������
  {
   SPI_SEND(SPI_buffer[i]); 
  }
  PORTB.2=1; // SPI_SS OFF 
  GICR=0x40; //������ ���������� �� ������ ������
  STROB(STX); //��������� ��������
  
  while(PIND.3==0); //�������� ������ ��������
  while(PIND.3==1); //�������� ����� ��������
  STROB(SIDLE);  //������� � ����� IDLE
  STROB(SFRX);  //������� ��������� ������
  STROB(SFTX); //������� ����������� ������
  GIFR|=0x80;  //����� ����� ����������
  GICR=0xC0;   //���������� ���������� �� ������ ������
}
//********************************************************************************************
unsigned char RECEIVE_PAKET(void) //������� ������ ������
{
unsigned char pktlen;
STROB(SIDLE);  //������� � ����� IDLE
PORTB.2=0; // SPI_SS ON
while(PINB.4==1); //���� 0 �� MISO
SPI_SEND(0xFF);  //�������� ������ ������
pktlen=SPI_SEND(0x00); //���������� ������ ������
for (i=0;i<pktlen;i++)    //���������� ������
   {
   SPI_buffer[i]=SPI_SEND(0x00);
   } 
PORTB.2=1; // SPI_SS OFF 
STROB(SFRX);
return pktlen; //������� ������ ������   
 } 
 //*******************************************************************************************
 void CLEAR_SPI_buffer(void) //������� SPI ������
 { for (i=0;i<64;i++)
   {
    SPI_buffer[i]=0x00;
   }
 }
 //********************************************************************************************
  // ������ ������ � SPI ������
 unsigned char Write_SPI_buffer(flash char *str)
 {
  i=0;
  while(*str)
  {
  SPI_buffer[i++]=*str++;
  
  }
 return i;
  }
//********************************************************************************************

//+++++++++++++++����������+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//********************************************************************************************
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void) //���������� �� �������� �������
{   GICR=0x80;
    delay_ms(200);

   if ((z==0x0F)&&(PIND.2==1))
   {  //LightDiode('G');
    #asm("sei") 
    
             for (i=0;i<5;i++)
       {delay_ms(300);
       LightDiode('G');
       delay_ms(300);
       LightDiode('R');
       } 
         //delay_ms(10);
         
                 /*
                   
        SEND_Str("AT+CSTA=145\r"); 
        delay_ms(100);
         SEND_Str("AT*PSSTKI=1\r");
        delay_ms(100); 
        SEND_Str("AT*PSCSSC=1\r");
         delay_ms(100);
        SEND_Str("ATD\"+79132425434\";\r");  
                       */
                       /* 
      do{SEND_Str("AT+CMGF=0\r");     // ��������� PDU ������ 
       }while(TEST_OK()==0); 
     
    do{ CLEAR_BUF();
     SEND_Str("AT+CMGS=39\r");  //    ���� ������� �������� ���������    
      }while (strrchr(rx_buffer, '>')==NULL);
      CLEAR_BUF();
     
      SEND_Str("0001000B91");     // ���� �������� PDU 
           
      for(i=0;i<12;i++)            // ���� ������
      {UART_Transmit(NR[i]);}      
       SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // ���� ������ ��������� 
                       */
                        
        SEND_SMS(1);
        CALL(1);
                /*
       delay_ms(25000);
         for(i=0;i<256;i++)
        {
        STAT[i]=rx_buffer[i];
        }     
               */
       
       for (i=0;i<5;i++)
       {delay_ms(300);
       LightDiode('G');
       delay_ms(300);
       LightDiode('R');
       } 
       
   }
   
    GIFR|=0x40;
    GICR=0xC0;
}
//********************************************************************************************
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)   //���������� �� ������ ������
{
unsigned char len;
while(PIND.3==1);
len=RECEIVE_PAKET();
 if (strstr(SPI_buffer,"BRELOK1")!=NULL)  
 
    {   
     if(strstr(SPI_buffer,"CHANGE")!=NULL) 
      {if(z==0x0F) z=0x00;
      else z=0x0F;}  
     
     
    CLEAR_SPI_buffer();
    STROB(SIDLE);
    STROB(SFRX);
    STROB(SFTX);
    if (z==0x0F )
    {len=Write_SPI_buffer("SECUR");
     LightDiode('R');}
    else {len=Write_SPI_buffer("IDLE");
        LightDiode('G');}
   delay_ms(3); 
   SEND_PAKET(len); 
   delay_ms(1); 
   }
   STROB(SRX);
   CLEAR_SPI_buffer(); 
   
}

//********************************************************************************************
/// ������� ��������� ���������� �� ������ ������� USART
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   if (rx_wr_index != RX_BUFFER_SIZE) rx_buffer[rx_wr_index++]=data;

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
// Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=0 State2=1 State1=T State0=T 
PORTB=0x04;
DDRB=0x2C;

// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=Out 
// State6=T State5=0 State4=0 State3=T State2=1 State1=T State0=1 
PORTC=0x05;
DDRC=0x35;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=T 
PORTD=0x04;
DDRD=0x02;

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
// INT0: On
// INT0 Mode: Rising Edge
// INT1: On
// INT1 Mode: Rising Edge
GICR|=0xC0;
MCUCR=0x0F;
GIFR=0xC0;

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
// SPI Clock Rate: 921,600 kHz
// SPI Clock Phase: Cycle Start
// SPI Clock Polarity: Low
// SPI Data Order: MSB First
SPCR=0x50;
SPSR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

#asm("cli")
LightDiode('G');
delay_ms(1000);
for(i=0;i<256;i++) STAT[i]=0xFF;
//==============================================������������� ����������================================================================
 RESET_TR(); 
 delay_ms(10);     
 INIT_TR();
 WRITE_PATABLE(); 
 STROB(SIDLE);
 STROB(SFRX);
 STROB(SFTX);
 STROB(SRX); 
 delay_ms(1);
 GIFR|=0x80;
// Global enable interrupts
#asm("sei")
//============================================������������� ������======================================================================

 RESET_MODEM(); 
 
   do{ SEND_Str("AT+COPS?\r");     //����������� ��������� ������� �����
  delay_ms(50);
  }while(strstr(rx_buffer, "+COPS:")==NULL);    
 if( strstr(rx_buffer, "Beeline")!=NULL ) OP=1;
  else OP=0;
   CLEAR_BUF(); 
           /*
   
    do{     SEND_Str("AT+CPBF=\"N1\"\r");  // ���������� ����������� ������ � SIM ����� 
       #asm("wdr")
      } while(SET_NR()==0);      // �������������� ������ � PDU ������  
          
   CALL(1);
            */ 
            LightDiode('R'); 
            
            
            
          SEND_Str("AT+CLIP=1\r"); 
           CLEAR_BUF();  
       for(i=0;i<30;i++)
       {
        if( strstr(rx_buffer, "RING")!=NULL)
         {  delay_ms(300);
         SEND_Str("ATH\r");
         delay_ms(5000);
         break;
         }
        delay_ms(1000);
       }  
          
        x=strstr(rx_buffer, "\"+7");
        
        if(x!=NULL)
        {
          x=x+1;
         for(i=0;i<12;i++)
          {NR[i]=*x;
           x=x+1;
          }
            
        CLEAR_BUF(); 
        delay_ms(300);  
        
        SEND_Str("AT+CPBF=\"N1\"\r");     
        delay_ms(300); 
        // SEND_Str("AT+CPBF=\"N2\"\r"); 
         
         if(strstr(rx_buffer, NR)==NULL)
          {
           SEND_Str("AT+CPBW=1,\""); 
            for(i=0;i<12;i++)            // ���� ������
            {UART_Transmit(NR[i]);}
            SEND_Str("\",145,\"N1\"\r");
            for(i=0;i<5;i++)
            { LightDiode('R'); 
              delay_ms(300);
              LightDiode('G');
              delay_ms(300);
            }
          }
         else{
           for(i=0;i<5;i++)
            { LightDiode('T'); 
              delay_ms(300);
              LightDiode('R');
              delay_ms(300);
            }
         
         } 
        }
         delay_ms(100); 
        SEND_Str("AT+CPBS?\r"); 
        
        
        
        
                 
    delay_ms(15000);
         for(i=0;i<256;i++)
        {
        STAT[i]=rx_buffer[i];
        }   
                     
 //=====================================================================================================================================
        z=0x00;
        LightDiode('G'); 
   
        
          /*
        for(i=0;i<256;i++)
        {
        STAT[i]=rx_buffer[i];
        }
             */
       
        
while (1)
      {
      // Place your code here

      }
}
