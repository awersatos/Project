/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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

#define CR 0xD     // Определение служебных символов
#define LF 0xA
#define ctrl_Z 0x1A

typedef union{                     // Определение структурного типа DATA
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
                    // Определение глобальных переменных
char z;          //Переменная статуса охраны 
unsigned int i; //Счетчик
unsigned char SPI_buffer[64];
unsigned char pktlen;
char Error;
eeprom unsigned char OP;
eeprom char NR[12];     // Массив телефонного номера
eeprom unsigned char COUNT;
//eeprom char eebuf[64];
//eeprom char eebuffer[256];
flash unsigned char CH=78;  //Номер канала
flash unsigned char SW=9;  //Делитель частоты
// значения для инициализации кадра
                                                               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
        flash unsigned char tbl_frame[30]  = {0x30,0x98,0x90,  //48  1  0  0  1  1  0 0 0 0 0 0 0 0 0 0 0 15:13 - 5 байт приамбула 12:11 - синхро-слово 64 бита {Reg55[15:0],Reg54[15:0],Reg53[15:0],Reg52[15:0]} 10:8 - трейлер 4 бита 7:6 - NRZ кодирование сигнала 5:4 - не использовать помехоустойчивое кодирование 3,2,1,0 - не особо важные настройки
                                              0x31,0xFF,0x8F,  //49  1  1  1  1  1  1 1 1 1 0 0 0 1 1 1 1 15:8 - максимальная задержка 2 мс 7 - часы работают в режиме сна 5:0 - BDATA1 сбросить через 15 us
                                              0x32,0x80,0x28,  //50  1  0  0  0  0  0 0 0 0 0 1 0 1 0 0 0 15:8 и 7:0 задержки для работы в режиме TX
                                              0x33,0x80,0x56,  //51  1  0  0  0  0  0 0 0 0 1 0 1 0 1 1 0 15:8 - RX таймер 7 - MISO в неопределенном состоянии 6:0 - ключ для скрамблера
                                              0x34,0x4E,0xF6,  //52  0  1  0  0  1  1 1 0 1 1 1 1 0 1 1 0  биты синхронизации
                                              0x35,0xF6,0xF5,  //53  1  1  1  1  0  1 1 0 1 1 1 1 0 1 0 1  биты синхронизации
                                              0x36,0x18,0x5C,  //54  0  0  0  1  1  0 0 0 0 1 0 1 1 1 0 0  биты синхронизации
                                              0x37,0xD6,0x51,  //55  1  1  0  1  0  1 1 0 0 1 0 1 0 0 0 1  биты синхронизации
                                              0x38,0x44,0x44,  //56  0  1  0  0  0  1 0 0 0 1 0 0 0 1 0 0  7 - PKF-flag высокий уровень активный
                                              0x39,0xA0,0x00}; //57  1  0  1  0  0  0 0 0 0 0 0 0 0 0 0 0  15 - использовать CRC 14 -не использовать скрамблер 13 - первый байт содержит длину пакета 7:0 - CRC (???????????)

		// значения для инициализации передатчика               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
		flash unsigned char tbl_rfinit[54]  = {0x09,0x21,0x01,  //9   0  0  1  0  0  0 0 1 0 0 0 0 0 0 0 1
											   0x00,0x35,0x4D,  //0   0  0  0  1  1  1 1 1 0 0 0 0 0 0 0 1
											   0x02,0x1F,0x01,  //2   0  0  0  1  1  1 1 1 0 0 0 0 0 0 0 1
											   0x04,0xBC,0xF0,  //4   1  0  1  1  1  1 0 0 1 1 1 1 0 0 0 0
											   0x05,0x00,0xA1,  //5   0  0  0  0  0  0 0 0 1 0 1 0 0 0 0 1
											   0x07,0x12,0x4C,  //7   0  0  0  1  0  0 1 0 0 1 0 0 1 1 0 0 13:9 - делитель 8- TX mode 7- RX mode 6:0 - частота (2402+76)
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
#define RX_BUFFER_SIZE 512
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256

#else
unsigned int rx_wr_index;
#endif

// This flag is set on USART Receiver buffer overflow


//********************************************************************************************
void LightDiode(unsigned char n) // Функция управления светодиодом
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
void UART_Transmit(char data) // Функция передачи символа через UART
{  
while (!(UCSRA & (1<<UDRE))) {};
UDR=data;
}

//**********************************************************************************************************
       void SEND_Str(flash char *str) {        // Функция передачи строки  из флеш памяти
        while(*str) { 
       UART_Transmit(*str++);
      
    };
    delay_ms(20);
}

//**********************************************************************************************************
void CLEAR_BUF(void)   // Функция очистки буффера приема
{

for (i=0;i<RX_BUFFER_SIZE;i++) {
      rx_buffer[i]=0;
    };
   rx_wr_index=0;
   #asm("wdr") 
   
}
//**********************************************************************************************************
  char TEST_OK(void)     // Функция проверки ответа ОК на команду
  {
  char c;
  char *d;
  char OK[]="OK";
  d=strstr(rx_buffer, OK);
  c=*d; 
  #asm("wdr")
 CLEAR_BUF();
   return c; 

  }
//**********************************************************************************************************
  char REG_NET(void)   // Функция проверки регистрации в сети
  {
  char c;
  char *d;
  char REG[]="+CREG:";
  d=strstr(rx_buffer, REG);
  d=d+9;
  c=*d; 
  #asm("wdr")
  CLEAR_BUF();
  return c;
  }
//**********************************************************************************************************
char SET_NR(void) // Функция считывания телефонного номера с SIM карты
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
  #asm("wdr")
  CLEAR_BUF();
  c=1;
  return c;  
}

//**********************************************************************************************************
// Функция проверки балланса
 void BALLANSE(void)
 {   unsigned char S;
   // char XY[2];
    unsigned char *s1, *s2;
    delay_ms(4000);
    CLEAR_BUF();
  do
   { if(OP==0) SEND_Str("AT+CUSD=1,\"*100#\"\r"); //Отправа запроса балланса
     else SEND_Str("AT+CUSD=1,\"*102#\"\r");
   delay_ms(500);
  // #asm("wdr") 
    }while(TEST_OK()==0);
    for(i=0;i<5;i++)
    {
     if(strstr(rx_buffer, "+CUSD:")!=NULL) break;   //Ожидание ответа на запрос 
    // #asm("wdr")
     delay_ms(1000);
    // #asm("wdr")
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
  //  #asm("wdr")
     SEND_Str("0001000B91");     // Ввод настроек PDU
      
      for(i=0;i<12;i++)            // Ввод номера
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
  for (i=0; i<256; i++)    // Запись буфера приема в eeprom
      {eebuffer[i]=rx_buffer[i];} 
             */
      }
      CLEAR_BUF();
 }
//********************************************************************************************
//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
//============================================================================================
unsigned char SPI_SEND(unsigned char data)  // Передать/принять байт  по SPI
{
SPDR = data;
		while (!(SPSR & (1<<SPIF)));
		return SPDR;
}

//*******************************************************************************************
//записать в регистр трансивера значение
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
		SPI_SEND(reg);    //регистр
		delay_us(2);
		SPI_SEND(dat.b[1]);   //старшая часть
		delay_us(2);
		SPI_SEND(dat.b[0]);   //младшая часть
		delay_us(2);
		PORTB.2=1;     // SPI_SS OFF
        #asm("wdr")
	}//end writeByte
//*******************************************************************************************	
 //Чтение из регистра трансивера
	unsigned int TR24A_Read(unsigned char reg)
	{
		union U
		{
			unsigned int buf;
			unsigned char b[2];
		};
           union U dat;
		PORTB.2=0;       // SPI_SS ON
		SPI_SEND(reg |0x80);   //Старший бит определяет операцию
		delay_us(2);
		dat.b[1]=SPI_SEND(0x0FF);
		delay_us(2);
		dat.b[0]=SPI_SEND(0x0FF);
		delay_us(2);
		PORTB.2=1;     // SPI_SS OFF
         #asm("wdr")
		return dat.buf;
	}//end readByte
//******************************************************************************************* 
//Инициализация трансивера
	void TR24A_INIT(void)
	{
		
		union U
		{
			unsigned int data;     //значение регистра
			unsigned char b[2];
		}; 
        union U dt;
                /*
		chanel=76;   //канал по умолчанию
		swallow=9;    //делитель частоты по умолчанию
		Error.byte=0; //обнулить все ошибки
		ProgCRC=0;    //программное CRC выкл
		TrState=0;    //предыдущей режим работы трансивера, необходимо для приема пакета
                  */
		//reset();

		unsigned char i;
        PORTB.0=0;      // Сброс трансивера перед инициализацией
     delay_ms(10);
     PORTB.0=1;
     delay_ms(5); 
		for(i=0;i<30;i=i+3)				//инициализация кадра
		{
			dt.b[1]=tbl_frame[i+1];
			dt.b[0]=tbl_frame[i+2];
			TR24_Wrtie(tbl_frame[i],dt.data);
		}

		delay_ms(5);
		for(i=0;i<54;i=i+3)		       //инициализация передатчика
		{
			dt.b[1]=tbl_rfinit[i+1];
			dt.b[0]=tbl_rfinit[i+2];
			TR24_Wrtie(tbl_rfinit[i],dt.data);
		}
           Error='N';
		//Проверить правильность инициализации трансивера
            #asm("wdr")
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
            #asm("wdr")
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
//Режим приема данных
	void TR24A_RX(void)
	{
		DATA buf;

        #asm("wdr")
		buf.data=TR24A_Read(0x07);
		buf.byte[1]=(SW<<1);
		buf.byte[0]=CH;
		buf.Bit.b8=0;
		buf.Bit.b7=1;

		TR24_Wrtie(0x07,buf.data);  // переход в режим RX, задаем канал
		delay_us(10);

	}//end ReciveMode
//*******************************************************************************************
//перейти в режим передачи данніх
	void TR24A_TX(void)
	{
		DATA buf;
        #asm("wdr")
		buf.data=TR24A_Read(0x07);
		buf.byte[1]=(SW<<1);
		buf.byte[0]=CH;
		buf.Bit.b8=1;
		buf.Bit.b7=0;

		TR24_Wrtie(0x07,buf.data);  

	}//end TransmitMode    
//*********************************************************************************************
//Прием пакта
  unsigned char TR24A_RXPKT(void)
  {
   unsigned char len; //Длинна пакета
   unsigned char j;   //Счетчик

  PORTB.2=0;       // SPI_SS ON  
   #asm("wdr")
  SPI_SEND(0x50|(1<<7));   //reg80
  delay_us(3);
  len=SPI_SEND(0xFF);
  for(j=0;j<len;j++)  //получить пакет
		{
			delay_us(3);
			SPI_buffer[j] = SPI_SEND(0xFF);
		} 
 PORTB.2=1;     // SPI_SS OFF  
 return len;
 
  }      
//******************************************************************************************
   //Функция передачи пакета
 void TR24A_TXPKT(void)
 { 

    #asm("wdr")
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
  // Запись строки в SPI буффер
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
 void USART_ON(void)   //Активация USART
  {
   PORTD.4=0;
   PORTD.5=0;
   while(PIND.6==1);
  } 
//*******************************************************************************************
 void USART_OFF(void)   //Деактивация USART
 {
 PORTD.4=1;
 PORTD.5=1;
 }
//********************************************************************************************
void RESET_MODEM(void)    // Сброс модема 
 {LightDiode(3);
  do { 
 //delay_ms(250);
  if (PINC.1==0)  
  {
  PORTC.0=0;       // Включение модема
  delay_ms(1000);
  PORTC.0=1;
  delay_ms(250);
   }  
   
   else
   {
    PORTC.2=0;       // Включение модема
  delay_ms(100);
  PORTC.2=1;
  delay_ms(1000);
   }   
   
    } while(PINC.1==0);   // Проверка включения модема 
       USART_ON();
   
    do{      SEND_Str("AT\r");  // Проверка ответа модема
         #asm("wdr")
      } while(TEST_OK()==0)  ; 
                 /*
            
    SEND_Str("AT+CREG?\r"); 
         delay_ms(100); 
       SEND_Str("HER?\r"); 
       delay_ms(1000);    
         for( i=0;i<64;i++) {eebuf[i]=rx_buffer[i];}        
          LightDiode(0);
          while(1){  #asm("wdr") }
                    */
 do{   SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети 
        #asm("wdr")
      delay_ms(1000); 
      #asm("wdr")   
      }while (REG_NET()!='1') ;  
      
     // USART_OFF();              

 }
//********************************************************************************************
void RESET_TR24A(void)   // Перезагрузка и инициализация трансивера
{
 LightDiode(3);
 do { TR24A_INIT();  // Инициализация трансивера
 #asm("wdr")
    }while(Error=='E') ;   // Если инициализация ошибочна возврат к сбросу
}

//============================================================================================
// Прерывание по приему пакета
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
     GICR=0x00; //Запрет внешних прерываний 
   
 pktlen=TR24A_RXPKT();
  
if (pktlen!=0)
  { 
   
        #asm("wdr")
 if (strstr(SPI_buffer,"BRELOK")!=NULL) {Write_SPI_buffer("DEVICE");}
 else {     
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
   }
   // delay_ms(30); 
    TR24A_TXPKT(); 
    while(PIND.3==0); 
 

}

  GIFR=0x80;    //Сброс флага прерывания 
  GICR=0x80;   // Разрешение прерывания
   
 TR24A_RX();              // Преход в режим RX
}
//*******************************************************************************************

// Функция обработки прерывания по приему символа USART
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

 //*****************************************************************************************
 // Прерывание по таймеру производит тест системы

 // Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
union U
		{
			unsigned int buf;
			unsigned char b[2];
		};
           union U stat;
TIMSK=0x00;
#asm("sei")
//LightDiode(0);
 USART_ON() ; //  Активация USART 
 
           
 SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
  
 if (REG_NET()!='1') 
   { 
   TCCR1B=0x00;
   #asm("wdr")
    RESET_MODEM();          
   #asm("wdr")          
   } 
   delay_ms(30);
   if(COUNT>=10)        
           {BALLANSE();
            COUNT=0;}
  USART_OFF() ; //  Дективация USART  
  
 stat.buf=TR24A_Read(0x40);
 if(stat.b[1]!=0xD0)
 {
  TCCR1B=0x00;
  RESET_TR24A(); 
  TR24A_RX();              // Преход в режим RX
 } 
 
 TIMSK=0x04;
 TCCR1B=0x05;
}
//=============================================================================================
//*****************************ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ*************************************
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
// Clock value: 3,600 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: On
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
// Watchdog Timer initialization
// Watchdog Timer Prescaler: OSC/2048k
#pragma optsize-
WDTCR=0x1F;
WDTCR=0x0F;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

 // Global enable interrupts
#asm("sei")
#asm("wdr") 
LightDiode(3);    //Зажечь светодиод
/************** ******************* АКТИВАЦИЯ МОДЕМА*****************************************/

 RESET_MODEM();
  
 #asm("wdr")
  USART_ON() ; //  Активация USART
                
 do{     SEND_Str("AT+CPBF=\"N\"\r");  // Считывание телефонного номера с SIM карты 
       #asm("wdr")
      } while(SET_NR()==0);      // Преобразование номера в PDU формат 
      
  do{ SEND_Str("AT+COPS?\r");
  delay_ms(50);
    #asm("wdr")
  }while(strstr(rx_buffer, "+COPS:")==NULL);    
 if( strstr(rx_buffer, "Beeline")!=NULL ) OP=1;
  else OP=0;
   CLEAR_BUF(); 
  USART_OFF() ;  //  Дективация USART 
  #asm("wdr")
//==========================================================================================  
//*************************АКТИВАЦИЯ ТРАНСИВЕРА**********************************************
  RESET_TR24A(); 
  TR24A_RX();              // Преход в режим RX
      
 
//============================================================================================  
 TIMSK=0x04;
 TCCR1B=0x05;
 z=1; // Включение режима охраны
  

while (1)
      { 

mx:      while((PIND.2==1)||(z==0))  // Цикл пока дверь открыта
       { #asm("wdr")
       if (z==0){LightDiode(0);}
       else {LightDiode(2);}
       } 
       delay_ms(100);
       
       if(PIND.2==1) goto mx;
my:       while((PIND.2==0) || (z==0) )           // Цикл пока дверь закрыта
       {   #asm("wdr")
       if (z==0){LightDiode(0);}
       else {LightDiode(1);}
       }  
       delay_ms(100);
       
       if(PIND.2==0) goto my; 
       USART_ON() ; 
         TCNT1H=0x00;
         TCNT1L=0x01;
       // TIMSK=0x00;                   
       // TCCR1B=0x00;              
m4:    SEND_Str("AT+CMGF=0\r");     // Установка PDU режима 
        #asm("wdr")
       if (TEST_OK()==0) goto m4 ; 
       
       
       
       
m5:   SEND_Str("AT+CMGS=39\r");  //    Ввод команды отправки сообщения
        #asm("wdr")
      if (strrchr(rx_buffer, '>')==NULL)
      {CLEAR_BUF();
      goto m5;}
      CLEAR_BUF();    
      
      SEND_Str("0001000B91");     // Ввод настроек PDU
      
      for(i=0;i<12;i++)            // Ввод номера
      {UART_Transmit(NR[i]);}
      
       SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // Ввод текста сообщения 
       
       /* if(COUNT==10)        
           {BALLANSE();
            COUNT=0;}*/
         COUNT++;    
               #asm("wdr")
              CLEAR_BUF();
             USART_OFF() ;  //  Дективация USART
             #asm("wdr")
              TCNT1H=0x01;
              TCNT1L=0x4F;
              TCCR1B=0x05;
              TIMSK=0x04;
      }
      
}
