
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega164PV
;Program type             : Application
;Clock frequency          : 7,372800 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega164PV
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1279
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R3
	.DEF _i=R5
	.DEF _j=R8
	.DEF _PGM=R7
	.DEF _x=R9

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _pin_change_isr0
	JMP  0x00
	JMP  _pin_change_isr2
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_init:
	.DB  0x6,0x0,0x6,0x2,0xFF,0x6,0x4,0x7
	.DB  0x5,0x8,0x1,0x9,0x2F,0xA,0x6,0xB
	.DB  0x0,0xC,0x10,0xD,0x9,0xE,0x7B,0xF
	.DB  0x85,0x10,0x78,0x11,0x3,0x12,0x2,0x13
	.DB  0xE5,0x14,0x14,0x15,0x30,0x17,0x18,0x18
	.DB  0x16,0x19,0x6C,0x1A,0xC0,0x1B,0x0,0x1C
	.DB  0xB2,0x1D,0xB6,0x21,0x10,0x22,0xE9,0x23
	.DB  0x2A,0x24,0x0,0x25,0x1F,0x26,0x59,0x29
	.DB  0x81,0x2C,0x35,0x2D,0x9,0x2E
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x297:
	.DB  0x0
_0x0:
	.DB  0x41,0x54,0xD,0x0,0x41,0x54,0x2B,0x43
	.DB  0x52,0x45,0x47,0x3F,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x4C,0x49,0x50,0x3D,0x31,0xD
	.DB  0x0,0x2C,0x22,0x2B,0x37,0x0,0x41,0x54
	.DB  0x2B,0x43,0x55,0x53,0x44,0x3D,0x31,0x2C
	.DB  0x22,0x2A,0x31,0x30,0x30,0x23,0x22,0xD
	.DB  0x0,0x41,0x54,0x2B,0x43,0x55,0x53,0x44
	.DB  0x3D,0x31,0x2C,0x22,0x2A,0x31,0x30,0x32
	.DB  0x23,0x22,0xD,0x0,0x2B,0x43,0x55,0x53
	.DB  0x44,0x3A,0x0,0x30,0x34,0x31,0x31,0x30
	.DB  0x34,0x33,0x30,0x30,0x34,0x33,0x42,0x30
	.DB  0x34,0x33,0x30,0x30,0x34,0x33,0x44,0x30
	.DB  0x34,0x34,0x31,0x0,0x30,0x34,0x34,0x30
	.DB  0x0,0x41,0x54,0x2B,0x43,0x4D,0x47,0x53
	.DB  0x3D,0x25,0x30,0x32,0x64,0xD,0x0,0x30
	.DB  0x30,0x30,0x31,0x30,0x30,0x30,0x42,0x39
	.DB  0x31,0x0,0x30,0x30,0x30,0x38,0x25,0x30
	.DB  0x32,0x58,0x0,0x41,0x54,0x2B,0x43,0x50
	.DB  0x42,0x46,0x3D,0x22,0x4E,0x31,0x22,0xD
	.DB  0x0,0x41,0x54,0x2B,0x43,0x50,0x42,0x46
	.DB  0x3D,0x22,0x4E,0x32,0x22,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x50,0x42,0x46,0x3D,0x22
	.DB  0x4E,0x33,0x22,0xD,0x0,0x41,0x54,0x2B
	.DB  0x43,0x50,0x42,0x46,0x3D,0x22,0x4E,0x34
	.DB  0x22,0xD,0x0,0x41,0x54,0x2B,0x43,0x50
	.DB  0x42,0x46,0x3D,0x22,0x4E,0x35,0x22,0xD
	.DB  0x0,0x41,0x54,0x2B,0x43,0x50,0x42,0x46
	.DB  0x3D,0x22,0x4E,0x36,0x22,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x53,0x54,0x41,0x3D,0x31
	.DB  0x34,0x35,0xD,0x0,0x41,0x54,0x2A,0x50
	.DB  0x53,0x53,0x54,0x4B,0x49,0x3D,0x30,0xD
	.DB  0x0,0x41,0x54,0x44,0x22,0x0,0x22,0x3B
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x4D,0x47
	.DB  0x46,0x3D,0x30,0xD,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x47,0x53,0x3D,0x34,0x35,0xD
	.DB  0x0,0x30,0x30,0x30,0x38,0x32,0x30,0x30
	.DB  0x34,0x31,0x34,0x30,0x34,0x33,0x30,0x30
	.DB  0x34,0x34,0x32,0x30,0x34,0x34,0x37,0x30
	.DB  0x34,0x33,0x38,0x30,0x34,0x33,0x41,0x30
	.DB  0x30,0x32,0x30,0x0,0x30,0x30,0x33,0x31
	.DB  0x0,0x30,0x30,0x33,0x32,0x0,0x30,0x30
	.DB  0x33,0x33,0x0,0x30,0x30,0x33,0x34,0x0
	.DB  0x30,0x30,0x33,0x35,0x0,0x30,0x30,0x33
	.DB  0x36,0x0,0x30,0x30,0x33,0x37,0x0,0x30
	.DB  0x30,0x33,0x38,0x0,0x30,0x30,0x32,0x30
	.DB  0x30,0x34,0x34,0x32,0x30,0x34,0x34,0x30
	.DB  0x30,0x34,0x33,0x35,0x30,0x34,0x33,0x32
	.DB  0x30,0x34,0x33,0x45,0x30,0x34,0x33,0x33
	.DB  0x30,0x34,0x33,0x30,0x1A,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x57,0x3D,0x31,0x2C
	.DB  0x22,0x0,0x22,0x2C,0x31,0x34,0x35,0x2C
	.DB  0x22,0x4E,0x31,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x57,0x3D,0x32,0x2C
	.DB  0x22,0x0,0x22,0x2C,0x31,0x34,0x35,0x2C
	.DB  0x22,0x4E,0x32,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x57,0x3D,0x33,0x2C
	.DB  0x22,0x0,0x22,0x2C,0x31,0x34,0x35,0x2C
	.DB  0x22,0x4E,0x33,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x57,0x3D,0x34,0x2C
	.DB  0x22,0x0,0x22,0x2C,0x31,0x34,0x35,0x2C
	.DB  0x22,0x4E,0x34,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x57,0x3D,0x35,0x2C
	.DB  0x22,0x0,0x22,0x2C,0x31,0x34,0x35,0x2C
	.DB  0x22,0x4E,0x35,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x57,0x3D,0x36,0x2C
	.DB  0x22,0x0,0x22,0x2C,0x31,0x34,0x35,0x2C
	.DB  0x22,0x4E,0x36,0x22,0xD,0x0,0x42,0x52
	.DB  0x45,0x4C,0x4F,0x4B,0x0,0x43,0x48,0x41
	.DB  0x4E,0x47,0x45,0x0,0x53,0x45,0x43,0x55
	.DB  0x52,0x0,0x49,0x44,0x4C,0x45,0x0,0x44
	.DB  0x41,0x54,0x43,0x48,0x49,0x4B,0x0,0x41
	.DB  0x54,0x2B,0x43,0x50,0x42,0x57,0x3D,0x31
	.DB  0xD,0x0,0x52,0x49,0x4E,0x47,0x0,0x41
	.DB  0x54,0x48,0xD,0x0,0x41,0x54,0x2B,0x43
	.DB  0x50,0x42,0x57,0x3D,0x32,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x50,0x42,0x57,0x3D,0x33
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x50,0x42
	.DB  0x57,0x3D,0x34,0xD,0x0,0x41,0x54,0x2B
	.DB  0x43,0x50,0x42,0x57,0x3D,0x35,0xD,0x0
	.DB  0x41,0x54,0x2B,0x43,0x50,0x42,0x57,0x3D
	.DB  0x36,0xD,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0xED
	.DW  _0x0*2+25

	.DW  0x07
	.DW  _0xFB
	.DW  _0x0*2+68

	.DW  0x19
	.DW  _0xFB+7
	.DW  _0x0*2+75

	.DW  0x05
	.DW  _0xFB+32
	.DW  _0x0*2+100

	.DW  0x05
	.DW  _0x10C
	.DW  _0x0*2+25

	.DW  0x04
	.DW  _0x133
	.DW  _0x0*2+26

	.DW  0x07
	.DW  _0x162
	.DW  _0x0*2+534

	.DW  0x07
	.DW  _0x162+7
	.DW  _0x0*2+541

	.DW  0x08
	.DW  _0x162+14
	.DW  _0x0*2+559

	.DW  0x05
	.DW  _0x1AC
	.DW  _0x0*2+578

	.DW  0x05
	.DW  _0x1AC+5
	.DW  _0x0*2+578

	.DW  0x05
	.DW  _0x1AC+10
	.DW  _0x0*2+578

	.DW  0x05
	.DW  _0x1AC+15
	.DW  _0x0*2+578

	.DW  0x05
	.DW  _0x1AC+20
	.DW  _0x0*2+578

	.DW  0x05
	.DW  _0x1AC+25
	.DW  _0x0*2+578

	.DW  0x01
	.DW  0x07
	.DW  _0x297*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : DWS
;Version :
;Date    : 06.07.2012
;Author  : Alexandr Gordejchik
;Company : NTS
;Comments:
;
;
;Chip type               : ATmega164PV
;Program type            : Application
;AVR Core Clock frequency: 3,686400 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega164.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <stdio.h>
;#include <spi.h>
;
;//++++++++++++ Определение строб-комманд трансивера+++++++++++++++++++++++++++++++++++++++++++++++++++++
;#define SRES 0x30 //Сброс трансивера
;#define SIDLE 0x36 //Переход в режим IDLE
;#define SCAL 0x33   // Калибровка частотного синтезатора
;#define SRX 0x34   // Переход в режим RX
;#define STX 0x35   // Переход в режим TX
;#define SFRX 0x3A  // Очистка RX FIFO
;#define SFTX 0x3B  // Очистка TX FIFO
;#define SNOP 0x3D  // Пустая строб-команда
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; // Массив инициализации регистров (старший байт - адрес, младший - значение)
;flash unsigned int init[35]=
;{
; 0x0006, //0 IOGFG2 Обнаружение несущей
; 0x0206, //1 IOGFG0 Прием-передача пакета
; 0x06FF, //2 PKTLEN Длинна пакета
; 0x0704, //3 PKRCTRL1 Контроль пакета
; 0x0805, //4 PKRCTRL0 Контроль пакета
; 0x0901, //5 ADDR Адрес устройства
; 0x0A2F, //6 CHANNR Номер канала
; 0x0B06, //7 FSCTRL1 Параметры контроля синтезатора частоты
; 0x0C00, //8 FSCTRL0 Параметры контроля синтезатора частоты
; 0x0D10, //9 FREQ2 Параметы опорной частоты
; 0x0E09, //10 FREQ1 Параметы опорной частоты
; 0x0F7B, //11 FREQ0 Параметы опорной частоты
; 0x1085, //12 MDMCFG4 Конфигурация модема
; 0x1178, //13 MDMCFG3 Конфигурация модема
; 0x1203, //14 MDMCFG2 Конфигурация модема
; 0x1302, //15 MDMCFG1 Конфигурация модема
; 0x14E5, //16 MDMCFG0 Конфигурация модема
; 0x1514, //17 DEVIATION Девиация
; 0x1730, //18 MCSM1 Конфигурация автомата контроля радио
; 0x1818, //19 MCSM0 Конфигурация автомата контроля радио
; 0x1916, //20 FOCCFG Компенсация сдвига частоты
; 0x1A6C, //21 BSCFG Конфигурация побитовой синхронизации
; 0x1BC0, //22 AGCCTRL2 Пармаметры приемного тракта
; 0x1C00, //23 AGCCTRL1 Пармаметры приемного тракта
; 0x1DB2, //24 AGCCTRL0 Пармаметры приемного тракта
; 0x21B6, //25 FREND1 Параметры приемного тракта
; 0x2210, //26 FREND0 Параметры передающего тракта
; 0x23E9, //27 FSCAL3 Параметры калибровки синтезатора частоты
; 0x242A, //28 FSCAL2 Параметры калибровки синтезатора частоты
; 0x2500, //29 FSCAL1 Параметры калибровки синтезатора частоты
; 0x261F, //30 FSCAL0 Параметры калибровки синтезатора частоты
; 0x2959, //31 FSTEST Проверка синтезаторы частоты
; 0x2C81, //32 TEST2
; 0x2D35, //33 TEST1
; 0x2E09  //34 TEST0
;};
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;union U      // Определение объединения
;		{
;			unsigned int buf;
;			unsigned char b[2];
;		};
;
;union U1
;        {
;         unsigned char byte;
;         // bit Bit[8];
;
;         struct{
;
;			unsigned char b0:1;
;			unsigned char b1:1;
;			unsigned char b2:1;
;			unsigned char b3:1;
;			unsigned char b4:1;
;			unsigned char b5:1;
;			unsigned char b6:1;
;			unsigned char b7:1;
;
;		    } Bit;
;
;         struct{
;
;			unsigned char l4:2;
;			unsigned char l3:2;
;			unsigned char l2:2;
;			unsigned char l1:2;
;
;		    }Led;
;
;        };
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 512
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0;
;#else
;unsigned int rx_wr_index0;
;#endif
;
;
;unsigned char NR[12];     // Массив телефонного номер
;
;// Определение глобальных переменных
;//char z;          //Переменная статуса охраны
;unsigned int i; //Основной  счетчик
;unsigned char j; //Счетчик
;unsigned char SPI_buffer[64];
;unsigned char PGM=0;
;unsigned char *x;
;eeprom union U1 LD1;
;eeprom union U1 LD2;
;eeprom union U1 LD3;
;
;eeprom unsigned char DAT1[]="026026";
;eeprom unsigned char DAT2[]="128128";
;eeprom unsigned char DAT3[]="256256";
;eeprom unsigned char DAT4[]="FFFFFF";
;eeprom unsigned char DAT5[]="FFFFFF";
;eeprom unsigned char DAT6[]="FFFFFF";
;eeprom unsigned char DAT7[]="FFFFFF";
;eeprom unsigned char DAT8[]="FFFFFF";
;
;eeprom unsigned char BREL1[]="164164";
;eeprom unsigned char BREL2[]="250250";
;eeprom unsigned char BREL3[]="FFFFFF";
;eeprom unsigned char BREL4[]="FFFFFF";
;eeprom unsigned char BREL5[]="FFFFFF";
;eeprom unsigned char BREL6[]="FFFFFF";
;
;eeprom unsigned char OP;
;eeprom unsigned char COUNT;
;eeprom unsigned char STAT[256];
;
;
;//======================================================================================================================================
;//========================================ФУНКЦИИ===================================================================================
;//=====================================================================================================================================
;void LOAD_LD(void)  //Загрузка состояния светодиодов
; 0000 00C8 
; 0000 00C9 {

	.CSEG
_LOAD_LD:
; 0000 00CA union U1 LD;
; 0000 00CB 
; 0000 00CC 
; 0000 00CD PORTA.4=0;
	SBIW R28,1
;	LD -> Y+0
	CBI  0x2,4
; 0000 00CE  LD.byte=LD3.byte;
	CALL SUBOPT_0x0
	ST   Y,R30
; 0000 00CF for (i=0;i<8;i++)
	CLR  R5
	CLR  R6
_0x6:
	CALL SUBOPT_0x1
	BRSH _0x7
; 0000 00D0   {
; 0000 00D1    PORTA.2=LD.Bit.b0;
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x8
	CBI  0x2,2
	RJMP _0x9
_0x8:
	SBI  0x2,2
_0x9:
; 0000 00D2    LD.byte= LD.byte>>1;
	CALL SUBOPT_0x2
; 0000 00D3    delay_ms(1);
; 0000 00D4    PORTA.3=1;
; 0000 00D5    delay_ms(1);
; 0000 00D6    PORTA.3=0;
; 0000 00D7   }
	CALL SUBOPT_0x3
	RJMP _0x6
_0x7:
; 0000 00D8  LD.byte=LD2.byte;
	CALL SUBOPT_0x4
	ST   Y,R30
; 0000 00D9 for (i=0;i<8;i++)
	CLR  R5
	CLR  R6
_0xF:
	CALL SUBOPT_0x1
	BRSH _0x10
; 0000 00DA   {
; 0000 00DB    PORTA.2=LD.Bit.b0;
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x11
	CBI  0x2,2
	RJMP _0x12
_0x11:
	SBI  0x2,2
_0x12:
; 0000 00DC    LD.byte= LD.byte>>1;
	CALL SUBOPT_0x2
; 0000 00DD    delay_ms(1);
; 0000 00DE    PORTA.3=1;
; 0000 00DF    delay_ms(1);
; 0000 00E0    PORTA.3=0;
; 0000 00E1   }
	CALL SUBOPT_0x3
	RJMP _0xF
_0x10:
; 0000 00E2  LD.byte=LD1.byte;
	CALL SUBOPT_0x5
	ST   Y,R30
; 0000 00E3 for (i=0;i<8;i++)
	CLR  R5
	CLR  R6
_0x18:
	CALL SUBOPT_0x1
	BRSH _0x19
; 0000 00E4   {
; 0000 00E5    PORTA.2=LD.Bit.b0;
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x1A
	CBI  0x2,2
	RJMP _0x1B
_0x1A:
	SBI  0x2,2
_0x1B:
; 0000 00E6    LD.byte=LD.byte>>1;
	CALL SUBOPT_0x2
; 0000 00E7    delay_ms(1);
; 0000 00E8    PORTA.3=1;
; 0000 00E9    delay_ms(1);
; 0000 00EA    PORTA.3=0;
; 0000 00EB   }
	CALL SUBOPT_0x3
	RJMP _0x18
_0x19:
; 0000 00EC  PORTA.5=1; //Погасить все светодиоды
	SBI  0x2,5
; 0000 00ED  PORTA.4=1;
	SBI  0x2,4
; 0000 00EE  delay_ms(1);
	CALL SUBOPT_0x6
; 0000 00EF  PORTA.4=0;
	CBI  0x2,4
; 0000 00F0  PORTA.5=0; //Зажечь светодиоды
	CBI  0x2,5
; 0000 00F1 }
	RJMP _0x20C0007
;//*********************************************************************************************
; char VALID_CODE(char *str1, eeprom char *str2, char n) //Функция проверки кода
; 0000 00F4 {  char e;
_VALID_CODE:
; 0000 00F5     e=0;
	ST   -Y,R17
;	*str1 -> Y+4
;	*str2 -> Y+2
;	n -> Y+1
;	e -> R17
	LDI  R17,LOW(0)
; 0000 00F6  for(i=0;i<n;i++)
	CLR  R5
	CLR  R6
_0x29:
	LDD  R30,Y+1
	CALL SUBOPT_0x7
	BRSH _0x2A
; 0000 00F7 
; 0000 00F8   {  if((*str1++)!=(*str2++))
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R0,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,1
	STD  Y+2,R26
	STD  Y+2+1,R27
	SBIW R26,1
	CALL __EEPROMRDB
	CP   R30,R0
	BREQ _0x2B
; 0000 00F9      { e=NULL;
	LDI  R17,LOW(0)
; 0000 00FA         break;}
	RJMP _0x2A
; 0000 00FB      else e=e+1;
_0x2B:
	SUBI R17,-LOW(1)
; 0000 00FC    // STAT[i]=*str2++;
; 0000 00FD   }
	CALL SUBOPT_0x8
	RJMP _0x29
_0x2A:
; 0000 00FE 
; 0000 00FF   return e;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,6
	RET
; 0000 0100 }
;//**************************************************************************************************
;void PROGRAM_DAT(char dev) //Функция прогаммирования датчика
; 0000 0103 { if(dev=='D')
_PROGRAM_DAT:
;	dev -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x44)
	BRNE _0x2D
; 0000 0104 {
; 0000 0105  if (VALID_CODE(x,DAT1,6)!=NULL){PGM=0xFF; return;}
	CALL SUBOPT_0x9
	BREQ _0x2E
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0106  if (VALID_CODE(x,DAT2,6)!=NULL){PGM=0xFF; return;}
_0x2E:
	CALL SUBOPT_0xA
	BREQ _0x2F
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0107  if (VALID_CODE(x,DAT3,6)!=NULL){PGM=0xFF; return;}
_0x2F:
	CALL SUBOPT_0xB
	BREQ _0x30
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0108  if (VALID_CODE(x,DAT4,6)!=NULL){PGM=0xFF; return;}
_0x30:
	CALL SUBOPT_0xC
	BREQ _0x31
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0109  if (VALID_CODE(x,DAT5,6)!=NULL){PGM=0xFF; return;}
_0x31:
	CALL SUBOPT_0xD
	BREQ _0x32
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 010A  if (VALID_CODE(x,DAT6,6)!=NULL){PGM=0xFF; return;}
_0x32:
	CALL SUBOPT_0xE
	BREQ _0x33
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 010B  if (VALID_CODE(x,DAT7,6)!=NULL){PGM=0xFF; return;}
_0x33:
	CALL SUBOPT_0xF
	BREQ _0x34
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 010C  if (VALID_CODE(x,DAT8,6)!=NULL){PGM=0xFF; return;}
_0x34:
	CALL SUBOPT_0x10
	BREQ _0x35
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 010D  }
_0x35:
; 0000 010E else if(dev=='B')
	RJMP _0x36
_0x2D:
	LD   R26,Y
	CPI  R26,LOW(0x42)
	BRNE _0x37
; 0000 010F {
; 0000 0110  if (VALID_CODE(x,BREL1,6)!=NULL){PGM=0xFF; return;}
	CALL SUBOPT_0x11
	BREQ _0x38
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0111  if (VALID_CODE(x,BREL2,6)!=NULL){PGM=0xFF; return;}
_0x38:
	CALL SUBOPT_0x12
	BREQ _0x39
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0112  if (VALID_CODE(x,BREL3,6)!=NULL){PGM=0xFF; return;}
_0x39:
	CALL SUBOPT_0x13
	BREQ _0x3A
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0113  if (VALID_CODE(x,BREL4,6)!=NULL){PGM=0xFF; return;}
_0x3A:
	CALL SUBOPT_0x14
	BREQ _0x3B
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0114  if (VALID_CODE(x,BREL5,6)!=NULL){PGM=0xFF; return;}
_0x3B:
	CALL SUBOPT_0x15
	BREQ _0x3C
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0115  if (VALID_CODE(x,BREL6,6)!=NULL){PGM=0xFF; return;}
_0x3C:
	CALL SUBOPT_0x16
	BREQ _0x3D
	LDI  R30,LOW(255)
	MOV  R7,R30
	RJMP _0x20C0007
; 0000 0116 }
_0x3D:
; 0000 0117  switch (PGM)
_0x37:
_0x36:
	MOV  R30,R7
	CALL SUBOPT_0x17
; 0000 0118   {
; 0000 0119 
; 0000 011A    case 1 :{
	BRNE _0x41
; 0000 011B            for(i=0;i<6;i++) DAT1[i]=*x++;
	CLR  R5
	CLR  R6
_0x43:
	CALL SUBOPT_0x18
	BRSH _0x44
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT1)
	SBCI R27,HIGH(-_DAT1)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x43
_0x44:
; 0000 011C PGM=0xDF;
	RJMP _0x281
; 0000 011D            break;
; 0000 011E            }
; 0000 011F 
; 0000 0120     case 2 :{
_0x41:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x45
; 0000 0121            for(i=0;i<6;i++) DAT2[i]=*x++;
	CLR  R5
	CLR  R6
_0x47:
	CALL SUBOPT_0x18
	BRSH _0x48
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT2)
	SBCI R27,HIGH(-_DAT2)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x47
_0x48:
; 0000 0122 PGM=0xDF;
	RJMP _0x281
; 0000 0123            break;
; 0000 0124            }
; 0000 0125 
; 0000 0126     case 3 :{
_0x45:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x49
; 0000 0127            for(i=0;i<6;i++) DAT3[i]=*x++;
	CLR  R5
	CLR  R6
_0x4B:
	CALL SUBOPT_0x18
	BRSH _0x4C
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT3)
	SBCI R27,HIGH(-_DAT3)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x4B
_0x4C:
; 0000 0128 PGM=0xDF;
	RJMP _0x281
; 0000 0129            break;
; 0000 012A            }
; 0000 012B 
; 0000 012C     case 4 :{
_0x49:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4D
; 0000 012D            for(i=0;i<6;i++) DAT4[i]=*x++;
	CLR  R5
	CLR  R6
_0x4F:
	CALL SUBOPT_0x18
	BRSH _0x50
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT4)
	SBCI R27,HIGH(-_DAT4)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x4F
_0x50:
; 0000 012E PGM=0xDF;
	RJMP _0x281
; 0000 012F            break;
; 0000 0130            }
; 0000 0131 
; 0000 0132     case 5 :{
_0x4D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x51
; 0000 0133            for(i=0;i<6;i++) DAT5[i]=*x++;
	CLR  R5
	CLR  R6
_0x53:
	CALL SUBOPT_0x18
	BRSH _0x54
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT5)
	SBCI R27,HIGH(-_DAT5)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x53
_0x54:
; 0000 0134 PGM=0xDF;
	RJMP _0x281
; 0000 0135            break;
; 0000 0136            }
; 0000 0137 
; 0000 0138      case 6 :{
_0x51:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x55
; 0000 0139            for(i=0;i<6;i++) DAT6[i]=*x++;
	CLR  R5
	CLR  R6
_0x57:
	CALL SUBOPT_0x18
	BRSH _0x58
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT6)
	SBCI R27,HIGH(-_DAT6)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x57
_0x58:
; 0000 013A PGM=0xDF;
	RJMP _0x281
; 0000 013B            break;
; 0000 013C            }
; 0000 013D 
; 0000 013E      case 7 :{
_0x55:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x59
; 0000 013F            for(i=0;i<6;i++) DAT7[i]=*x++;
	CLR  R5
	CLR  R6
_0x5B:
	CALL SUBOPT_0x18
	BRSH _0x5C
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT7)
	SBCI R27,HIGH(-_DAT7)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x5B
_0x5C:
; 0000 0140 PGM=0xDF;
	RJMP _0x281
; 0000 0141            break;
; 0000 0142            }
; 0000 0143 
; 0000 0144 
; 0000 0145     case 8 :{
_0x59:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x5D
; 0000 0146            for(i=0;i<6;i++) DAT8[i]=*x++;
	CLR  R5
	CLR  R6
_0x5F:
	CALL SUBOPT_0x18
	BRSH _0x60
	__GETW2R 5,6
	SUBI R26,LOW(-_DAT8)
	SBCI R27,HIGH(-_DAT8)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x5F
_0x60:
; 0000 0147 PGM=0xDF;
	RJMP _0x281
; 0000 0148            break;
; 0000 0149            }
; 0000 014A 
; 0000 014B    case 11 :{
_0x5D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x61
; 0000 014C            for(i=0;i<6;i++) BREL1[i]=*x++;
	CLR  R5
	CLR  R6
_0x63:
	CALL SUBOPT_0x18
	BRSH _0x64
	__GETW2R 5,6
	SUBI R26,LOW(-_BREL1)
	SBCI R27,HIGH(-_BREL1)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x63
_0x64:
; 0000 014D PGM=0xDF;
	RJMP _0x281
; 0000 014E            break;
; 0000 014F            }
; 0000 0150 
; 0000 0151     case 12 :{
_0x61:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x65
; 0000 0152            for(i=0;i<6;i++) BREL2[i]=*x++;
	CLR  R5
	CLR  R6
_0x67:
	CALL SUBOPT_0x18
	BRSH _0x68
	__GETW2R 5,6
	SUBI R26,LOW(-_BREL2)
	SBCI R27,HIGH(-_BREL2)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x67
_0x68:
; 0000 0153 PGM=0xDF;
	RJMP _0x281
; 0000 0154            break;
; 0000 0155            }
; 0000 0156 
; 0000 0157      case 13 :{
_0x65:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x69
; 0000 0158            for(i=0;i<6;i++) BREL3[i]=*x++;
	CLR  R5
	CLR  R6
_0x6B:
	CALL SUBOPT_0x18
	BRSH _0x6C
	__GETW2R 5,6
	SUBI R26,LOW(-_BREL3)
	SBCI R27,HIGH(-_BREL3)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x6B
_0x6C:
; 0000 0159 PGM=0xDF;
	RJMP _0x281
; 0000 015A            break;
; 0000 015B            }
; 0000 015C 
; 0000 015D       case 14 :{
_0x69:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x6D
; 0000 015E            for(i=0;i<6;i++) BREL4[i]=*x++;
	CLR  R5
	CLR  R6
_0x6F:
	CALL SUBOPT_0x18
	BRSH _0x70
	__GETW2R 5,6
	SUBI R26,LOW(-_BREL4)
	SBCI R27,HIGH(-_BREL4)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x6F
_0x70:
; 0000 015F PGM=0xDF;
	RJMP _0x281
; 0000 0160            break;
; 0000 0161            }
; 0000 0162 
; 0000 0163        case 15 :{
_0x6D:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x71
; 0000 0164            for(i=0;i<6;i++) BREL5[i]=*x++;
	CLR  R5
	CLR  R6
_0x73:
	CALL SUBOPT_0x18
	BRSH _0x74
	__GETW2R 5,6
	SUBI R26,LOW(-_BREL5)
	SBCI R27,HIGH(-_BREL5)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x73
_0x74:
; 0000 0165 PGM=0xDF;
	RJMP _0x281
; 0000 0166            break;
; 0000 0167            }
; 0000 0168 
; 0000 0169         case 16 :{
_0x71:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x40
; 0000 016A            for(i=0;i<6;i++) BREL6[i]=*x++;
	CLR  R5
	CLR  R6
_0x77:
	CALL SUBOPT_0x18
	BRSH _0x78
	__GETW2R 5,6
	SUBI R26,LOW(-_BREL6)
	SBCI R27,HIGH(-_BREL6)
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3
	RJMP _0x77
_0x78:
; 0000 016B PGM=0xDF;
_0x281:
	LDI  R30,LOW(223)
	MOV  R7,R30
; 0000 016C            break;
; 0000 016D            }
; 0000 016E 
; 0000 016F    }
_0x40:
; 0000 0170 }
	RJMP _0x20C0007
;
; //==================ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ============================================
; //*******************************************************************************************
; unsigned char SPI_SEND(unsigned char data)  // Передать/принять байт  по SPI
; 0000 0175 {
_SPI_SEND:
; 0000 0176 SPDR = data;
;	data -> Y+0
	LD   R30,Y
	OUT  0x2E,R30
; 0000 0177 		while (!(SPSR & (1<<SPIF)));
_0x79:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ _0x79
; 0000 0178 		return SPDR;
	IN   R30,0x2E
	RJMP _0x20C0007
; 0000 0179 }
;
;
;//********************************************************************************************
; void RESET_TR(void) //Сброс трансивера по включению питания
; 0000 017E {
_RESET_TR:
; 0000 017F SPCR=0x00; //Отключение SPI
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 0180 PORTB.7=1; //Устанавливаем 1 на SCK
	SBI  0x5,7
; 0000 0181 PORTB.5=0;  // Устанавливаем 0 на MOSI
	CBI  0x5,5
; 0000 0182 PORTB.4=0; // SPI_SS ON
	CBI  0x5,4
; 0000 0183 delay_us(1);
	__DELAY_USB 2
; 0000 0184 PORTB.4=1; // SPI_SS OFF
	SBI  0x5,4
; 0000 0185 delay_us(40);
	__DELAY_USB 98
; 0000 0186 SPCR=0x50; //Включение SPI
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0000 0187 PORTB.4=0; // SPI_SS ON
	CBI  0x5,4
; 0000 0188 while(PINB.6==1); //Ждем 0 на MISO
_0x86:
	SBIC 0x3,6
	RJMP _0x86
; 0000 0189 SPI_SEND(SRES);
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 018A PORTB.4=1; // SPI_SS OFF
	RJMP _0x20C0008
; 0000 018B }
;//*******************************************************************************************
;void WRITE_REG( unsigned int reg) // Функция записи регистра
; 0000 018E {  union U dat;
_WRITE_REG:
; 0000 018F PORTB.4=0; // SPI_SS ON
	SBIW R28,2
;	reg -> Y+2
;	dat -> Y+0
	CBI  0x5,4
; 0000 0190 while(PINB.6==1); //Ждем 0 на MISO
_0x8D:
	SBIC 0x3,6
	RJMP _0x8D
; 0000 0191 
; 0000 0192  dat.buf=reg;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0193  SPI_SEND(dat.b[1]);  //Адрес регистра
	LDD  R30,Y+1
	CALL SUBOPT_0x1A
; 0000 0194  SPI_SEND(dat.b[0]);  //Значение регистра
; 0000 0195 PORTB.4=1; // SPI_SS OFF
	SBI  0x5,4
; 0000 0196 }
	RJMP _0x20C0006
;//*******************************************************************************************
;//********************************************************************************************
;unsigned char READ_REG(unsigned char adr)  // Функция чтения регистра
; 0000 019A {  unsigned char reg;
; 0000 019B   PORTB.4=0; // SPI_SS ON
;	adr -> Y+1
;	reg -> R17
; 0000 019C while(PINB.6==1); //Ждем 0 на MISO
; 0000 019D    SPI_SEND(adr | 0x80);   // Старший бит определяет операцию
; 0000 019E    reg= SPI_SEND(0x00);
; 0000 019F    return reg;
; 0000 01A0 PORTB.4=1; // SPI_SS OFF
; 0000 01A1 }
;//**********************************************************************************************
; void INIT_TR(void) //Функция инициализации трансивера
; 0000 01A4  {
_INIT_TR:
; 0000 01A5 
; 0000 01A6 
; 0000 01A7   for (i=0;i<35;i++)
	CLR  R5
	CLR  R6
_0x9A:
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	CP   R5,R30
	CPC  R6,R31
	BRSH _0x9B
; 0000 01A8    {
; 0000 01A9     WRITE_REG(init[i]);
	__GETW1R 5,6
	LDI  R26,LOW(_init*2)
	LDI  R27,HIGH(_init*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	CALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	RCALL _WRITE_REG
; 0000 01AA     };
	CALL SUBOPT_0x3
	RJMP _0x9A
_0x9B:
; 0000 01AB 
; 0000 01AC 
; 0000 01AD 
; 0000 01AE  }
	RET
; //********************************************************************************************
;void WRITE_PATABLE(void)    //Запись таблицы мощности
; 0000 01B1 {
_WRITE_PATABLE:
; 0000 01B2 PORTB.4=0; // SPI_SS ON
	CBI  0x5,4
; 0000 01B3 while(PINB.6==1); //Ждем 0 на MISO
_0x9E:
	SBIC 0x3,6
	RJMP _0x9E
; 0000 01B4 WRITE_REG(0x3EC0);         //Запись значения выходной мощности передатчика +10dbm
	LDI  R30,LOW(16064)
	LDI  R31,HIGH(16064)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _WRITE_REG
; 0000 01B5   PORTB.4=1; // SPI_SS OFF
_0x20C0008:
	SBI  0x5,4
; 0000 01B6 }
	RET
;//*********************************************************************************************
;void STROB(unsigned char strob)  //Запись строб-команды
; 0000 01B9 {
_STROB:
; 0000 01BA PORTB.4=0; // SPI_SS ON
;	strob -> Y+0
	CBI  0x5,4
; 0000 01BB while(PINB.6==1); //Ждем 0 на MISO
_0xA5:
	SBIC 0x3,6
	RJMP _0xA5
; 0000 01BC  SPI_SEND(strob);
	LD   R30,Y
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 01BD   PORTB.4=1; // SPI_SS OFF
	SBI  0x5,4
; 0000 01BE }
	RJMP _0x20C0007
;//******************************************************************************************
;unsigned char STATUS(void)  //Получение статуса трансивера
; 0000 01C1 { unsigned char st;
; 0000 01C2 PORTB.4=0; // SPI_SS ON
;	st -> R17
; 0000 01C3 while(PINB.6==1); //Ждем 0 на MISO
; 0000 01C4 st=SPI_SEND(SNOP);
; 0000 01C5  PORTB.4=1; // SPI_SS OFF
; 0000 01C6 return st;
; 0000 01C7 }
;//********************************************************************************************
;
;void SEND_PAKET(unsigned char pktlen) //Функция передачи пакета
; 0000 01CB {
_SEND_PAKET:
; 0000 01CC   STROB(SIDLE);  //Переход в режим IDLE
;	pktlen -> Y+0
	CALL SUBOPT_0x1B
; 0000 01CD   STROB(SFRX);  //Очистка приемного буфера
; 0000 01CE   STROB(SFTX); //Очистка передающего буфера
; 0000 01CF   delay_ms(1);
	CALL SUBOPT_0x6
; 0000 01D0   PORTB.4=0; // SPI_SS ON
	CBI  0x5,4
; 0000 01D1   while(PINB.6==1); //Ждем 0 на MISO
_0xB3:
	SBIC 0x3,6
	RJMP _0xB3
; 0000 01D2   SPI_SEND(0x7F);   //Открытие буфера на запись
	LDI  R30,LOW(127)
	CALL SUBOPT_0x1A
; 0000 01D3   SPI_SEND(pktlen); //Запись длинны пакета
; 0000 01D4   for (i=0;i<pktlen;i++)  //Запмсь пакета
	CLR  R5
	CLR  R6
_0xB7:
	LD   R30,Y
	CALL SUBOPT_0x7
	BRSH _0xB8
; 0000 01D5   {
; 0000 01D6    SPI_SEND(SPI_buffer[i]);
	LDI  R26,LOW(_SPI_buffer)
	LDI  R27,HIGH(_SPI_buffer)
	CALL SUBOPT_0x1C
	RCALL _SPI_SEND
; 0000 01D7   }
	CALL SUBOPT_0x8
	RJMP _0xB7
_0xB8:
; 0000 01D8   PORTB.4=1; // SPI_SS OFF
	SBI  0x5,4
; 0000 01D9   PCICR=0x04; //Запрет прерывания по приему пакета
	LDI  R30,LOW(4)
	STS  104,R30
; 0000 01DA   STROB(STX); //Включение передачи
	LDI  R30,LOW(53)
	ST   -Y,R30
	RCALL _STROB
; 0000 01DB 
; 0000 01DC   while(PINA.0==0); //Ожидание начала передачи
_0xBB:
	SBIS 0x0,0
	RJMP _0xBB
; 0000 01DD   while(PINA.0==1); //Ожидание конца передачи
_0xBE:
	SBIC 0x0,0
	RJMP _0xBE
; 0000 01DE   STROB(SIDLE);  //Переход в режим IDLE
	CALL SUBOPT_0x1B
; 0000 01DF   STROB(SFRX);  //Очистка приемного буфера
; 0000 01E0   STROB(SFTX); //Очистка передающего буфера
; 0000 01E1   PCIFR|=0x04;  //Сброс флага прерывания
	SBI  0x1B,2
; 0000 01E2   PCICR=0x05;   //Разрешение прерывания по приему пакета
	LDI  R30,LOW(5)
	STS  104,R30
; 0000 01E3 }
	RJMP _0x20C0007
;
;//********************************************************************************************
;unsigned char RECEIVE_PAKET(void) //Функция приема пакета
; 0000 01E7 {
_RECEIVE_PAKET:
; 0000 01E8 unsigned char pktlen;
; 0000 01E9 STROB(SIDLE);  //Переход в режим IDLE
	ST   -Y,R17
;	pktlen -> R17
	LDI  R30,LOW(54)
	ST   -Y,R30
	RCALL _STROB
; 0000 01EA PORTB.4=0; // SPI_SS ON
	CBI  0x5,4
; 0000 01EB while(PINB.6==1); //Ждем 0 на MISO
_0xC3:
	SBIC 0x3,6
	RJMP _0xC3
; 0000 01EC SPI_SEND(0xFF);  //Открытие буфера приема
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 01ED pktlen=SPI_SEND(0x00); //Считывание длинны пакета
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_SEND
	MOV  R17,R30
; 0000 01EE for (i=0;i<pktlen;i++)    //Считывание пакета
	CLR  R5
	CLR  R6
_0xC7:
	MOV  R30,R17
	CALL SUBOPT_0x7
	BRSH _0xC8
; 0000 01EF    {
; 0000 01F0    SPI_buffer[i]=SPI_SEND(0x00);
	__GETW1R 5,6
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_SEND
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01F1    }
	CALL SUBOPT_0x8
	RJMP _0xC7
_0xC8:
; 0000 01F2 PORTB.4=1; // SPI_SS OFF
	SBI  0x5,4
; 0000 01F3 STROB(SFRX);
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL _STROB
; 0000 01F4 return pktlen; //Возврат длинны пакета
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 01F5  }
; //*******************************************************************************************
; void CLEAR_SPI_buffer(void) //Очистка SPI буфера
; 0000 01F8  { for (i=0;i<64;i++)
_CLEAR_SPI_buffer:
	CLR  R5
	CLR  R6
_0xCC:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CP   R5,R30
	CPC  R6,R31
	BRSH _0xCD
; 0000 01F9    {
; 0000 01FA     SPI_buffer[i]=0x00;
	LDI  R26,LOW(_SPI_buffer)
	LDI  R27,HIGH(_SPI_buffer)
	ADD  R26,R5
	ADC  R27,R6
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 01FB    }
	CALL SUBOPT_0x3
	RJMP _0xCC
_0xCD:
; 0000 01FC  }
	RET
; //********************************************************************************************
;  // Запись строки в SPI буффер
; unsigned char Write_SPI_buffer(flash char *str)
; 0000 0200  {
_Write_SPI_buffer:
; 0000 0201   i=0;
;	*str -> Y+0
	CLR  R5
	CLR  R6
; 0000 0202   while(*str)
_0xCE:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xD0
; 0000 0203   {
; 0000 0204   SPI_buffer[i++]=*str++;
	CALL SUBOPT_0x8
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	MOVW R26,R30
	CALL SUBOPT_0x1D
	ST   X,R30
; 0000 0205 
; 0000 0206   }
	RJMP _0xCE
_0xD0:
; 0000 0207  return i;
	MOV  R30,R5
	RJMP _0x20C0002
; 0000 0208   }
;//***********************************************************************************
;//==================ФУНКЦИИ ДЛЯ РАБОТЫ С МОДЕМОМ============================================
;//******************************************************************************************
;void UART_Transmit(char data) // Функция передачи символа через UART
; 0000 020D {
_UART_Transmit:
; 0000 020E while (!(UCSR0A & (1<<UDRE0))) {};
;	data -> Y+0
_0xD1:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0xD1
; 0000 020F UDR0=data;
	LD   R30,Y
	STS  198,R30
; 0000 0210 }
_0x20C0007:
	ADIW R28,1
	RET
;
;
;//**********************************************************************************************************
;       void SEND_Str(flash char *str) {        // Функция передачи строки  из флеш памяти
; 0000 0214 void SEND_Str(flash char *str) {
_SEND_Str:
; 0000 0215         while(*str) {
;	*str -> Y+0
_0xD4:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xD6
; 0000 0216        UART_Transmit(*str++);
	CALL SUBOPT_0x1D
	ST   -Y,R30
	RCALL _UART_Transmit
; 0000 0217 
; 0000 0218     };
	RJMP _0xD4
_0xD6:
; 0000 0219     delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x1E
; 0000 021A }
	RJMP _0x20C0002
;//**********************************************************************************************************
;void CLEAR_BUF(void)   // Функция очистки буффера приема
; 0000 021D {
_CLEAR_BUF:
; 0000 021E 
; 0000 021F for (i=0;i<RX_BUFFER_SIZE0;i++) {
	CLR  R5
	CLR  R6
_0xD8:
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CP   R5,R30
	CPC  R6,R31
	BRSH _0xD9
; 0000 0220       rx_buffer0[i]=0;
	LDI  R26,LOW(_rx_buffer0)
	LDI  R27,HIGH(_rx_buffer0)
	ADD  R26,R5
	ADC  R27,R6
	ST   X,R30
; 0000 0221     };
	CALL SUBOPT_0x3
	RJMP _0xD8
_0xD9:
; 0000 0222    rx_wr_index0=0;
	CLR  R3
	CLR  R4
; 0000 0223   // #asm("wdr")
; 0000 0224 
; 0000 0225 }
	RET
;//**********************************************************************************************************
;  char TEST_OK(void)     // Функция проверки ответа ОК на команду
; 0000 0228   {
_TEST_OK:
; 0000 0229   char c;
; 0000 022A   char *d;
; 0000 022B   char OK[]="OK";
; 0000 022C   d=strstr(rx_buffer0, OK);
	SBIW R28,3
	LDI  R30,LOW(79)
	ST   Y,R30
	LDI  R30,LOW(75)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	CALL SUBOPT_0x1F
;	c -> R17
;	*d -> R18,R19
;	OK -> Y+4
; 0000 022D   c=*d;
	CALL SUBOPT_0x20
; 0000 022E  // #asm("wdr")
; 0000 022F  CLEAR_BUF();
; 0000 0230    return c;
	ADIW R28,7
	RET
; 0000 0231 
; 0000 0232   }
;
;//**********************************************************************************************************
;  char REG_NET(void)   // Функция проверки регистрации в сети
; 0000 0236   {
_REG_NET:
; 0000 0237   char c;
; 0000 0238   char *d;
; 0000 0239   char REG[]="+CREG:";
; 0000 023A   d=strstr(rx_buffer0, REG);
	SBIW R28,7
	LDI  R30,LOW(43)
	ST   Y,R30
	LDI  R30,LOW(67)
	STD  Y+1,R30
	LDI  R30,LOW(82)
	STD  Y+2,R30
	LDI  R30,LOW(69)
	STD  Y+3,R30
	LDI  R30,LOW(71)
	STD  Y+4,R30
	LDI  R30,LOW(58)
	STD  Y+5,R30
	LDI  R30,LOW(0)
	STD  Y+6,R30
	CALL SUBOPT_0x1F
;	c -> R17
;	*d -> R18,R19
;	REG -> Y+4
; 0000 023B   d=d+9;
	__ADDWRN 18,19,9
; 0000 023C   c=*d;
	CALL SUBOPT_0x20
; 0000 023D  // #asm("wdr")
; 0000 023E   CLEAR_BUF();
; 0000 023F   return c;
	ADIW R28,11
	RET
; 0000 0240   }
;//********************************************************************************************
;void RESET_MODEM(void)    // Сброс модема
; 0000 0243  {//LightDiode('O');
_RESET_MODEM:
; 0000 0244   do {
_0xDB:
; 0000 0245 
; 0000 0246   if (PINB.1==0)
	SBIC 0x3,1
	RJMP _0xDD
; 0000 0247   {
; 0000 0248   PORTB.0=0;       // Включение модема
	CBI  0x5,0
; 0000 0249   delay_ms(1000);
	CALL SUBOPT_0x21
; 0000 024A   PORTB.0=1;
	SBI  0x5,0
; 0000 024B   delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP _0x282
; 0000 024C    }
; 0000 024D 
; 0000 024E    else
_0xDD:
; 0000 024F    {
; 0000 0250     PORTB.2=0;       // Сброс модема
	CBI  0x5,2
; 0000 0251   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0252   PORTB.2=1;
	SBI  0x5,2
; 0000 0253   delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0x282:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0254    }
; 0000 0255 
; 0000 0256     } while(PINB.1==0);   // Проверка включения модема
	SBIS 0x3,1
	RJMP _0xDB
; 0000 0257 
; 0000 0258 
; 0000 0259     do{      SEND_Str("AT\r");  // Проверка ответа модема
_0xE8:
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x23
; 0000 025A         // #asm("wdr")
; 0000 025B       } while(TEST_OK()==NULL)  ;
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0xE8
; 0000 025C 
; 0000 025D  do{   SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
_0xEB:
	__POINTW1FN _0x0,4
	CALL SUBOPT_0x23
; 0000 025E        // #asm("wdr")
; 0000 025F       delay_ms(1000);
	CALL SUBOPT_0x21
; 0000 0260      // #asm("wdr")
; 0000 0261       }while (REG_NET()!='1') ;
	RCALL _REG_NET
	CPI  R30,LOW(0x31)
	BRNE _0xEB
; 0000 0262 
; 0000 0263 
; 0000 0264           SEND_Str("AT+CLIP=1\r");
	__POINTW1FN _0x0,14
	CALL SUBOPT_0x23
; 0000 0265            CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0266 
; 0000 0267  }
	RET
;
;
;//**********************************************************************************************************
;char SET_NR(void) // Функция считывания телефонного номера с SIM карты
; 0000 026C {
_SET_NR:
; 0000 026D char c;
; 0000 026E char *d;
; 0000 026F 
; 0000 0270 d=strstr(rx_buffer0, ",\"+7");
	CALL __SAVELOCR4
;	c -> R17
;	*d -> R18,R19
	CALL SUBOPT_0x24
	__POINTW1MN _0xED,0
	CALL SUBOPT_0x25
	MOVW R18,R30
; 0000 0271 if (d==NULL){c=0;
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xEE
	LDI  R17,LOW(0)
; 0000 0272           return c;}
	RJMP _0x20C0005
; 0000 0273   d=d+4;
_0xEE:
	__ADDWRN 18,19,4
; 0000 0274   i=0;
	CLR  R5
	CLR  R6
; 0000 0275   while(i<12)
_0xEF:
	CALL SUBOPT_0x26
	BRSH _0xF1
; 0000 0276   {
; 0000 0277   NR[i++]=*d;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x27
; 0000 0278    d=d-1;
	__SUBWRN 18,19,1
; 0000 0279    NR[i++]=*d;
	CALL SUBOPT_0x8
	CALL SUBOPT_0x27
; 0000 027A    d=d+3;
	__ADDWRN 18,19,3
; 0000 027B   }
	RJMP _0xEF
_0xF1:
; 0000 027C   NR[10]='F';
	LDI  R30,LOW(70)
	__PUTB1MN _NR,10
; 0000 027D 
; 0000 027E   CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 027F   c=1;
	LDI  R17,LOW(1)
; 0000 0280   return c;
_0x20C0005:
	MOV  R30,R17
	CALL __LOADLOCR4
_0x20C0006:
	ADIW R28,4
	RET
; 0000 0281 }

	.DSEG
_0xED:
	.BYTE 0x5
;
;//**********************************************************************************************************
;// Функция проверки балланса
; void BALLANSE(void)
; 0000 0286  {   unsigned char S;

	.CSEG
; 0000 0287    // char XY[2];
; 0000 0288     unsigned char *s1, *s2;
; 0000 0289     delay_ms(4000);
;	S -> R17
;	*s1 -> R18,R19
;	*s2 -> R20,R21
; 0000 028A     CLEAR_BUF();
; 0000 028B   do
; 0000 028C    { if(OP==0) SEND_Str("AT+CUSD=1,\"*100#\"\r"); //Отправа запроса балланса
; 0000 028D      else SEND_Str("AT+CUSD=1,\"*102#\"\r");
; 0000 028E    delay_ms(500);
; 0000 028F    #asm("wdr")
; 0000 0290     }while(TEST_OK()==0);
; 0000 0291     for(i=0;i<5;i++)
; 0000 0292     {
; 0000 0293      if(strstr(rx_buffer0, "+CUSD:")!=NULL) break;   //Ожидание ответа на запрос
; 0000 0294      #asm("wdr")
; 0000 0295      delay_ms(1000);
; 0000 0296      #asm("wdr")
; 0000 0297     }
; 0000 0298     s1=strstr(rx_buffer0, "04110430043B0430043D0441");
; 0000 0299     if(s1!=NULL)
; 0000 029A     {
; 0000 029B     s2=strstr(rx_buffer0, "0440");
; 0000 029C     S=((s2-s1+4)/2)+13;
; 0000 029D    // sprintf(XY, "%02d", S);
; 0000 029E    // XX[0]=XY[0];
; 0000 029F    // XX[1]=XY[1];
; 0000 02A0 
; 0000 02A1     printf("AT+CMGS=%02d\r",S) ;
; 0000 02A2     delay_ms(100);
; 0000 02A3     #asm("wdr")
; 0000 02A4      SEND_Str("0001000B91");     // Ввод настроек PDU
; 0000 02A5 
; 0000 02A6       for(i=0;i<12;i++)            // Ввод номера
; 0000 02A7       {UART_Transmit(NR[i]);}
; 0000 02A8       S=S-13;
; 0000 02A9       printf("0008%02X", S);
; 0000 02AA       s2=s2+4;
; 0000 02AB       do{
; 0000 02AC        UART_Transmit(*s1);
; 0000 02AD        s1++;
; 0000 02AE       }while(s1!=s2);
; 0000 02AF       UART_Transmit(0x1A);
; 0000 02B0              /*
; 0000 02B1       delay_ms(1000);
; 0000 02B2   for (i=0; i<256; i++)    // Запись буфера приема в eeprom
; 0000 02B3       {eebuffer[i]=rx_buffer[i];}
; 0000 02B4              */
; 0000 02B5       }
; 0000 02B6       CLEAR_BUF();
; 0000 02B7  }

	.DSEG
_0xFB:
	.BYTE 0x25
; //*********************************************************************************************
; char CALL(unsigned char nom)
; 0000 02BA  { unsigned char NOM[12];

	.CSEG
_CALL:
; 0000 02BB    char *d1;
; 0000 02BC    char s;
; 0000 02BD     #asm("sei")
	SBIW R28,12
	CALL __SAVELOCR4
;	nom -> Y+16
;	NOM -> Y+4
;	*d1 -> R16,R17
;	s -> R19
	sei
; 0000 02BE    LD3.Led.l1=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 02BF    LOAD_LD();
; 0000 02C0 switch (nom)
	LDD  R30,Y+16
	CALL SUBOPT_0x17
; 0000 02C1     {
; 0000 02C2      case 1:
	BRNE _0x106
; 0000 02C3 			{
; 0000 02C4 			    SEND_Str("AT+CPBF=\"N1\"\r");
	__POINTW1FN _0x0,139
	RJMP _0x284
; 0000 02C5 				break;
; 0000 02C6 			}
; 0000 02C7 
; 0000 02C8      case 2:
_0x106:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x107
; 0000 02C9 			{
; 0000 02CA 			    SEND_Str("AT+CPBF=\"N2\"\r");
	__POINTW1FN _0x0,153
	RJMP _0x284
; 0000 02CB 				break;
; 0000 02CC 			}
; 0000 02CD 
; 0000 02CE      case 3:
_0x107:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x108
; 0000 02CF 			{
; 0000 02D0 			    SEND_Str("AT+CPBF=\"N3\"\r");
	__POINTW1FN _0x0,167
	RJMP _0x284
; 0000 02D1 				break;
; 0000 02D2 			}
; 0000 02D3 
; 0000 02D4      case 4:
_0x108:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x109
; 0000 02D5 			{
; 0000 02D6 			    SEND_Str("AT+CPBF=\"N4\"\r");
	__POINTW1FN _0x0,181
	RJMP _0x284
; 0000 02D7 				break;
; 0000 02D8 			}
; 0000 02D9 
; 0000 02DA      case 5:
_0x109:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x10A
; 0000 02DB 			{
; 0000 02DC 			    SEND_Str("AT+CPBF=\"N5\"\r");
	__POINTW1FN _0x0,195
	RJMP _0x284
; 0000 02DD 				break;
; 0000 02DE 			}
; 0000 02DF 
; 0000 02E0      case 6:
_0x10A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x105
; 0000 02E1 			{
; 0000 02E2 			    SEND_Str("AT+CPBF=\"N6\"\r");
	__POINTW1FN _0x0,209
_0x284:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SEND_Str
; 0000 02E3 				break;
; 0000 02E4 			}
; 0000 02E5 
; 0000 02E6 
; 0000 02E7     }
_0x105:
; 0000 02E8     delay_ms(100);
	CALL SUBOPT_0x22
; 0000 02E9     d1=strstr(rx_buffer0, ",\"+7");
	CALL SUBOPT_0x24
	__POINTW1MN _0x10C,0
	CALL SUBOPT_0x25
	MOVW R16,R30
; 0000 02EA     if(d1!=NULL)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x10D
; 0000 02EB     {
; 0000 02EC      d1=d1+2;
	__ADDWRN 16,17,2
; 0000 02ED      for(i=0;i<12;i++)
	CLR  R5
	CLR  R6
_0x10F:
	CALL SUBOPT_0x26
	BRSH _0x110
; 0000 02EE       { NOM[i]=*d1;
	__GETW1R 5,6
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R16
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 02EF        d1=d1+1;
	__ADDWRN 16,17,1
; 0000 02F0       }
	CALL SUBOPT_0x3
	RJMP _0x10F
_0x110:
; 0000 02F1     }
; 0000 02F2 
; 0000 02F3     else {s=0;
	RJMP _0x111
_0x10D:
	LDI  R19,LOW(0)
; 0000 02F4     LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 02F5      return s; }
	MOV  R30,R19
	RJMP _0x20C0004
_0x111:
; 0000 02F6     CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 02F7    SEND_Str("AT+CSTA=145\r");
	__POINTW1FN _0x0,223
	CALL SUBOPT_0x23
; 0000 02F8    delay_ms(100);
	CALL SUBOPT_0x22
; 0000 02F9    SEND_Str("AT*PSSTKI=0\r");
	__POINTW1FN _0x0,236
	CALL SUBOPT_0x23
; 0000 02FA    delay_ms(100);
	CALL SUBOPT_0x22
; 0000 02FB    SEND_Str("ATD\"");
	__POINTW1FN _0x0,249
	CALL SUBOPT_0x23
; 0000 02FC    for(i=0;i<12;i++) UART_Transmit(NOM[i]);
	CLR  R5
	CLR  R6
_0x113:
	CALL SUBOPT_0x26
	BRSH _0x114
	MOVW R26,R28
	ADIW R26,4
	CALL SUBOPT_0x1C
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x113
_0x114:
; 0000 02FD SEND_Str("\";\r");
	__POINTW1FN _0x0,254
	CALL SUBOPT_0x23
; 0000 02FE    delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CALL SUBOPT_0x1E
; 0000 02FF     CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0300    LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0301    LOAD_LD();
	RCALL _LOAD_LD
; 0000 0302  }
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,17
	RET

	.DSEG
_0x10C:
	.BYTE 0x5
; //**********************************************************************************************
;  char SEND_SMS(unsigned char nom, unsigned char ndat)
; 0000 0305 
; 0000 0306   {      //unsigned char NOM[12];

	.CSEG
_SEND_SMS:
; 0000 0307    //char *d;
; 0000 0308    char s;
; 0000 0309   #asm("sei")
	ST   -Y,R17
;	nom -> Y+2
;	ndat -> Y+1
;	s -> R17
	sei
; 0000 030A   LD3.Led.l1=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 030B    LOAD_LD();
; 0000 030C switch (nom)
	LDD  R30,Y+2
	CALL SUBOPT_0x17
; 0000 030D     {
; 0000 030E      case 1:
	BRNE _0x118
; 0000 030F 			{
; 0000 0310 			    SEND_Str("AT+CPBF=\"N1\"\r");
	__POINTW1FN _0x0,139
	RJMP _0x285
; 0000 0311 				break;
; 0000 0312 			}
; 0000 0313 
; 0000 0314      case 2:
_0x118:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x119
; 0000 0315 			{
; 0000 0316 			    SEND_Str("AT+CPBF=\"N2\"\r");
	__POINTW1FN _0x0,153
	RJMP _0x285
; 0000 0317 				break;
; 0000 0318 			}
; 0000 0319 
; 0000 031A      case 3:
_0x119:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x11A
; 0000 031B 			{
; 0000 031C 			    SEND_Str("AT+CPBF=\"N3\"\r");
	__POINTW1FN _0x0,167
	RJMP _0x285
; 0000 031D 				break;
; 0000 031E 			}
; 0000 031F 
; 0000 0320      case 4:
_0x11A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11B
; 0000 0321 			{
; 0000 0322 			    SEND_Str("AT+CPBF=\"N4\"\r");
	__POINTW1FN _0x0,181
	RJMP _0x285
; 0000 0323 				break;
; 0000 0324 			}
; 0000 0325 
; 0000 0326      case 5:
_0x11B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x11C
; 0000 0327 			{
; 0000 0328 			    SEND_Str("AT+CPBF=\"N5\"\r");
	__POINTW1FN _0x0,195
	RJMP _0x285
; 0000 0329 				break;
; 0000 032A 			}
; 0000 032B 
; 0000 032C      case 6:
_0x11C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x117
; 0000 032D 			{
; 0000 032E 			    SEND_Str("AT+CPBF=\"N6\"\r");
	__POINTW1FN _0x0,209
_0x285:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SEND_Str
; 0000 032F 				break;
; 0000 0330 			}
; 0000 0331 
; 0000 0332 
; 0000 0333     }
_0x117:
; 0000 0334     delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0335 
; 0000 0336    if(SET_NR()==0) {s=0; LD3.Led.l1=1; return s; }
	RCALL _SET_NR
	CPI  R30,0
	BRNE _0x11E
	LDI  R17,LOW(0)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
	MOV  R30,R17
	RJMP _0x20C0003
; 0000 0337 
; 0000 0338     do{SEND_Str("AT+CMGF=0\r");     // Установка PDU режима
_0x11E:
_0x120:
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x23
; 0000 0339        }while(TEST_OK()==0);
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0x120
; 0000 033A 
; 0000 033B     do{ CLEAR_BUF();
_0x123:
	RCALL _CLEAR_BUF
; 0000 033C      SEND_Str("AT+CMGS=45\r");  //    Ввод команды отправки сообщения (39 для Дверь открыта)
	__POINTW1FN _0x0,269
	CALL SUBOPT_0x23
; 0000 033D       }while (strrchr(rx_buffer0, '>')==NULL);
	CALL SUBOPT_0x24
	LDI  R30,LOW(62)
	ST   -Y,R30
	CALL _strrchr
	SBIW R30,0
	BREQ _0x123
; 0000 033E       CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 033F 
; 0000 0340       SEND_Str("0001000B91");     // Ввод настроек PDU
	__POINTW1FN _0x0,119
	CALL SUBOPT_0x23
; 0000 0341 
; 0000 0342       for(i=0;i<12;i++)            // Ввод номера
	CLR  R5
	CLR  R6
_0x126:
	CALL SUBOPT_0x26
	BRSH _0x127
; 0000 0343       {UART_Transmit(NR[i]);}
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x126
_0x127:
; 0000 0344 
; 0000 0345       // SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // Ввод текста сообщения
; 0000 0346       SEND_Str("00082004140430044204470438043A0020");
	__POINTW1FN _0x0,281
	CALL SUBOPT_0x23
; 0000 0347       switch (ndat)
	LDD  R30,Y+1
	CALL SUBOPT_0x17
; 0000 0348       {
; 0000 0349         case 1:
	BRNE _0x12B
; 0000 034A 			{
; 0000 034B 			    SEND_Str("0031");
	__POINTW1FN _0x0,316
	RJMP _0x286
; 0000 034C 				break;
; 0000 034D 			}
; 0000 034E 
; 0000 034F        case 2:
_0x12B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12C
; 0000 0350 			{
; 0000 0351 			    SEND_Str("0032");
	__POINTW1FN _0x0,321
	RJMP _0x286
; 0000 0352 				break;
; 0000 0353 			}
; 0000 0354 
; 0000 0355         case 3:
_0x12C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x12D
; 0000 0356 			{
; 0000 0357 			    SEND_Str("0033");
	__POINTW1FN _0x0,326
	RJMP _0x286
; 0000 0358 				break;
; 0000 0359 			}
; 0000 035A         case 4:
_0x12D:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x12E
; 0000 035B 			{
; 0000 035C 			    SEND_Str("0034");
	__POINTW1FN _0x0,331
	RJMP _0x286
; 0000 035D 				break;
; 0000 035E 			}
; 0000 035F 
; 0000 0360         case 5:
_0x12E:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x12F
; 0000 0361 			{
; 0000 0362 			    SEND_Str("0035");
	__POINTW1FN _0x0,336
	RJMP _0x286
; 0000 0363 				break;
; 0000 0364 			}
; 0000 0365 
; 0000 0366        case 6:
_0x12F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x130
; 0000 0367 			{
; 0000 0368 			    SEND_Str("0036");
	__POINTW1FN _0x0,341
	RJMP _0x286
; 0000 0369 				break;
; 0000 036A 			}
; 0000 036B 
; 0000 036C        case 7:
_0x130:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x131
; 0000 036D 			{
; 0000 036E 			    SEND_Str("0037");
	__POINTW1FN _0x0,346
	RJMP _0x286
; 0000 036F 				break;
; 0000 0370 			}
; 0000 0371 
; 0000 0372 
; 0000 0373        case 8:
_0x131:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x12A
; 0000 0374 			{
; 0000 0375 			    SEND_Str("0038");
	__POINTW1FN _0x0,351
_0x286:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SEND_Str
; 0000 0376 				break;
; 0000 0377 			}
; 0000 0378 
; 0000 0379 
; 0000 037A 
; 0000 037B        }
_0x12A:
; 0000 037C        SEND_Str("00200442044004350432043E04330430\x1A");
	__POINTW1FN _0x0,356
	CALL SUBOPT_0x23
; 0000 037D        delay_ms(3000);
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x1E
; 0000 037E      //  for(i=0;i<256;i++) STAT[i]=rx_buffer0[i];
; 0000 037F         CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0380        delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	CALL SUBOPT_0x1E
; 0000 0381     LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0382    LOAD_LD();
	RCALL _LOAD_LD
; 0000 0383   }
_0x20C0003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
;//*****************************************************************************************************************
;unsigned char WRITE_NUMBER(unsigned char nr) //Функция программирования телефонного номера
; 0000 0386 { unsigned char povtor;
_WRITE_NUMBER:
; 0000 0387 povtor=128;
	ST   -Y,R17
;	nr -> Y+1
;	povtor -> R17
	LDI  R17,LOW(128)
; 0000 0388  x=strstr(rx_buffer0, "\"+7");
	CALL SUBOPT_0x24
	__POINTW1MN _0x133,0
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2B
; 0000 0389  if(x!=NULL)
	BRNE PC+3
	JMP _0x134
; 0000 038A  { x++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 038B   for(i=0;i<12;i++) NR[i]=*x++;
	CLR  R5
	CLR  R6
_0x136:
	CALL SUBOPT_0x26
	BRSH _0x137
	__GETW2R 5,6
	SUBI R26,LOW(-_NR)
	SBCI R27,HIGH(-_NR)
	__GETW1R 9,10
	ADIW R30,1
	__PUTW1R 9,10
	SBIW R30,1
	LD   R30,Z
	ST   X,R30
	CALL SUBOPT_0x3
	RJMP _0x136
_0x137:
; 0000 038D CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 038E   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 038F   SEND_Str("AT+CPBF=\"N1\"\r");
	__POINTW1FN _0x0,139
	CALL SUBOPT_0x23
; 0000 0390   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0391   SEND_Str("AT+CPBF=\"N2\"\r");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x23
; 0000 0392   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0393   SEND_Str("AT+CPBF=\"N3\"\r");
	__POINTW1FN _0x0,167
	CALL SUBOPT_0x23
; 0000 0394   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0395   SEND_Str("AT+CPBF=\"N4\"\r");
	__POINTW1FN _0x0,181
	CALL SUBOPT_0x23
; 0000 0396   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0397   SEND_Str("AT+CPBF=\"N5\"\r");
	__POINTW1FN _0x0,195
	CALL SUBOPT_0x23
; 0000 0398   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 0399   SEND_Str("AT+CPBF=\"N6\"\r");
	__POINTW1FN _0x0,209
	CALL SUBOPT_0x23
; 0000 039A   delay_ms(100);
	CALL SUBOPT_0x22
; 0000 039B 
; 0000 039C 
; 0000 039D 
; 0000 039E     switch (nr)
	LDD  R30,Y+1
	CALL SUBOPT_0x17
; 0000 039F     {
; 0000 03A0    case 1:{
	BRNE _0x13B
; 0000 03A1            if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x13C
	LDI  R17,LOW(0)
	MOV  R30,R17
	RJMP _0x20C0001
; 0000 03A2          else {
_0x13C:
; 0000 03A3            SEND_Str("AT+CPBW=1,\"");
	__POINTW1FN _0x0,390
	CALL SUBOPT_0x23
; 0000 03A4           for(i=0;i<12;i++) UART_Transmit(NR[i]);
	CLR  R5
	CLR  R6
_0x13F:
	CALL SUBOPT_0x26
	BRSH _0x140
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x13F
_0x140:
; 0000 03A5 SEND_Str("\",145,\"N1\"\r");
	__POINTW1FN _0x0,402
	CALL SUBOPT_0x23
; 0000 03A6            }
; 0000 03A7          break;
	RJMP _0x13A
; 0000 03A8        }
; 0000 03A9 
; 0000 03AA     case 2:{
_0x13B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x141
; 0000 03AB            if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x142
	LDI  R17,LOW(0)
	MOV  R30,R17
	RJMP _0x20C0001
; 0000 03AC          else {
_0x142:
; 0000 03AD            SEND_Str("AT+CPBW=2,\"");
	__POINTW1FN _0x0,414
	CALL SUBOPT_0x23
; 0000 03AE           for(i=0;i<12;i++) UART_Transmit(NR[i]);
	CLR  R5
	CLR  R6
_0x145:
	CALL SUBOPT_0x26
	BRSH _0x146
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x145
_0x146:
; 0000 03AF SEND_Str("\",145,\"N2\"\r");
	__POINTW1FN _0x0,426
	CALL SUBOPT_0x23
; 0000 03B0            }
; 0000 03B1         break;
	RJMP _0x13A
; 0000 03B2        }
; 0000 03B3 
; 0000 03B4       case 3:{
_0x141:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x147
; 0000 03B5            if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x148
	LDI  R17,LOW(0)
	MOV  R30,R17
	RJMP _0x20C0001
; 0000 03B6          else {
_0x148:
; 0000 03B7            SEND_Str("AT+CPBW=3,\"");
	__POINTW1FN _0x0,438
	CALL SUBOPT_0x23
; 0000 03B8           for(i=0;i<12;i++) UART_Transmit(NR[i]);
	CLR  R5
	CLR  R6
_0x14B:
	CALL SUBOPT_0x26
	BRSH _0x14C
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x14B
_0x14C:
; 0000 03B9 SEND_Str("\",145,\"N3\"\r");
	__POINTW1FN _0x0,450
	CALL SUBOPT_0x23
; 0000 03BA            }
; 0000 03BB          break;
	RJMP _0x13A
; 0000 03BC        }
; 0000 03BD 
; 0000 03BE       case 4:{
_0x147:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x14D
; 0000 03BF            if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x14E
	LDI  R17,LOW(0)
	MOV  R30,R17
	RJMP _0x20C0001
; 0000 03C0          else {
_0x14E:
; 0000 03C1            SEND_Str("AT+CPBW=4,\"");
	__POINTW1FN _0x0,462
	CALL SUBOPT_0x23
; 0000 03C2           for(i=0;i<12;i++) UART_Transmit(NR[i]);
	CLR  R5
	CLR  R6
_0x151:
	CALL SUBOPT_0x26
	BRSH _0x152
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x151
_0x152:
; 0000 03C3 SEND_Str("\",145,\"N4\"\r");
	__POINTW1FN _0x0,474
	CALL SUBOPT_0x23
; 0000 03C4            }
; 0000 03C5          break;
	RJMP _0x13A
; 0000 03C6        }
; 0000 03C7 
; 0000 03C8 
; 0000 03C9        case 5:{
_0x14D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x153
; 0000 03CA            if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x154
	LDI  R17,LOW(0)
	MOV  R30,R17
	RJMP _0x20C0001
; 0000 03CB          else {
_0x154:
; 0000 03CC            SEND_Str("AT+CPBW=5,\"");
	__POINTW1FN _0x0,486
	CALL SUBOPT_0x23
; 0000 03CD           for(i=0;i<12;i++) UART_Transmit(NR[i]);
	CLR  R5
	CLR  R6
_0x157:
	CALL SUBOPT_0x26
	BRSH _0x158
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x157
_0x158:
; 0000 03CE SEND_Str("\",145,\"N5\"\r");
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x23
; 0000 03CF            }
; 0000 03D0           break;
	RJMP _0x13A
; 0000 03D1        }
; 0000 03D2 
; 0000 03D3          case 6:{
_0x153:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x13A
; 0000 03D4            if(strstr(rx_buffer0, NR)!=NULL) {povtor=NULL; return povtor;}
	CALL SUBOPT_0x24
	CALL SUBOPT_0x2C
	SBIW R30,0
	BREQ _0x15A
	LDI  R17,LOW(0)
	MOV  R30,R17
	RJMP _0x20C0001
; 0000 03D5          else {
_0x15A:
; 0000 03D6            SEND_Str("AT+CPBW=6,\"");
	__POINTW1FN _0x0,510
	CALL SUBOPT_0x23
; 0000 03D7           for(i=0;i<12;i++) UART_Transmit(NR[i]);
	CLR  R5
	CLR  R6
_0x15D:
	CALL SUBOPT_0x26
	BRSH _0x15E
	CALL SUBOPT_0x2A
	RCALL _UART_Transmit
	CALL SUBOPT_0x3
	RJMP _0x15D
_0x15E:
; 0000 03D8 SEND_Str("\",145,\"N6\"\r");
	__POINTW1FN _0x0,522
	CALL SUBOPT_0x23
; 0000 03D9            }
; 0000 03DA           break;
; 0000 03DB        }
; 0000 03DC 
; 0000 03DD 
; 0000 03DE 
; 0000 03DF   }
_0x13A:
; 0000 03E0   return povtor;
	MOV  R30,R17
; 0000 03E1  }
; 0000 03E2 
; 0000 03E3 }
_0x134:
_0x20C0001:
	LDD  R17,Y+0
_0x20C0002:
	ADIW R28,2
	RET

	.DSEG
_0x133:
	.BYTE 0x4
;//======================================================================================================================================
;//========================================ПРЕРЫВАНИЯ===================================================================================
;//=====================================================================================================================================
;// Pin change 0-7 interrupt service routine
;interrupt [PC_INT0] void pin_change_isr0(void) //Прерывание от трансивера
; 0000 03E9 {

	.CSEG
_pin_change_isr0:
	CALL SUBOPT_0x2D
; 0000 03EA unsigned char len;
; 0000 03EB // char *x;
; 0000 03EC PCICR=0x00;
	ST   -Y,R17
;	len -> R17
	LDI  R30,LOW(0)
	STS  104,R30
; 0000 03ED 
; 0000 03EE while(PINA.1==1);
_0x15F:
	SBIC 0x0,1
	RJMP _0x15F
; 0000 03EF 
; 0000 03F0 len=RECEIVE_PAKET();
	RCALL _RECEIVE_PAKET
	MOV  R17,R30
; 0000 03F1 
; 0000 03F2 x=strstr(SPI_buffer,"BRELOK");
	CALL SUBOPT_0x2E
	__POINTW1MN _0x162,0
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2B
; 0000 03F3  if (x!=NULL)
	BRNE PC+3
	JMP _0x163
; 0000 03F4    { x=x+6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	__ADDWRR 9,10,30,31
; 0000 03F5    if(PGM!=0) PROGRAM_DAT('B');
	TST  R7
	BREQ _0x164
	LDI  R30,LOW(66)
	ST   -Y,R30
	RCALL _PROGRAM_DAT
; 0000 03F6   else if((VALID_CODE(x,BREL1,6)!=NULL)||(VALID_CODE(x,BREL2,6)!=NULL)||(VALID_CODE(x,BREL3,6)!=NULL)||(VALID_CODE(x,BREL4,6)!=NULL)||(VALID_CODE(x,BREL5,6)!=NULL)||(VALID_CODE(x,BREL6,6)!=NULL))
	RJMP _0x165
_0x164:
	CALL SUBOPT_0x11
	BRNE _0x167
	CALL SUBOPT_0x12
	BRNE _0x167
	CALL SUBOPT_0x13
	BRNE _0x167
	CALL SUBOPT_0x14
	BRNE _0x167
	CALL SUBOPT_0x15
	BRNE _0x167
	CALL SUBOPT_0x16
	BREQ _0x166
_0x167:
; 0000 03F7    {  if(strstr(SPI_buffer,"CHANGE")!=NULL)
	CALL SUBOPT_0x2E
	__POINTW1MN _0x162,7
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x169
; 0000 03F8       {if(LD3.Led.l2==1) LD3.Led.l2=2;
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x30)
	CPI  R30,LOW(0x10)
	BRNE _0x16A
	CALL SUBOPT_0x0
	ANDI R30,LOW(0xCF)
	ORI  R30,0x20
	RJMP _0x287
; 0000 03F9       else LD3.Led.l2=1;}
_0x16A:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0xCF)
	ORI  R30,0x10
_0x287:
	CALL __EEPROMWRB
; 0000 03FA 
; 0000 03FB 
; 0000 03FC      CLEAR_SPI_buffer();
_0x169:
	RCALL _CLEAR_SPI_buffer
; 0000 03FD      STROB(SIDLE);
	CALL SUBOPT_0x1B
; 0000 03FE      STROB(SFRX);
; 0000 03FF      STROB(SFTX);
; 0000 0400      if (LD3.Led.l2==2 )
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x30)
	CPI  R30,LOW(0x20)
	BRNE _0x16C
; 0000 0401      {len=Write_SPI_buffer("SECUR");
	__POINTW1FN _0x0,548
	RJMP _0x288
; 0000 0402       }
; 0000 0403      else
_0x16C:
; 0000 0404      {len=Write_SPI_buffer("IDLE");
	__POINTW1FN _0x0,554
_0x288:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write_SPI_buffer
	MOV  R17,R30
; 0000 0405         }
; 0000 0406     delay_ms(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x1E
; 0000 0407     SEND_PAKET(len);
	ST   -Y,R17
	RCALL _SEND_PAKET
; 0000 0408     delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0409     }
; 0000 040A   }
_0x166:
_0x165:
; 0000 040B 
; 0000 040C 
; 0000 040D 
; 0000 040E    x=strstr(SPI_buffer,"DATCHIK");
_0x163:
	CALL SUBOPT_0x2E
	__POINTW1MN _0x162,14
	CALL SUBOPT_0x25
	CALL SUBOPT_0x2B
; 0000 040F  if(x!=NULL)  // Проверка слова датчик
	BRNE PC+3
	JMP _0x16E
; 0000 0410 {   x=x+7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	__ADDWRR 9,10,30,31
; 0000 0411  if(PGM!=0) PROGRAM_DAT('D'); //Если включен режим программирования то программирование датика
	TST  R7
	BREQ _0x16F
	LDI  R30,LOW(68)
	ST   -Y,R30
	RCALL _PROGRAM_DAT
; 0000 0412  else  if(LD3.Led.l2==2)   //Проверка режима охраны
	RJMP _0x170
_0x16F:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x30)
	CPI  R30,LOW(0x20)
	BREQ PC+3
	JMP _0x171
; 0000 0413 {
; 0000 0414 if((( VALID_CODE(x,DAT1,6))!=NULL)&&(LD1.Led.l1==1))
	CALL SUBOPT_0x9
	BREQ _0x173
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xC0)
	CPI  R30,LOW(0x40)
	BREQ _0x174
_0x173:
	RJMP _0x172
_0x174:
; 0000 0415    {
; 0000 0416 
; 0000 0417 
; 0000 0418     LD1.Led.l1=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x28
; 0000 0419     LOAD_LD();
; 0000 041A     SEND_SMS(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x2F
; 0000 041B     CALL(1);
; 0000 041C     LD1.Led.l1=1;
	CALL SUBOPT_0x29
; 0000 041D     LOAD_LD();
	CALL _LOAD_LD
; 0000 041E 
; 0000 041F    }
; 0000 0420 
; 0000 0421 if((( VALID_CODE(x,DAT2,6))!=NULL)&&(LD1.Led.l2==1))
_0x172:
	CALL SUBOPT_0xA
	BREQ _0x176
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x30)
	CPI  R30,LOW(0x10)
	BREQ _0x177
_0x176:
	RJMP _0x175
_0x177:
; 0000 0422    {
; 0000 0423 
; 0000 0424     LD1.Led.l2=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x30
; 0000 0425     LOAD_LD();
; 0000 0426     SEND_SMS(1,2);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2F
; 0000 0427     CALL(1);
; 0000 0428     LD1.Led.l2=1;
	CALL SUBOPT_0x31
; 0000 0429     LOAD_LD();
; 0000 042A 
; 0000 042B    }
; 0000 042C 
; 0000 042D if((( VALID_CODE(x,DAT3,6))!=NULL)&&(LD1.Led.l3==1))
_0x175:
	CALL SUBOPT_0xB
	BREQ _0x179
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BREQ _0x17A
_0x179:
	RJMP _0x178
_0x17A:
; 0000 042E    {
; 0000 042F 
; 0000 0430     LD1.Led.l3=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x32
; 0000 0431      LOAD_LD();
; 0000 0432     SEND_SMS(1,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x33
; 0000 0433     CALL(1);
; 0000 0434      LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0435      LOAD_LD();
	CALL _LOAD_LD
; 0000 0436 
; 0000 0437    }
; 0000 0438 
; 0000 0439 if((( VALID_CODE(x,DAT4,6))!=NULL)&&(LD1.Led.l4==1))
_0x178:
	CALL SUBOPT_0xC
	BREQ _0x17C
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x1)
	BREQ _0x17D
_0x17C:
	RJMP _0x17B
_0x17D:
; 0000 043A    {
; 0000 043B 
; 0000 043C     LD1.Led.l4=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x34
; 0000 043D     LOAD_LD();
; 0000 043E     SEND_SMS(1,4);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x2F
; 0000 043F     CALL(1);
; 0000 0440     LD1.Led.l4=1;
	CALL SUBOPT_0x35
; 0000 0441     LOAD_LD();
; 0000 0442 
; 0000 0443    }
; 0000 0444 
; 0000 0445 if((( VALID_CODE(x,DAT5,6))!=NULL)&&(LD2.Led.l1==1))
_0x17B:
	CALL SUBOPT_0xD
	BREQ _0x17F
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xC0)
	CPI  R30,LOW(0x40)
	BREQ _0x180
_0x17F:
	RJMP _0x17E
_0x180:
; 0000 0446    {
; 0000 0447 
; 0000 0448 
; 0000 0449      LD2.Led.l1=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x28
; 0000 044A      LOAD_LD();
; 0000 044B      SEND_SMS(1,5);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(5)
	CALL SUBOPT_0x33
; 0000 044C      CALL(1);
; 0000 044D      LD2.Led.l1=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x29
; 0000 044E      LOAD_LD();
	CALL _LOAD_LD
; 0000 044F 
; 0000 0450    }
; 0000 0451 
; 0000 0452 if((( VALID_CODE(x,DAT6,6))!=NULL)&&(LD2.Led.l2==1))
_0x17E:
	CALL SUBOPT_0xE
	BREQ _0x182
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x30)
	CPI  R30,LOW(0x10)
	BREQ _0x183
_0x182:
	RJMP _0x181
_0x183:
; 0000 0453    {
; 0000 0454 
; 0000 0455 
; 0000 0456     LD2.Led.l2=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x30
; 0000 0457      LOAD_LD();
; 0000 0458      SEND_SMS(1,6);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x33
; 0000 0459     CALL(1);
; 0000 045A      LD2.Led.l2=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x31
; 0000 045B      LOAD_LD();
; 0000 045C 
; 0000 045D    }
; 0000 045E 
; 0000 045F if((( VALID_CODE(x,DAT7,6))!=NULL)&&(LD2.Led.l3==1))
_0x181:
	CALL SUBOPT_0xF
	BREQ _0x185
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xC)
	CPI  R30,LOW(0x4)
	BREQ _0x186
_0x185:
	RJMP _0x184
_0x186:
; 0000 0460    {
; 0000 0461 
; 0000 0462 
; 0000 0463     LD2.Led.l3=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x32
; 0000 0464     LOAD_LD();
; 0000 0465     SEND_SMS(1,7);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x33
; 0000 0466     CALL(1);
; 0000 0467     LD2.Led.l3=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x36
; 0000 0468     LOAD_LD();
; 0000 0469 
; 0000 046A    }
; 0000 046B 
; 0000 046C if((( VALID_CODE(x,DAT8,6))!=NULL)&&(LD2.Led.l4==1))
_0x184:
	CALL SUBOPT_0x10
	BREQ _0x188
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x3)
	CPI  R30,LOW(0x1)
	BREQ _0x189
_0x188:
	RJMP _0x187
_0x189:
; 0000 046D    {
; 0000 046E 
; 0000 046F 
; 0000 0470     LD2.Led.l4=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x34
; 0000 0471     LOAD_LD();
; 0000 0472     SEND_SMS(1,8);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x33
; 0000 0473     CALL(1);
; 0000 0474      LD2.Led.l4=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x35
; 0000 0475      LOAD_LD();
; 0000 0476 
; 0000 0477    }
; 0000 0478 
; 0000 0479 }
_0x187:
; 0000 047A }
_0x171:
_0x170:
; 0000 047B CLEAR_SPI_buffer();
_0x16E:
	RCALL _CLEAR_SPI_buffer
; 0000 047C STROB(SIDLE);
	CALL SUBOPT_0x1B
; 0000 047D STROB(SFRX);
; 0000 047E STROB(SFTX);
; 0000 047F STROB(SRX);
	LDI  R30,LOW(52)
	ST   -Y,R30
	RCALL _STROB
; 0000 0480 CLEAR_SPI_buffer();
	RCALL _CLEAR_SPI_buffer
; 0000 0481 delay_ms(500);
	CALL SUBOPT_0x37
; 0000 0482 LOAD_LD();
	CALL _LOAD_LD
; 0000 0483 
; 0000 0484 PCIFR|=0x01; //Сбросфлага прерывания по приему пакета
	SBI  0x1B,0
; 0000 0485 PCICR=0x05;
	LDI  R30,LOW(5)
	STS  104,R30
; 0000 0486 }
	LD   R17,Y+
	CALL SUBOPT_0x38
	RETI

	.DSEG
_0x162:
	.BYTE 0x16
;//**************************************************************************************************************************************
;
;// Pin change 16-23 interrupt service routine
;interrupt [PC_INT2] void pin_change_isr2(void)  //Прерывание по изменению состояния клавиатуры
; 0000 048B {

	.CSEG
_pin_change_isr2:
	CALL SUBOPT_0x2D
; 0000 048C 
; 0000 048D PCICR=0x01;
	LDI  R30,LOW(1)
	STS  104,R30
; 0000 048E 
; 0000 048F    switch (PINC)
	IN   R30,0x6
; 0000 0490   {
; 0000 0491 
; 0000 0492    case 0xFE :{
	CPI  R30,LOW(0xFE)
	BREQ PC+3
	JMP _0x18D
; 0000 0493 
; 0000 0494               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0495      if(PINC==0xFE)
	IN   R30,0x6
	CPI  R30,LOW(0xFE)
	BREQ PC+3
	JMP _0x18E
; 0000 0496         {
; 0000 0497 
; 0000 0498            for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x190:
	CALL SUBOPT_0x39
	BRSH _0x191
; 0000 0499             {
; 0000 049A             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 049B             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x192
; 0000 049C               {
; 0000 049D               if(LD1.Led.l1==0) LD1.Led.l1=1;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xC0)
	BRNE _0x193
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	RJMP _0x289
; 0000 049E               else LD1.Led.l1=0;
_0x193:
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x3F)
_0x289:
	CALL __EEPROMWRB
; 0000 049F               LOAD_LD();
	CALL _LOAD_LD
; 0000 04A0               break;
	RJMP _0x191
; 0000 04A1               }
; 0000 04A2              }
_0x192:
	CALL SUBOPT_0x3
	RJMP _0x190
_0x191:
; 0000 04A3          if(PINC==0xFE) //Программирование датчика 1
	IN   R30,0x6
	CPI  R30,LOW(0xFE)
	BRNE _0x195
; 0000 04A4           { PGM=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 04A5            #asm("sei")
	sei
; 0000 04A6            for(i=0;i<6;i++) DAT1[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x197:
	CALL SUBOPT_0x18
	BRSH _0x198
	LDI  R26,LOW(_DAT1)
	LDI  R27,HIGH(_DAT1)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x197
_0x198:
; 0000 04A7 for(j=0;j<60;j++)
	CLR  R8
_0x19A:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x19B
; 0000 04A8             {
; 0000 04A9             LD1.Led.l1=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x28
; 0000 04AA             LOAD_LD();
; 0000 04AB             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 04AC             LD1.Led.l1=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
; 0000 04AD             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 04AE             delay_ms(250);
; 0000 04AF 
; 0000 04B0             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x19C
; 0000 04B1                {LD1.Led.l1=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x28
; 0000 04B2                 LOAD_LD();
; 0000 04B3                 delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 04B4                 LD1.Led.l1=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x3F)
	CALL __EEPROMWRB
; 0000 04B5                 break;
	RJMP _0x19B
; 0000 04B6                }
; 0000 04B7             if(PGM==0xDF){LD1.Led.l1=1; break; }
_0x19C:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x19D
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
	RJMP _0x19B
; 0000 04B8             }
_0x19D:
	INC  R8
	RJMP _0x19A
_0x19B:
; 0000 04B9             PGM=0;
	CLR  R7
; 0000 04BA            }
; 0000 04BB          if(PINC==0x7E)  //Пргораммирование брелока 1
_0x195:
	IN   R30,0x6
	CPI  R30,LOW(0x7E)
	BRNE _0x19E
; 0000 04BC          {  PGM=11;
	LDI  R30,LOW(11)
	MOV  R7,R30
; 0000 04BD            #asm("sei")
	sei
; 0000 04BE            for(i=0;i<6;i++) BREL1[i]='F'; //Стирание кода брелка
	CLR  R5
	CLR  R6
_0x1A0:
	CALL SUBOPT_0x18
	BRSH _0x1A1
	LDI  R26,LOW(_BREL1)
	LDI  R27,HIGH(_BREL1)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x1A0
_0x1A1:
; 0000 04BF for(j=0;j<60;j++)
	CLR  R8
_0x1A3:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1A4
; 0000 04C0             {
; 0000 04C1             LD1.Led.l1=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3E
; 0000 04C2             LD3.Led.l2=2;
	CALL SUBOPT_0x3F
; 0000 04C3             LOAD_LD();
; 0000 04C4             delay_ms(250);
; 0000 04C5             LD1.Led.l1=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
; 0000 04C6             LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 04C7             LOAD_LD();
; 0000 04C8             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 04C9              if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x1A5
; 0000 04CA               {LD1.Led.l1=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x28
; 0000 04CB                 LOAD_LD();
; 0000 04CC                 delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 04CD                 LD1.Led.l1=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x3F)
	CALL __EEPROMWRB
; 0000 04CE                 break;
	RJMP _0x1A4
; 0000 04CF                }
; 0000 04D0             if(PGM==0xDF){LD1.Led.l1=1; break; }
_0x1A5:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x1A6
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
	RJMP _0x1A4
; 0000 04D1             }
_0x1A6:
	INC  R8
	RJMP _0x1A3
_0x1A4:
; 0000 04D2           PGM=0;
	CLR  R7
; 0000 04D3          }
; 0000 04D4 
; 0000 04D5          if(PINC==0xBE)  //Пргораммирование номера 1
_0x19E:
	IN   R30,0x6
	CPI  R30,LOW(0xBE)
	BREQ PC+3
	JMP _0x1A7
; 0000 04D6          { #asm("sei")
	sei
; 0000 04D7           SEND_Str("AT+CPBW=1\r");
	__POINTW1FN _0x0,567
	CALL SUBOPT_0x23
; 0000 04D8           delay_ms(30);
	CALL SUBOPT_0x40
; 0000 04D9           CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 04DA           for(j=0;j<60;j++)
	CLR  R8
_0x1A9:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1AA
; 0000 04DB             {
; 0000 04DC             LD1.Led.l1=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3E
; 0000 04DD             LD3.Led.l1=2;
	CALL SUBOPT_0x28
; 0000 04DE             LOAD_LD();
; 0000 04DF             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 04E0             LD1.Led.l1=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
; 0000 04E1             LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 04E2             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 04E3             delay_ms(250);
; 0000 04E4              if( strstr(rx_buffer0, "RING")!=NULL)
	CALL SUBOPT_0x24
	__POINTW1MN _0x1AC,0
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x1AB
; 0000 04E5              {  delay_ms(300);
	CALL SUBOPT_0x41
; 0000 04E6               SEND_Str("ATH\r");
	CALL SUBOPT_0x42
; 0000 04E7               delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 04E8              if( WRITE_NUMBER(1)==NULL)LD3.Led.l1=2;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x43
	BRNE _0x1AD
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	RJMP _0x28A
; 0000 04E9              else LD3.Led.l1=1;
_0x1AD:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
_0x28A:
	CALL __EEPROMWRB
; 0000 04EA              LOAD_LD();
	CALL SUBOPT_0x44
; 0000 04EB               delay_ms(2000);
; 0000 04EC               LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 04ED              CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 04EE                 break;
	RJMP _0x1AA
; 0000 04EF                 }
; 0000 04F0             }
_0x1AB:
	INC  R8
	RJMP _0x1A9
_0x1AA:
; 0000 04F1 
; 0000 04F2          }
; 0000 04F3               }
_0x1A7:
; 0000 04F4 
; 0000 04F5 				break;
_0x18E:
	JMP  _0x18C
; 0000 04F6 			 }
; 0000 04F7 
; 0000 04F8 
; 0000 04F9    case 0xFD :{
_0x18D:
	CPI  R30,LOW(0xFD)
	BREQ PC+3
	JMP _0x1AF
; 0000 04FA 
; 0000 04FB               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 04FC      if(PINC==0xFD)
	IN   R30,0x6
	CPI  R30,LOW(0xFD)
	BREQ PC+3
	JMP _0x1B0
; 0000 04FD         { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x1B2:
	CALL SUBOPT_0x39
	BRSH _0x1B3
; 0000 04FE             {
; 0000 04FF             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0500             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x1B4
; 0000 0501               {
; 0000 0502               if(LD1.Led.l2==0) LD1.Led.l2=1;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x30)
	BRNE _0x1B5
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xCF)
	ORI  R30,0x10
	RJMP _0x28B
; 0000 0503               else LD1.Led.l2=0;
_0x1B5:
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xCF)
_0x28B:
	CALL __EEPROMWRB
; 0000 0504               LOAD_LD();
	CALL _LOAD_LD
; 0000 0505               break;
	RJMP _0x1B3
; 0000 0506               }
; 0000 0507              }
_0x1B4:
	CALL SUBOPT_0x3
	RJMP _0x1B2
_0x1B3:
; 0000 0508          if(PINC==0xFD)
	IN   R30,0x6
	CPI  R30,LOW(0xFD)
	BRNE _0x1B7
; 0000 0509           { PGM=2;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 050A            #asm("sei")
	sei
; 0000 050B            for(i=0;i<6;i++) DAT2[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x1B9:
	CALL SUBOPT_0x18
	BRSH _0x1BA
	LDI  R26,LOW(_DAT2)
	LDI  R27,HIGH(_DAT2)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x1B9
_0x1BA:
; 0000 050C for(j=0;j<60;j++)
	CLR  R8
_0x1BC:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1BD
; 0000 050D             {
; 0000 050E             LD1.Led.l2=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3F
; 0000 050F             LOAD_LD();
; 0000 0510             delay_ms(250);
; 0000 0511             LD1.Led.l2=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x31
; 0000 0512             LOAD_LD();
; 0000 0513             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0514 
; 0000 0515             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x1BE
; 0000 0516                {LD1.Led.l2=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x45
; 0000 0517                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 0518                 delay_ms(2000);
; 0000 0519                 LD1.Led.l2=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xCF)
	CALL __EEPROMWRB
; 0000 051A                 break;
	RJMP _0x1BD
; 0000 051B                }
; 0000 051C             if(PGM==0xDF){LD1.Led.l2=1; break; }
_0x1BE:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x1BF
	CALL SUBOPT_0x5
	CALL SUBOPT_0x46
	RJMP _0x1BD
; 0000 051D             }
_0x1BF:
	INC  R8
	RJMP _0x1BC
_0x1BD:
; 0000 051E             PGM=0;
	CLR  R7
; 0000 051F            }
; 0000 0520 
; 0000 0521           if(PINC==0x7D)  //Программирование брелока 2
_0x1B7:
	IN   R30,0x6
	CPI  R30,LOW(0x7D)
	BREQ PC+3
	JMP _0x1C0
; 0000 0522          {  PGM=12;
	LDI  R30,LOW(12)
	MOV  R7,R30
; 0000 0523            #asm("sei")
	sei
; 0000 0524            for(i=0;i<6;i++) BREL2[i]='F'; //Стирание кода брелка
	CLR  R5
	CLR  R6
_0x1C2:
	CALL SUBOPT_0x18
	BRSH _0x1C3
	LDI  R26,LOW(_BREL2)
	LDI  R27,HIGH(_BREL2)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x1C2
_0x1C3:
; 0000 0527 for(j=0;j<60;j++)
	CLR  R8
_0x1C5:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1C6
; 0000 0528             {
; 0000 0529             LD1.Led.l2=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x45
; 0000 052A             LD3.Led.l2=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3F
; 0000 052B             LOAD_LD();
; 0000 052C             delay_ms(250);
; 0000 052D             LD1.Led.l2=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x46
; 0000 052E             LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 052F             LOAD_LD();
; 0000 0530             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0531              if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x1C7
; 0000 0532                {LD1.Led.l2=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x45
; 0000 0533                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 0534                 delay_ms(2000);
; 0000 0535                 LD1.Led.l2=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xCF)
	CALL __EEPROMWRB
; 0000 0536                 break;
	RJMP _0x1C6
; 0000 0537                }
; 0000 0538             if(PGM==0xDF){LD1.Led.l2=1; break; }
_0x1C7:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x1C8
	CALL SUBOPT_0x5
	CALL SUBOPT_0x46
	RJMP _0x1C6
; 0000 0539             }
_0x1C8:
	INC  R8
	RJMP _0x1C5
_0x1C6:
; 0000 053A            PGM=0;
	CLR  R7
; 0000 053B          }
; 0000 053C           if(PINC==0xBD)  //Пргораммирование номера 2
_0x1C0:
	IN   R30,0x6
	CPI  R30,LOW(0xBD)
	BREQ PC+3
	JMP _0x1C9
; 0000 053D          { #asm("sei")
	sei
; 0000 053E          SEND_Str("AT+CPBW=2\r");
	__POINTW1FN _0x0,588
	CALL SUBOPT_0x23
; 0000 053F           delay_ms(30);
	CALL SUBOPT_0x40
; 0000 0540           CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 0541           for(j=0;j<60;j++)
	CLR  R8
_0x1CB:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1CC
; 0000 0542             {
; 0000 0543             LD1.Led.l2=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x45
; 0000 0544             LD3.Led.l1=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 0545             LOAD_LD();
; 0000 0546             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0547             LD1.Led.l2=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x46
; 0000 0548             LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0549             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 054A             delay_ms(250);
; 0000 054B              if( strstr(rx_buffer0, "RING")!=NULL)
	CALL SUBOPT_0x24
	__POINTW1MN _0x1AC,5
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x1CD
; 0000 054C              {  delay_ms(300);
	CALL SUBOPT_0x41
; 0000 054D               SEND_Str("ATH\r");
	CALL SUBOPT_0x42
; 0000 054E               delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 054F              if( WRITE_NUMBER(2)==NULL)LD3.Led.l1=2;
	LDI  R30,LOW(2)
	CALL SUBOPT_0x43
	BRNE _0x1CE
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	RJMP _0x28C
; 0000 0550              else LD3.Led.l1=1;
_0x1CE:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
_0x28C:
	CALL __EEPROMWRB
; 0000 0551              LOAD_LD();
	CALL SUBOPT_0x44
; 0000 0552               delay_ms(2000);
; 0000 0553               LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0554              CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 0555                 break;
	RJMP _0x1CC
; 0000 0556                 }
; 0000 0557             }
_0x1CD:
	INC  R8
	RJMP _0x1CB
_0x1CC:
; 0000 0558 
; 0000 0559          }
; 0000 055A 
; 0000 055B               }
_0x1C9:
; 0000 055C 
; 0000 055D 				break;
_0x1B0:
	JMP  _0x18C
; 0000 055E 			 }
; 0000 055F 
; 0000 0560    case 0xFB :{
_0x1AF:
	CPI  R30,LOW(0xFB)
	BREQ PC+3
	JMP _0x1D0
; 0000 0561 
; 0000 0562               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0563      if(PINC==0xFB)
	IN   R30,0x6
	CPI  R30,LOW(0xFB)
	BREQ PC+3
	JMP _0x1D1
; 0000 0564         { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x1D3:
	CALL SUBOPT_0x39
	BRSH _0x1D4
; 0000 0565             {
; 0000 0566             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0567             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x1D5
; 0000 0568               {
; 0000 0569               if(LD1.Led.l3==0) LD1.Led.l3=1;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xC)
	BRNE _0x1D6
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xF3)
	ORI  R30,4
	RJMP _0x28D
; 0000 056A               else LD1.Led.l3=0;
_0x1D6:
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xF3)
_0x28D:
	CALL __EEPROMWRB
; 0000 056B               LOAD_LD();
	CALL _LOAD_LD
; 0000 056C               break;
	RJMP _0x1D4
; 0000 056D               }
; 0000 056E              }
_0x1D5:
	CALL SUBOPT_0x3
	RJMP _0x1D3
_0x1D4:
; 0000 056F          if(PINC==0xFB)
	IN   R30,0x6
	CPI  R30,LOW(0xFB)
	BRNE _0x1D8
; 0000 0570           { PGM=3;
	LDI  R30,LOW(3)
	MOV  R7,R30
; 0000 0571            #asm("sei")
	sei
; 0000 0572            for(i=0;i<6;i++) DAT3[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x1DA:
	CALL SUBOPT_0x18
	BRSH _0x1DB
	LDI  R26,LOW(_DAT3)
	LDI  R27,HIGH(_DAT3)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x1DA
_0x1DB:
; 0000 0573 for(j=0;j<60;j++)
	CLR  R8
_0x1DD:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1DE
; 0000 0574             {
; 0000 0575             LD1.Led.l3=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x47
; 0000 0576             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 0577             delay_ms(250);
; 0000 0578             LD1.Led.l3=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x36
; 0000 0579             LOAD_LD();
; 0000 057A             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 057B 
; 0000 057C             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x1DF
; 0000 057D                {LD1.Led.l3=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x47
; 0000 057E                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 057F                 delay_ms(2000);
; 0000 0580                 LD1.Led.l3=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xF3)
	CALL __EEPROMWRB
; 0000 0581                 break;
	RJMP _0x1DE
; 0000 0582                }
; 0000 0583             if(PGM==0xDF){LD1.Led.l1=1; break; }
_0x1DF:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x1E0
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
	RJMP _0x1DE
; 0000 0584             }
_0x1E0:
	INC  R8
	RJMP _0x1DD
_0x1DE:
; 0000 0585             PGM=0;
	CLR  R7
; 0000 0586            }
; 0000 0587 
; 0000 0588            if(PINC==0x7B)  //Пргораммирование брелока 3
_0x1D8:
	IN   R30,0x6
	CPI  R30,LOW(0x7B)
	BREQ PC+3
	JMP _0x1E1
; 0000 0589          {  PGM=13;
	LDI  R30,LOW(13)
	MOV  R7,R30
; 0000 058A            #asm("sei")
	sei
; 0000 058B            for(i=0;i<6;i++) BREL3[i]='F'; //Стирание кода брелка
	CLR  R5
	CLR  R6
_0x1E3:
	CALL SUBOPT_0x18
	BRSH _0x1E4
	LDI  R26,LOW(_BREL3)
	LDI  R27,HIGH(_BREL3)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x1E3
_0x1E4:
; 0000 058D for(j=0;j<60;j++)
	CLR  R8
_0x1E6:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1E7
; 0000 058E             {
; 0000 058F             LD1.Led.l3=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x47
; 0000 0590             LD3.Led.l2=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3F
; 0000 0591             LOAD_LD();
; 0000 0592             delay_ms(250);
; 0000 0593             LD1.Led.l3=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x48
; 0000 0594             LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 0595             LOAD_LD();
; 0000 0596             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0597              if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x1E8
; 0000 0598               {LD1.Led.l3=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x47
; 0000 0599                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 059A                 delay_ms(2000);
; 0000 059B                 LD1.Led.l3=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xF3)
	CALL __EEPROMWRB
; 0000 059C                 break;
	RJMP _0x1E7
; 0000 059D                }
; 0000 059E             if(PGM==0xDF){LD1.Led.l3=1; break; }
_0x1E8:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x1E9
	CALL SUBOPT_0x5
	CALL SUBOPT_0x48
	RJMP _0x1E7
; 0000 059F             }
_0x1E9:
	INC  R8
	RJMP _0x1E6
_0x1E7:
; 0000 05A0           PGM=0;
	CLR  R7
; 0000 05A1          }
; 0000 05A2 
; 0000 05A3           if(PINC==0xBB)  //Пргораммирование номера 3
_0x1E1:
	IN   R30,0x6
	CPI  R30,LOW(0xBB)
	BREQ PC+3
	JMP _0x1EA
; 0000 05A4          { #asm("sei")
	sei
; 0000 05A5           SEND_Str("AT+CPBW=3\r");
	__POINTW1FN _0x0,599
	CALL SUBOPT_0x23
; 0000 05A6           delay_ms(30);
	CALL SUBOPT_0x40
; 0000 05A7           CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 05A8            for(j=0;j<60;j++)
	CLR  R8
_0x1EC:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1ED
; 0000 05A9             {
; 0000 05AA             LD1.Led.l3=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x47
; 0000 05AB             LD3.Led.l1=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 05AC             LOAD_LD();
; 0000 05AD             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 05AE             LD1.Led.l3=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x48
; 0000 05AF             LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 05B0             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 05B1             delay_ms(250);
; 0000 05B2              if( strstr(rx_buffer0, "RING")!=NULL)
	CALL SUBOPT_0x24
	__POINTW1MN _0x1AC,10
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x1EE
; 0000 05B3              {  delay_ms(300);
	CALL SUBOPT_0x41
; 0000 05B4               SEND_Str("ATH\r");
	CALL SUBOPT_0x42
; 0000 05B5               delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 05B6              if( WRITE_NUMBER(3)==NULL)LD3.Led.l1=2;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x43
	BRNE _0x1EF
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	RJMP _0x28E
; 0000 05B7              else LD3.Led.l1=1;
_0x1EF:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
_0x28E:
	CALL __EEPROMWRB
; 0000 05B8              LOAD_LD();
	CALL SUBOPT_0x44
; 0000 05B9               delay_ms(2000);
; 0000 05BA               LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 05BB               CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 05BC                 break;
	RJMP _0x1ED
; 0000 05BD                 }
; 0000 05BE             }
_0x1EE:
	INC  R8
	RJMP _0x1EC
_0x1ED:
; 0000 05BF 
; 0000 05C0          }
; 0000 05C1               }
_0x1EA:
; 0000 05C2 
; 0000 05C3 				break;
_0x1D1:
	RJMP _0x18C
; 0000 05C4 			 }
; 0000 05C5 
; 0000 05C6    case 0xF7 :{
_0x1D0:
	CPI  R30,LOW(0xF7)
	BREQ PC+3
	JMP _0x1F1
; 0000 05C7 
; 0000 05C8               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 05C9      if(PINC==0xF7)
	IN   R30,0x6
	CPI  R30,LOW(0xF7)
	BREQ PC+3
	JMP _0x1F2
; 0000 05CA         { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x1F4:
	CALL SUBOPT_0x39
	BRSH _0x1F5
; 0000 05CB             {
; 0000 05CC             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 05CD             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x1F6
; 0000 05CE               {
; 0000 05CF               if(LD1.Led.l4==0) LD1.Led.l4=1;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0x3)
	BRNE _0x1F7
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xFC)
	ORI  R30,1
	RJMP _0x28F
; 0000 05D0               else LD1.Led.l4=0;
_0x1F7:
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xFC)
_0x28F:
	CALL __EEPROMWRB
; 0000 05D1               LOAD_LD();
	CALL _LOAD_LD
; 0000 05D2               break;
	RJMP _0x1F5
; 0000 05D3               }
; 0000 05D4              }
_0x1F6:
	CALL SUBOPT_0x3
	RJMP _0x1F4
_0x1F5:
; 0000 05D5          if(PINC==0xF7)
	IN   R30,0x6
	CPI  R30,LOW(0xF7)
	BRNE _0x1F9
; 0000 05D6           { PGM=4;
	LDI  R30,LOW(4)
	MOV  R7,R30
; 0000 05D7            #asm("sei")
	sei
; 0000 05D8            for(i=0;i<6;i++) DAT4[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x1FB:
	CALL SUBOPT_0x18
	BRSH _0x1FC
	LDI  R26,LOW(_DAT4)
	LDI  R27,HIGH(_DAT4)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x1FB
_0x1FC:
; 0000 05D9 for(j=0;j<60;j++)
	CLR  R8
_0x1FE:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x1FF
; 0000 05DA             {
; 0000 05DB             LD1.Led.l4=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x49
; 0000 05DC             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 05DD             delay_ms(250);
; 0000 05DE             LD1.Led.l4=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x35
; 0000 05DF             LOAD_LD();
; 0000 05E0             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 05E1 
; 0000 05E2             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x200
; 0000 05E3                {LD1.Led.l4=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x49
; 0000 05E4                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 05E5                 delay_ms(2000);
; 0000 05E6                 LD1.Led.l4=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xFC)
	CALL __EEPROMWRB
; 0000 05E7                 break;
	RJMP _0x1FF
; 0000 05E8                }
; 0000 05E9             if(PGM==0xDF){LD1.Led.l4=1; break; }
_0x200:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x201
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4A
	RJMP _0x1FF
; 0000 05EA             }
_0x201:
	INC  R8
	RJMP _0x1FE
_0x1FF:
; 0000 05EB             PGM=0;
	CLR  R7
; 0000 05EC            }
; 0000 05ED           if(PINC==0x77)  //Пргораммирование брелока 4
_0x1F9:
	IN   R30,0x6
	CPI  R30,LOW(0x77)
	BREQ PC+3
	JMP _0x202
; 0000 05EE          {  PGM=14;
	LDI  R30,LOW(14)
	MOV  R7,R30
; 0000 05EF            #asm("sei")
	sei
; 0000 05F0            for(i=0;i<6;i++) BREL4[i]='F'; //Стирание кода брелка
	CLR  R5
	CLR  R6
_0x204:
	CALL SUBOPT_0x18
	BRSH _0x205
	LDI  R26,LOW(_BREL4)
	LDI  R27,HIGH(_BREL4)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x204
_0x205:
; 0000 05F1 for(j=0;j<60;j++)
	CLR  R8
_0x207:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x208
; 0000 05F2             {
; 0000 05F3             LD1.Led.l4=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x49
; 0000 05F4             LD3.Led.l2=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3F
; 0000 05F5             LOAD_LD();
; 0000 05F6             delay_ms(250);
; 0000 05F7             LD1.Led.l4=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4A
; 0000 05F8             LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 05F9             LOAD_LD();
; 0000 05FA             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 05FB              if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x209
; 0000 05FC               {LD1.Led.l4=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x49
; 0000 05FD                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 05FE                 delay_ms(2000);
; 0000 05FF                 LD1.Led.l4=0;
	CALL SUBOPT_0x5
	ANDI R30,LOW(0xFC)
	CALL __EEPROMWRB
; 0000 0600                 break;
	RJMP _0x208
; 0000 0601                }
; 0000 0602             if(PGM==0xDF){LD1.Led.l4=1; break; }
_0x209:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x20A
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4A
	RJMP _0x208
; 0000 0603             }
_0x20A:
	INC  R8
	RJMP _0x207
_0x208:
; 0000 0604            PGM=0;
	CLR  R7
; 0000 0605          }
; 0000 0606           if(PINC==0xB7)  //Пргораммирование номера 4
_0x202:
	IN   R30,0x6
	CPI  R30,LOW(0xB7)
	BREQ PC+3
	JMP _0x20B
; 0000 0607          { #asm("sei")
	sei
; 0000 0608           SEND_Str("AT+CPBW=4\r");
	__POINTW1FN _0x0,610
	CALL SUBOPT_0x23
; 0000 0609           delay_ms(30);
	CALL SUBOPT_0x40
; 0000 060A           CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 060B           for(j=0;j<60;j++)
	CLR  R8
_0x20D:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x20E
; 0000 060C             {
; 0000 060D             LD1.Led.l4=2;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x49
; 0000 060E             LD3.Led.l1=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 060F             LOAD_LD();
; 0000 0610             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0611             LD1.Led.l4=1;
	CALL SUBOPT_0x5
	CALL SUBOPT_0x4A
; 0000 0612             LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0613             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 0614             delay_ms(250);
; 0000 0615              if( strstr(rx_buffer0, "RING")!=NULL)
	CALL SUBOPT_0x24
	__POINTW1MN _0x1AC,15
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x20F
; 0000 0616              {  delay_ms(300);
	CALL SUBOPT_0x41
; 0000 0617               SEND_Str("ATH\r");
	CALL SUBOPT_0x42
; 0000 0618               delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 0619              if( WRITE_NUMBER(4)==NULL)LD3.Led.l1=2;
	LDI  R30,LOW(4)
	CALL SUBOPT_0x43
	BRNE _0x210
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	RJMP _0x290
; 0000 061A              else LD3.Led.l1=1;
_0x210:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
_0x290:
	CALL __EEPROMWRB
; 0000 061B              LOAD_LD();
	CALL SUBOPT_0x44
; 0000 061C               delay_ms(2000);
; 0000 061D               LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 061E              CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 061F                 break;
	RJMP _0x20E
; 0000 0620                 }
; 0000 0621             }
_0x20F:
	INC  R8
	RJMP _0x20D
_0x20E:
; 0000 0622 
; 0000 0623          }
; 0000 0624               }
_0x20B:
; 0000 0625 
; 0000 0626 				break;
_0x1F2:
	RJMP _0x18C
; 0000 0627 			 }
; 0000 0628 
; 0000 0629    case 0xEF :{
_0x1F1:
	CPI  R30,LOW(0xEF)
	BREQ PC+3
	JMP _0x212
; 0000 062A 
; 0000 062B               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 062C      if(PINC==0xEF)
	IN   R30,0x6
	CPI  R30,LOW(0xEF)
	BREQ PC+3
	JMP _0x213
; 0000 062D         { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x215:
	CALL SUBOPT_0x39
	BRSH _0x216
; 0000 062E             {
; 0000 062F             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0630             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x217
; 0000 0631               {
; 0000 0632               if(LD2.Led.l1==0) LD2.Led.l1=1;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xC0)
	BRNE _0x218
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	RJMP _0x291
; 0000 0633               else LD2.Led.l1=0;
_0x218:
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x3F)
_0x291:
	CALL __EEPROMWRB
; 0000 0634               LOAD_LD();
	CALL _LOAD_LD
; 0000 0635               break;
	RJMP _0x216
; 0000 0636               }
; 0000 0637              }
_0x217:
	CALL SUBOPT_0x3
	RJMP _0x215
_0x216:
; 0000 0638          if(PINC==0xEF)
	IN   R30,0x6
	CPI  R30,LOW(0xEF)
	BRNE _0x21A
; 0000 0639           { PGM=5;
	LDI  R30,LOW(5)
	MOV  R7,R30
; 0000 063A            #asm("sei")
	sei
; 0000 063B            for(i=0;i<6;i++) DAT5[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x21C:
	CALL SUBOPT_0x18
	BRSH _0x21D
	LDI  R26,LOW(_DAT5)
	LDI  R27,HIGH(_DAT5)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x21C
_0x21D:
; 0000 063C for(j=0;j<60;j++)
	CLR  R8
_0x21F:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x220
; 0000 063D             {
; 0000 063E             LD2.Led.l1=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x28
; 0000 063F             LOAD_LD();
; 0000 0640             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0641             LD2.Led.l1=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x29
; 0000 0642             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 0643             delay_ms(250);
; 0000 0644 
; 0000 0645             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x221
; 0000 0646                {LD2.Led.l1=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x28
; 0000 0647                 LOAD_LD();
; 0000 0648                 delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 0649                 LD2.Led.l1=0;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x3F)
	CALL __EEPROMWRB
; 0000 064A                 break;
	RJMP _0x220
; 0000 064B                }
; 0000 064C             if(PGM==0xDF){LD2.Led.l1=1; break; }
_0x221:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x222
	CALL SUBOPT_0x4
	CALL SUBOPT_0x29
	RJMP _0x220
; 0000 064D             }
_0x222:
	INC  R8
	RJMP _0x21F
_0x220:
; 0000 064E             PGM=0;
	CLR  R7
; 0000 064F            }
; 0000 0650 
; 0000 0651           if(PINC==0x6F)  //Пргораммирование брелока 5
_0x21A:
	IN   R30,0x6
	CPI  R30,LOW(0x6F)
	BRNE _0x223
; 0000 0652          { PGM=15;
	LDI  R30,LOW(15)
	MOV  R7,R30
; 0000 0653            #asm("sei")
	sei
; 0000 0654            for(i=0;i<6;i++) BREL5[i]='F'; //Стирание кода брелка
	CLR  R5
	CLR  R6
_0x225:
	CALL SUBOPT_0x18
	BRSH _0x226
	LDI  R26,LOW(_BREL5)
	LDI  R27,HIGH(_BREL5)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x225
_0x226:
; 0000 0655 for(j=0;j<60;j++)
	CLR  R8
_0x228:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x229
; 0000 0656             {
; 0000 0657             LD2.Led.l1=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3E
; 0000 0658             LD3.Led.l2=2;
	CALL SUBOPT_0x3F
; 0000 0659             LOAD_LD();
; 0000 065A             delay_ms(250);
; 0000 065B             LD2.Led.l1=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x29
; 0000 065C             LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 065D             LOAD_LD();
; 0000 065E             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 065F              if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x22A
; 0000 0660               {LD2.Led.l1=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x28
; 0000 0661                 LOAD_LD();
; 0000 0662                 delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 0663                 LD2.Led.l1=0;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x3F)
	CALL __EEPROMWRB
; 0000 0664                 break;
	RJMP _0x229
; 0000 0665                }
; 0000 0666             if(PGM==0xDF){LD2.Led.l1=1; break; }
_0x22A:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x22B
	CALL SUBOPT_0x4
	CALL SUBOPT_0x29
	RJMP _0x229
; 0000 0667             }
_0x22B:
	INC  R8
	RJMP _0x228
_0x229:
; 0000 0668            PGM=0;
	CLR  R7
; 0000 0669          }
; 0000 066A 
; 0000 066B           if(PINC==0xAF)  //Пргораммирование номера 5
_0x223:
	IN   R30,0x6
	CPI  R30,LOW(0xAF)
	BREQ PC+3
	JMP _0x22C
; 0000 066C          {#asm("sei")
	sei
; 0000 066D           SEND_Str("AT+CPBW=5\r");
	__POINTW1FN _0x0,621
	CALL SUBOPT_0x23
; 0000 066E           delay_ms(30);
	CALL SUBOPT_0x40
; 0000 066F           CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 0670           for(j=0;j<60;j++)
	CLR  R8
_0x22E:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x22F
; 0000 0671             {
; 0000 0672             LD2.Led.l1=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3E
; 0000 0673             LD3.Led.l1=2;
	CALL SUBOPT_0x28
; 0000 0674             LOAD_LD();
; 0000 0675             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0676             LD2.Led.l1=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x29
; 0000 0677             LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0678             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 0679             delay_ms(250);
; 0000 067A              if( strstr(rx_buffer0, "RING")!=NULL)
	CALL SUBOPT_0x24
	__POINTW1MN _0x1AC,20
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x230
; 0000 067B              {  delay_ms(300);
	CALL SUBOPT_0x41
; 0000 067C               SEND_Str("ATH\r");
	CALL SUBOPT_0x42
; 0000 067D               delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 067E              if( WRITE_NUMBER(5)==NULL)LD3.Led.l1=2;
	LDI  R30,LOW(5)
	CALL SUBOPT_0x43
	BRNE _0x231
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	RJMP _0x292
; 0000 067F              else LD3.Led.l1=1;
_0x231:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
_0x292:
	CALL __EEPROMWRB
; 0000 0680              LOAD_LD();
	CALL SUBOPT_0x44
; 0000 0681               delay_ms(2000);
; 0000 0682               LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0683              CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 0684                 break;
	RJMP _0x22F
; 0000 0685                 }
; 0000 0686             }
_0x230:
	INC  R8
	RJMP _0x22E
_0x22F:
; 0000 0687 
; 0000 0688          }
; 0000 0689               }
_0x22C:
; 0000 068A 
; 0000 068B 				break;
_0x213:
	RJMP _0x18C
; 0000 068C 			 }
; 0000 068D 
; 0000 068E    case 0xDF :{
_0x212:
	CPI  R30,LOW(0xDF)
	BREQ PC+3
	JMP _0x233
; 0000 068F 
; 0000 0690               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0691      if(PINC==0xDF)
	IN   R30,0x6
	CPI  R30,LOW(0xDF)
	BREQ PC+3
	JMP _0x234
; 0000 0692         { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x236:
	CALL SUBOPT_0x39
	BRSH _0x237
; 0000 0693             {
; 0000 0694             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0695             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x238
; 0000 0696               {
; 0000 0697               if(LD2.Led.l2==0) LD2.Led.l2=1;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x30)
	BRNE _0x239
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xCF)
	ORI  R30,0x10
	RJMP _0x293
; 0000 0698               else LD2.Led.l2=0;
_0x239:
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xCF)
_0x293:
	CALL __EEPROMWRB
; 0000 0699               LOAD_LD();
	CALL _LOAD_LD
; 0000 069A               break;
	RJMP _0x237
; 0000 069B               }
; 0000 069C              }
_0x238:
	CALL SUBOPT_0x3
	RJMP _0x236
_0x237:
; 0000 069D          if(PINC==0xDF)
	IN   R30,0x6
	CPI  R30,LOW(0xDF)
	BRNE _0x23B
; 0000 069E           { PGM=6;
	LDI  R30,LOW(6)
	MOV  R7,R30
; 0000 069F            #asm("sei")
	sei
; 0000 06A0            for(i=0;i<6;i++) DAT6[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x23D:
	CALL SUBOPT_0x18
	BRSH _0x23E
	LDI  R26,LOW(_DAT6)
	LDI  R27,HIGH(_DAT6)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x23D
_0x23E:
; 0000 06A1 for(j=0;j<60;j++)
	CLR  R8
_0x240:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x241
; 0000 06A2             {
; 0000 06A3             LD2.Led.l2=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x3F
; 0000 06A4             LOAD_LD();
; 0000 06A5             delay_ms(250);
; 0000 06A6             LD2.Led.l2=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x31
; 0000 06A7             LOAD_LD();
; 0000 06A8             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 06A9 
; 0000 06AA             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x242
; 0000 06AB                {LD2.Led.l2=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x45
; 0000 06AC                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 06AD                 delay_ms(2000);
; 0000 06AE                 LD2.Led.l2=0;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xCF)
	CALL __EEPROMWRB
; 0000 06AF                 break;
	RJMP _0x241
; 0000 06B0                }
; 0000 06B1             if(PGM==0xDF){LD2.Led.l2=1; break; }
_0x242:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x243
	CALL SUBOPT_0x4
	CALL SUBOPT_0x46
	RJMP _0x241
; 0000 06B2             }
_0x243:
	INC  R8
	RJMP _0x240
_0x241:
; 0000 06B3             PGM=0;
	CLR  R7
; 0000 06B4            }
; 0000 06B5 
; 0000 06B6          if(PINC==0x5F)  //Пргораммирование брелока 6
_0x23B:
	IN   R30,0x6
	CPI  R30,LOW(0x5F)
	BREQ PC+3
	JMP _0x244
; 0000 06B7          { PGM=16;
	LDI  R30,LOW(16)
	MOV  R7,R30
; 0000 06B8            #asm("sei")
	sei
; 0000 06B9            for(i=0;i<6;i++) BREL6[i]='F'; //Стирание кода брелка
	CLR  R5
	CLR  R6
_0x246:
	CALL SUBOPT_0x18
	BRSH _0x247
	LDI  R26,LOW(_BREL6)
	LDI  R27,HIGH(_BREL6)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x246
_0x247:
; 0000 06BA for(j=0;j<60;j++)
	CLR  R8
_0x249:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x24A
; 0000 06BB             {
; 0000 06BC             LD2.Led.l2=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x45
; 0000 06BD             LD3.Led.l2=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x3F
; 0000 06BE             LOAD_LD();
; 0000 06BF             delay_ms(250);
; 0000 06C0             LD2.Led.l2=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x46
; 0000 06C1             LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 06C2             LOAD_LD();
; 0000 06C3             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 06C4              if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x24B
; 0000 06C5               {LD2.Led.l2=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x45
; 0000 06C6                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 06C7                 delay_ms(2000);
; 0000 06C8                 LD2.Led.l2=0;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xCF)
	CALL __EEPROMWRB
; 0000 06C9                 break;
	RJMP _0x24A
; 0000 06CA                }
; 0000 06CB             if(PGM==0xDF){LD2.Led.l2=1; break; }
_0x24B:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x24C
	CALL SUBOPT_0x4
	CALL SUBOPT_0x46
	RJMP _0x24A
; 0000 06CC             }
_0x24C:
	INC  R8
	RJMP _0x249
_0x24A:
; 0000 06CD            PGM=0;
	CLR  R7
; 0000 06CE          }
; 0000 06CF           if(PINC==0x9F)  //Пргораммирование номера 6
_0x244:
	IN   R30,0x6
	CPI  R30,LOW(0x9F)
	BREQ PC+3
	JMP _0x24D
; 0000 06D0          { #asm("sei")
	sei
; 0000 06D1           SEND_Str("AT+CPBW=6\r");
	__POINTW1FN _0x0,632
	CALL SUBOPT_0x23
; 0000 06D2           delay_ms(30);
	CALL SUBOPT_0x40
; 0000 06D3           CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 06D4           for(j=0;j<60;j++)
	CLR  R8
_0x24F:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x250
; 0000 06D5             {
; 0000 06D6             LD2.Led.l2=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x45
; 0000 06D7             LD3.Led.l1=2;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 06D8             LOAD_LD();
; 0000 06D9             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 06DA             LD2.Led.l2=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x46
; 0000 06DB             LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 06DC             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 06DD             delay_ms(250);
; 0000 06DE              if( strstr(rx_buffer0, "RING")!=NULL)
	CALL SUBOPT_0x24
	__POINTW1MN _0x1AC,25
	CALL SUBOPT_0x25
	SBIW R30,0
	BREQ _0x251
; 0000 06DF              {  delay_ms(300);
	CALL SUBOPT_0x41
; 0000 06E0               SEND_Str("ATH\r");
	CALL SUBOPT_0x42
; 0000 06E1               delay_ms(2000);
	CALL SUBOPT_0x3D
; 0000 06E2              if( WRITE_NUMBER(6)==NULL)LD3.Led.l1=2;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x43
	BRNE _0x252
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	RJMP _0x294
; 0000 06E3              else LD3.Led.l1=1;
_0x252:
	CALL SUBOPT_0x0
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
_0x294:
	CALL __EEPROMWRB
; 0000 06E4              LOAD_LD();
	CALL SUBOPT_0x44
; 0000 06E5               delay_ms(2000);
; 0000 06E6               LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 06E7              CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 06E8                 break;
	RJMP _0x250
; 0000 06E9                 }
; 0000 06EA             }
_0x251:
	INC  R8
	RJMP _0x24F
_0x250:
; 0000 06EB 
; 0000 06EC          }
; 0000 06ED               }
_0x24D:
; 0000 06EE 
; 0000 06EF 				break;
_0x234:
	RJMP _0x18C
; 0000 06F0 			 }
; 0000 06F1 
; 0000 06F2    case 0xBF :{
_0x233:
	CPI  R30,LOW(0xBF)
	BREQ PC+3
	JMP _0x254
; 0000 06F3 
; 0000 06F4               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 06F5      if(PINC==0xBF)
	IN   R30,0x6
	CPI  R30,LOW(0xBF)
	BREQ PC+3
	JMP _0x255
; 0000 06F6             { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x257:
	CALL SUBOPT_0x39
	BRSH _0x258
; 0000 06F7             {
; 0000 06F8             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 06F9             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x259
; 0000 06FA               {
; 0000 06FB               if(LD2.Led.l3==0) LD2.Led.l3=1;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xC)
	BRNE _0x25A
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xF3)
	ORI  R30,4
	RJMP _0x295
; 0000 06FC               else LD2.Led.l3=0;
_0x25A:
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xF3)
_0x295:
	CALL __EEPROMWRB
; 0000 06FD               LOAD_LD();
	CALL _LOAD_LD
; 0000 06FE               break;
	RJMP _0x258
; 0000 06FF               }
; 0000 0700              }
_0x259:
	CALL SUBOPT_0x3
	RJMP _0x257
_0x258:
; 0000 0701          if(PINC==0xBF)
	IN   R30,0x6
	CPI  R30,LOW(0xBF)
	BRNE _0x25C
; 0000 0702           { PGM=7;
	LDI  R30,LOW(7)
	MOV  R7,R30
; 0000 0703            #asm("sei")
	sei
; 0000 0704            for(i=0;i<6;i++) DAT7[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x25E:
	CALL SUBOPT_0x18
	BRSH _0x25F
	LDI  R26,LOW(_DAT7)
	LDI  R27,HIGH(_DAT7)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x25E
_0x25F:
; 0000 0705 for(j=0;j<60;j++)
	CLR  R8
_0x261:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x262
; 0000 0706             {
; 0000 0707             LD2.Led.l3=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x47
; 0000 0708             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 0709             delay_ms(250);
; 0000 070A             LD2.Led.l3=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x36
; 0000 070B             LOAD_LD();
; 0000 070C             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 070D 
; 0000 070E             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x263
; 0000 070F                {LD2.Led.l3=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x47
; 0000 0710                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 0711                 delay_ms(2000);
; 0000 0712                 LD2.Led.l3=0;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xF3)
	CALL __EEPROMWRB
; 0000 0713                 break;
	RJMP _0x262
; 0000 0714                }
; 0000 0715             if(PGM==0xDF){LD2.Led.l3=1; break; }
_0x263:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x264
	CALL SUBOPT_0x4
	CALL SUBOPT_0x48
	RJMP _0x262
; 0000 0716             }
_0x264:
	INC  R8
	RJMP _0x261
_0x262:
; 0000 0717             PGM=0;
	CLR  R7
; 0000 0718            }
; 0000 0719               }
_0x25C:
; 0000 071A 
; 0000 071B 				break;
_0x255:
	RJMP _0x18C
; 0000 071C 			 }
; 0000 071D 
; 0000 071E    case 0x7F :{
_0x254:
	CPI  R30,LOW(0x7F)
	BREQ PC+3
	JMP _0x18C
; 0000 071F 
; 0000 0720               delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0721      if(PINC==0x7F)
	IN   R30,0x6
	CPI  R30,LOW(0x7F)
	BREQ PC+3
	JMP _0x266
; 0000 0722         { for(i=0;i<3000;i++)
	CLR  R5
	CLR  R6
_0x268:
	CALL SUBOPT_0x39
	BRSH _0x269
; 0000 0723             {
; 0000 0724             delay_ms(1);
	CALL SUBOPT_0x6
; 0000 0725             if(PINC==0xFF)
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x26A
; 0000 0726               {
; 0000 0727               if(LD2.Led.l4==0) LD2.Led.l4=1;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0x3)
	BRNE _0x26B
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xFC)
	ORI  R30,1
	RJMP _0x296
; 0000 0728               else LD2.Led.l4=0;
_0x26B:
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xFC)
_0x296:
	CALL __EEPROMWRB
; 0000 0729               LOAD_LD();
	CALL _LOAD_LD
; 0000 072A               break;
	RJMP _0x269
; 0000 072B               }
; 0000 072C              }
_0x26A:
	CALL SUBOPT_0x3
	RJMP _0x268
_0x269:
; 0000 072D          if(PINC==0x7F)
	IN   R30,0x6
	CPI  R30,LOW(0x7F)
	BRNE _0x26D
; 0000 072E           { PGM=8;
	LDI  R30,LOW(8)
	MOV  R7,R30
; 0000 072F            #asm("sei")
	sei
; 0000 0730            for(i=0;i<6;i++) DAT8[i]='F'; //Стирание кода датчика
	CLR  R5
	CLR  R6
_0x26F:
	CALL SUBOPT_0x18
	BRSH _0x270
	LDI  R26,LOW(_DAT8)
	LDI  R27,HIGH(_DAT8)
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3
	RJMP _0x26F
_0x270:
; 0000 0731 for(j=0;j<60;j++)
	CLR  R8
_0x272:
	LDI  R30,LOW(60)
	CP   R8,R30
	BRSH _0x273
; 0000 0732             {
; 0000 0733             LD2.Led.l4=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x49
; 0000 0734             LOAD_LD();
	CALL SUBOPT_0x3C
; 0000 0735             delay_ms(250);
; 0000 0736             LD2.Led.l4=1;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x35
; 0000 0737             LOAD_LD();
; 0000 0738             delay_ms(250);
	CALL SUBOPT_0x3B
; 0000 0739 
; 0000 073A             if(PGM==0xFF)
	LDI  R30,LOW(255)
	CP   R30,R7
	BRNE _0x274
; 0000 073B                {LD2.Led.l4=2;
	CALL SUBOPT_0x4
	CALL SUBOPT_0x49
; 0000 073C                 LOAD_LD();
	CALL SUBOPT_0x44
; 0000 073D                 delay_ms(2000);
; 0000 073E                 LD2.Led.l4=0;
	CALL SUBOPT_0x4
	ANDI R30,LOW(0xFC)
	CALL __EEPROMWRB
; 0000 073F                 break;
	RJMP _0x273
; 0000 0740                }
; 0000 0741             if(PGM==0xDF){LD2.Led.l4=1; break; }
_0x274:
	LDI  R30,LOW(223)
	CP   R30,R7
	BRNE _0x275
	CALL SUBOPT_0x4
	CALL SUBOPT_0x4A
	RJMP _0x273
; 0000 0742             }
_0x275:
	INC  R8
	RJMP _0x272
_0x273:
; 0000 0743             PGM=0;
	CLR  R7
; 0000 0744            }
; 0000 0745               }
_0x26D:
; 0000 0746 
; 0000 0747 				break;
_0x266:
; 0000 0748 			 }
; 0000 0749 
; 0000 074A 
; 0000 074B   }
_0x18C:
; 0000 074C 
; 0000 074D   CLEAR_BUF();
	CALL _CLEAR_BUF
; 0000 074E     delay_ms(300);
	CALL SUBOPT_0x41
; 0000 074F   while(PINC!=0xFF);
_0x276:
	IN   R30,0x6
	CPI  R30,LOW(0xFF)
	BRNE _0x276
; 0000 0750   PCICR=0x05;
	LDI  R30,LOW(5)
	STS  104,R30
; 0000 0751   PCIFR|=0x04;  //Сброс флага прерывания
	SBI  0x1B,2
; 0000 0752 
; 0000 0753 
; 0000 0754 }
	CALL SUBOPT_0x38
	RETI

	.DSEG
_0x1AC:
	.BYTE 0x1E
;
;
;
;
;
;
;//***************************************************************************************************************************************
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)  //Прерывание по приему символа USART
; 0000 075E {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 075F char status,data;
; 0000 0760 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0761 data=UDR0;
	LDS  R16,198
; 0000 0762 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x279
; 0000 0763    {
; 0000 0764    rx_buffer0[rx_wr_index0++]=data;
	__GETW1R 3,4
	ADIW R30,1
	__PUTW1R 3,4
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0765 
; 0000 0766 
; 0000 0767    }
; 0000 0768 }
_0x279:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;//=====================================================================================================================================
;
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0771 {
_main:
; 0000 0772 // Declare your local variables here
; 0000 0773 
; 0000 0774 // Crystal Oscillator division factor: 1
; 0000 0775 #pragma optsize-
; 0000 0776 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0777 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0778 #ifdef _OPTIMIZE_SIZE_
; 0000 0779 #pragma optsize+
; 0000 077A #endif
; 0000 077B 
; 0000 077C // Input/Output Ports initialization
; 0000 077D // Port A initialization
; 0000 077E // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 077F // State7=T State6=T State5=1 State4=0 State3=0 State2=0 State1=T State0=T
; 0000 0780 PORTA=0x20;
	LDI  R30,LOW(32)
	OUT  0x2,R30
; 0000 0781 DDRA=0x3C;
	LDI  R30,LOW(60)
	OUT  0x1,R30
; 0000 0782 
; 0000 0783 // Port B initialization
; 0000 0784 // Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=Out
; 0000 0785 // State7=0 State6=T State5=0 State4=1 State3=0 State2=1 State1=T State0=1
; 0000 0786 PORTB=0x15;
	LDI  R30,LOW(21)
	OUT  0x5,R30
; 0000 0787 DDRB=0xBD;
	LDI  R30,LOW(189)
	OUT  0x4,R30
; 0000 0788 
; 0000 0789 // Port C initialization
; 0000 078A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 078B // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 078C PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x8,R30
; 0000 078D DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 078E 
; 0000 078F // Port D initialization
; 0000 0790 // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In
; 0000 0791 // State7=T State6=0 State5=0 State4=0 State3=0 State2=T State1=0 State0=T
; 0000 0792 PORTD=0x00;
	OUT  0xB,R30
; 0000 0793 DDRD=0x7A;
	LDI  R30,LOW(122)
	OUT  0xA,R30
; 0000 0794 
; 0000 0795 // Timer/Counter 0 initialization
; 0000 0796 // Clock source: System Clock
; 0000 0797 // Clock value: Timer 0 Stopped
; 0000 0798 // Mode: Normal top=0xFF
; 0000 0799 // OC0A output: Disconnected
; 0000 079A // OC0B output: Disconnected
; 0000 079B TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 079C TCCR0B=0x00;
	OUT  0x25,R30
; 0000 079D TCNT0=0x00;
	OUT  0x26,R30
; 0000 079E OCR0A=0x00;
	OUT  0x27,R30
; 0000 079F OCR0B=0x00;
	OUT  0x28,R30
; 0000 07A0 
; 0000 07A1 // Timer/Counter 1 initialization
; 0000 07A2 // Clock source: System Clock
; 0000 07A3 // Clock value: Timer1 Stopped
; 0000 07A4 // Mode: Normal top=0xFFFF
; 0000 07A5 // OC1A output: Discon.
; 0000 07A6 // OC1B output: Discon.
; 0000 07A7 // Noise Canceler: Off
; 0000 07A8 // Input Capture on Falling Edge
; 0000 07A9 // Timer1 Overflow Interrupt: Off
; 0000 07AA // Input Capture Interrupt: Off
; 0000 07AB // Compare A Match Interrupt: Off
; 0000 07AC // Compare B Match Interrupt: Off
; 0000 07AD TCCR1A=0x00;
	STS  128,R30
; 0000 07AE TCCR1B=0x00;
	STS  129,R30
; 0000 07AF TCNT1H=0x00;
	STS  133,R30
; 0000 07B0 TCNT1L=0x00;
	STS  132,R30
; 0000 07B1 ICR1H=0x00;
	STS  135,R30
; 0000 07B2 ICR1L=0x00;
	STS  134,R30
; 0000 07B3 OCR1AH=0x00;
	STS  137,R30
; 0000 07B4 OCR1AL=0x00;
	STS  136,R30
; 0000 07B5 OCR1BH=0x00;
	STS  139,R30
; 0000 07B6 OCR1BL=0x00;
	STS  138,R30
; 0000 07B7 
; 0000 07B8 // Timer/Counter 2 initialization
; 0000 07B9 // Clock source: System Clock
; 0000 07BA // Clock value: Timer2 Stopped
; 0000 07BB // Mode: Normal top=0xFF
; 0000 07BC // OC2A output: Disconnected
; 0000 07BD // OC2B output: Disconnected
; 0000 07BE ASSR=0x00;
	STS  182,R30
; 0000 07BF TCCR2A=0x00;
	STS  176,R30
; 0000 07C0 TCCR2B=0x00;
	STS  177,R30
; 0000 07C1 TCNT2=0x00;
	STS  178,R30
; 0000 07C2 OCR2A=0x00;
	STS  179,R30
; 0000 07C3 OCR2B=0x00;
	STS  180,R30
; 0000 07C4 
; 0000 07C5 // External Interrupt(s) initialization
; 0000 07C6 // INT0: Off
; 0000 07C7 // INT1: Off
; 0000 07C8 // INT2: Off
; 0000 07C9 // Interrupt on any change on pins PCINT0-7: On
; 0000 07CA // Interrupt on any change on pins PCINT8-15: Off
; 0000 07CB // Interrupt on any change on pins PCINT16-23: On
; 0000 07CC // Interrupt on any change on pins PCINT24-31: Off
; 0000 07CD EICRA=0x00;
	STS  105,R30
; 0000 07CE EIMSK=0x00;
	OUT  0x1D,R30
; 0000 07CF PCMSK0=0x03;
	LDI  R30,LOW(3)
	STS  107,R30
; 0000 07D0 PCMSK2=0xFF;
	LDI  R30,LOW(255)
	STS  109,R30
; 0000 07D1 PCICR=0x05;
	LDI  R30,LOW(5)
	STS  104,R30
; 0000 07D2 PCIFR=0x05;
	OUT  0x1B,R30
; 0000 07D3 
; 0000 07D4 // Timer/Counter 0 Interrupt(s) initialization
; 0000 07D5 TIMSK0=0x00;
	LDI  R30,LOW(0)
	STS  110,R30
; 0000 07D6 
; 0000 07D7 // Timer/Counter 1 Interrupt(s) initialization
; 0000 07D8 TIMSK1=0x00;
	STS  111,R30
; 0000 07D9 
; 0000 07DA // Timer/Counter 2 Interrupt(s) initialization
; 0000 07DB TIMSK2=0x00;
	STS  112,R30
; 0000 07DC 
; 0000 07DD // USART0 initialization
; 0000 07DE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 07DF // USART0 Receiver: On
; 0000 07E0 // USART0 Transmitter: On
; 0000 07E1 // USART0 Mode: Asynchronous
; 0000 07E2 // USART0 Baud Rate: 115200
; 0000 07E3 UCSR0A=0x00;
	STS  192,R30
; 0000 07E4 UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 07E5 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 07E6 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 07E7 UBRR0L=0x03;
	LDI  R30,LOW(3)
	STS  196,R30
; 0000 07E8 
; 0000 07E9 // USART1 initialization
; 0000 07EA // USART1 disabled
; 0000 07EB UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  201,R30
; 0000 07EC 
; 0000 07ED // Analog Comparator initialization
; 0000 07EE // Analog Comparator: Off
; 0000 07EF // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 07F0 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 07F1 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 07F2 DIDR1=0x00;
	STS  127,R30
; 0000 07F3 
; 0000 07F4 // ADC initialization
; 0000 07F5 // ADC disabled
; 0000 07F6 ADCSRA=0x00;
	STS  122,R30
; 0000 07F7 
; 0000 07F8 // SPI initialization
; 0000 07F9 // SPI Type: Master
; 0000 07FA // SPI Clock Rate: 921,600 kHz
; 0000 07FB // SPI Clock Phase: Cycle Start
; 0000 07FC // SPI Clock Polarity: Low
; 0000 07FD // SPI Data Order: MSB First
; 0000 07FE SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0x2C,R30
; 0000 07FF SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0800 
; 0000 0801 // TWI initialization
; 0000 0802 // TWI disabled
; 0000 0803 TWCR=0x00;
	STS  188,R30
; 0000 0804 
; 0000 0805 // Global enable interrupts
; 0000 0806 
; 0000 0807 #asm("cli")
	cli
; 0000 0808  for(i=0;i<256;i++) STAT[i]=0xFF;
	CLR  R5
	CLR  R6
_0x27B:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CP   R5,R30
	CPC  R6,R31
	BRSH _0x27C
	LDI  R26,LOW(_STAT)
	LDI  R27,HIGH(_STAT)
	ADD  R26,R5
	ADC  R27,R6
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
	CALL SUBOPT_0x3
	RJMP _0x27B
_0x27C:
; 0000 0809 LD1.byte=0x00;
	LDI  R26,LOW(_LD1)
	LDI  R27,HIGH(_LD1)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 080A LD2.byte=0x00;
	LDI  R26,LOW(_LD2)
	LDI  R27,HIGH(_LD2)
	CALL __EEPROMWRB
; 0000 080B LD3.byte=0x00;
	LDI  R26,LOW(_LD3)
	LDI  R27,HIGH(_LD3)
	CALL __EEPROMWRB
; 0000 080C //LD3.Led.l1=1;
; 0000 080D LOAD_LD();
	CALL _LOAD_LD
; 0000 080E delay_ms(1000);
	CALL SUBOPT_0x21
; 0000 080F //==============================================ИНИЦИАЛИЗАЦИЯ ТРАНСИВЕРА================================================================
; 0000 0810  RESET_TR();
	CALL _RESET_TR
; 0000 0811  delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1E
; 0000 0812  INIT_TR();
	CALL _INIT_TR
; 0000 0813  WRITE_PATABLE();
	CALL _WRITE_PATABLE
; 0000 0814  STROB(SIDLE);
	CALL SUBOPT_0x1B
; 0000 0815  STROB(SFRX);
; 0000 0816  STROB(SFTX);
; 0000 0817  STROB(SRX);
	LDI  R30,LOW(52)
	ST   -Y,R30
	CALL _STROB
; 0000 0818  delay_ms(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x1E
; 0000 0819 
; 0000 081A LD3.Led.l2=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x31
; 0000 081B  LOAD_LD();
; 0000 081C  PCIFR|=0x01; //Сбросфлага прерывания по приему пакета
	SBI  0x1B,0
; 0000 081D  #asm("sei")
	sei
; 0000 081E  //============================================ИНИЦИАЛИЗАЦИЯ МОДЕМА======================================================================
; 0000 081F    delay_ms(500);
	CALL SUBOPT_0x37
; 0000 0820  RESET_MODEM();
	CALL _RESET_MODEM
; 0000 0821 
; 0000 0822  //SEND_Str("AT+COPS?\r");
; 0000 0823 // delay_ms(1000);
; 0000 0824 
; 0000 0825 
; 0000 0826   //SEND_Str("AT+CSTA=145\r");
; 0000 0827   delay_ms(500);
	CALL SUBOPT_0x37
; 0000 0828   // SEND_Str("AT*PSSTKI=1\r");
; 0000 0829   //delay_ms(100);
; 0000 082A //CALL(1);
; 0000 082B //SEND_Str("AT*PSSTK?\r");
; 0000 082C // SEND_Str("ATD\"+79139357900\";\r");
; 0000 082D        /*
; 0000 082E delay_ms(15000);
; 0000 082F  for(i=0;i<256;i++)
; 0000 0830         {
; 0000 0831         STAT[i]=rx_buffer0[i];
; 0000 0832         }
; 0000 0833         */
; 0000 0834 
; 0000 0835 
; 0000 0836 
; 0000 0837  LD3.Led.l1=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
; 0000 0838  LOAD_LD();
	CALL _LOAD_LD
; 0000 0839 // delay_ms(3000);
; 0000 083A // CALL(1);
; 0000 083B 
; 0000 083C while (1)
_0x27D:
; 0000 083D       {
; 0000 083E       LOAD_LD();
	CALL _LOAD_LD
; 0000 083F       }
	RJMP _0x27D
; 0000 0840 }
_0x280:
	RJMP _0x280

	.CSEG
_strrchr:
    ld   r22,y+
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strrchr0:
    ld   r23,x
    cp   r22,r23
    brne strrchr1
    movw r30,r26
strrchr1:
    adiw r26,1
    tst  r23
    brne strrchr0
    ret
_strstr:
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	ADIW R28,4
	RET

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x200
_NR:
	.BYTE 0xC
_SPI_buffer:
	.BYTE 0x40

	.ESEG
_LD1:
	.BYTE 0x1
_LD2:
	.BYTE 0x1
_LD3:
	.BYTE 0x1
_DAT1:
	.DB  LOW(0x30363230),HIGH(0x30363230),BYTE3(0x30363230),BYTE4(0x30363230)
	.DW  0x3632
	.DB  0x0
_DAT2:
	.DB  LOW(0x31383231),HIGH(0x31383231),BYTE3(0x31383231),BYTE4(0x31383231)
	.DW  0x3832
	.DB  0x0
_DAT3:
	.DB  LOW(0x32363532),HIGH(0x32363532),BYTE3(0x32363532),BYTE4(0x32363532)
	.DW  0x3635
	.DB  0x0
_DAT4:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_DAT5:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_DAT6:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_DAT7:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_DAT8:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_BREL1:
	.DB  LOW(0x31343631),HIGH(0x31343631),BYTE3(0x31343631),BYTE4(0x31343631)
	.DW  0x3436
	.DB  0x0
_BREL2:
	.DB  LOW(0x32303532),HIGH(0x32303532),BYTE3(0x32303532),BYTE4(0x32303532)
	.DW  0x3035
	.DB  0x0
_BREL3:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_BREL4:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_BREL5:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_BREL6:
	.DB  LOW(0x46464646),HIGH(0x46464646),BYTE3(0x46464646),BYTE4(0x46464646)
	.DW  0x4646
	.DB  0x0
_OP:
	.BYTE 0x1
_STAT:
	.BYTE 0x100

	.DSEG
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 57 TIMES, CODE SIZE REDUCTION:109 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_LD3)
	LDI  R27,HIGH(_LD3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R5,R30
	CPC  R6,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x2:
	LD   R30,Y
	LDI  R31,0
	ASR  R31
	ROR  R30
	ST   Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBI  0x2,3
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x2,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 53 TIMES, CODE SIZE REDUCTION:101 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 59 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_LD2)
	LDI  R27,HIGH(_LD2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 72 TIMES, CODE SIZE REDUCTION:139 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_LD1)
	LDI  R27,HIGH(_LD1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	__GETW2R 5,6
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x8:
	__GETW1R 5,6
	ADIW R30,1
	__PUTW1R 5,6
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT1)
	LDI  R31,HIGH(_DAT1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT2)
	LDI  R31,HIGH(_DAT2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT3)
	LDI  R31,HIGH(_DAT3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT4)
	LDI  R31,HIGH(_DAT4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT5)
	LDI  R31,HIGH(_DAT5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT6)
	LDI  R31,HIGH(_DAT6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT7)
	LDI  R31,HIGH(_DAT7)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_DAT8)
	LDI  R31,HIGH(_DAT8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_BREL1)
	LDI  R31,HIGH(_BREL1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_BREL2)
	LDI  R31,HIGH(_BREL2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_BREL3)
	LDI  R31,HIGH(_BREL3)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_BREL4)
	LDI  R31,HIGH(_BREL4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_BREL5)
	LDI  R31,HIGH(_BREL5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	ST   -Y,R10
	ST   -Y,R9
	LDI  R30,LOW(_BREL6)
	LDI  R31,HIGH(_BREL6)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _VALID_CODE
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R5,R30
	CPC  R6,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:88 WORDS
SUBOPT_0x19:
	__GETW1R 9,10
	ADIW R30,1
	__PUTW1R 9,10
	SBIW R30,1
	LD   R30,Z
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	CALL _SPI_SEND
	LD   R30,Y
	ST   -Y,R30
	JMP  _SPI_SEND

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(54)
	ST   -Y,R30
	CALL _STROB
	LDI  R30,LOW(58)
	ST   -Y,R30
	CALL _STROB
	LDI  R30,LOW(59)
	ST   -Y,R30
	JMP  _STROB

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	ADD  R26,R5
	ADC  R27,R6
	LD   R30,X
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 104 TIMES, CODE SIZE REDUCTION:203 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1F:
	CALL __SAVELOCR4
	LDI  R30,LOW(_rx_buffer0)
	LDI  R31,HIGH(_rx_buffer0)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _strstr
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	MOVW R26,R18
	LD   R17,X
	CALL _CLEAR_BUF
	MOV  R30,R17
	CALL __LOADLOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _SEND_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(_rx_buffer0)
	LDI  R31,HIGH(_rx_buffer0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x25:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _strstr

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CP   R5,R30
	CPC  R6,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	SUBI R30,LOW(-_NR)
	SBCI R31,HIGH(-_NR)
	MOVW R0,R30
	MOVW R26,R18
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x28:
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	CALL __EEPROMWRB
	JMP  _LOAD_LD

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x29:
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_NR)
	LDI  R27,HIGH(_NR)
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	__PUTW1R 9,10
	MOV  R0,R9
	OR   R0,R10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(_NR)
	LDI  R31,HIGH(_NR)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2D:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2F:
	ST   -Y,R30
	CALL _SEND_SMS
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _CALL
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	ANDI R30,LOW(0xCF)
	ORI  R30,0x20
	CALL __EEPROMWRB
	CALL _LOAD_LD
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x31:
	ANDI R30,LOW(0xCF)
	ORI  R30,0x10
	CALL __EEPROMWRB
	JMP  _LOAD_LD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	ANDI R30,LOW(0xF3)
	ORI  R30,8
	CALL __EEPROMWRB
	CALL _LOAD_LD
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x33:
	ST   -Y,R30
	CALL _SEND_SMS
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _CALL

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	ANDI R30,LOW(0xFC)
	ORI  R30,2
	CALL __EEPROMWRB
	CALL _LOAD_LD
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	ANDI R30,LOW(0xFC)
	ORI  R30,1
	CALL __EEPROMWRB
	JMP  _LOAD_LD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x36:
	ANDI R30,LOW(0xF3)
	ORI  R30,4
	CALL __EEPROMWRB
	JMP  _LOAD_LD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x38:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CP   R5,R30
	CPC  R6,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x3A:
	ADD  R26,R5
	ADC  R27,R6
	LDI  R30,LOW(70)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x3C:
	CALL _LOAD_LD
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	ANDI R30,LOW(0x3F)
	ORI  R30,0x80
	CALL __EEPROMWRB
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3F:
	ANDI R30,LOW(0xCF)
	ORI  R30,0x20
	CALL __EEPROMWRB
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x42:
	__POINTW1FN _0x0,583
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x43:
	ST   -Y,R30
	CALL _WRITE_NUMBER
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x44:
	CALL _LOAD_LD
	RJMP SUBOPT_0x3D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x45:
	ANDI R30,LOW(0xCF)
	ORI  R30,0x20
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x46:
	ANDI R30,LOW(0xCF)
	ORI  R30,0x10
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
	ANDI R30,LOW(0xF3)
	ORI  R30,8
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x48:
	ANDI R30,LOW(0xF3)
	ORI  R30,4
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	ANDI R30,LOW(0xFC)
	ORI  R30,2
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	ANDI R30,LOW(0xFC)
	ORI  R30,1
	CALL __EEPROMWRB
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x733
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
