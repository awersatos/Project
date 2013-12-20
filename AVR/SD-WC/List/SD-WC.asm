
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8L
;Program type             : Application
;Clock frequency          : 3,686400 MHz
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
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _z=R5
	.DEF _i=R6
	.DEF _pktlen=R4
	.DEF _Error=R9
	.DEF _rx_wr_index=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl_frame:
	.DB  0x30,0x98,0x90,0x31,0xFF,0x8F,0x32,0x80
	.DB  0x28,0x33,0x80,0x56,0x34,0x4E,0xF6,0x35
	.DB  0xF6,0xF5,0x36,0x18,0x5C,0x37,0xD6,0x51
	.DB  0x38,0x44,0x44,0x39,0xA0,0x0
_tbl_rfinit:
	.DB  0x9,0x21,0x1,0x0,0x35,0x4D,0x2,0x1F
	.DB  0x1,0x4,0xBC,0xF0,0x5,0x0,0xA1,0x7
	.DB  0x12,0x4C,0x8,0x80,0x0,0xC,0x80,0x0
	.DB  0xE,0x16,0x9B,0xF,0x90,0xAD,0x10,0xB0
	.DB  0x0,0x13,0xA1,0x14,0x14,0x81,0x91,0x16
	.DB  0x0,0x2,0x18,0xB1,0x40,0x19,0xA8,0xF
	.DB  0x1A,0x3F,0x4,0x1C,0x58,0x0
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x2C,0x22,0x2B,0x37,0x0,0x41,0x54,0x2B
	.DB  0x43,0x55,0x53,0x44,0x3D,0x31,0x2C,0x22
	.DB  0x2A,0x31,0x30,0x30,0x23,0x22,0xD,0x0
	.DB  0x41,0x54,0x2B,0x43,0x55,0x53,0x44,0x3D
	.DB  0x31,0x2C,0x22,0x2A,0x31,0x30,0x32,0x23
	.DB  0x22,0xD,0x0,0x2B,0x43,0x55,0x53,0x44
	.DB  0x3A,0x0,0x30,0x34,0x31,0x31,0x30,0x34
	.DB  0x33,0x30,0x30,0x34,0x33,0x42,0x30,0x34
	.DB  0x33,0x30,0x30,0x34,0x33,0x44,0x30,0x34
	.DB  0x34,0x31,0x0,0x30,0x34,0x34,0x30,0x0
	.DB  0x41,0x54,0x2B,0x43,0x4D,0x47,0x53,0x3D
	.DB  0x25,0x30,0x32,0x64,0xD,0x0,0x30,0x30
	.DB  0x30,0x31,0x30,0x30,0x30,0x42,0x39,0x31
	.DB  0x0,0x30,0x30,0x30,0x38,0x25,0x30,0x32
	.DB  0x58,0x0,0x41,0x54,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x52,0x45,0x47,0x3F,0xD,0x0
	.DB  0x42,0x52,0x45,0x4C,0x4F,0x4B,0x0,0x44
	.DB  0x45,0x56,0x49,0x43,0x45,0x0,0x43,0x48
	.DB  0x41,0x4E,0x47,0x45,0x0,0x53,0x74,0x61
	.DB  0x74,0x75,0x73,0x2D,0x49,0x44,0x4C,0x45
	.DB  0x0,0x53,0x74,0x61,0x74,0x75,0x73,0x2D
	.DB  0x53,0x45,0x43,0x55,0x52,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x46,0x3D,0x22,0x4E
	.DB  0x22,0xD,0x0,0x41,0x54,0x2B,0x43,0x4F
	.DB  0x50,0x53,0x3F,0xD,0x0,0x2B,0x43,0x4F
	.DB  0x50,0x53,0x3A,0x0,0x42,0x65,0x65,0x6C
	.DB  0x69,0x6E,0x65,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4D,0x47,0x46,0x3D,0x30,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x53,0x3D,0x33
	.DB  0x39,0xD,0x0,0x30,0x30,0x30,0x38,0x31
	.DB  0x41,0x30,0x34,0x31,0x34,0x30,0x34,0x33
	.DB  0x32,0x30,0x34,0x33,0x35,0x30,0x34,0x34
	.DB  0x30,0x30,0x34,0x34,0x43,0x30,0x30,0x32
	.DB  0x30,0x30,0x34,0x33,0x45,0x30,0x34,0x34
	.DB  0x32,0x30,0x34,0x33,0x41,0x30,0x34,0x34
	.DB  0x30,0x30,0x34,0x34,0x42,0x30,0x34,0x34
	.DB  0x32,0x30,0x34,0x33,0x30,0x1A,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x23
	.DW  _0x0*2

	.DW  0x07
	.DW  _0x31
	.DW  _0x0*2+43

	.DW  0x19
	.DW  _0x31+7
	.DW  _0x0*2+50

	.DW  0x05
	.DW  _0x31+32
	.DW  _0x0*2+75

	.DW  0x07
	.DW  _0x8E
	.DW  _0x0*2+128

	.DW  0x07
	.DW  _0x8E+7
	.DW  _0x0*2+142

	.DW  0x07
	.DW  _0xA3
	.DW  _0x0*2+197

	.DW  0x08
	.DW  _0xA3+7
	.DW  _0x0*2+204

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
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : SD-WC
;Version : 1
;Date    : 16.10.2011
;Author  : Alexandr Gordejchik
;Company : NTS
;Comments:
;
;
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 3,686400 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <stdio.h>
;#include <spi.h>
;
;#define CR 0xD     // Определение служебных символов
;#define LF 0xA
;#define ctrl_Z 0x1A
;
;typedef union{                     // Определение структурного типа DATA
;		unsigned int data;
;		unsigned char byte[2];
;		struct{
;			unsigned char b0:1;
;			unsigned char b1:1;
;			unsigned char b2:1;
;			unsigned char b3:1;
;			unsigned char b4:1;
;			unsigned char b5:1;
;			unsigned char b6:1;
;			unsigned char b7:1;
;			unsigned char b8:1;
;			unsigned char b9:1;
;			unsigned char b10:1;
;			unsigned char b11:1;
;			unsigned char b12:1;
;			unsigned char b13:1;
;			unsigned char b14:1;
;			unsigned char b15:1;
;		} Bit;
;	}DATA;
;                    // Определение глобальных переменных
;char z;          //Переменная статуса охраны
;unsigned int i; //Счетчик
;unsigned char SPI_buffer[64];
;unsigned char pktlen;
;char Error;
;eeprom unsigned char OP;
;eeprom char NR[12];     // Массив телефонного номера
;eeprom unsigned char COUNT;
;//eeprom char eebuf[64];
;//eeprom char eebuffer[256];
;flash unsigned char CH=78;  //Номер канала
;flash unsigned char SW=9;  //Делитель частоты
;// значения для инициализации кадра
;                                                               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
;        flash unsigned char tbl_frame[30]  = {0x30,0x98,0x90,  //48  1  0  0  1  1  0 0 0 0 0 0 0 0 0 0 0 15:13 - 5 байт приамбула 12:11 - синхро-слово 64 бита {Reg55[15:0],Reg54[15:0],Reg53[15:0],Reg52[15:0]} 10:8 - трейлер 4 бита 7:6 - NRZ кодирование сигнала 5:4 - не использовать помехоустойчивое кодирование 3,2,1,0 - не особо важные настройки
;                                              0x31,0xFF,0x8F,  //49  1  1  1  1  1  1 1 1 1 0 0 0 1 1 1 1 15:8 - максимальная задержка 2 мс 7 - часы работают в режиме сна 5:0 - BDATA1 сбросить через 15 us
;                                              0x32,0x80,0x28,  //50  1  0  0  0  0  0 0 0 0 0 1 0 1 0 0 0 15:8 и 7:0 задержки для работы в режиме TX
;                                              0x33,0x80,0x56,  //51  1  0  0  0  0  0 0 0 0 1 0 1 0 1 1 0 15:8 - RX таймер 7 - MISO в неопределенном состоянии 6:0 - ключ для скрамблера
;                                              0x34,0x4E,0xF6,  //52  0  1  0  0  1  1 1 0 1 1 1 1 0 1 1 0  биты синхронизации
;                                              0x35,0xF6,0xF5,  //53  1  1  1  1  0  1 1 0 1 1 1 1 0 1 0 1  биты синхронизации
;                                              0x36,0x18,0x5C,  //54  0  0  0  1  1  0 0 0 0 1 0 1 1 1 0 0  биты синхронизации
;                                              0x37,0xD6,0x51,  //55  1  1  0  1  0  1 1 0 0 1 0 1 0 0 0 1  биты синхронизации
;                                              0x38,0x44,0x44,  //56  0  1  0  0  0  1 0 0 0 1 0 0 0 1 0 0  7 - PKF-flag высокий уровень активный
;                                              0x39,0xA0,0x00}; //57  1  0  1  0  0  0 0 0 0 0 0 0 0 0 0 0  15 - использовать CRC 14 -не использовать скрамблер 13 - первый байт содержит длину пакета 7:0 - CRC (???????????)
;
;		// значения для инициализации передатчика               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
;		flash unsigned char tbl_rfinit[54]  = {0x09,0x21,0x01,  //9   0  0  1  0  0  0 0 1 0 0 0 0 0 0 0 1
;											   0x00,0x35,0x4D,  //0   0  0  0  1  1  1 1 1 0 0 0 0 0 0 0 1
;											   0x02,0x1F,0x01,  //2   0  0  0  1  1  1 1 1 0 0 0 0 0 0 0 1
;											   0x04,0xBC,0xF0,  //4   1  0  1  1  1  1 0 0 1 1 1 1 0 0 0 0
;											   0x05,0x00,0xA1,  //5   0  0  0  0  0  0 0 0 1 0 1 0 0 0 0 1
;											   0x07,0x12,0x4C,  //7   0  0  0  1  0  0 1 0 0 1 0 0 1 1 0 0 13:9 - делитель 8- TX mode 7- RX mode 6:0 - частота (2402+76)
;											   0x08,0x80,0x00,  //8   1  0  0  0  0  0 0 0 0 0 0 0 0 0 0 0
;											   0x0C,0x80,0x00,  //12  1  0  0  0  0  0 0 0 0 0 0 0 0 0 0 0
;											   0x0E,0x16,0x9B,  //14  0  0  0  1  0  1 1 0 1 0 0 1 1 0 1 1
;											   0x0F,0x90,0xAD,  //15  1  0  0  1  0  0 0 0 1 0 1 0 1 1 0 1
;											   0x10,0xB0,0x00,  //16  1  0  1  1  0  0 0 0 0 0 0 0 0 0 0 0
;											   0x13,0xA1,0x14,  //19  1  0  1  0  0  0 0 1 0 0 0 1 0 1 0 0
;											   0x14,0x81,0x91,  //20  1  0  0  0  0  0 0 1 1 0 0 1 0 0 0 1
;											   0x16,0x00,0x02,  //22  0  0  0  0  0  0 0 0 0 0 0 0 0 0 1 0
;											   0x18,0xB1,0x40,  //24  1  0  1  1  0  0 0 1 0 1 0 0 0 0 0 0
;											   0x19,0xA8,0x0F,  //25  1  0  1  0  1  0 0 0 0 0 0 0 1 1 1 1
;											   0x1A,0x3F,0x04,  //26  0  0  1  1  1  1 1 1 0 0 0 0 0 1 0 0
;											   0x1C,0x58,0x00}; //28  0  1  0  1  1  0 0 0 0 0 0 0 0 0 0 0
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
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 512
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;
;#else
;unsigned int rx_wr_index;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;
;
;//********************************************************************************************
;void LightDiode(unsigned char n) // Функция управления светодиодом
; 0000 0098 {

	.CSEG
_LightDiode:
; 0000 0099  switch (n)
;	n -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x0
; 0000 009A  {
; 0000 009B  case 0:
	SBIW R30,0
	BRNE _0x6
; 0000 009C 			{
; 0000 009D 			PORTC.4=0;
	CBI  0x15,4
; 0000 009E             PORTC.5=0;
	CBI  0x15,5
; 0000 009F 				break;
	RJMP _0x5
; 0000 00A0 			}
; 0000 00A1  case 1:
_0x6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
; 0000 00A2 			{
; 0000 00A3 			PORTC.4=1;
	SBI  0x15,4
; 0000 00A4             PORTC.5=0;
	CBI  0x15,5
; 0000 00A5 				break;
	RJMP _0x5
; 0000 00A6 			}
; 0000 00A7  case 2:
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10
; 0000 00A8 			{
; 0000 00A9 			PORTC.4=0;
	CBI  0x15,4
; 0000 00AA             PORTC.5=1;
	RJMP _0xC3
; 0000 00AB 				break;
; 0000 00AC  case 3:
_0x10:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5
; 0000 00AD 			{
; 0000 00AE 			PORTC.4=1;
	SBI  0x15,4
; 0000 00AF             PORTC.5=1;
_0xC3:
	SBI  0x15,5
; 0000 00B0 				break;
; 0000 00B1 			} 			}
; 0000 00B2  }
_0x5:
; 0000 00B3 
; 0000 00B4 }
	RJMP _0x20C0002
;//***********************************************************************************************************
;void UART_Transmit(char data) // Функция передачи символа через UART
; 0000 00B7 {
_UART_Transmit:
; 0000 00B8 while (!(UCSRA & (1<<UDRE))) {};
;	data -> Y+0
_0x1A:
	SBIS 0xB,5
	RJMP _0x1A
; 0000 00B9 UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00BA }
	RJMP _0x20C0002
;
;//**********************************************************************************************************
;       void SEND_Str(flash char *str) {        // Функция передачи строки  из флеш памяти
; 0000 00BD void SEND_Str(flash char *str) {
_SEND_Str:
; 0000 00BE         while(*str) {
;	*str -> Y+0
_0x1D:
	RCALL SUBOPT_0x1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x1F
; 0000 00BF        UART_Transmit(*str++);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00C0 
; 0000 00C1     };
	RJMP _0x1D
_0x1F:
; 0000 00C2     delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x4
	RCALL _delay_ms
; 0000 00C3 }
	RJMP _0x20C0004
;
;//**********************************************************************************************************
;void CLEAR_BUF(void)   // Функция очистки буффера приема
; 0000 00C7 {
_CLEAR_BUF:
; 0000 00C8 
; 0000 00C9 for (i=0;i<RX_BUFFER_SIZE;i++) {
	RCALL SUBOPT_0x5
_0x21:
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	RCALL SUBOPT_0x6
	BRSH _0x22
; 0000 00CA       rx_buffer[i]=0;
	LDI  R26,LOW(_rx_buffer)
	LDI  R27,HIGH(_rx_buffer)
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00CB     };
	RCALL SUBOPT_0x8
	RJMP _0x21
_0x22:
; 0000 00CC    rx_wr_index=0;
	CLR  R10
	CLR  R11
; 0000 00CD    #asm("wdr")
	wdr
; 0000 00CE 
; 0000 00CF }
	RET
;//**********************************************************************************************************
;  char TEST_OK(void)     // Функция проверки ответа ОК на команду
; 0000 00D2   {
_TEST_OK:
; 0000 00D3   char c;
; 0000 00D4   char *d;
; 0000 00D5   char OK[]="OK";
; 0000 00D6   d=strstr(rx_buffer, OK);
	SBIW R28,3
	LDI  R30,LOW(79)
	ST   Y,R30
	LDI  R30,LOW(75)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	RCALL SUBOPT_0x9
;	c -> R17
;	*d -> R18,R19
;	OK -> Y+4
; 0000 00D7   c=*d;
	MOVW R26,R18
	LD   R17,X
; 0000 00D8   #asm("wdr")
	wdr
; 0000 00D9  CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 00DA    return c;
	RCALL SUBOPT_0xA
	ADIW R28,7
	RET
; 0000 00DB 
; 0000 00DC   }
;//**********************************************************************************************************
;  char REG_NET(void)   // Функция проверки регистрации в сети
; 0000 00DF   {
_REG_NET:
; 0000 00E0   char c;
; 0000 00E1   char *d;
; 0000 00E2   char REG[]="+CREG:";
; 0000 00E3   d=strstr(rx_buffer, REG);
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
	RCALL SUBOPT_0x9
;	c -> R17
;	*d -> R18,R19
;	REG -> Y+4
; 0000 00E4   d=d+9;
	__ADDWRN 18,19,9
; 0000 00E5   c=*d;
	MOVW R26,R18
	LD   R17,X
; 0000 00E6   #asm("wdr")
	wdr
; 0000 00E7   CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 00E8   return c;
	RCALL SUBOPT_0xA
	ADIW R28,11
	RET
; 0000 00E9   }
;//**********************************************************************************************************
;char SET_NR(void) // Функция считывания телефонного номера с SIM карты
; 0000 00EC {
_SET_NR:
; 0000 00ED char c;
; 0000 00EE char *d;
; 0000 00EF 
; 0000 00F0 d=strstr(rx_buffer, ",\"+7");
	RCALL __SAVELOCR4
;	c -> R17
;	*d -> R18,R19
	RCALL SUBOPT_0xB
	__POINTW1MN _0x23,0
	RCALL SUBOPT_0xC
	MOVW R18,R30
; 0000 00F1 if (d==NULL){c=0;
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x24
	LDI  R17,LOW(0)
; 0000 00F2           return c;}
	RCALL SUBOPT_0xA
	RJMP _0x20C0003
; 0000 00F3   d=d+4;
_0x24:
	__ADDWRN 18,19,4
; 0000 00F4   i=0;
	RCALL SUBOPT_0x5
; 0000 00F5   while(i<12)
_0x25:
	RCALL SUBOPT_0xD
	BRSH _0x27
; 0000 00F6   {
; 0000 00F7   NR[i++]=*d;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xE
; 0000 00F8    d=d-1;
	__SUBWRN 18,19,1
; 0000 00F9    NR[i++]=*d;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xE
; 0000 00FA    d=d+3;
	__ADDWRN 18,19,3
; 0000 00FB   }
	RJMP _0x25
_0x27:
; 0000 00FC   NR[10]='F';
	__POINTW2MN _NR,10
	LDI  R30,LOW(70)
	RCALL __EEPROMWRB
; 0000 00FD   #asm("wdr")
	wdr
; 0000 00FE   CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 00FF   c=1;
	LDI  R17,LOW(1)
; 0000 0100   return c;
	RCALL SUBOPT_0xA
	RJMP _0x20C0003
; 0000 0101 }

	.DSEG
_0x23:
	.BYTE 0x5
;
;//**********************************************************************************************************
;// Функция проверки балланса
; void BALLANSE(void)
; 0000 0106  {   unsigned char S;

	.CSEG
_BALLANSE:
; 0000 0107    // char XY[2];
; 0000 0108     unsigned char *s1, *s2;
; 0000 0109     delay_ms(4000);
	RCALL __SAVELOCR6
;	S -> R17
;	*s1 -> R18,R19
;	*s2 -> R20,R21
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	RCALL SUBOPT_0xF
; 0000 010A     CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 010B   do
_0x29:
; 0000 010C    { if(OP==0) SEND_Str("AT+CUSD=1,\"*100#\"\r"); //Отправа запроса балланса
	LDI  R26,LOW(_OP)
	LDI  R27,HIGH(_OP)
	RCALL __EEPROMRDB
	CPI  R30,0
	BRNE _0x2B
	__POINTW1FN _0x0,5
	RJMP _0xC4
; 0000 010D      else SEND_Str("AT+CUSD=1,\"*102#\"\r");
_0x2B:
	__POINTW1FN _0x0,24
_0xC4:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SEND_Str
; 0000 010E    delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0xF
; 0000 010F    #asm("wdr")
	wdr
; 0000 0110     }while(TEST_OK()==0);
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0x29
; 0000 0111     for(i=0;i<5;i++)
	RCALL SUBOPT_0x5
_0x2E:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x6
	BRSH _0x2F
; 0000 0112     {
; 0000 0113      if(strstr(rx_buffer, "+CUSD:")!=NULL) break;   //Ожидание ответа на запрос
	RCALL SUBOPT_0xB
	__POINTW1MN _0x31,0
	RCALL SUBOPT_0xC
	SBIW R30,0
	BRNE _0x2F
; 0000 0114      #asm("wdr")
	wdr
; 0000 0115      delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 0116      #asm("wdr")
	wdr
; 0000 0117     }
	RCALL SUBOPT_0x8
	RJMP _0x2E
_0x2F:
; 0000 0118     s1=strstr(rx_buffer, "04110430043B0430043D0441");
	RCALL SUBOPT_0xB
	__POINTW1MN _0x31,7
	RCALL SUBOPT_0xC
	MOVW R18,R30
; 0000 0119     if(s1!=NULL)
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x32
; 0000 011A     {
; 0000 011B     s2=strstr(rx_buffer, "0440");
	RCALL SUBOPT_0xB
	__POINTW1MN _0x31,32
	RCALL SUBOPT_0xC
	MOVW R20,R30
; 0000 011C     S=((s2-s1+4)/2)+13;
	MOVW R30,R20
	SUB  R30,R18
	SBC  R31,R19
	ADIW R30,4
	LSR  R31
	ROR  R30
	SUBI R30,-LOW(13)
	MOV  R17,R30
; 0000 011D    // sprintf(XY, "%02d", S);
; 0000 011E    // XX[0]=XY[0];
; 0000 011F    // XX[1]=XY[1];
; 0000 0120 
; 0000 0121     printf("AT+CMGS=%02d\r",S) ;
	__POINTW1FN _0x0,80
	RCALL SUBOPT_0x11
; 0000 0122     delay_ms(100);
	RCALL SUBOPT_0x12
; 0000 0123     #asm("wdr")
	wdr
; 0000 0124      SEND_Str("0001000B91");     // Ввод настроек PDU
	RCALL SUBOPT_0x13
; 0000 0125 
; 0000 0126       for(i=0;i<12;i++)            // Ввод номера
_0x34:
	RCALL SUBOPT_0xD
	BRSH _0x35
; 0000 0127       {UART_Transmit(NR[i]);}
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	RJMP _0x34
_0x35:
; 0000 0128       S=S-13;
	RCALL SUBOPT_0x15
	SBIW R30,13
	MOV  R17,R30
; 0000 0129       printf("0008%02X", S);
	__POINTW1FN _0x0,105
	RCALL SUBOPT_0x11
; 0000 012A       s2=s2+4;
	__ADDWRN 20,21,4
; 0000 012B       do{
_0x37:
; 0000 012C        UART_Transmit(*s1);
	MOVW R26,R18
	LD   R30,X
	RCALL SUBOPT_0x3
; 0000 012D        s1++;
	__ADDWRN 18,19,1
; 0000 012E       }while(s1!=s2);
	__CPWRR 20,21,18,19
	BRNE _0x37
; 0000 012F       UART_Transmit(0x1A);
	LDI  R30,LOW(26)
	RCALL SUBOPT_0x3
; 0000 0130              /*
; 0000 0131       delay_ms(1000);
; 0000 0132   for (i=0; i<256; i++)    // Запись буфера приема в eeprom
; 0000 0133       {eebuffer[i]=rx_buffer[i];}
; 0000 0134              */
; 0000 0135       }
; 0000 0136       CLEAR_BUF();
_0x32:
	RCALL _CLEAR_BUF
; 0000 0137  }
	RCALL __LOADLOCR6
	ADIW R28,6
	RET

	.DSEG
_0x31:
	.BYTE 0x25
;//********************************************************************************************
;//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
;//============================================================================================
;unsigned char SPI_SEND(unsigned char data)  // Передать/принять байт  по SPI
; 0000 013C {

	.CSEG
_SPI_SEND:
; 0000 013D SPDR = data;
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 013E 		while (!(SPSR & (1<<SPIF)));
_0x39:
	SBIS 0xE,7
	RJMP _0x39
; 0000 013F 		return SPDR;
	IN   R30,0xF
	RJMP _0x20C0002
; 0000 0140 }
;
;//*******************************************************************************************
;//записать в регистр трансивера значение
;	void TR24_Wrtie(unsigned char reg,unsigned int data)
; 0000 0145 	{
_TR24_Wrtie:
; 0000 0146 		union U
; 0000 0147 		{
; 0000 0148 			unsigned int buf;
; 0000 0149 			unsigned char b[2];
; 0000 014A 		};
; 0000 014B        union U dat;
; 0000 014C 		dat.buf=data;
	SBIW R28,2
;	reg -> Y+4
;	data -> Y+2
;	U -> Y+2
;	dat -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x16
; 0000 014D 
; 0000 014E 		PORTB.2=0;       // SPI_SS ON
	CBI  0x18,2
; 0000 014F 		SPI_SEND(reg);    //регистр
	LDD  R30,Y+4
	RCALL SUBOPT_0x17
; 0000 0150 		delay_us(2);
; 0000 0151 		SPI_SEND(dat.b[1]);   //старшая часть
	LDD  R30,Y+1
	RCALL SUBOPT_0x17
; 0000 0152 		delay_us(2);
; 0000 0153 		SPI_SEND(dat.b[0]);   //младшая часть
	LD   R30,Y
	RCALL SUBOPT_0x17
; 0000 0154 		delay_us(2);
; 0000 0155 		PORTB.2=1;     // SPI_SS OFF
	SBI  0x18,2
; 0000 0156         #asm("wdr")
	wdr
; 0000 0157 	}//end writeByte
	ADIW R28,5
	RET
;//*******************************************************************************************
; //Чтение из регистра трансивера
;	unsigned int TR24A_Read(unsigned char reg)
; 0000 015B 	{
_TR24A_Read:
; 0000 015C 		union U
; 0000 015D 		{
; 0000 015E 			unsigned int buf;
; 0000 015F 			unsigned char b[2];
; 0000 0160 		};
; 0000 0161            union U dat;
; 0000 0162 		PORTB.2=0;       // SPI_SS ON
	SBIW R28,2
;	reg -> Y+2
;	U -> Y+2
;	dat -> Y+0
	CBI  0x18,2
; 0000 0163 		SPI_SEND(reg |0x80);   //Старший бит определяет операцию
	LDD  R30,Y+2
	ORI  R30,0x80
	RCALL SUBOPT_0x17
; 0000 0164 		delay_us(2);
; 0000 0165 		dat.b[1]=SPI_SEND(0x0FF);
	RCALL SUBOPT_0x18
	STD  Y+1,R30
; 0000 0166 		delay_us(2);
	__DELAY_USB 2
; 0000 0167 		dat.b[0]=SPI_SEND(0x0FF);
	RCALL SUBOPT_0x18
	ST   Y,R30
; 0000 0168 		delay_us(2);
	__DELAY_USB 2
; 0000 0169 		PORTB.2=1;     // SPI_SS OFF
	SBI  0x18,2
; 0000 016A          #asm("wdr")
	wdr
; 0000 016B 		return dat.buf;
	RCALL SUBOPT_0x1
	RJMP _0x20C0001
; 0000 016C 	}//end readByte
;//*******************************************************************************************
;//Инициализация трансивера
;	void TR24A_INIT(void)
; 0000 0170 	{
_TR24A_INIT:
; 0000 0171 
; 0000 0172 		union U
; 0000 0173 		{
; 0000 0174 			unsigned int data;     //значение регистра
; 0000 0175 			unsigned char b[2];
; 0000 0176 		};
; 0000 0177         union U dt;
; 0000 0178                 /*
; 0000 0179 		chanel=76;   //канал по умолчанию
; 0000 017A 		swallow=9;    //делитель частоты по умолчанию
; 0000 017B 		Error.byte=0; //обнулить все ошибки
; 0000 017C 		ProgCRC=0;    //программное CRC выкл
; 0000 017D 		TrState=0;    //предыдущей режим работы трансивера, необходимо для приема пакета
; 0000 017E                   */
; 0000 017F 		//reset();
; 0000 0180 
; 0000 0181 		unsigned char i;
; 0000 0182         PORTB.0=0;      // Сброс трансивера перед инициализацией
	SBIW R28,2
	ST   -Y,R17
;	U -> Y+3
;	dt -> Y+1
;	i -> R17
	CBI  0x18,0
; 0000 0183      delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0xF
; 0000 0184      PORTB.0=1;
	SBI  0x18,0
; 0000 0185      delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0xF
; 0000 0186 		for(i=0;i<30;i=i+3)				//инициализация кадра
	LDI  R17,LOW(0)
_0x49:
	CPI  R17,30
	BRSH _0x4A
; 0000 0187 		{
; 0000 0188 			dt.b[1]=tbl_frame[i+1];
	RCALL SUBOPT_0x15
	__ADDW1FN _tbl_frame,1
	LPM  R0,Z
	STD  Y+2,R0
; 0000 0189 			dt.b[0]=tbl_frame[i+2];
	RCALL SUBOPT_0x15
	__ADDW1FN _tbl_frame,2
	LPM  R0,Z
	STD  Y+1,R0
; 0000 018A 			TR24_Wrtie(tbl_frame[i],dt.data);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
; 0000 018B 		}
	SUBI R17,-LOW(3)
	RJMP _0x49
_0x4A:
; 0000 018C 
; 0000 018D 		delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0xF
; 0000 018E 		for(i=0;i<54;i=i+3)		       //инициализация передатчика
	LDI  R17,LOW(0)
_0x4C:
	CPI  R17,54
	BRSH _0x4D
; 0000 018F 		{
; 0000 0190 			dt.b[1]=tbl_rfinit[i+1];
	RCALL SUBOPT_0x15
	__ADDW1FN _tbl_rfinit,1
	LPM  R0,Z
	STD  Y+2,R0
; 0000 0191 			dt.b[0]=tbl_rfinit[i+2];
	RCALL SUBOPT_0x15
	__ADDW1FN _tbl_rfinit,2
	LPM  R0,Z
	STD  Y+1,R0
; 0000 0192 			TR24_Wrtie(tbl_rfinit[i],dt.data);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1A
; 0000 0193 		}
	SUBI R17,-LOW(3)
	RJMP _0x4C
_0x4D:
; 0000 0194            Error='N';
	LDI  R30,LOW(78)
	MOV  R9,R30
; 0000 0195 		//Проверить правильность инициализации трансивера
; 0000 0196             #asm("wdr")
	wdr
; 0000 0197 		for(i=0;i<54;i=i+3)
	LDI  R17,LOW(0)
_0x4F:
	CPI  R17,54
	BRSH _0x50
; 0000 0198 		{
; 0000 0199 			dt.data=TR24A_Read(tbl_rfinit[i]);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
; 0000 019A 
; 0000 019B 			if(dt.b[1]!=tbl_rfinit[i+1])
	__ADDW1FN _tbl_rfinit,1
	LPM  R30,Z
	LDD  R26,Y+2
	CP   R30,R26
	BRNE _0xC5
; 0000 019C 			{
; 0000 019D 				Error='E';
; 0000 019E 			}
; 0000 019F 			else if(dt.b[0]!=tbl_rfinit[i+2])
	RCALL SUBOPT_0x15
	__ADDW1FN _tbl_rfinit,2
	LPM  R30,Z
	LDD  R26,Y+1
	CP   R30,R26
	BREQ _0x53
; 0000 01A0 			{
; 0000 01A1 				Error='E';
_0xC5:
	LDI  R30,LOW(69)
	MOV  R9,R30
; 0000 01A2 			}
; 0000 01A3 
; 0000 01A4 		}
_0x53:
	SUBI R17,-LOW(3)
	RJMP _0x4F
_0x50:
; 0000 01A5             #asm("wdr")
	wdr
; 0000 01A6 		for(i=0;i<30;i=i+3)
	LDI  R17,LOW(0)
_0x55:
	CPI  R17,30
	BRSH _0x56
; 0000 01A7 		{
; 0000 01A8 			dt.data=TR24A_Read(tbl_frame[i]);
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1C
; 0000 01A9 
; 0000 01AA 			if(dt.b[1]!=tbl_frame[i+1])
	__ADDW1FN _tbl_frame,1
	LPM  R30,Z
	LDD  R26,Y+2
	CP   R30,R26
	BRNE _0xC6
; 0000 01AB 			{
; 0000 01AC 				Error='E';
; 0000 01AD 			}
; 0000 01AE 			else if(dt.b[0]!=tbl_frame[i+2])
	RCALL SUBOPT_0x15
	__ADDW1FN _tbl_frame,2
	LPM  R30,Z
	LDD  R26,Y+1
	CP   R30,R26
	BREQ _0x59
; 0000 01AF 			{
; 0000 01B0 				Error='E';
_0xC6:
	LDI  R30,LOW(69)
	MOV  R9,R30
; 0000 01B1 			}
; 0000 01B2 		}
_0x59:
	SUBI R17,-LOW(3)
	RJMP _0x55
_0x56:
; 0000 01B3 
; 0000 01B4 	}//end init
	LDD  R17,Y+0
	RJMP _0x20C0001
;//*************************************************************************************************
;//Режим приема данных
;	void TR24A_RX(void)
; 0000 01B8 	{
_TR24A_RX:
; 0000 01B9 		DATA buf;
; 0000 01BA 
; 0000 01BB         #asm("wdr")
	SBIW R28,2
;	buf -> Y+0
	wdr
; 0000 01BC 		buf.data=TR24A_Read(0x07);
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
; 0000 01BD 		buf.byte[1]=(SW<<1);
; 0000 01BE 		buf.byte[0]=CH;
; 0000 01BF 		buf.Bit.b8=0;
	ANDI R30,0xFE
	STD  Y+1,R30
; 0000 01C0 		buf.Bit.b7=1;
	LD   R30,Y
	ORI  R30,0x80
	ST   Y,R30
; 0000 01C1 
; 0000 01C2 		TR24_Wrtie(0x07,buf.data);  // переход в режим RX, задаем канал
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1F
; 0000 01C3 		delay_us(10);
	__DELAY_USB 12
; 0000 01C4 
; 0000 01C5 	}//end ReciveMode
	RJMP _0x20C0004
;//*******************************************************************************************
;//перейти в режим передачи данніх
;	void TR24A_TX(void)
; 0000 01C9 	{
_TR24A_TX:
; 0000 01CA 		DATA buf;
; 0000 01CB         #asm("wdr")
	SBIW R28,2
;	buf -> Y+0
	wdr
; 0000 01CC 		buf.data=TR24A_Read(0x07);
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
; 0000 01CD 		buf.byte[1]=(SW<<1);
; 0000 01CE 		buf.byte[0]=CH;
; 0000 01CF 		buf.Bit.b8=1;
	ORI  R30,1
	STD  Y+1,R30
; 0000 01D0 		buf.Bit.b7=0;
	LD   R30,Y
	ANDI R30,0x7F
	ST   Y,R30
; 0000 01D1 
; 0000 01D2 		TR24_Wrtie(0x07,buf.data);
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1F
; 0000 01D3 
; 0000 01D4 	}//end TransmitMode
	RJMP _0x20C0004
;//*********************************************************************************************
;//Прием пакта
;  unsigned char TR24A_RXPKT(void)
; 0000 01D8   {
_TR24A_RXPKT:
; 0000 01D9    unsigned char len; //Длинна пакета
; 0000 01DA    unsigned char j;   //Счетчик
; 0000 01DB 
; 0000 01DC   PORTB.2=0;       // SPI_SS ON
	RCALL __SAVELOCR2
;	len -> R17
;	j -> R16
	CBI  0x18,2
; 0000 01DD    #asm("wdr")
	wdr
; 0000 01DE   SPI_SEND(0x50|(1<<7));   //reg80
	LDI  R30,LOW(208)
	RCALL SUBOPT_0x20
; 0000 01DF   delay_us(3);
; 0000 01E0   len=SPI_SEND(0xFF);
	RCALL SUBOPT_0x18
	MOV  R17,R30
; 0000 01E1   for(j=0;j<len;j++)  //получить пакет
	LDI  R16,LOW(0)
_0x5D:
	CP   R16,R17
	BRSH _0x5E
; 0000 01E2 		{
; 0000 01E3 			delay_us(3);
	RCALL SUBOPT_0x21
; 0000 01E4 			SPI_buffer[j] = SPI_SEND(0xFF);
	MOV  R30,R16
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x18
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01E5 		}
	SUBI R16,-1
	RJMP _0x5D
_0x5E:
; 0000 01E6  PORTB.2=1;     // SPI_SS OFF
	SBI  0x18,2
; 0000 01E7  return len;
	MOV  R30,R17
	RCALL __LOADLOCR2P
	RET
; 0000 01E8 
; 0000 01E9   }
;//******************************************************************************************
;   //Функция передачи пакета
; void TR24A_TXPKT(void)
; 0000 01ED  {
_TR24A_TXPKT:
; 0000 01EE 
; 0000 01EF     #asm("wdr")
	wdr
; 0000 01F0    TR24_Wrtie(0x52,0x8000);
	LDI  R30,LOW(82)
	ST   -Y,R30
	LDI  R30,LOW(32768)
	LDI  R31,HIGH(32768)
	RCALL SUBOPT_0x4
	RCALL _TR24_Wrtie
; 0000 01F1 
; 0000 01F2       PORTB.2=0;       // SPI_SS ON
	CBI  0x18,2
; 0000 01F3       delay_us(3);
	RCALL SUBOPT_0x21
; 0000 01F4       SPI_SEND(0x50);
	LDI  R30,LOW(80)
	RCALL SUBOPT_0x20
; 0000 01F5       delay_us(3);
; 0000 01F6       SPI_SEND(pktlen);
	ST   -Y,R4
	RCALL _SPI_SEND
; 0000 01F7       for (i=0;i<pktlen;i++)
	RCALL SUBOPT_0x5
_0x64:
	MOV  R30,R4
	MOVW R26,R6
	RCALL SUBOPT_0x0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x65
; 0000 01F8      {
; 0000 01F9        delay_us(3);
	RCALL SUBOPT_0x21
; 0000 01FA       SPI_SEND(SPI_buffer[i]);
	LDI  R26,LOW(_SPI_buffer)
	LDI  R27,HIGH(_SPI_buffer)
	RCALL SUBOPT_0x7
	LD   R30,X
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 01FB     };
	RCALL SUBOPT_0x8
	SBIW R30,1
	RJMP _0x64
_0x65:
; 0000 01FC 
; 0000 01FD       PORTB.2=1;       // SPI_SS OFF
	SBI  0x18,2
; 0000 01FE 
; 0000 01FF       delay_us(3);
	RCALL SUBOPT_0x21
; 0000 0200        TR24A_TX();
	RCALL _TR24A_TX
; 0000 0201  }
	RET
;//********************************************************************************************
;  // Запись строки в SPI буффер
; void Write_SPI_buffer(flash char *str)
; 0000 0205  {
_Write_SPI_buffer:
; 0000 0206   i=0;
;	*str -> Y+0
	RCALL SUBOPT_0x5
; 0000 0207   while(*str)
_0x68:
	RCALL SUBOPT_0x1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x6A
; 0000 0208   {
; 0000 0209   SPI_buffer[i++]=*str++;
	RCALL SUBOPT_0x8
	SBIW R30,1
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	MOVW R26,R30
	RCALL SUBOPT_0x2
	ST   X,R30
; 0000 020A 
; 0000 020B   }
	RJMP _0x68
_0x6A:
; 0000 020C   pktlen=i;
	MOV  R4,R6
; 0000 020D   }
_0x20C0004:
	ADIW R28,2
	RET
;//********************************************************************************************
; void USART_ON(void)   //Активация USART
; 0000 0210   {
_USART_ON:
; 0000 0211    PORTD.4=0;
	CBI  0x12,4
; 0000 0212    PORTD.5=0;
	CBI  0x12,5
; 0000 0213    while(PIND.6==1);
_0x6F:
	SBIC 0x10,6
	RJMP _0x6F
; 0000 0214   }
	RET
;//*******************************************************************************************
; void USART_OFF(void)   //Деактивация USART
; 0000 0217  {
_USART_OFF:
; 0000 0218  PORTD.4=1;
	SBI  0x12,4
; 0000 0219  PORTD.5=1;
	SBI  0x12,5
; 0000 021A  }
	RET
;//********************************************************************************************
;void RESET_MODEM(void)    // Сброс модема
; 0000 021D  {LightDiode(3);
_RESET_MODEM:
	RCALL SUBOPT_0x22
; 0000 021E   do {
_0x77:
; 0000 021F  //delay_ms(250);
; 0000 0220   if (PINC.1==0)
	SBIC 0x13,1
	RJMP _0x79
; 0000 0221   {
; 0000 0222   PORTC.0=0;       // Включение модема
	CBI  0x15,0
; 0000 0223   delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 0224   PORTC.0=1;
	SBI  0x15,0
; 0000 0225   delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP _0xC7
; 0000 0226    }
; 0000 0227 
; 0000 0228    else
_0x79:
; 0000 0229    {
; 0000 022A     PORTC.2=0;       // Включение модема
	CBI  0x15,2
; 0000 022B   delay_ms(100);
	RCALL SUBOPT_0x12
; 0000 022C   PORTC.2=1;
	SBI  0x15,2
; 0000 022D   delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
_0xC7:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 022E    }
; 0000 022F 
; 0000 0230     } while(PINC.1==0);   // Проверка включения модема
	SBIS 0x13,1
	RJMP _0x77
; 0000 0231        USART_ON();
	RCALL _USART_ON
; 0000 0232 
; 0000 0233     do{      SEND_Str("AT\r");  // Проверка ответа модема
_0x84:
	__POINTW1FN _0x0,114
	RCALL SUBOPT_0x23
; 0000 0234          #asm("wdr")
	wdr
; 0000 0235       } while(TEST_OK()==0)  ;
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0x84
; 0000 0236                  /*
; 0000 0237 
; 0000 0238     SEND_Str("AT+CREG?\r");
; 0000 0239          delay_ms(100);
; 0000 023A        SEND_Str("HER?\r");
; 0000 023B        delay_ms(1000);
; 0000 023C          for( i=0;i<64;i++) {eebuf[i]=rx_buffer[i];}
; 0000 023D           LightDiode(0);
; 0000 023E           while(1){  #asm("wdr") }
; 0000 023F                     */
; 0000 0240  do{   SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
_0x87:
	__POINTW1FN _0x0,118
	RCALL SUBOPT_0x23
; 0000 0241         #asm("wdr")
	wdr
; 0000 0242       delay_ms(1000);
	RCALL SUBOPT_0x10
; 0000 0243       #asm("wdr")
	wdr
; 0000 0244       }while (REG_NET()!='1') ;
	RCALL _REG_NET
	CPI  R30,LOW(0x31)
	BRNE _0x87
; 0000 0245 
; 0000 0246      // USART_OFF();
; 0000 0247 
; 0000 0248  }
	RET
;//********************************************************************************************
;void RESET_TR24A(void)   // Перезагрузка и инициализация трансивера
; 0000 024B {
_RESET_TR24A:
; 0000 024C  LightDiode(3);
	RCALL SUBOPT_0x22
; 0000 024D  do { TR24A_INIT();  // Инициализация трансивера
_0x8A:
	RCALL _TR24A_INIT
; 0000 024E  #asm("wdr")
	wdr
; 0000 024F     }while(Error=='E') ;   // Если инициализация ошибочна возврат к сбросу
	LDI  R30,LOW(69)
	CP   R30,R9
	BREQ _0x8A
; 0000 0250 }
	RET
;
;//============================================================================================
;// Прерывание по приему пакета
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0256 {
_ext_int1_isr:
	RCALL SUBOPT_0x24
; 0000 0257      GICR=0x00; //Запрет внешних прерываний
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 0258 
; 0000 0259  pktlen=TR24A_RXPKT();
	RCALL _TR24A_RXPKT
	MOV  R4,R30
; 0000 025A 
; 0000 025B if (pktlen!=0)
	TST  R4
	BREQ _0x8C
; 0000 025C   {
; 0000 025D 
; 0000 025E         #asm("wdr")
	wdr
; 0000 025F  if (strstr(SPI_buffer,"BRELOK")!=NULL) {Write_SPI_buffer("DEVICE");}
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	RCALL SUBOPT_0x4
	__POINTW1MN _0x8E,0
	RCALL SUBOPT_0xC
	SBIW R30,0
	BREQ _0x8D
	__POINTW1FN _0x0,135
	RJMP _0xC8
; 0000 0260  else {
_0x8D:
; 0000 0261    if (strstr(SPI_buffer,"CHANGE")!=NULL)
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	RCALL SUBOPT_0x4
	__POINTW1MN _0x8E,7
	RCALL SUBOPT_0xC
	SBIW R30,0
	BREQ _0x90
; 0000 0262    {
; 0000 0263     if(z==0) {z=1;}
	TST  R5
	BRNE _0x91
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0264     else {z=0;}
	RJMP _0x92
_0x91:
	CLR  R5
_0x92:
; 0000 0265    }
; 0000 0266 
; 0000 0267    if(z==0)
_0x90:
	TST  R5
	BRNE _0x93
; 0000 0268    {
; 0000 0269     Write_SPI_buffer("Status-IDLE");
	__POINTW1FN _0x0,149
	RJMP _0xC8
; 0000 026A    }
; 0000 026B 
; 0000 026C   else
_0x93:
; 0000 026D    {
; 0000 026E     Write_SPI_buffer("Status-SECUR");
	__POINTW1FN _0x0,161
_0xC8:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write_SPI_buffer
; 0000 026F    }
; 0000 0270    }
; 0000 0271    // delay_ms(30);
; 0000 0272     TR24A_TXPKT();
	RCALL _TR24A_TXPKT
; 0000 0273     while(PIND.3==0);
_0x95:
	SBIS 0x10,3
	RJMP _0x95
; 0000 0274 
; 0000 0275 
; 0000 0276 }
; 0000 0277 
; 0000 0278   GIFR=0x80;    //Сброс флага прерывания
_0x8C:
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0279   GICR=0x80;   // Разрешение прерывания
	OUT  0x3B,R30
; 0000 027A 
; 0000 027B  TR24A_RX();              // Преход в режим RX
	RCALL _TR24A_RX
; 0000 027C }
	RJMP _0xCC

	.DSEG
_0x8E:
	.BYTE 0xE
;//*******************************************************************************************
;
;// Функция обработки прерывания по приему символа USART
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0281 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0282 char status,data;
; 0000 0283 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0284 data=UDR;
	IN   R16,12
; 0000 0285 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x98
; 0000 0286    {
; 0000 0287    if (rx_wr_index != RX_BUFFER_SIZE) rx_buffer[rx_wr_index++]=data;
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0x99
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0288 
; 0000 0289       }
_0x99:
; 0000 028A    }
_0x98:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
; //*****************************************************************************************
; // Прерывание по таймеру производит тест системы
;
; // Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0291 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x24
; 0000 0292 union U
; 0000 0293 		{
; 0000 0294 			unsigned int buf;
; 0000 0295 			unsigned char b[2];
; 0000 0296 		};
; 0000 0297            union U stat;
; 0000 0298 TIMSK=0x00;
	SBIW R28,2
;	U -> Y+2
;	stat -> Y+0
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0299 #asm("sei")
	sei
; 0000 029A //LightDiode(0);
; 0000 029B  USART_ON() ; //  Активация USART
	RCALL _USART_ON
; 0000 029C 
; 0000 029D 
; 0000 029E  SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
	__POINTW1FN _0x0,118
	RCALL SUBOPT_0x23
; 0000 029F 
; 0000 02A0  if (REG_NET()!='1')
	RCALL _REG_NET
	CPI  R30,LOW(0x31)
	BREQ _0x9A
; 0000 02A1    {
; 0000 02A2    TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 02A3    #asm("wdr")
	wdr
; 0000 02A4     RESET_MODEM();
	RCALL _RESET_MODEM
; 0000 02A5    #asm("wdr")
	wdr
; 0000 02A6    }
; 0000 02A7    delay_ms(30);
_0x9A:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0xF
; 0000 02A8    if(COUNT>=10)
	LDI  R26,LOW(_COUNT)
	LDI  R27,HIGH(_COUNT)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0xA)
	BRLO _0x9B
; 0000 02A9            {BALLANSE();
	RCALL _BALLANSE
; 0000 02AA             COUNT=0;}
	LDI  R26,LOW(_COUNT)
	LDI  R27,HIGH(_COUNT)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 02AB   USART_OFF() ; //  Дективация USART
_0x9B:
	RCALL _USART_OFF
; 0000 02AC 
; 0000 02AD  stat.buf=TR24A_Read(0x40);
	LDI  R30,LOW(64)
	ST   -Y,R30
	RCALL _TR24A_Read
	RCALL SUBOPT_0x16
; 0000 02AE  if(stat.b[1]!=0xD0)
	LDD  R26,Y+1
	CPI  R26,LOW(0xD0)
	BREQ _0x9C
; 0000 02AF  {
; 0000 02B0   TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 02B1   RESET_TR24A();
	RCALL _RESET_TR24A
; 0000 02B2   TR24A_RX();              // Преход в режим RX
	RCALL _TR24A_RX
; 0000 02B3  }
; 0000 02B4 
; 0000 02B5  TIMSK=0x04;
_0x9C:
	RCALL SUBOPT_0x25
; 0000 02B6  TCCR1B=0x05;
; 0000 02B7 }
	ADIW R28,2
_0xCC:
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
	RETI
;//=============================================================================================
;//*****************************ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ*************************************
;//===============================================================================================
;
;void main(void)
; 0000 02BD {
_main:
; 0000 02BE // Declare your local variables here
; 0000 02BF 
; 0000 02C0 // Input/Output Ports initialization
; 0000 02C1 // Port B initialization
; 0000 02C2 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=Out
; 0000 02C3 // State7=T State6=T State5=0 State4=T State3=0 State2=1 State1=T State0=1
; 0000 02C4 PORTB=0x05;
	LDI  R30,LOW(5)
	OUT  0x18,R30
; 0000 02C5 DDRB=0x2D;
	LDI  R30,LOW(45)
	OUT  0x17,R30
; 0000 02C6 
; 0000 02C7 // Port C initialization
; 0000 02C8 // Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=Out
; 0000 02C9 // State6=T State5=0 State4=0 State3=T State2=1 State1=T State0=1
; 0000 02CA PORTC=0x05;
	LDI  R30,LOW(5)
	OUT  0x15,R30
; 0000 02CB DDRC=0x35;
	LDI  R30,LOW(53)
	OUT  0x14,R30
; 0000 02CC 
; 0000 02CD // Port D initialization
; 0000 02CE // Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 02CF // State7=T State6=T State5=1 State4=1 State3=T State2=P State1=T State0=T
; 0000 02D0 PORTD=0x34;
	LDI  R30,LOW(52)
	OUT  0x12,R30
; 0000 02D1 DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 02D2 
; 0000 02D3 // Timer/Counter 0 initialization
; 0000 02D4 // Clock source: System Clock
; 0000 02D5 // Clock value: Timer 0 Stopped
; 0000 02D6 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 02D7 TCNT0=0x00;
	OUT  0x32,R30
; 0000 02D8 
; 0000 02D9 // Timer/Counter 1 initialization
; 0000 02DA // Clock source: System Clock
; 0000 02DB // Clock value: 3,600 kHz
; 0000 02DC // Mode: Normal top=0xFFFF
; 0000 02DD // OC1A output: Discon.
; 0000 02DE // OC1B output: Discon.
; 0000 02DF // Noise Canceler: Off
; 0000 02E0 // Input Capture on Falling Edge
; 0000 02E1 // Timer1 Overflow Interrupt: On
; 0000 02E2 // Input Capture Interrupt: Off
; 0000 02E3 // Compare A Match Interrupt: Off
; 0000 02E4 // Compare B Match Interrupt: Off
; 0000 02E5 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 02E6 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 02E7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 02E8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 02E9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 02EA ICR1L=0x00;
	OUT  0x26,R30
; 0000 02EB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 02EC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 02ED OCR1BH=0x00;
	OUT  0x29,R30
; 0000 02EE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 02EF 
; 0000 02F0 // Timer/Counter 2 initialization
; 0000 02F1 // Clock source: System Clock
; 0000 02F2 // Clock value: Timer2 Stopped
; 0000 02F3 // Mode: Normal top=0xFF
; 0000 02F4 // OC2 output: Disconnected
; 0000 02F5 ASSR=0x00;
	OUT  0x22,R30
; 0000 02F6 TCCR2=0x00;
	OUT  0x25,R30
; 0000 02F7 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02F8 OCR2=0x00;
	OUT  0x23,R30
; 0000 02F9 
; 0000 02FA // External Interrupt(s) initialization
; 0000 02FB // INT0: Off
; 0000 02FC // INT1: On
; 0000 02FD // INT1 Mode: Rising Edge
; 0000 02FE GICR|=0x80;
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 02FF MCUCR=0x0C;
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0000 0300 GIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0301 
; 0000 0302 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0303 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0304 
; 0000 0305 // USART initialization
; 0000 0306 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0307 // USART Receiver: On
; 0000 0308 // USART Transmitter: On
; 0000 0309 // USART Mode: Asynchronous
; 0000 030A // USART Baud Rate: 115200
; 0000 030B UCSRA=0x00;
	OUT  0xB,R30
; 0000 030C UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 030D UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 030E UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 030F UBRRL=0x01;
	LDI  R30,LOW(1)
	OUT  0x9,R30
; 0000 0310 
; 0000 0311 // Analog Comparator initialization
; 0000 0312 // Analog Comparator: Off
; 0000 0313 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0314 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0315 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0316 
; 0000 0317 // ADC initialization
; 0000 0318 // ADC disabled
; 0000 0319 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 031A 
; 0000 031B // SPI initialization
; 0000 031C // SPI Type: Master
; 0000 031D // SPI Clock Rate: 28,800 kHz
; 0000 031E // SPI Clock Phase: Cycle Half
; 0000 031F // SPI Clock Polarity: Low
; 0000 0320 // SPI Data Order: MSB First
; 0000 0321 SPCR=0x57;
	LDI  R30,LOW(87)
	OUT  0xD,R30
; 0000 0322 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0323 
; 0000 0324 // TWI initialization
; 0000 0325 // TWI disabled
; 0000 0326 TWCR=0x00;
	OUT  0x36,R30
; 0000 0327 // Watchdog Timer initialization
; 0000 0328 // Watchdog Timer Prescaler: OSC/2048k
; 0000 0329 #pragma optsize-
; 0000 032A WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0000 032B WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0000 032C #ifdef _OPTIMIZE_SIZE_
; 0000 032D #pragma optsize+
; 0000 032E #endif
; 0000 032F 
; 0000 0330  // Global enable interrupts
; 0000 0331 #asm("sei")
	sei
; 0000 0332 #asm("wdr")
	wdr
; 0000 0333 LightDiode(3);    //Зажечь светодиод
	RCALL SUBOPT_0x22
; 0000 0334 /************** ******************* АКТИВАЦИЯ МОДЕМА*****************************************/
; 0000 0335 
; 0000 0336  RESET_MODEM();
	RCALL _RESET_MODEM
; 0000 0337 
; 0000 0338  #asm("wdr")
	wdr
; 0000 0339   USART_ON() ; //  Активация USART
	RCALL _USART_ON
; 0000 033A 
; 0000 033B  do{     SEND_Str("AT+CPBF=\"N\"\r");  // Считывание телефонного номера с SIM карты
_0x9E:
	__POINTW1FN _0x0,174
	RCALL SUBOPT_0x23
; 0000 033C        #asm("wdr")
	wdr
; 0000 033D       } while(SET_NR()==0);      // Преобразование номера в PDU формат
	RCALL _SET_NR
	CPI  R30,0
	BREQ _0x9E
; 0000 033E 
; 0000 033F   do{ SEND_Str("AT+COPS?\r");
_0xA1:
	__POINTW1FN _0x0,187
	RCALL SUBOPT_0x23
; 0000 0340   delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0xF
; 0000 0341     #asm("wdr")
	wdr
; 0000 0342   }while(strstr(rx_buffer, "+COPS:")==NULL);
	RCALL SUBOPT_0xB
	__POINTW1MN _0xA3,0
	RCALL SUBOPT_0xC
	SBIW R30,0
	BREQ _0xA1
; 0000 0343  if( strstr(rx_buffer, "Beeline")!=NULL ) OP=1;
	RCALL SUBOPT_0xB
	__POINTW1MN _0xA3,7
	RCALL SUBOPT_0xC
	SBIW R30,0
	BREQ _0xA4
	LDI  R26,LOW(_OP)
	LDI  R27,HIGH(_OP)
	LDI  R30,LOW(1)
	RJMP _0xC9
; 0000 0344   else OP=0;
_0xA4:
	LDI  R26,LOW(_OP)
	LDI  R27,HIGH(_OP)
	LDI  R30,LOW(0)
_0xC9:
	RCALL __EEPROMWRB
; 0000 0345    CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0346   USART_OFF() ;  //  Дективация USART
	RCALL _USART_OFF
; 0000 0347   #asm("wdr")
	wdr
; 0000 0348 //==========================================================================================
; 0000 0349 //*************************АКТИВАЦИЯ ТРАНСИВЕРА**********************************************
; 0000 034A   RESET_TR24A();
	RCALL _RESET_TR24A
; 0000 034B   TR24A_RX();              // Преход в режим RX
	RCALL _TR24A_RX
; 0000 034C 
; 0000 034D 
; 0000 034E //============================================================================================
; 0000 034F  TIMSK=0x04;
	RCALL SUBOPT_0x25
; 0000 0350  TCCR1B=0x05;
; 0000 0351  z=1; // Включение режима охраны
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0352 
; 0000 0353 
; 0000 0354 while (1)
_0xA6:
; 0000 0355       {
; 0000 0356 
; 0000 0357 mx:      while((PIND.2==1)||(z==0))  // Цикл пока дверь открыта
_0xA9:
_0xAA:
	SBIC 0x10,2
	RJMP _0xAD
	LDI  R30,LOW(0)
	CP   R30,R5
	BRNE _0xAC
_0xAD:
; 0000 0358        { #asm("wdr")
	wdr
; 0000 0359        if (z==0){LightDiode(0);}
	TST  R5
	BRNE _0xAF
	LDI  R30,LOW(0)
	RJMP _0xCA
; 0000 035A        else {LightDiode(2);}
_0xAF:
	LDI  R30,LOW(2)
_0xCA:
	ST   -Y,R30
	RCALL _LightDiode
; 0000 035B        }
	RJMP _0xAA
_0xAC:
; 0000 035C        delay_ms(100);
	RCALL SUBOPT_0x12
; 0000 035D 
; 0000 035E        if(PIND.2==1) goto mx;
	SBIC 0x10,2
	RJMP _0xA9
; 0000 035F my:       while((PIND.2==0) || (z==0) )           // Цикл пока дверь закрыта
_0xB2:
_0xB3:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xB6
	LDI  R30,LOW(0)
	CP   R30,R5
	BRNE _0xB5
_0xB6:
; 0000 0360        {   #asm("wdr")
	wdr
; 0000 0361        if (z==0){LightDiode(0);}
	TST  R5
	BRNE _0xB8
	LDI  R30,LOW(0)
	RJMP _0xCB
; 0000 0362        else {LightDiode(1);}
_0xB8:
	LDI  R30,LOW(1)
_0xCB:
	ST   -Y,R30
	RCALL _LightDiode
; 0000 0363        }
	RJMP _0xB3
_0xB5:
; 0000 0364        delay_ms(100);
	RCALL SUBOPT_0x12
; 0000 0365 
; 0000 0366        if(PIND.2==0) goto my;
	SBIS 0x10,2
	RJMP _0xB2
; 0000 0367        USART_ON() ;
	RCALL _USART_ON
; 0000 0368          TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0369          TCNT1L=0x01;
	LDI  R30,LOW(1)
	OUT  0x2C,R30
; 0000 036A        // TIMSK=0x00;
; 0000 036B        // TCCR1B=0x00;
; 0000 036C m4:    SEND_Str("AT+CMGF=0\r");     // Установка PDU режима
_0xBB:
	__POINTW1FN _0x0,212
	RCALL SUBOPT_0x23
; 0000 036D         #asm("wdr")
	wdr
; 0000 036E        if (TEST_OK()==0) goto m4 ;
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0xBB
; 0000 036F 
; 0000 0370 
; 0000 0371 
; 0000 0372 
; 0000 0373 m5:   SEND_Str("AT+CMGS=39\r");  //    Ввод команды отправки сообщения
_0xBD:
	__POINTW1FN _0x0,223
	RCALL SUBOPT_0x23
; 0000 0374         #asm("wdr")
	wdr
; 0000 0375       if (strrchr(rx_buffer, '>')==NULL)
	RCALL SUBOPT_0xB
	LDI  R30,LOW(62)
	ST   -Y,R30
	RCALL _strrchr
	SBIW R30,0
	BRNE _0xBE
; 0000 0376       {CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0377       goto m5;}
	RJMP _0xBD
; 0000 0378       CLEAR_BUF();
_0xBE:
	RCALL _CLEAR_BUF
; 0000 0379 
; 0000 037A       SEND_Str("0001000B91");     // Ввод настроек PDU
	RCALL SUBOPT_0x13
; 0000 037B 
; 0000 037C       for(i=0;i<12;i++)            // Ввод номера
_0xC0:
	RCALL SUBOPT_0xD
	BRSH _0xC1
; 0000 037D       {UART_Transmit(NR[i]);}
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	RJMP _0xC0
_0xC1:
; 0000 037E 
; 0000 037F        SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // Ввод текста сообщения
	__POINTW1FN _0x0,235
	RCALL SUBOPT_0x23
; 0000 0380 
; 0000 0381        /* if(COUNT==10)
; 0000 0382            {BALLANSE();
; 0000 0383             COUNT=0;}*/
; 0000 0384          COUNT++;
	LDI  R26,LOW(_COUNT)
	LDI  R27,HIGH(_COUNT)
	RCALL __EEPROMRDB
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 0385                #asm("wdr")
	wdr
; 0000 0386               CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0387              USART_OFF() ;  //  Дективация USART
	RCALL _USART_OFF
; 0000 0388              #asm("wdr")
	wdr
; 0000 0389               TCNT1H=0x01;
	LDI  R30,LOW(1)
	OUT  0x2D,R30
; 0000 038A               TCNT1L=0x4F;
	LDI  R30,LOW(79)
	OUT  0x2C,R30
; 0000 038B               TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 038C               TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 038D       }
	RJMP _0xA6
; 0000 038E 
; 0000 038F }
_0xC2:
	RJMP _0xC2

	.DSEG
_0xA3:
	.BYTE 0xF

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
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
_0x20C0003:
	ADIW R28,4
	RET

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20C0002:
	ADIW R28,1
	RET
_put_usart_G102:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20C0001:
	ADIW R28,3
	RET
__print_G102:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0x26
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	RCALL SUBOPT_0x26
	RJMP _0x20400C9
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	RCALL SUBOPT_0x27
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x27
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x29
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2B
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RCALL SUBOPT_0x2C
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	RCALL SUBOPT_0x2C
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2D
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	RCALL SUBOPT_0x2A
	RCALL SUBOPT_0x2D
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	RCALL SUBOPT_0x26
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x2C
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	RCALL SUBOPT_0x26
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x2C
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CA
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x29
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	RCALL SUBOPT_0x26
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x29
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400C9:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x4
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x4
	RCALL __print_G102
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_SPI_buffer:
	.BYTE 0x40

	.ESEG
_OP:
	.BYTE 0x1
_NR:
	.BYTE 0xC
_COUNT:
	.BYTE 0x1

	.DSEG
_rx_buffer:
	.BYTE 0x200
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	RCALL SUBOPT_0x1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _UART_Transmit

;OPTIMIZER ADDED SUBROUTINE, CALLED 66 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	CLR  R6
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	ADD  R26,R6
	ADC  R27,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	RCALL __SAVELOCR4
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	RCALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x4
	RCALL _strstr
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	RCALL __LOADLOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x4
	RJMP _strstr

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	SBIW R30,1
	SUBI R30,LOW(-_NR)
	SBCI R31,HIGH(-_NR)
	MOVW R0,R30
	MOVW R26,R18
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0x4
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0x4
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	__POINTW1FN _0x0,94
	RCALL SUBOPT_0x4
	RCALL _SEND_Str
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_NR)
	LDI  R27,HIGH(_NR)
	RCALL SUBOPT_0x7
	RCALL __EEPROMRDB
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x15:
	MOV  R30,R17
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	RCALL _SPI_SEND
	__DELAY_USB 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(255)
	ST   -Y,R30
	RJMP _SPI_SEND

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	SUBI R30,LOW(-_tbl_frame*2)
	SBCI R31,HIGH(-_tbl_frame*2)
	LPM  R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x4
	RJMP _TR24_Wrtie

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	SUBI R30,LOW(-_tbl_rfinit*2)
	SBCI R31,HIGH(-_tbl_rfinit*2)
	LPM  R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL _TR24A_Read
	STD  Y+1,R30
	STD  Y+1+1,R31
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	RCALL _TR24A_Read
	RCALL SUBOPT_0x16
	LDI  R30,LOW(18)
	STD  Y+1,R30
	LDI  R30,LOW(78)
	ST   Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x4
	RJMP _TR24_Wrtie

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	ST   -Y,R30
	RCALL _SPI_SEND
	__DELAY_USB 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	__DELAY_USB 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(3)
	ST   -Y,R30
	RJMP _LightDiode

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x4
	RJMP _SEND_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x24:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(4)
	OUT  0x39,R30
	LDI  R30,LOW(5)
	OUT  0x2E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x26:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x4
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x29:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x4
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	RCALL SUBOPT_0x27
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x39A
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
