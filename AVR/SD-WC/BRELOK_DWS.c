/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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



//++++++++++++ Определение строб-комманд трансивера+++++++++++++++++++++++++++++++++++++++++++++++++++++
#define SRES 0x30 //Сброс трансивера
#define SIDLE 0x36 //Переход в режим IDLE
#define SCAL 0x33   // Калибровка частотного синтезатора
#define SRX 0x34   // Переход в режим RX
#define STX 0x35   // Переход в режим TX
#define SFRX 0x3A  // Очистка RX FIFO
#define SFTX 0x3B  // Очистка TX FIFO
#define SNOP 0x3D  // Пустая строб-команда
#define SPWD 0x39  //Переходв SLEEP режим
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 // Массив инициализации регистров (старший байт - адрес, младший - значение)
flash unsigned int init[35]=
{
 0x000E, //0 IOGFG2 Обнаружение несущей
 0x0206, //1 IOGFG0 Прием-передача пакета
 0x06FF, //2 PKTLEN Длинна пакета
 0x0704, //3 PKRCTRL1 Контроль пакета
 0x0805, //4 PKRCTRL0 Контроль пакета
 0x0901, //5 ADDR Адрес устройства
 0x0A2F, //6 CHANNR Номер канала
 0x0B06, //7 FSCTRL1 Параметры контроля синтезатора частоты
 0x0C00, //8 FSCTRL0 Параметры контроля синтезатора частоты
 0x0D10, //9 FREQ2 Параметы опорной частоты
 0x0E09, //10 FREQ1 Параметы опорной частоты
 0x0F7B, //11 FREQ0 Параметы опорной частоты
 0x1085, //12 MDMCFG4 Конфигурация модема
 0x1178, //13 MDMCFG3 Конфигурация модема
 0x1203, //14 MDMCFG2 Конфигурация модема
 0x1302, //15 MDMCFG1 Конфигурация модема
 0x14E5, //16 MDMCFG0 Конфигурация модема
 0x1514, //17 DEVIATION Девиация
 0x1730, //18 MCSM1 Конфигурация автомата контроля радио
 0x1818, //19 MCSM0 Конфигурация автомата контроля радио
 0x1916, //20 FOCCFG Компенсация сдвига частоты
 0x1A6C, //21 BSCFG Конфигурация побитовой синхронизации
 0x1BC0, //22 AGCCTRL2 Пармаметры приемного тракта
 0x1C00, //23 AGCCTRL1 Пармаметры приемного тракта 
 0x1DB2, //24 AGCCTRL0 Пармаметры приемного тракта
 0x21B6, //25 FREND1 Параметры приемного тракта
 0x2210, //26 FREND0 Параметры передающего тракта
 0x23E9, //27 FSCAL3 Параметры калибровки синтезатора частоты
 0x242A, //28 FSCAL2 Параметры калибровки синтезатора частоты
 0x2500, //29 FSCAL1 Параметры калибровки синтезатора частоты 
 0x261F, //30 FSCAL0 Параметры калибровки синтезатора частоты
 0x2959, //31 FSTEST Проверка синтезаторы частоты
 0x2C81, //32 TEST2
 0x2D35, //33 TEST1
 0x2E09  //34 TEST0
};
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
union U      // Определение объединения
		{
			unsigned int buf;
			unsigned char b[2];
		};  
                      
//union U FREQ;
//union U FR1;
//union U FR0;

// Определение глобальных переменных
unsigned char i;   //Основной счетчик
unsigned char SPI_buffer[64];
unsigned char len;
//eeprom unsigned char ST;
eeprom unsigned char STAT[37];
//*******************************************************************************************
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
PORTA.3=0; // SPI_SS ON
delay_us(1);
PORTA.3=1; // SPI_SS OFF
delay_us(40);
USICR=0x1A; //Включение SPI
PORTA.3=0; // SPI_SS ON
while(PINA.6==1); //Ждем 0 на MISO
SPI_SEND(SRES);
PORTA.3=1; // SPI_SS OFF
}
//*******************************************************************************************
void WRITE_REG( unsigned int reg) // Функция записи регистра
{  union U dat;
PORTA.3=0; // SPI_SS ON
while(PINA.6==1); //Ждем 0 на MISO
 
 dat.buf=reg;
 SPI_SEND(dat.b[1]);  //Адрес регистра 
 SPI_SEND(dat.b[0]);  //Значение регистра 
 PORTA.3=1; // SPI_SS OFF
}
//********************************************************************************************
unsigned char READ_REG(unsigned char adr)  // Функция чтения регистра
{  unsigned char reg;
   PORTA.3=0; // SPI_SS ON
   while(PINA.6==1); //Ждем 0 на MISO   
   SPI_SEND(adr | 0x80);   // Старший бит определяет операцию  
   reg= SPI_SEND(0x00);
   return reg; 
   PORTA.3=1; // SPI_SS OFF 
}
//**********************************************************************************************
 void INIT_TR(void) //Функция инициализации трансивера
 {
 
 
  for (i=0;i<35;i++)
   {
    WRITE_REG(init[i]);
    };
    
    
  
 }
//********************************************************************************************
void WRITE_PATABLE(void)    //Запись таблицы мощности
{
PORTA.3=0; // SPI_SS ON
   while(PINA.6==1); //Ждем 0 на MISO  
WRITE_REG(0x3EC0);         //Запись значения выходной мощности передатчика +1dbm
   PORTA.3=1; // SPI_SS OFF 
}
//*********************************************************************************************
void STROB(unsigned char strob)  //Запись строб-команды
{
PORTA.3=0; // SPI_SS ON
 while(PINA.6==1); //Ждем 0 на MISO 
 SPI_SEND(strob);
  PORTA.3=1; // SPI_SS OFF
}
//******************************************************************************************
unsigned char STATUS(void)
{ unsigned char st;
PORTA.3=0; // SPI_SS ON
while(PINA.6==1); //Ждем 0 на MISO
st=SPI_SEND(SNOP);
PORTA.3=1; // SPI_SS OFF
return st; 
}
//********************************************************************************************
void SEND_PAKET(unsigned char pktlen) //Функция передачи пакета
{
  STROB(SIDLE);  //Переход в режим IDLE
  STROB(SFRX);  //Очистка приемного буфера
  STROB(SFTX); //Очистка передающего буфера
  delay_ms(1);
  PORTA.3=0; // SPI_SS ON
 while(PINA.6==1); //Ждем 0 на MISO 
  SPI_SEND(0x7F);   //Открытие буфера на запись
  SPI_SEND(pktlen); //Запись длинны пакета
  for (i=0;i<pktlen;i++)  //Запмсь пакета
  {
   SPI_SEND(SPI_buffer[i]); 
  }
PORTA.3=1; // SPI_SS OFF
  //GICR=0x00; //Запрет прерывания по приему пакета
  STROB(STX); //Включение передачи
  
 while(PINA.0==0); 
 while(PINA.0==1); 
  STROB(SIDLE);  //Переход в режим IDLE
  STROB(SFRX);  //Очистка приемного буфера
  STROB(SFTX); //Очистка передающего буфера
 // GIFR=0xFF;  //Сброс флага прерывания
  //GICR=0xC0;   //Разрешение прерывания по приему пакета
}
//********************************************************************************************
unsigned char RECEIVE_PAKET(void) //Функция приема пакета
{
unsigned char pktlen;
STROB(SIDLE);  //Переход в режим IDLE
PORTB.2=0; // SPI_SS ON
 PORTA.3=0; // SPI_SS ON
 while(PINA.6==1); //Ждем 0 на MISO 
 SPI_SEND(0xFF);  //Открытие буфера приема
pktlen=SPI_SEND(0x00); //Считывание длинны пакета
for (i=0;i<pktlen;i++)    //Считывание пакета
   {
   SPI_buffer[i]=SPI_SEND(0x00);
   } 
PORTA.3=1; // SPI_SS OFF
STROB(SFRX);
return pktlen; //Возврат длинны пакета   
 } 
 //*******************************************************************************************
 void CLEAR_SPI_buffer(void) //Очистка SPI буфера
 { for (i=0;i<64;i++)
   {
    SPI_buffer[i]=0x00;
   }
 }
 //********************************************************************************************
  // Запись строки в SPI буффер
 unsigned char Write_SPI_buffer(flash char *str)
 {
  i=0;
  while(*str)
  {
  SPI_buffer[i++]=*str++;
  
  }
 return i;
  }
//*******************************************************************************************
//===========================ПРЕРЫВАНИЯ======================================================
// Timer 0 output compare A interrupt service routine
interrupt [TIM0_COMPA] void timer0_compa_isr(void)    //Прерывание по совпадению таймера
{   #asm("sei")
USICR |= (1<<USITC); // Задание тактового импульса

}
//*******************************************************************************************
// Pin change 0-7 interrupt service routine
interrupt [PC_INT0] void pin_change_isr0(void)
{ // PORTA.2=1; //Светодиод 1 
   //PORTA.7=0; //Светодиод 2
      GIMSK=0x00;
      #asm("sei")
     while(PINA.0==1); 
      len=RECEIVE_PAKET();
       
       if (strstr(SPI_buffer,"SECUR")!=NULL)
       { PORTA.2=1; //Светодиод 1 
        PORTA.7=0;} //Светодиод 2 
        if (strstr(SPI_buffer,"IDLE")!=NULL) 
        {  PORTA.2=0; //Светодиод 1 
           PORTA.7=1;} //Светодиод 2 
         if (strstr(SPI_buffer,"CLEAR_OK")!=NULL)    
            {for(i=0;i<5;i++)
              {PORTA.2=0; //Светодиод 1 
               PORTA.7=1;  //Светодиод 2
               delay_ms(200);
               PORTA.2=1; //Светодиод 1 
               PORTA.7=0;  //Светодиод 2
               delay_ms(200);
               
                 

              }
            }
           
         CLEAR_SPI_buffer();
         delay_ms(500);
}
//********************************************************************************************
// Pin change 8-11 interrupt service routine
interrupt [PC_INT1] void pin_change_isr1(void)
{
GIMSK=0x00;
#asm("sei")
RESET_TR(); 
delay_ms(10);     
INIT_TR();
WRITE_PATABLE(); 



delay_ms(300);
if((PINB.0==0)&&(PINB.1==0))
{ PORTA.2=1; //Светодиод 1 
  PORTA.7=1; //Светодиод 2 
  delay_ms(1000);
  if((PINB.0==0)&&(PINB.1==0))SEND_PAKET(Write_SPI_buffer("DATCHIK026026")); 
  

 } 
 else{
if((PINB.0==0))  SEND_PAKET(Write_SPI_buffer("BRELOK250250-READ")); 
if((PINB.1==0))  SEND_PAKET(Write_SPI_buffer("BRELOK250250-CHANGE")); } 
 CLEAR_SPI_buffer();
  GIFR|=0x10;
  GIMSK=0x10;
  STROB(SRX);
   delay_ms(1000);
   while ((PINB.0==0)||(PINB.1==0));
   GIFR|=0x30;
   GIMSK=0x20; 
   PORTA.2=0; //Светодиод 1 
  PORTA.7=0; //Светодиод 2 
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
// Interrupt on any change on pins PCINT0-7: On
// Interrupt on any change on pins PCINT8-11: On
MCUCR=0x00;
PCMSK0=0x01;
PCMSK1=0x03;
GIMSK=0x20;
GIFR=0x30;
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
 PORTA.2=1; //Светодиод 1 
 PORTA.7=0; //Светодиод 2
      delay_ms(1000);
      
      RESET_TR(); 
      delay_ms(10);     
      INIT_TR();
      WRITE_PATABLE(); 
      
while (1)

      {  PORTA.2=0; //Светодиод 1 
         PORTA.7=0; //Светодиод 2 
        STROB(SPWD);
        delay_ms(10);
        MCUCR|=0x30 ; //Разрешение перехода в спящий режим
        #asm("SLEEP")
        delay_ms(500);   
      }
}
