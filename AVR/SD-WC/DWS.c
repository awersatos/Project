/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DWS
Version : 
Date    : 06.07.2012
Author  : Alexandr Gordejchik
Company : NTS
Comments: 


Chip type               : ATmega164PV
Program type            : Application
AVR Core Clock frequency: 3,686400 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega164.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <spi.h>

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
         
union U1
        {
         unsigned char byte; 
         // bit Bit[8];
              
         struct{
                     
			unsigned char b0:1;
			unsigned char b1:1;
			unsigned char b2:1;
			unsigned char b3:1;
			unsigned char b4:1;
			unsigned char b5:1;
			unsigned char b6:1;
			unsigned char b7:1;
			        
		    } Bit;
         
         struct{
                     
			unsigned char l4:2;
			unsigned char l3:2;
			unsigned char l2:2;
			unsigned char l1:2;			
			        
		    }Led;   
            
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

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 512
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0;
#else
unsigned int rx_wr_index0;
#endif


unsigned char NR[12];     // ������ ����������� �����

// ����������� ���������� ����������
//char z;          //���������� ������� ������ 
unsigned int i; //��������  �������
unsigned char j; //�������
unsigned char SPI_buffer[64];
unsigned char PGM=0;
unsigned char *x;
eeprom union U1 LD1;
eeprom union U1 LD2;
eeprom union U1 LD3;

eeprom unsigned char DAT1[]="026026";
eeprom unsigned char DAT2[]="128128";
eeprom unsigned char DAT3[]="256256";
eeprom unsigned char DAT4[]="FFFFFF";
eeprom unsigned char DAT5[]="FFFFFF";
eeprom unsigned char DAT6[]="FFFFFF";
eeprom unsigned char DAT7[]="FFFFFF";
eeprom unsigned char DAT8[]="FFFFFF";

eeprom unsigned char BREL1[]="164164";
eeprom unsigned char BREL2[]="250250";
eeprom unsigned char BREL3[]="FFFFFF";
eeprom unsigned char BREL4[]="FFFFFF";
eeprom unsigned char BREL5[]="FFFFFF";
eeprom unsigned char BREL6[]="FFFFFF";

eeprom unsigned char OP;
eeprom unsigned char COUNT;
eeprom unsigned char STAT[256];


//======================================================================================================================================
//========================================�������===================================================================================
//=====================================================================================================================================
void LOAD_LD(void)  //�������� ��������� �����������

{
union U1 LD;


PORTA.4=0;
 LD.byte=LD3.byte;
for (i=0;i<8;i++)
  {
   PORTA.2=LD.Bit.b0;
   LD.byte= LD.byte>>1;
   delay_ms(1);
   PORTA.3=1; 
   delay_ms(1);
   PORTA.3=0;
  }
 LD.byte=LD2.byte; 
for (i=0;i<8;i++)
  {
   PORTA.2=LD.Bit.b0;
   LD.byte= LD.byte>>1;
   delay_ms(1);
   PORTA.3=1; 
   delay_ms(1);
   PORTA.3=0;
  }
 LD.byte=LD1.byte; 
for (i=0;i<8;i++)
  {
   PORTA.2=LD.Bit.b0;
   LD.byte=LD.byte>>1;
   delay_ms(1);
   PORTA.3=1; 
   delay_ms(1);
   PORTA.3=0;
  } 
 PORTA.5=1; //�������� ��� ����������
 PORTA.4=1; 
 delay_ms(1);
 PORTA.4=0;
 PORTA.5=0; //������ ����������   
}
//*********************************************************************************************
 char VALID_CODE(char *str1, eeprom char *str2, char n) //������� �������� ����
{  char e;
    e=0;
 for(i=0;i<n;i++)
   
  {  if((*str1++)!=(*str2++))
     { e=NULL; 
        break;}
     else e=e+1;
   // STAT[i]=*str2++;
  }
  
  return e;                    
}
//**************************************************************************************************
void PROGRAM_DAT(char dev) //������� ��������������� �������
{ if(dev=='D') 
{
 if (VALID_CODE(x,DAT1,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT2,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT3,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT4,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT5,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT6,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT7,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,DAT8,6)!=NULL){PGM=0xFF; return;} 
 }
else if(dev=='B')
{
 if (VALID_CODE(x,BREL1,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,BREL2,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,BREL3,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,BREL4,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,BREL5,6)!=NULL){PGM=0xFF; return;}
 if (VALID_CODE(x,BREL6,6)!=NULL){PGM=0xFF; return;}
} 
 switch (PGM)
  {
   
   case 1 :{      
           for(i=0;i<6;i++) DAT1[i]=*x++;
           PGM=0xDF;
           break;
           }
   
    case 2 :{      
           for(i=0;i<6;i++) DAT2[i]=*x++;
           PGM=0xDF;
           break;
           }
   
    case 3 :{      
           for(i=0;i<6;i++) DAT3[i]=*x++;
           PGM=0xDF;
           break;
           }
   
    case 4 :{      
           for(i=0;i<6;i++) DAT4[i]=*x++;
           PGM=0xDF;
           break;
           }
   
    case 5 :{      
           for(i=0;i<6;i++) DAT5[i]=*x++;
           PGM=0xDF;
           break;
           }
   
     case 6 :{      
           for(i=0;i<6;i++) DAT6[i]=*x++;
           PGM=0xDF;
           break;
           }
   
     case 7 :{      
           for(i=0;i<6;i++) DAT7[i]=*x++;
           PGM=0xDF;
           break;
           }
   
   
    case 8 :{      
           for(i=0;i<6;i++) DAT8[i]=*x++;
           PGM=0xDF;
           break;
           }
   
   case 11 :{      
           for(i=0;i<6;i++) BREL1[i]=*x++;
           PGM=0xDF;
           break;
           }
   
    case 12 :{      
           for(i=0;i<6;i++) BREL2[i]=*x++;
           PGM=0xDF;
           break;
           } 
           
     case 13 :{      
           for(i=0;i<6;i++) BREL3[i]=*x++;
           PGM=0xDF;
           break;
           } 
           
      case 14 :{      
           for(i=0;i<6;i++) BREL4[i]=*x++;
           PGM=0xDF;
           break;
           }
          
       case 15 :{      
           for(i=0;i<6;i++) BREL5[i]=*x++;
           PGM=0xDF;
           break;
           }
           
        case 16 :{      
           for(i=0;i<6;i++) BREL6[i]=*x++;
           PGM=0xDF;
           break;
           }
   
   }
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
PORTB.7=1; //������������� 1 �� SCK
PORTB.5=0;  // ������������� 0 �� MOSI
PORTB.4=0; // SPI_SS ON
delay_us(1);
PORTB.4=1; // SPI_SS OFF
delay_us(40);
SPCR=0x50; //��������� SPI
PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
SPI_SEND(SRES);
PORTB.4=1; // SPI_SS OFF
}
//*******************************************************************************************
void WRITE_REG( unsigned int reg) // ������� ������ ��������
{  union U dat;
PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
 
 dat.buf=reg;
 SPI_SEND(dat.b[1]);  //����� �������� 
 SPI_SEND(dat.b[0]);  //�������� �������� 
PORTB.4=1; // SPI_SS OFF
}
//*******************************************************************************************
//********************************************************************************************
unsigned char READ_REG(unsigned char adr)  // ������� ������ ��������
{  unsigned char reg;
  PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
   SPI_SEND(adr | 0x80);   // ������� ��� ���������� ��������  
   reg= SPI_SEND(0x00);
   return reg; 
PORTB.4=1; // SPI_SS OFF
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
PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
WRITE_REG(0x3EC0);         //������ �������� �������� �������� ����������� +10dbm
  PORTB.4=1; // SPI_SS OFF 
}
//*********************************************************************************************
void STROB(unsigned char strob)  //������ �����-�������
{
PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
 SPI_SEND(strob);
  PORTB.4=1; // SPI_SS OFF 
}
//******************************************************************************************
unsigned char STATUS(void)  //��������� ������� ����������
{ unsigned char st;
PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
st=SPI_SEND(SNOP);
 PORTB.4=1; // SPI_SS OFF
return st; 
}
//********************************************************************************************
              
void SEND_PAKET(unsigned char pktlen) //������� �������� ������
{
  STROB(SIDLE);  //������� � ����� IDLE
  STROB(SFRX);  //������� ��������� ������
  STROB(SFTX); //������� ����������� ������
  delay_ms(1);
  PORTB.4=0; // SPI_SS ON
  while(PINB.6==1); //���� 0 �� MISO
  SPI_SEND(0x7F);   //�������� ������ �� ������
  SPI_SEND(pktlen); //������ ������ ������
  for (i=0;i<pktlen;i++)  //������ ������
  {
   SPI_SEND(SPI_buffer[i]); 
  }
  PORTB.4=1; // SPI_SS OFF 
  PCICR=0x04; //������ ���������� �� ������ ������
  STROB(STX); //��������� ��������
  
  while(PINA.0==0); //�������� ������ ��������
  while(PINA.0==1); //�������� ����� ��������
  STROB(SIDLE);  //������� � ����� IDLE
  STROB(SFRX);  //������� ��������� ������
  STROB(SFTX); //������� ����������� ������
  PCIFR|=0x04;  //����� ����� ����������
  PCICR=0x05;   //���������� ���������� �� ������ ������
}
                  
//********************************************************************************************
unsigned char RECEIVE_PAKET(void) //������� ������ ������
{
unsigned char pktlen;
STROB(SIDLE);  //������� � ����� IDLE
PORTB.4=0; // SPI_SS ON
while(PINB.6==1); //���� 0 �� MISO
SPI_SEND(0xFF);  //�������� ������ ������
pktlen=SPI_SEND(0x00); //���������� ������ ������
for (i=0;i<pktlen;i++)    //���������� ������
   {
   SPI_buffer[i]=SPI_SEND(0x00);
   } 
PORTB.4=1; // SPI_SS OFF 
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
//***********************************************************************************
//==================������� ��� ������ � �������============================================
//******************************************************************************************
void UART_Transmit(char data) // ������� �������� ������� ����� UART
{  
while (!(UCSR0A & (1<<UDRE0))) {};
UDR0=data;
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

for (i=0;i<RX_BUFFER_SIZE0;i++) {
      rx_buffer0[i]=0;
    };
   rx_wr_index0=0;
  // #asm("wdr") 
   
}
//**********************************************************************************************************
  char TEST_OK(void)     // ������� �������� ������ �� �� �������
  {
  char c;
  char *d;
  char OK[]="OK";
  d=strstr(rx_buffer0, OK);
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
  d=strstr(rx_buffer0, REG);
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

  if (PINB.1==0)  
  {
  PORTB.0=0;       // ��������� ������
  delay_ms(1000);
  PORTB.0=1;
  delay_ms(250);
   }  
   
   else
   {
    PORTB.2=0;       // ����� ������
  delay_ms(100);
  PORTB.2=1;
  delay_ms(1000);
   }   
   
    } while(PINB.1==0);   // �������� ��������� ������ 

   
    do{      SEND_Str("AT\r");  // �������� ������ ������
        // #asm("wdr")
      } while(TEST_OK()==NULL)  ; 
              
 do{   SEND_Str("AT+CREG?\r");   // �������� ����������� � ���� 
       // #asm("wdr")
      delay_ms(1000); 
     // #asm("wdr")   
      }while (REG_NET()!='1') ;  
      
    
          SEND_Str("AT+CLIP=1\r"); 
           CLEAR_BUF();               

 }


//**********************************************************************************************************
char SET_NR(void) // ������� ���������� ����������� ������ � SIM �����
{
char c;
char *d;

d=strstr(rx_buffer0, ",\"+7");
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
     if(strstr(rx_buffer0, "+CUSD:")!=NULL) break;   //�������� ������ �� ������ 
     #asm("wdr")
     delay_ms(1000);
     #asm("wdr")
    }
    s1=strstr(rx_buffer0, "04110430043B0430043D0441");
    if(s1!=NULL)
    {
    s2=strstr(rx_buffer0, "0440");
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
    #asm("sei")
   LD3.Led.l1=2;
   LOAD_LD();
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
    d1=strstr(rx_buffer0, ",\"+7");
    if(d1!=NULL)
    {
     d1=d1+2;
     for(i=0;i<12;i++)
      { NOM[i]=*d1;
       d1=d1+1;
      }
    } 
    
    else {s=0; 
    LD3.Led.l1=1;
     return s; }
    CLEAR_BUF(); 
   SEND_Str("AT+CSTA=145\r"); 
   delay_ms(100);
   SEND_Str("AT*PSSTKI=0\r");
   delay_ms(100);
   SEND_Str("ATD\"");     
   for(i=0;i<12;i++) UART_Transmit(NOM[i]);
   SEND_Str("\";\r"); 
   delay_ms(10000); 
    CLEAR_BUF(); 
   LD3.Led.l1=1;
   LOAD_LD();
 }
 //**********************************************************************************************
  char SEND_SMS(unsigned char nom, unsigned char ndat)
  
  {      //unsigned char NOM[12];
   //char *d;
   char s; 
  #asm("sei")
  LD3.Led.l1=2;
   LOAD_LD(); 
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

   if(SET_NR()==0) {s=0; LD3.Led.l1=1; return s; } 

    do{SEND_Str("AT+CMGF=0\r");     // ��������� PDU ������ 
       }while(TEST_OK()==0); 
     
    do{ CLEAR_BUF();
     SEND_Str("AT+CMGS=45\r");  //    ���� ������� �������� ��������� (39 ��� ����� �������)   
      }while (strrchr(rx_buffer0, '>')==NULL);
      CLEAR_BUF();
     
      SEND_Str("0001000B91");     // ���� �������� PDU 
           
      for(i=0;i<12;i++)            // ���� ������
      {UART_Transmit(NR[i]);} 
           
      // SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // ���� ������ ���������
      SEND_Str("00082004140430044204470438043A0020");
      switch (ndat)
      {
        case 1:
			{
			    SEND_Str("0031");
				break;
			} 
            
       case 2:
			{
			    SEND_Str("0032");
				break;
			}       
            
        case 3:
			{
			    SEND_Str("0033");
				break;
			}      
        case 4:
			{
			    SEND_Str("0034");
				break;
			} 
            
        case 5:
			{
			    SEND_Str("0035");
				break;
			}      
            
       case 6:
			{
			    SEND_Str("0036");
				break;
			}       
            
       case 7:
			{
			    SEND_Str("0037");
				break;
			}       
            
            
       case 8:
			{
			    SEND_Str("0038");
				break;
			}       
                 
            
               
       }
       SEND_Str("00200442044004350432043E04330430\x1A");
       delay_ms(3000);
     //  for(i=0;i<256;i++) STAT[i]=rx_buffer0[i];
        CLEAR_BUF();
       delay_ms(5000);
    LD3.Led.l1=1;
   LOAD_LD();   
  }
//*****************************************************************************************************************
unsigned char WRITE_NUMBER(unsigned char nr) //������� ���������������� ����������� ������
{ unsigned char povtor;
povtor=128;
 x=strstr(rx_buffer0, "\"+7");
 if(x!=NULL)
 { x++;
  for(i=0;i<12;i++) NR[i]=*x++;
   
  CLEAR_BUF();
  delay_ms(100);
  SEND_Str("AT+CPBF=\"N1\"\r");
  delay_ms(100);
  SEND_Str("AT+CPBF=\"N2\"\r");
  delay_ms(100);
  SEND_Str("AT+CPBF=\"N3\"\r");
  delay_ms(100);
  SEND_Str("AT+CPBF=\"N4\"\r");
  delay_ms(100);
  SEND_Str("AT+CPBF=\"N5\"\r");
  delay_ms(100);
  SEND_Str("AT+CPBF=\"N6\"\r");
  delay_ms(100);
  
  

    switch (nr)
    { 
   case 1:{  
           if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
         else {
           SEND_Str("AT+CPBW=1,\""); 
          for(i=0;i<12;i++) UART_Transmit(NR[i]);
           SEND_Str("\",145,\"N1\"\r");
           }
         break;
       }
       
    case 2:{  
           if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
         else {
           SEND_Str("AT+CPBW=2,\""); 
          for(i=0;i<12;i++) UART_Transmit(NR[i]);
           SEND_Str("\",145,\"N2\"\r");
           }
        break;
       }
       
      case 3:{  
           if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
         else {
           SEND_Str("AT+CPBW=3,\""); 
          for(i=0;i<12;i++) UART_Transmit(NR[i]);
           SEND_Str("\",145,\"N3\"\r");
           }
         break;
       }   
       
      case 4:{  
           if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
         else {
           SEND_Str("AT+CPBW=4,\""); 
          for(i=0;i<12;i++) UART_Transmit(NR[i]);
           SEND_Str("\",145,\"N4\"\r");
           }
         break;
       }   
       
       
       case 5:{  
           if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
         else {
           SEND_Str("AT+CPBW=5,\""); 
          for(i=0;i<12;i++) UART_Transmit(NR[i]);
           SEND_Str("\",145,\"N5\"\r");
           }
          break;
       } 
       
         case 6:{  
           if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
         else {
           SEND_Str("AT+CPBW=6,\""); 
          for(i=0;i<12;i++) UART_Transmit(NR[i]);
           SEND_Str("\",145,\"N6\"\r");
           }
          break;
       }
       
      
            
  }  
  return povtor;      
 }
 
} 
//======================================================================================================================================
//========================================����������===================================================================================
//=====================================================================================================================================
// Pin change 0-7 interrupt service routine
interrupt [PC_INT0] void pin_change_isr0(void) //���������� �� ����������
{   
unsigned char len;
// char *x;
PCICR=0x00;

while(PINA.1==1);

len=RECEIVE_PAKET();

x=strstr(SPI_buffer,"BRELOK");
 if (x!=NULL)   
   { x=x+6;
   if(PGM!=0) PROGRAM_DAT('B');
  else if((VALID_CODE(x,BREL1,6)!=NULL)||(VALID_CODE(x,BREL2,6)!=NULL)||(VALID_CODE(x,BREL3,6)!=NULL)||(VALID_CODE(x,BREL4,6)!=NULL)||(VALID_CODE(x,BREL5,6)!=NULL)||(VALID_CODE(x,BREL6,6)!=NULL)) 
   {  if(strstr(SPI_buffer,"CHANGE")!=NULL) 
      {if(LD3.Led.l2==1) LD3.Led.l2=2;
      else LD3.Led.l2=1;}  
     
     
     CLEAR_SPI_buffer();
     STROB(SIDLE);
     STROB(SFRX);
     STROB(SFTX);
     if (LD3.Led.l2==2 )
     {len=Write_SPI_buffer("SECUR");
      }
     else
     {len=Write_SPI_buffer("IDLE");
        }
    delay_ms(3); 
    SEND_PAKET(len); 
    delay_ms(1);
    } 
  }
  
   
   
   x=strstr(SPI_buffer,"DATCHIK");
 if(x!=NULL)  // �������� ����� ������
{   x=x+7;
 if(PGM!=0) PROGRAM_DAT('D'); //���� ������� ����� ���������������� �� ���������������� ������ 
 else  if(LD3.Led.l2==2)   //�������� ������ ������
{    
if((( VALID_CODE(x,DAT1,6))!=NULL)&&(LD1.Led.l1==1)) 
   {    
   

    LD1.Led.l1=2;
    LOAD_LD();
    SEND_SMS(1,1);
    CALL(1);
    LD1.Led.l1=1;
    LOAD_LD();
    
   }
   
if((( VALID_CODE(x,DAT2,6))!=NULL)&&(LD1.Led.l2==1)) 
   {    
   
    LD1.Led.l2=2;
    LOAD_LD();
    SEND_SMS(1,2);
    CALL(1);
    LD1.Led.l2=1;
    LOAD_LD();
    
   }   

if((( VALID_CODE(x,DAT3,6))!=NULL)&&(LD1.Led.l3==1)) 
   {    
   
    LD1.Led.l3=2;
     LOAD_LD();
    SEND_SMS(1,3);
    CALL(1);
     LD3.Led.l1=1;
     LOAD_LD();
    
   }
   
if((( VALID_CODE(x,DAT4,6))!=NULL)&&(LD1.Led.l4==1)) 
   {    
   
    LD1.Led.l4=2;
    LOAD_LD();
    SEND_SMS(1,4);
    CALL(1);
    LD1.Led.l4=1;
    LOAD_LD();
    
   }      
   
if((( VALID_CODE(x,DAT5,6))!=NULL)&&(LD2.Led.l1==1)) 
   {    
   

     LD2.Led.l1=2;
     LOAD_LD();
     SEND_SMS(1,5);
     CALL(1);
     LD2.Led.l1=1;
     LOAD_LD();
    
   } 
   
if((( VALID_CODE(x,DAT6,6))!=NULL)&&(LD2.Led.l2==1)) 
   {    
   

    LD2.Led.l2=2;
     LOAD_LD();
     SEND_SMS(1,6);
    CALL(1);
     LD2.Led.l2=1;
     LOAD_LD();
    
   }      
   
if((( VALID_CODE(x,DAT7,6))!=NULL)&&(LD2.Led.l3==1)) 
   {    
   

    LD2.Led.l3=2;
    LOAD_LD();
    SEND_SMS(1,7);
    CALL(1);
    LD2.Led.l3=1;
    LOAD_LD();
    
   }      
   
if((( VALID_CODE(x,DAT8,6))!=NULL)&&(LD2.Led.l4==1)) 
   {    
   

    LD2.Led.l4=2;
    LOAD_LD();
    SEND_SMS(1,8);
    CALL(1);
     LD2.Led.l4=1;
     LOAD_LD();
    
   }           
         
}               
}          
CLEAR_SPI_buffer();
STROB(SIDLE);
STROB(SFRX);
STROB(SFTX);     
STROB(SRX);
CLEAR_SPI_buffer();
delay_ms(500);
LOAD_LD();

PCIFR|=0x01; //���������� ���������� �� ������ ������
PCICR=0x05;
}
//**************************************************************************************************************************************

// Pin change 16-23 interrupt service routine
interrupt [PC_INT2] void pin_change_isr2(void)  //���������� �� ��������� ��������� ����������
{ 

PCICR=0x01;  
        
   switch (PINC)
  {
   
   case 0xFE :{
			
              delay_ms(1);
     if(PINC==0xFE)        
        {        
            
           for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD1.Led.l1==0) LD1.Led.l1=1;
              else LD1.Led.l1=0;
              LOAD_LD();
              break;
              }
             }   
         if(PINC==0xFE) //���������������� ������� 1
          { PGM=1;
           #asm("sei") 
           for(i=0;i<6;i++) DAT1[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD1.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l1=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)   
               {LD1.Led.l1=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l1=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l1=1; break; } 
            }
            PGM=0;
           }
         if(PINC==0x7E)  //���������������� ������� 1
         {  PGM=11;
           #asm("sei")
           for(i=0;i<6;i++) BREL1[i]='F'; //�������� ���� ������
           for(j=0;j<60;j++)
            {
            LD1.Led.l1=2;
            LD3.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l1=1;
            LD3.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
             if(PGM==0xFF)                                       
              {LD1.Led.l1=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l1=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l1=1; break; }
            }
          PGM=0;
         } 
         
         if(PINC==0xBE)  //���������������� ������ 1
         { #asm("sei")
          SEND_Str("AT+CPBW=1\r");
          delay_ms(30);
          CLEAR_BUF(); 
          for(j=0;j<60;j++)
            {
            LD1.Led.l1=2;
            LD3.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l1=1;
            LD3.Led.l1=1;
            LOAD_LD();
            delay_ms(250);
             if( strstr(rx_buffer0, "RING")!=NULL)
             {  delay_ms(300);
              SEND_Str("ATH\r");
              delay_ms(2000);
             if( WRITE_NUMBER(1)==NULL)LD3.Led.l1=2;
             else LD3.Led.l1=1;
             LOAD_LD();
              delay_ms(2000);
              LD3.Led.l1=1;
             CLEAR_BUF();
                break;
                }
            }
          
         }         
              }
             	
				break;
			 } 
             
              
   case 0xFD :{
			
              delay_ms(1);
     if(PINC==0xFD)        
        { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD1.Led.l2==0) LD1.Led.l2=1;
              else LD1.Led.l2=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0xFD)
          { PGM=2;
           #asm("sei") 
           for(i=0;i<6;i++) DAT2[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD1.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD1.Led.l2=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l2=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l2=1; break; } 
            }
            PGM=0;
           }
          
          if(PINC==0x7D)  //���������������� ������� 2
         {  PGM=12;
           #asm("sei")
           for(i=0;i<6;i++) BREL2[i]='F'; //�������� ���� ������
         
         
          for(j=0;j<60;j++)
            {
            LD1.Led.l2=2;
            LD3.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l2=1;
            LD3.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
             if(PGM==0xFF)
               {LD1.Led.l2=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l2=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l2=1; break; }   
            }
           PGM=0;
         }     
          if(PINC==0xBD)  //���������������� ������ 2
         { #asm("sei")
         SEND_Str("AT+CPBW=2\r");
          delay_ms(30);
          CLEAR_BUF(); 
          for(j=0;j<60;j++)
            {
            LD1.Led.l2=2;
            LD3.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l2=1;
            LD3.Led.l1=1;
            LOAD_LD();
            delay_ms(250); 
             if( strstr(rx_buffer0, "RING")!=NULL)
             {  delay_ms(300);
              SEND_Str("ATH\r");
              delay_ms(2000);
             if( WRITE_NUMBER(2)==NULL)LD3.Led.l1=2;
             else LD3.Led.l1=1;
             LOAD_LD();
              delay_ms(2000);
              LD3.Led.l1=1;
             CLEAR_BUF();
                break;
                }
            }
          
         }          
              
              }
             	
				break;
			 } 

   case 0xFB :{
			
              delay_ms(1);
     if(PINC==0xFB)        
        { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD1.Led.l3==0) LD1.Led.l3=1;
              else LD1.Led.l3=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0xFB)
          { PGM=3;
           #asm("sei") 
           for(i=0;i<6;i++) DAT3[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD1.Led.l3=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l3=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD1.Led.l3=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l3=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l1=1; break; } 
            }
            PGM=0;
           }
           
           if(PINC==0x7B)  //���������������� ������� 3
         {  PGM=13;
           #asm("sei")
           for(i=0;i<6;i++) BREL3[i]='F'; //�������� ���� ������
         
          for(j=0;j<60;j++)
            {
            LD1.Led.l3=2;
            LD3.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l3=1;
            LD3.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
             if(PGM==0xFF)
              {LD1.Led.l3=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l3=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l3=1; break; }
            }
          PGM=0;
         }  
         
          if(PINC==0xBB)  //���������������� ������ 3
         { #asm("sei")
          SEND_Str("AT+CPBW=3\r");
          delay_ms(30);
          CLEAR_BUF(); 
           for(j=0;j<60;j++)
            {
            LD1.Led.l3=2;
            LD3.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l3=1;
            LD3.Led.l1=1;
            LOAD_LD();
            delay_ms(250); 
             if( strstr(rx_buffer0, "RING")!=NULL)
             {  delay_ms(300);
              SEND_Str("ATH\r");
              delay_ms(2000);
             if( WRITE_NUMBER(3)==NULL)LD3.Led.l1=2;
             else LD3.Led.l1=1;
             LOAD_LD();
              delay_ms(2000);
              LD3.Led.l1=1;
              CLEAR_BUF();
                break;
                }
            }
          
         }            
              }
             	
				break;
			 } 
   
   case 0xF7 :{
			
              delay_ms(1);
     if(PINC==0xF7)        
        { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD1.Led.l4==0) LD1.Led.l4=1;
              else LD1.Led.l4=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0xF7)
          { PGM=4;
           #asm("sei") 
           for(i=0;i<6;i++) DAT4[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD1.Led.l4=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l4=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD1.Led.l4=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l4=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l4=1; break; } 
            }
            PGM=0;
           }
          if(PINC==0x77)  //���������������� ������� 4
         {  PGM=14;
           #asm("sei")
           for(i=0;i<6;i++) BREL4[i]='F'; //�������� ���� ������
           for(j=0;j<60;j++)
            {
            LD1.Led.l4=2;
            LD3.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l4=1;
            LD3.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
             if(PGM==0xFF)
              {LD1.Led.l4=2;
                LOAD_LD();
                delay_ms(2000);
                LD1.Led.l4=0;
                break;
               }
            if(PGM==0xDF){LD1.Led.l4=1; break; }
            }
           PGM=0;
         }      
          if(PINC==0xB7)  //���������������� ������ 4
         { #asm("sei")
          SEND_Str("AT+CPBW=4\r");
          delay_ms(30);
          CLEAR_BUF(); 
          for(j=0;j<60;j++)
            {
            LD1.Led.l4=2;
            LD3.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD1.Led.l4=1;
            LD3.Led.l1=1;
            LOAD_LD();
            delay_ms(250);
             if( strstr(rx_buffer0, "RING")!=NULL)
             {  delay_ms(300);
              SEND_Str("ATH\r");
              delay_ms(2000);
             if( WRITE_NUMBER(4)==NULL)LD3.Led.l1=2;
             else LD3.Led.l1=1;
             LOAD_LD();
              delay_ms(2000);
              LD3.Led.l1=1;
             CLEAR_BUF();
                break;
                }
            }
          
         }           
              }
             	
				break;
			 }
   
   case 0xEF :{
			
              delay_ms(1);
     if(PINC==0xEF)        
        { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD2.Led.l1==0) LD2.Led.l1=1;
              else LD2.Led.l1=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0xEF)
          { PGM=5;
           #asm("sei") 
           for(i=0;i<6;i++) DAT5[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD2.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l1=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD2.Led.l1=2;
                LOAD_LD();
                delay_ms(2000);
                LD2.Led.l1=0;
                break;
               }
            if(PGM==0xDF){LD2.Led.l1=1; break; } 
            }
            PGM=0;
           }
           
          if(PINC==0x6F)  //���������������� ������� 5
         { PGM=15;
           #asm("sei")
           for(i=0;i<6;i++) BREL5[i]='F'; //�������� ���� ������
           for(j=0;j<60;j++)
            {
            LD2.Led.l1=2;
            LD3.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l1=1;
            LD3.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
             if(PGM==0xFF)
              {LD2.Led.l1=2;
                LOAD_LD();
                delay_ms(2000);
                LD2.Led.l1=0;
                break;
               }
            if(PGM==0xDF){LD2.Led.l1=1; break; }
            }
           PGM=0;
         }
         
          if(PINC==0xAF)  //���������������� ������ 5
         {#asm("sei") 
          SEND_Str("AT+CPBW=5\r");
          delay_ms(30);
          CLEAR_BUF(); 
          for(j=0;j<60;j++)
            {
            LD2.Led.l1=2;
            LD3.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l1=1;
            LD3.Led.l1=1;
            LOAD_LD();
            delay_ms(250); 
             if( strstr(rx_buffer0, "RING")!=NULL)
             {  delay_ms(300);
              SEND_Str("ATH\r");
              delay_ms(2000);
             if( WRITE_NUMBER(5)==NULL)LD3.Led.l1=2;
             else LD3.Led.l1=1;
             LOAD_LD();
              delay_ms(2000);
              LD3.Led.l1=1;
             CLEAR_BUF();
                break;
                }
            }
          
         }               
              }
             	
				break;
			 } 
   
   case 0xDF :{
			
              delay_ms(1);
     if(PINC==0xDF)        
        { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD2.Led.l2==0) LD2.Led.l2=1;
              else LD2.Led.l2=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0xDF)
          { PGM=6;
           #asm("sei") 
           for(i=0;i<6;i++) DAT6[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD2.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD2.Led.l2=2;
                LOAD_LD();
                delay_ms(2000);
                LD2.Led.l2=0;
                break;
               }
            if(PGM==0xDF){LD2.Led.l2=1; break; } 
            }
            PGM=0;
           }
         
         if(PINC==0x5F)  //���������������� ������� 6
         { PGM=16;
           #asm("sei")
           for(i=0;i<6;i++) BREL6[i]='F'; //�������� ���� ������ 
          for(j=0;j<60;j++)
            {
            LD2.Led.l2=2;
            LD3.Led.l2=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l2=1;
            LD3.Led.l2=1;
            LOAD_LD();
            delay_ms(250);
             if(PGM==0xFF)
              {LD2.Led.l2=2;
                LOAD_LD();
                delay_ms(2000);
                LD2.Led.l2=0;
                break;
               }
            if(PGM==0xDF){LD2.Led.l2=1; break; }
            }
           PGM=0;
         } 
          if(PINC==0x9F)  //���������������� ������ 6
         { #asm("sei")
          SEND_Str("AT+CPBW=6\r");
          delay_ms(30);
          CLEAR_BUF(); 
          for(j=0;j<60;j++)
            {
            LD2.Led.l2=2;
            LD3.Led.l1=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l2=1;
            LD3.Led.l1=1;
            LOAD_LD();
            delay_ms(250);
             if( strstr(rx_buffer0, "RING")!=NULL)
             {  delay_ms(300);
              SEND_Str("ATH\r");
              delay_ms(2000);
             if( WRITE_NUMBER(6)==NULL)LD3.Led.l1=2;
             else LD3.Led.l1=1;
             LOAD_LD();
              delay_ms(2000);
              LD3.Led.l1=1;
             CLEAR_BUF();
                break;
                }
            }
          
         }               
              }
             	
				break;
			 } 
   
   case 0xBF :{
			
              delay_ms(1);
     if(PINC==0xBF)        
            { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD2.Led.l3==0) LD2.Led.l3=1;
              else LD2.Led.l3=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0xBF)
          { PGM=7;
           #asm("sei") 
           for(i=0;i<6;i++) DAT7[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD2.Led.l3=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l3=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD2.Led.l3=2;
                LOAD_LD();
                delay_ms(2000);
                LD2.Led.l3=0;
                break;
               }
            if(PGM==0xDF){LD2.Led.l3=1; break; } 
            }
            PGM=0;
           }
              }
             	
				break;
			 } 
   
   case 0x7F :{
			
              delay_ms(1);
     if(PINC==0x7F)        
        { for(i=0;i<3000;i++)
            { 
            delay_ms(1);
            if(PINC==0xFF)
              {
              if(LD2.Led.l4==0) LD2.Led.l4=1;
              else LD2.Led.l4=0;
              LOAD_LD();
              break;
              }
             } 
         if(PINC==0x7F)
          { PGM=8;
           #asm("sei") 
           for(i=0;i<6;i++) DAT8[i]='F'; //�������� ���� �������
           for(j=0;j<60;j++)
            {
            LD2.Led.l4=2;
            LOAD_LD();
            delay_ms(250);
            LD2.Led.l4=1;
            LOAD_LD();
            delay_ms(250);
            
            if(PGM==0xFF)
               {LD2.Led.l4=2;
                LOAD_LD();
                delay_ms(2000);
                LD2.Led.l4=0;
                break;
               }
            if(PGM==0xDF){LD2.Led.l4=1; break; } 
            }
            PGM=0;
           }
              }
             	
				break;
			 } 
   
                        
  } 
    
  CLEAR_BUF();
    delay_ms(300);
  while(PINC!=0xFF);
  PCICR=0x05; 
  PCIFR|=0x04;  //����� ����� ����������
  
  
}






//***************************************************************************************************************************************
// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)  //���������� �� ������ ������� USART
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
   
   
   }
}

//=====================================================================================================================================



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
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=1 State4=0 State3=0 State2=0 State1=T State0=T 
PORTA=0x20;
DDRA=0x3C;

// Port B initialization
// Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=Out 
// State7=0 State6=T State5=0 State4=1 State3=0 State2=1 State1=T State0=1 
PORTB=0x15;
DDRB=0xBD;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P 
PORTC=0xFF;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In 
// State7=T State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=T 
PORTD=0x00;
DDRD=0x7A;

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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// Interrupt on any change on pins PCINT0-7: On
// Interrupt on any change on pins PCINT8-15: Off
// Interrupt on any change on pins PCINT16-23: On
// Interrupt on any change on pins PCINT24-31: Off
EICRA=0x00;
EIMSK=0x00;
PCMSK0=0x03;
PCMSK2=0xFF;
PCICR=0x05;
PCIFR=0x05;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 115200
UCSR0A=0x00;
UCSR0B=0x98;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x03;

// USART1 initialization
// USART1 disabled
UCSR1B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR1=0x00;

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

// Global enable interrupts

#asm("cli")
 for(i=0;i<256;i++) STAT[i]=0xFF;
LD1.byte=0x00;
LD2.byte=0x00;
LD3.byte=0x00;
//LD3.Led.l1=1;
LOAD_LD();
delay_ms(1000);
//==============================================������������� ����������================================================================
 RESET_TR(); 
 delay_ms(10);     
 INIT_TR();
 WRITE_PATABLE(); 
 STROB(SIDLE); 
 STROB(SFRX);
 STROB(SFTX);
 STROB(SRX); 
 delay_ms(3);

LD3.Led.l2=1;
 LOAD_LD();
 PCIFR|=0x01; //���������� ���������� �� ������ ������
 #asm("sei")
 //============================================������������� ������======================================================================
   delay_ms(500);
 RESET_MODEM(); 
 
 //SEND_Str("AT+COPS?\r");
// delay_ms(1000);
 
 
  //SEND_Str("AT+CSTA=145\r");
  delay_ms(500);
  // SEND_Str("AT*PSSTKI=1\r"); 
  //delay_ms(100);
//CALL(1); 
//SEND_Str("AT*PSSTK?\r");
// SEND_Str("ATD\"+79139357900\";\r"); 
       /*
delay_ms(15000);
 for(i=0;i<256;i++)
        {
        STAT[i]=rx_buffer0[i];
        }
        */ 
        
            
           
 LD3.Led.l1=1;
 LOAD_LD();
// delay_ms(3000);
// CALL(1);
 
while (1)
      {    
      LOAD_LD();
      }
}
