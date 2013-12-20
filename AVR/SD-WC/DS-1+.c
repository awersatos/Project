/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 03.04.2012
Author  : 
Company : 
Comments: 


Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 3,686400 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <spi.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
//++++++++++++ Определение строб-комманд трансивера+++++++++++++++++++++++++++++++++++++++++++++++++++++
#define SRES 0x30 //Сброс трансивера
#define SIDLE 0x36 //Переход в режим IDLE
#define SCAL 0x33   // Калибровка частотного синтезатора
#define SRX 0x34   // Переход в режим RX
#define STX 0x35   // Переход в режим TX
#define SFRX 0x3A  // Очистка RX FIFO
#define SFTX 0x3B  // Очистка TX FIFO
#define SNOP 0x3D  // Пустая строб-команда
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 // Массив инициализации регистров (старший байт - адрес, младший - значение)
flash unsigned int init[39]={0x0B08,     //0 FSCTRL1  Параметры синтезатора частоты
                             0x0C00,     //1 FSCTRL0
                             0x0D58,     //2 FREQ2 Определение базовой несущей частоты
                             0x0EE9,     //3 FREQ1
                             0x0F00,     //4 FREQ0
                             0x1084,     //5 MDMCFG4 ПАРАМЕТРЫ МОДЕМА ширина полосы пропускания
                             0x11F1,     //6 MDMCFG3 скорость передачи
                             0x1204,     //7 MDMCFG2 вид модуляции параметры слова синхронизации
                             0x1302,     //8 MDMCFG1 длинна приамбулы включение FEC
                             0x14E5,     //9 MDMCFG0 величина разноса каналлов
                             0x0A00,     //10 CHANNR номер канала
                             0x1504,     //11 DEVIATN девиация
                             0x2156,     //12 FREND1
                             0x2210,     //13 FREND0
                             0x1607,     //14 MCSM2   ПАРАМЕТРЫ КОНТРОЛЯ РАДИО
                             0x1730,     //15 MCSM1
                             0x1818,     //16 MCSM0
                             0x1916,     //17 FOCCFG компенсация сдвига частоты
                             0x1A6C,     //18 BSCFG кофигурация побитовой синхронизации
                             0x1BFB,     //19 AGCCTRL2 Параметры МШУ и порог чувствительности при приеме
                             0x1C40,     //20 AGCCTRL1
                             0x1D91,     //21 AGCCTRL0 
                             0x23A9,     //22 FSCAL3  Параметры калибровки синтезатора
                             0x240A,     //23 FSCAL2
                             0x2500,     //24 FSCAL1
                             0x2611,     //25 FSCAL0
                             0x2959,     //26 FSTEST
                             0x2C88,     //27 TEST2
                             0x2D31,     //28 TEST1
                             0x2E0B,     //29 TEST0 
                             0x000E,     //30 IOCFG2 Конфигурация GDO2 - 1при приеме синхрослова 0 пакет принят
                             0x020E,     //31 IOCFG0 Конфигурация GDO0 - обнаружение несущей
                             0x0740,     //32 PKTCTRL1 Конфигурация пакета
                             0x0805,     //33 PKTCTRL0
                             0x0900,     //34 ADDR Адрес устройства
                             0x06FF,     //35 PKTLEN Длинна пакета
                             0x0307,      //36 FIFOTHR граница переполнения FIFO 
                             0x04CF,      //37
                             0x05FC,       //38            
                             } ;
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
union U      // Определение объединения
		{
			unsigned int buf;
			unsigned char b[2];
		};  
                      
union U data;
// Определение глобальных переменных
eeprom unsigned char STATUS[128];
unsigned char i; //Основной счетчик
 unsigned char z;
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
//****************************************************************************************************
//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
//============================================================================================
//*********************************************************************************************
unsigned char SPI_SEND(unsigned char data)  // Передать/принять байт  по SPI
{
SPDR = data;
		while (!(SPSR & (1<<SPIF)));
		return SPDR;
}

//*******************************************************************************************
void RESET_TR(void) //Сброс трансивера по включению питания
{
SPCR=0x00; //Отключение SPI
PORTB.5=1; //Устанавливаем 1 на SCK
PORTB.3=0;  // Устанавливаем 0 на MOSI
PORTB.2=0; // SPI_SS ON
delay_us(1);
PORTB.2=1; // SPI_SS OFF
delay_us(40);
SPCR=0x50; //Включение SPI
PORTB.2=0; // SPI_SS ON
while(PORTB.4==1); //Ждем 0 на MISO
SPI_SEND(SRES);
PORTB.2=1; // SPI_SS OFF
}

//*******************************************************************************************
void WRITE_REG( unsigned int reg) // Функция записи регистра
{
 union U dat;
 dat.buf=reg;
 SPI_SEND(dat.b[1]);  //Адрес регистра 
 SPI_SEND(dat.b[0]);  //Значение регистра
}
//********************************************************************************************
unsigned char READ_REG(unsigned char adr)  // Функция чтения регистра
{  unsigned char reg;
   SPI_SEND(adr | 0x80);   // Старший бит определяет операцию  
   reg= SPI_SEND(0xFF);
   return reg; 
}
//**********************************************************************************************
 void INIT_TR(void) //Функция инициализации трансивера
 { union U dt;
   unsigned char err;
  PORTB.2=0; // SPI_SS ON
  while(PORTB.4==1); //Ждем 0 на MISO  
  do{
  for (i=0;i<39;i++)
   {
    WRITE_REG(init[i]);
    };
    err=0; 
    
    for (i=0;i<39;i++)
     {
     dt.buf=init[i];
     if(dt.b[0]!=READ_REG(dt.b[1])){ err=1; }
     }
     
    }while(err==1);
    
   PORTB.2=1; // SPI_SS OFF  
 }
//********************************************************************************************
void WRITE_PATABLE(void)    //Запись таблицы мощности
{
PORTB.2=0; // SPI_SS ON
while(PORTB.4==1); //Ждем 0 на MISO
WRITE_REG(0x3EFF);         //Запись значения выходной мощности передатчика +1dbm
//SPI_SEND(0x7E);
//SPI_SEND(0x00);
//SPI_SEND(0xFF);
PORTB.2=1; // SPI_SS OFF 
}
//*********************************************************************************************
//++++++++++++++++++++++++++++++++ПРЕРЫВАНИЯ++++++++++++++++++++++++++++++++++++++++++++++++++
//***********************************************************************************************
// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void) //Прерывание по приему пакета
{  LightDiode(2);
 //while(PORTD.3==1);
  //while(1);
 delay_ms(200);
 SPI_SEND(SIDLE);
  SPI_SEND(0xFB);
 z=SPI_SEND(0xFF);
  STATUS[0]=z;
  PORTB.2=1; // SPI_SS OFF
  
 PORTB.2=0; // SPI_SS ON
   while(PORTB.4==1); //Ждем 0 на MISO
   SPI_SEND(0xFF);
   for(i=1;i<z;i++)
   {   STATUS[i]=SPI_SEND(0x00);
    //if( SPI_SEND(0xFF)==0xD3)  { LightDiode(0); while(1);}
    
    //if (SPI_SEND(0xFF)==0x91){LightDiode(1); while(1);}   }          ;
   }
   PORTB.2=1; // SPI_SS OFF
    
  PORTB.2=0; // SPI_SS ON
   while(PORTB.4==1); //Ждем 0 на MISO
    SPI_SEND(SFRX); 
    SPI_SEND(SRX); 
    PORTB.2=1; // SPI_SS OFF
   
 //while(1);
 LightDiode(1); 
 
          /*
// if(PORTD.3==0)    LightDiode(0);
  PORTB.2=0; // SPI_SS ON
   while(PORTB.4==1); //Ждем 0 на MISO 
 STATUS[0]=SPI_SEND(SNOP);
  while(PORTD.3==1);
  STATUS[1]=SPI_SEND(SNOP);

    
    delay_ms(100);
    STATUS[2]=SPI_SEND(SNOP);
     SPI_SEND(SIDLE);
     SPI_SEND(SFRX);
     SPI_SEND(SRX);
      PORTB.2=1; // SPI_SS OFF 
               */
     
      
}
//*********************************************************************************************
//============================================================================================
//+++++++++++++ ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ ++++++++++++++++++++++++++++++++++++++++++++++++++
//============================================================================================
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=0 State4=T State3=1 State2=1 State1=T State0=T 
PORTB=0x0D;
DDRB=0x2C;

// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x30;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x08;
DDRD=0x00;

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
GICR=0x00;
MCUCR=0x0C;
GIFR=0x80;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

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
     #asm("sei")
while (1)
      {
        for(i=0;i<128;i++)
        {
        STATUS[i]=0xFF;
        }
     // delay_ms(1000); 
      
      RESET_TR();
      delay_ms(10); 
      INIT_TR();
      WRITE_PATABLE();  
      
           
     
      delay_ms(300);
      PORTB.2=0; // SPI_SS ON
      while(PORTB.4==1); //Ждем 0 на MISO 
      SPI_SEND(SIDLE); //Переход в режим IDLE
      SPI_SEND(SFRX); //Сброс буфера приема
      SPI_SEND(SFTX); //Сброс буфера передачи 
      SPI_SEND(SRX);  //Переход в режим RX 
        delay_ms(1); 
       LightDiode(1);  
     // GIFR=0x80;   // Сброс флага прерывания 
     // GICR|=0x80;  //Разрешение прерывания по приему пакета
      
      /*
        SPI_SEND(0x7F);
      SPI_SEND(0x07);
      SPI_SEND('S');
      SPI_SEND('E');
      SPI_SEND('X'); 
      SPI_SEND('O');
      SPI_SEND('N');
      SPI_SEND('I');
      SPI_SEND('X');
      PORTB.2=1; // SPI_SS OFF 
      
      PORTB.2=0; // SPI_SS ON
      while(PORTB.4==1); //Ждем 0 на MISO 
      SPI_SEND(STX);
            */ 
      //STATUS[0]=READ_REG(0x04);
      //STATUS[1]=READ_REG(0x05); 
               /*
         LightDiode(0);
      for (i=1;i<128;i++)
       {
         SPI_SEND(0xF4);
         STATUS[i]=SPI_SEND(0xFF);
         delay_ms(10);
      
      
        }   
         SPI_SEND(0xFB);
         STATUS[0]=SPI_SEND(0xFF);
      PORTB.2=1; // SPI_SS OFF 
            LightDiode(1);
                  */
                /*
  
      PORTB.2=0; // SPI_SS ON
      while(PORTB.4==1); //Ждем 0 на MISO 
            
       for (i=0;i<37;i++)
       {
       data.buf=init[i];
        STATUS[i]=READ_REG(data.b[1]);
       } 
              
      STATUS[0]=0xAA;          
      STATUS[1]=READ_REG(0x3E);          
      STATUS[2]=0xAA; 
      STATUS[3]=SPI_SEND(SNOP);         
      PORTB.2=1; // SPI_SS OFF
       
         
        // delay_ms(3000);
          LightDiode(1);
          PORTB.2=0; // SPI_SS ON
      while(PORTB.4==1); //Ждем 0 на MISO 
          STATUS[5]=SPI_SEND(SNOP);         
      PORTB.2=1; // SPI_SS OFF 
      
       // LightDiode(0);
       // while(PORTB.0==0);
        // LightDiode(2); 
        */ 
      GIFR=0x80;   // Сброс флага прерывания 
      GICR|=0x80;  //Разрешение прерывания по приему пакета 
     //PORTB.2=0; // SPI_SS ON
     // while(PORTB.4==1); //Ждем 0 на MISO
                 /*
      for (i=0;i<128;i++)
      { STATUS[i]=SPI_SEND(0xF4);
       delay_ms(1);}
                  */
       
       while(1);
        
       while(1)  {
                   if (PORTB.0==1){ LightDiode(2);
                       delay_ms(100);}
       else LightDiode(1); 
       }
        
      }
}