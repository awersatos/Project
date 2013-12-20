/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : BRELOK_DS1+
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
                             0x10E4,     //5 MDMCFG4 ПАРАМЕТРЫ МОДЕМА ширина полосы пропускания
                             0x11F1,     //6 MDMCFG3 скорость передачи
                             0x1201,     //7 MDMCFG2 вид модуляции параметры слова синхронизации
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
                             0x0006,     //30 IOCFG2 Конфигурация GDO2 - 1при приеме синхрослова 0 пакет принят
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
                      
//union U data;

// Определение глобальных переменных
unsigned char i;   //Основной счетчик
eeprom unsigned char STAT[37];
//*******************************************************************************************
void LightDiode(unsigned char n) // Функция управления светодиодом
{
 switch (n)
 {
 case 0:
			{
			PORTB.0=0;
            PORTB.1=0;	
				break;
			} 
 case 1:
			{
			PORTB.0=1;
            PORTB.1=0;		
				break;
			} 
 case 2:
			{
			PORTB.0=0;
            PORTB.1=1;		
				break;
 case 3:
			{
			PORTB.0=1;
           PORTB.1=1;		
				break;
			} 			}             
 }

}
//*******************************************************************************************
//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
//============================================================================================
// Функция передачи символа по SPI
unsigned char SPI_SEND(unsigned char data)
{
 USIDR=data;      // Загрузка данных в сдвиговый регистр
 USISR=(1<<USIOIF);  // Очистка флага переполнения и 4-битного счетчика
 TIFR0 |= (1<<OCF0A);   // Очистка флага прерывания по совпадению таймера
 TIMSK0 |= (1<<OCIE0A); // Разрешение прерывания по совпадению
 while(USISR.USIOIF==0); //Ожидание конца передачи байта
 TIMSK0=0x00;     //Запрет прерывания
 return USIDR; // Возврат данных 
 }
//*******************************************************************************************
 void RESET_TR(void) //Сброс трансивера по включению питания
{
USICR=0x00; //Отключение SPI
PORTA.4=1; //Устанавливаем 1 на SCK
PORTA.5=0;  // Устанавливаем 0 на MOSI
PORTA.7=0; // SPI_SS ON
delay_us(1);
PORTA.7=1; // SPI_SS OFF
delay_us(40);
USICR=0x1A; //Включение SPI
PORTA.7=0; // SPI_SS ON
while(PORTA.6==1); //Ждем 0 на MISO
SPI_SEND(SRES);
PORTA.7=1; // SPI_SS OFF
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
  PORTA.7=0; // SPI_SS ON
while(PORTA.6==1); //Ждем 0 на MISO  
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
    
  PORTA.7=1; // SPI_SS OFF 
 }
//********************************************************************************************
void WRITE_PATABLE(void)    //Запись таблицы мощности
{
PORTA.7=0; // SPI_SS ON
while(PORTA.6==1); //Ждем 0 на MISO
WRITE_REG(0x3EFF);         //Запись значения выходной мощности передатчика +1dbm
//SPI_SEND(0x7E);
//SPI_SEND(0x00);
//SPI_SEND(0xFF);
PORTA.7=1; // SPI_SS OFF 
}
//*********************************************************************************************


//*********************************************************************************************
//===========================ПРЕРЫВАНИЯ======================================================
// Timer 0 output compare A interrupt service routine
interrupt [TIM0_COMPA] void timer0_compa_isr(void)    //Прерывание по совпадению таймера
{
USICR |= (1<<USITC); // Задание тактового импульса

}

//============================================================================================
//+++++++++++++++++++ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ ++++++++++++++++++++++++++++++++++++++++++++++
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
// Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=1 State6=T State5=0 State4=0 State3=T State2=T State1=P State0=P 
PORTA=0x83;
DDRA=0xB0;

// Port B initialization
// Func3=In Func2=In Func1=Out Func0=Out 
// State3=T State2=T State1=0 State0=0 
PORTB=0x00;
DDRB=0x03;

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
TIMSK0=0x00;

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;

// Universal Serial Interface initialization
// Mode: Three Wire (SPI)
// Clock source: Reg.=ext. pos. edge, Cnt.=USITC
// USI Counter Overflow Interrupt: Off
USICR=0x00;

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
      {LightDiode(1); 
      delay_ms(500);
      RESET_TR();
      delay_ms(10); 
      INIT_TR();
      WRITE_PATABLE();
m:    
      LightDiode(0); 
       PORTA.7=0; // SPI_SS ON
      while(PORTA.6==1); //Ждем 0 на MISO 
      SPI_SEND(SIDLE); //Переход в режим IDLE
      SPI_SEND(SFRX); //Сброс буфера приема
      SPI_SEND(SFTX); //Сброс буфера передачи 
     // SPI_SEND(SRX);
      
          
      SPI_SEND(0x7F);
      SPI_SEND(0x0A);
      SPI_SEND('S');
      SPI_SEND('E');
      SPI_SEND('X'); 
      SPI_SEND('O');
      SPI_SEND('N');
      SPI_SEND('I');
      SPI_SEND('X');
      
      PORTA.7=1; // SPI_SS OFF 
      // LightDiode(0);
      delay_ms(1); 
      
      
      PORTA.7=0; // SPI_SS ON
      while(PORTA.6==1); //Ждем 0 на MISO  
              /*
       SPI_SEND(0xFA);
      STATUS[0]=SPI_SEND(0xFF);
      STATUS[1]=SPI_SEND(SNOP);
              */
      SPI_SEND(STX);
      delay_ms(200); 
                     /*
      STATUS[2]=SPI_SEND(SNOP);
      delay_ms(100);
      STATUS[3]=SPI_SEND(SNOP); 
                  */
     // PORTA.7=1; // SPI_SS OFF 
      
     //while(PORTA.3==0); 
     LightDiode(2);
     PORTA.7=1; // SPI_SS OFF
     // while(PORTA.3==1);
       //LightDiode(0);        
          /*
     for (i=0;i<37;i++)
       {
       data.buf=init[i];
        STATUS[i]=READ_REG(data.b[1]);}
                */
                /*
      PORTA.7=1; // SPI_SS OFF 
         delay_ms(300);
      LightDiode(2);
              */
              while(1);
              delay_ms(1000);
              goto m;
      while(1);
      }
}
