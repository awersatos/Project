
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
;global 'const' stored in FLASH: No
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
	.DEF _rx_wr_index=R4
	.DEF _z=R7
	.DEF _i=R8
	.DEF _x=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
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

_0x0:
	.DB  0x41,0x54,0xD,0x0,0x41,0x54,0x2B,0x43
	.DB  0x52,0x45,0x47,0x3F,0xD,0x0,0x2C,0x22
	.DB  0x2B,0x37,0x0,0x41,0x54,0x2B,0x43,0x55
	.DB  0x53,0x44,0x3D,0x31,0x2C,0x22,0x2A,0x31
	.DB  0x30,0x30,0x23,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x55,0x53,0x44,0x3D,0x31,0x2C
	.DB  0x22,0x2A,0x31,0x30,0x32,0x23,0x22,0xD
	.DB  0x0,0x2B,0x43,0x55,0x53,0x44,0x3A,0x0
	.DB  0x30,0x34,0x31,0x31,0x30,0x34,0x33,0x30
	.DB  0x30,0x34,0x33,0x42,0x30,0x34,0x33,0x30
	.DB  0x30,0x34,0x33,0x44,0x30,0x34,0x34,0x31
	.DB  0x0,0x30,0x34,0x34,0x30,0x0,0x41,0x54
	.DB  0x2B,0x43,0x4D,0x47,0x53,0x3D,0x25,0x30
	.DB  0x32,0x64,0xD,0x0,0x30,0x30,0x30,0x31
	.DB  0x30,0x30,0x30,0x42,0x39,0x31,0x0,0x30
	.DB  0x30,0x30,0x38,0x25,0x30,0x32,0x58,0x0
	.DB  0x41,0x54,0x2B,0x43,0x50,0x42,0x46,0x3D
	.DB  0x22,0x4E,0x31,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x46,0x3D,0x22,0x4E
	.DB  0x32,0x22,0xD,0x0,0x41,0x54,0x2B,0x43
	.DB  0x50,0x42,0x46,0x3D,0x22,0x4E,0x33,0x22
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x50,0x42
	.DB  0x46,0x3D,0x22,0x4E,0x34,0x22,0xD,0x0
	.DB  0x41,0x54,0x2B,0x43,0x50,0x42,0x46,0x3D
	.DB  0x22,0x4E,0x35,0x22,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x50,0x42,0x46,0x3D,0x22,0x4E
	.DB  0x36,0x22,0xD,0x0,0x41,0x54,0x2B,0x43
	.DB  0x53,0x54,0x41,0x3D,0x31,0x34,0x35,0xD
	.DB  0x0,0x41,0x54,0x2A,0x50,0x53,0x53,0x54
	.DB  0x4B,0x49,0x3D,0x31,0xD,0x0,0x41,0x54
	.DB  0x44,0x22,0x0,0x22,0x3B,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x46,0x3D,0x30
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x4D,0x47
	.DB  0x53,0x3D,0x33,0x39,0xD,0x0,0x30,0x30
	.DB  0x30,0x38,0x31,0x41,0x30,0x34,0x31,0x34
	.DB  0x30,0x34,0x33,0x32,0x30,0x34,0x33,0x35
	.DB  0x30,0x34,0x34,0x30,0x30,0x34,0x34,0x43
	.DB  0x30,0x30,0x32,0x30,0x30,0x34,0x33,0x45
	.DB  0x30,0x34,0x34,0x32,0x30,0x34,0x33,0x41
	.DB  0x30,0x34,0x34,0x30,0x30,0x34,0x34,0x42
	.DB  0x30,0x34,0x34,0x32,0x30,0x34,0x33,0x30
	.DB  0x1A,0x0,0x42,0x52,0x45,0x4C,0x4F,0x4B
	.DB  0x31,0x0,0x43,0x48,0x41,0x4E,0x47,0x45
	.DB  0x0,0x53,0x45,0x43,0x55,0x52,0x0,0x49
	.DB  0x44,0x4C,0x45,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4F,0x50,0x53,0x3F,0xD,0x0,0x2B,0x43
	.DB  0x4F,0x50,0x53,0x3A,0x0,0x42,0x65,0x65
	.DB  0x6C,0x69,0x6E,0x65,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4C,0x49,0x50,0x3D,0x31,0xD,0x0
	.DB  0x52,0x49,0x4E,0x47,0x0,0x41,0x54,0x48
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x50,0x42
	.DB  0x57,0x3D,0x31,0x2C,0x22,0x0,0x22,0x2C
	.DB  0x31,0x34,0x35,0x2C,0x22,0x4E,0x31,0x22
	.DB  0xD,0x0,0x41,0x54,0x2B,0x43,0x50,0x42
	.DB  0x53,0x3F,0xD,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x36
	.DW  _0x0*2+14

	.DW  0x07
	.DW  _0x44
	.DW  _0x0*2+57

	.DW  0x19
	.DW  _0x44+7
	.DW  _0x0*2+64

	.DW  0x05
	.DW  _0x44+32
	.DW  _0x0*2+89

	.DW  0x05
	.DW  _0x55
	.DW  _0x0*2+14

	.DW  0x08
	.DW  _0xD6
	.DW  _0x0*2+330

	.DW  0x07
	.DW  _0xD6+8
	.DW  _0x0*2+338

	.DW  0x07
	.DW  _0xE4
	.DW  _0x0*2+366

	.DW  0x08
	.DW  _0xE4+7
	.DW  _0x0*2+373

	.DW  0x05
	.DW  _0xE4+15
	.DW  _0x0*2+392

	.DW  0x04
	.DW  _0xE4+20
	.DW  _0x0*2+15

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
;Project : DS(NEW)
;Version :
;Date    : 01.01.2002
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
;
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
; char NR[12];     // Массив телефонного номер
;// This flag is set on USART Receiver buffer overflow
;//bit rx_buffer_overflow;
;
;     // Определение глобальных переменных
;char z;          //Переменная статуса охраны
;
;unsigned int i; //Счетчик
;
;unsigned char SPI_buffer[64];
;unsigned char *x;
;
;eeprom unsigned char OP;
;
;
;eeprom unsigned char COUNT;
;eeprom unsigned char STAT[256];
;//*******************************************************************************************
;//+++++++++++++++ФУНКЦИИ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;//********************************************************************************************
;void LightDiode(unsigned char n) // Функция управления светодиодом
; 0000 009E {

	.CSEG
_LightDiode:
; 0000 009F  switch (n)
;	n -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x0
; 0000 00A0  {
; 0000 00A1  case 'T':
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x6
; 0000 00A2 			{
; 0000 00A3 			PORTC.4=0;
	CBI  0x15,4
; 0000 00A4             PORTC.5=0;
	CBI  0x15,5
; 0000 00A5 				break;
	RJMP _0x5
; 0000 00A6 			}
; 0000 00A7  case 'R':
_0x6:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0xB
; 0000 00A8 			{
; 0000 00A9 			PORTC.4=1;
	SBI  0x15,4
; 0000 00AA             PORTC.5=0;
	CBI  0x15,5
; 0000 00AB 				break;
	RJMP _0x5
; 0000 00AC 			}
; 0000 00AD  case 'G':
_0xB:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0x10
; 0000 00AE 			{
; 0000 00AF 			PORTC.4=0;
	CBI  0x15,4
; 0000 00B0             PORTC.5=1;
	RJMP _0x101
; 0000 00B1 				break;
; 0000 00B2            }
; 0000 00B3  case 'O':
_0x10:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x5
; 0000 00B4 			{
; 0000 00B5 			PORTC.4=1;
	SBI  0x15,4
; 0000 00B6             PORTC.5=1;
_0x101:
	SBI  0x15,5
; 0000 00B7 				break;
; 0000 00B8 			}
; 0000 00B9  }
_0x5:
; 0000 00BA 
; 0000 00BB }
	RJMP _0x20C0003
;//==================ФУНКЦИИ ДЛЯ РАБОТЫ С МОДЕМОМ============================================
;//******************************************************************************************
;void UART_Transmit(char data) // Функция передачи символа через UART
; 0000 00BF {
_UART_Transmit:
; 0000 00C0 while (!(UCSRA & (1<<UDRE))) {};
;	data -> Y+0
_0x1A:
	SBIS 0xB,5
	RJMP _0x1A
; 0000 00C1 UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00C2 }
	RJMP _0x20C0003
;
;
;//**********************************************************************************************************
;       void SEND_Str(flash char *str) {        // Функция передачи строки  из флеш памяти
; 0000 00C6 void SEND_Str(flash char *str) {
_SEND_Str:
; 0000 00C7         while(*str) {
;	*str -> Y+0
_0x1D:
	RCALL SUBOPT_0x1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x1F
; 0000 00C8        UART_Transmit(*str++);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00C9 
; 0000 00CA     };
	RJMP _0x1D
_0x1F:
; 0000 00CB     delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x4
	RCALL _delay_ms
; 0000 00CC }
	RJMP _0x20C0002
;//**********************************************************************************************************
;void CLEAR_BUF(void)   // Функция очистки буффера приема
; 0000 00CF {
_CLEAR_BUF:
; 0000 00D0 
; 0000 00D1 for (i=0;i<RX_BUFFER_SIZE;i++) {
	RCALL SUBOPT_0x5
_0x21:
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	RCALL SUBOPT_0x6
	BRSH _0x22
; 0000 00D2       rx_buffer[i]=0;
	RCALL SUBOPT_0x7
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00D3     };
	RCALL SUBOPT_0x8
	RJMP _0x21
_0x22:
; 0000 00D4    rx_wr_index=0;
	CLR  R4
	CLR  R5
; 0000 00D5   // #asm("wdr")
; 0000 00D6 
; 0000 00D7 }
	RET
;//**********************************************************************************************************
;  char TEST_OK(void)     // Функция проверки ответа ОК на команду
; 0000 00DA   {
_TEST_OK:
; 0000 00DB   char c;
; 0000 00DC   char *d;
; 0000 00DD   char OK[]="OK";
; 0000 00DE   d=strstr(rx_buffer, OK);
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
; 0000 00DF   c=*d;
	RCALL SUBOPT_0xA
; 0000 00E0  // #asm("wdr")
; 0000 00E1  CLEAR_BUF();
; 0000 00E2    return c;
	ADIW R28,7
	RET
; 0000 00E3 
; 0000 00E4   }
;
;//**********************************************************************************************************
;  char REG_NET(void)   // Функция проверки регистрации в сети
; 0000 00E8   {
_REG_NET:
; 0000 00E9   char c;
; 0000 00EA   char *d;
; 0000 00EB   char REG[]="+CREG:";
; 0000 00EC   d=strstr(rx_buffer, REG);
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
; 0000 00ED   d=d+9;
	__ADDWRN 18,19,9
; 0000 00EE   c=*d;
	RCALL SUBOPT_0xA
; 0000 00EF  // #asm("wdr")
; 0000 00F0   CLEAR_BUF();
; 0000 00F1   return c;
	ADIW R28,11
	RET
; 0000 00F2   }
;//********************************************************************************************
;void RESET_MODEM(void)    // Сброс модема
; 0000 00F5  {//LightDiode('O');
_RESET_MODEM:
; 0000 00F6   do {
_0x24:
; 0000 00F7 
; 0000 00F8   if (PINC.1==0)
	SBIC 0x13,1
	RJMP _0x26
; 0000 00F9   {
; 0000 00FA   PORTC.0=0;       // Включение модема
	CBI  0x15,0
; 0000 00FB   delay_ms(1000);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 00FC   PORTC.0=1;
	SBI  0x15,0
; 0000 00FD   delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP _0x102
; 0000 00FE    }
; 0000 00FF 
; 0000 0100    else
_0x26:
; 0000 0101    {
; 0000 0102     PORTC.2=0;       // Сброс модема
	CBI  0x15,2
; 0000 0103   delay_ms(100);
	RCALL SUBOPT_0xD
; 0000 0104   PORTC.2=1;
	SBI  0x15,2
; 0000 0105   delay_ms(1000);
	RCALL SUBOPT_0xB
_0x102:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0106    }
; 0000 0107 
; 0000 0108     } while(PINC.1==0);   // Проверка включения модема
	SBIS 0x13,1
	RJMP _0x24
; 0000 0109 
; 0000 010A 
; 0000 010B     do{      SEND_Str("AT\r");  // Проверка ответа модема
_0x31:
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0xE
; 0000 010C         // #asm("wdr")
; 0000 010D       } while(TEST_OK()==NULL)  ;
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0x31
; 0000 010E 
; 0000 010F  do{   SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
_0x34:
	__POINTW1FN _0x0,4
	RCALL SUBOPT_0xE
; 0000 0110        // #asm("wdr")
; 0000 0111       delay_ms(1000);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 0112      // #asm("wdr")
; 0000 0113       }while (REG_NET()!='1') ;
	RCALL _REG_NET
	CPI  R30,LOW(0x31)
	BRNE _0x34
; 0000 0114 
; 0000 0115 
; 0000 0116 
; 0000 0117  }
	RET
;
;
;//**********************************************************************************************************
;char SET_NR(void) // Функция считывания телефонного номера с SIM карты
; 0000 011C {
_SET_NR:
; 0000 011D char c;
; 0000 011E char *d;
; 0000 011F 
; 0000 0120 d=strstr(rx_buffer, ",\"+7");
	RCALL __SAVELOCR4
;	c -> R17
;	*d -> R18,R19
	RCALL SUBOPT_0xF
	__POINTW1MN _0x36,0
	RCALL SUBOPT_0x10
	MOVW R18,R30
; 0000 0121 if (d==NULL){c=0;
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x37
	LDI  R17,LOW(0)
; 0000 0122           return c;}
	MOV  R30,R17
	RCALL __LOADLOCR4
	RJMP _0x20C0001
; 0000 0123   d=d+4;
_0x37:
	__ADDWRN 18,19,4
; 0000 0124   i=0;
	RCALL SUBOPT_0x5
; 0000 0125   while(i<12)
_0x38:
	RCALL SUBOPT_0x11
	BRSH _0x3A
; 0000 0126   {
; 0000 0127   NR[i++]=*d;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x12
; 0000 0128    d=d-1;
	__SUBWRN 18,19,1
; 0000 0129    NR[i++]=*d;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x12
; 0000 012A    d=d+3;
	__ADDWRN 18,19,3
; 0000 012B   }
	RJMP _0x38
_0x3A:
; 0000 012C   NR[10]='F';
	LDI  R30,LOW(70)
	__PUTB1MN _NR,10
; 0000 012D 
; 0000 012E   CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 012F   c=1;
	LDI  R17,LOW(1)
; 0000 0130   return c;
	MOV  R30,R17
	RCALL __LOADLOCR4
	RJMP _0x20C0001
; 0000 0131 }

	.DSEG
_0x36:
	.BYTE 0x5
;
;//**********************************************************************************************************
;// Функция проверки балланса
; void BALLANSE(void)
; 0000 0136  {   unsigned char S;

	.CSEG
; 0000 0137    // char XY[2];
; 0000 0138     unsigned char *s1, *s2;
; 0000 0139     delay_ms(4000);
;	S -> R17
;	*s1 -> R18,R19
;	*s2 -> R20,R21
; 0000 013A     CLEAR_BUF();
; 0000 013B   do
; 0000 013C    { if(OP==0) SEND_Str("AT+CUSD=1,\"*100#\"\r"); //Отправа запроса балланса
; 0000 013D      else SEND_Str("AT+CUSD=1,\"*102#\"\r");
; 0000 013E    delay_ms(500);
; 0000 013F    #asm("wdr")
; 0000 0140     }while(TEST_OK()==0);
; 0000 0141     for(i=0;i<5;i++)
; 0000 0142     {
; 0000 0143      if(strstr(rx_buffer, "+CUSD:")!=NULL) break;   //Ожидание ответа на запрос
; 0000 0144      #asm("wdr")
; 0000 0145      delay_ms(1000);
; 0000 0146      #asm("wdr")
; 0000 0147     }
; 0000 0148     s1=strstr(rx_buffer, "04110430043B0430043D0441");
; 0000 0149     if(s1!=NULL)
; 0000 014A     {
; 0000 014B     s2=strstr(rx_buffer, "0440");
; 0000 014C     S=((s2-s1+4)/2)+13;
; 0000 014D    // sprintf(XY, "%02d", S);
; 0000 014E    // XX[0]=XY[0];
; 0000 014F    // XX[1]=XY[1];
; 0000 0150 
; 0000 0151     printf("AT+CMGS=%02d\r",S) ;
; 0000 0152     delay_ms(100);
; 0000 0153     #asm("wdr")
; 0000 0154      SEND_Str("0001000B91");     // Ввод настроек PDU
; 0000 0155 
; 0000 0156       for(i=0;i<12;i++)            // Ввод номера
; 0000 0157       {UART_Transmit(NR[i]);}
; 0000 0158       S=S-13;
; 0000 0159       printf("0008%02X", S);
; 0000 015A       s2=s2+4;
; 0000 015B       do{
; 0000 015C        UART_Transmit(*s1);
; 0000 015D        s1++;
; 0000 015E       }while(s1!=s2);
; 0000 015F       UART_Transmit(0x1A);
; 0000 0160              /*
; 0000 0161       delay_ms(1000);
; 0000 0162   for (i=0; i<256; i++)    // Запись буфера приема в eeprom
; 0000 0163       {eebuffer[i]=rx_buffer[i];}
; 0000 0164              */
; 0000 0165       }
; 0000 0166       CLEAR_BUF();
; 0000 0167  }

	.DSEG
_0x44:
	.BYTE 0x25
; //*********************************************************************************************
; char CALL(unsigned char nom)
; 0000 016A  { unsigned char NOM[12];

	.CSEG
_CALL:
; 0000 016B    char *d1;
; 0000 016C    char s;
; 0000 016D switch (nom)
	SBIW R28,12
	RCALL __SAVELOCR4
;	nom -> Y+16
;	NOM -> Y+4
;	*d1 -> R16,R17
;	s -> R19
	LDD  R30,Y+16
	RCALL SUBOPT_0x13
; 0000 016E     {
; 0000 016F      case 1:
	BRNE _0x4F
; 0000 0170 			{
; 0000 0171 			    SEND_Str("AT+CPBF=\"N1\"\r");
	__POINTW1FN _0x0,128
	RJMP _0x104
; 0000 0172 				break;
; 0000 0173 			}
; 0000 0174 
; 0000 0175      case 2:
_0x4F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x50
; 0000 0176 			{
; 0000 0177 			    SEND_Str("AT+CPBF=\"N2\"\r");
	__POINTW1FN _0x0,142
	RJMP _0x104
; 0000 0178 				break;
; 0000 0179 			}
; 0000 017A 
; 0000 017B      case 3:
_0x50:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x51
; 0000 017C 			{
; 0000 017D 			    SEND_Str("AT+CPBF=\"N3\"\r");
	__POINTW1FN _0x0,156
	RJMP _0x104
; 0000 017E 				break;
; 0000 017F 			}
; 0000 0180 
; 0000 0181      case 4:
_0x51:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x52
; 0000 0182 			{
; 0000 0183 			    SEND_Str("AT+CPBF=\"N4\"\r");
	__POINTW1FN _0x0,170
	RJMP _0x104
; 0000 0184 				break;
; 0000 0185 			}
; 0000 0186 
; 0000 0187      case 5:
_0x52:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x53
; 0000 0188 			{
; 0000 0189 			    SEND_Str("AT+CPBF=\"N5\"\r");
	__POINTW1FN _0x0,184
	RJMP _0x104
; 0000 018A 				break;
; 0000 018B 			}
; 0000 018C 
; 0000 018D      case 6:
_0x53:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4E
; 0000 018E 			{
; 0000 018F 			    SEND_Str("AT+CPBF=\"N6\"\r");
	__POINTW1FN _0x0,198
_0x104:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SEND_Str
; 0000 0190 				break;
; 0000 0191 			}
; 0000 0192 
; 0000 0193 
; 0000 0194     }
_0x4E:
; 0000 0195     delay_ms(100);
	RCALL SUBOPT_0xD
; 0000 0196     d1=strstr(rx_buffer, ",\"+7");
	RCALL SUBOPT_0xF
	__POINTW1MN _0x55,0
	RCALL SUBOPT_0x10
	MOVW R16,R30
; 0000 0197     if(d1!=NULL)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x56
; 0000 0198     {
; 0000 0199      d1=d1+2;
	__ADDWRN 16,17,2
; 0000 019A      for(i=0;i<12;i++)
	RCALL SUBOPT_0x5
_0x58:
	RCALL SUBOPT_0x11
	BRSH _0x59
; 0000 019B       { NOM[i]=*d1;
	MOVW R30,R8
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R16
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 019C        d1=d1+1;
	__ADDWRN 16,17,1
; 0000 019D       }
	RCALL SUBOPT_0x8
	RJMP _0x58
_0x59:
; 0000 019E     }
; 0000 019F 
; 0000 01A0     else {s=0;
	RJMP _0x5A
_0x56:
	LDI  R19,LOW(0)
; 0000 01A1      return s; }
	MOV  R30,R19
	RJMP _0x20C0005
_0x5A:
; 0000 01A2     CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 01A3    SEND_Str("AT+CSTA=145\r");
	__POINTW1FN _0x0,212
	RCALL SUBOPT_0xE
; 0000 01A4    delay_ms(100);
	RCALL SUBOPT_0xD
; 0000 01A5    SEND_Str("AT*PSSTKI=1\r");
	__POINTW1FN _0x0,225
	RCALL SUBOPT_0xE
; 0000 01A6    delay_ms(100);
	RCALL SUBOPT_0xD
; 0000 01A7    SEND_Str("ATD\"");
	__POINTW1FN _0x0,238
	RCALL SUBOPT_0xE
; 0000 01A8    for(i=0;i<12;i++) UART_Transmit(NOM[i]);
	RCALL SUBOPT_0x5
_0x5C:
	RCALL SUBOPT_0x11
	BRSH _0x5D
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	RJMP _0x5C
_0x5D:
; 0000 01A9 SEND_Str("\";\r");
	__POINTW1FN _0x0,243
	RCALL SUBOPT_0xE
; 0000 01AA    delay_ms(15000);
	LDI  R30,LOW(15000)
	LDI  R31,HIGH(15000)
	RCALL SUBOPT_0xC
; 0000 01AB     CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 01AC  }
_0x20C0005:
	RCALL __LOADLOCR4
	ADIW R28,17
	RET

	.DSEG
_0x55:
	.BYTE 0x5
; //**********************************************************************************************
;  char SEND_SMS(unsigned char nom)
; 0000 01AF 
; 0000 01B0   {      //unsigned char NOM[12];

	.CSEG
_SEND_SMS:
; 0000 01B1    //char *d;
; 0000 01B2    char s;
; 0000 01B3 switch (nom)
	ST   -Y,R17
;	nom -> Y+1
;	s -> R17
	LDD  R30,Y+1
	RCALL SUBOPT_0x13
; 0000 01B4     {
; 0000 01B5      case 1:
	BRNE _0x61
; 0000 01B6 			{
; 0000 01B7 			    SEND_Str("AT+CPBF=\"N1\"\r");
	__POINTW1FN _0x0,128
	RJMP _0x105
; 0000 01B8 				break;
; 0000 01B9 			}
; 0000 01BA 
; 0000 01BB      case 2:
_0x61:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x62
; 0000 01BC 			{
; 0000 01BD 			    SEND_Str("AT+CPBF=\"N2\"\r");
	__POINTW1FN _0x0,142
	RJMP _0x105
; 0000 01BE 				break;
; 0000 01BF 			}
; 0000 01C0 
; 0000 01C1      case 3:
_0x62:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x63
; 0000 01C2 			{
; 0000 01C3 			    SEND_Str("AT+CPBF=\"N3\"\r");
	__POINTW1FN _0x0,156
	RJMP _0x105
; 0000 01C4 				break;
; 0000 01C5 			}
; 0000 01C6 
; 0000 01C7      case 4:
_0x63:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x64
; 0000 01C8 			{
; 0000 01C9 			    SEND_Str("AT+CPBF=\"N4\"\r");
	__POINTW1FN _0x0,170
	RJMP _0x105
; 0000 01CA 				break;
; 0000 01CB 			}
; 0000 01CC 
; 0000 01CD      case 5:
_0x64:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x65
; 0000 01CE 			{
; 0000 01CF 			    SEND_Str("AT+CPBF=\"N5\"\r");
	__POINTW1FN _0x0,184
	RJMP _0x105
; 0000 01D0 				break;
; 0000 01D1 			}
; 0000 01D2 
; 0000 01D3      case 6:
_0x65:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x60
; 0000 01D4 			{
; 0000 01D5 			    SEND_Str("AT+CPBF=\"N6\"\r");
	__POINTW1FN _0x0,198
_0x105:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _SEND_Str
; 0000 01D6 				break;
; 0000 01D7 			}
; 0000 01D8 
; 0000 01D9 
; 0000 01DA     }
_0x60:
; 0000 01DB     delay_ms(100);
	RCALL SUBOPT_0xD
; 0000 01DC 
; 0000 01DD    if(SET_NR()==0) {s=0; return s; }
	RCALL _SET_NR
	CPI  R30,0
	BRNE _0x67
	LDI  R17,LOW(0)
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20C0002
; 0000 01DE 
; 0000 01DF     do{SEND_Str("AT+CMGF=0\r");     // Установка PDU режима
_0x67:
_0x69:
	__POINTW1FN _0x0,247
	RCALL SUBOPT_0xE
; 0000 01E0        }while(TEST_OK()==0);
	RCALL _TEST_OK
	CPI  R30,0
	BREQ _0x69
; 0000 01E1 
; 0000 01E2     do{ CLEAR_BUF();
_0x6C:
	RCALL _CLEAR_BUF
; 0000 01E3      SEND_Str("AT+CMGS=39\r");  //    Ввод команды отправки сообщения
	__POINTW1FN _0x0,258
	RCALL SUBOPT_0xE
; 0000 01E4       }while (strrchr(rx_buffer, '>')==NULL);
	RCALL SUBOPT_0xF
	LDI  R30,LOW(62)
	ST   -Y,R30
	RCALL _strrchr
	SBIW R30,0
	BREQ _0x6C
; 0000 01E5       CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 01E6 
; 0000 01E7       SEND_Str("0001000B91");     // Ввод настроек PDU
	__POINTW1FN _0x0,108
	RCALL SUBOPT_0xE
; 0000 01E8 
; 0000 01E9       for(i=0;i<12;i++)            // Ввод номера
	RCALL SUBOPT_0x5
_0x6F:
	RCALL SUBOPT_0x11
	BRSH _0x70
; 0000 01EA       {UART_Transmit(NR[i]);}
	LDI  R26,LOW(_NR)
	LDI  R27,HIGH(_NR)
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	RJMP _0x6F
_0x70:
; 0000 01EB        SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // Ввод текста сообщения
	__POINTW1FN _0x0,270
	RCALL SUBOPT_0xE
; 0000 01EC         CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 01ED        delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0xC
; 0000 01EE 
; 0000 01EF   }
	LDD  R17,Y+0
	RJMP _0x20C0002
; //==================ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ============================================
; //*******************************************************************************************
; unsigned char SPI_SEND(unsigned char data)  // Передать/принять байт  по SPI
; 0000 01F3 {
_SPI_SEND:
; 0000 01F4 SPDR = data;
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 01F5 		while (!(SPSR & (1<<SPIF)));
_0x71:
	SBIS 0xE,7
	RJMP _0x71
; 0000 01F6 		return SPDR;
	IN   R30,0xF
	RJMP _0x20C0003
; 0000 01F7 }
;
;
;//********************************************************************************************
; void RESET_TR(void) //Сброс трансивера по включению питания
; 0000 01FC {
_RESET_TR:
; 0000 01FD SPCR=0x00; //Отключение SPI
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 01FE PORTB.5=1; //Устанавливаем 1 на SCK
	SBI  0x18,5
; 0000 01FF PORTB.3=0;  // Устанавливаем 0 на MOSI
	CBI  0x18,3
; 0000 0200 PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 0201 delay_us(1);
	__DELAY_USB 1
; 0000 0202 PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 0203 delay_us(40);
	__DELAY_USB 49
; 0000 0204 SPCR=0x50; //Включение SPI
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 0205 PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 0206 while(PINB.4==1); //Ждем 0 на MISO
_0x7E:
	SBIC 0x16,4
	RJMP _0x7E
; 0000 0207 SPI_SEND(SRES);
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x15
; 0000 0208 PORTB.2=1; // SPI_SS OFF
	RJMP _0x20C0004
; 0000 0209 }
;//*******************************************************************************************
;void WRITE_REG( unsigned int reg) // Функция записи регистра
; 0000 020C {  union U dat;
_WRITE_REG:
; 0000 020D PORTB.2=0; // SPI_SS ON
	SBIW R28,2
;	reg -> Y+2
;	dat -> Y+0
	CBI  0x18,2
; 0000 020E while(PINB.4==1); //Ждем 0 на MISO
_0x85:
	SBIC 0x16,4
	RJMP _0x85
; 0000 020F 
; 0000 0210  dat.buf=reg;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0211  SPI_SEND(dat.b[1]);  //Адрес регистра
	LDD  R30,Y+1
	RCALL SUBOPT_0x15
; 0000 0212  SPI_SEND(dat.b[0]);  //Значение регистра
	LD   R30,Y
	RCALL SUBOPT_0x15
; 0000 0213 PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 0214 }
	RJMP _0x20C0001
;//*******************************************************************************************
;//********************************************************************************************
;unsigned char READ_REG(unsigned char adr)  // Функция чтения регистра
; 0000 0218 {  unsigned char reg;
; 0000 0219   PORTB.2=0; // SPI_SS ON
;	adr -> Y+1
;	reg -> R17
; 0000 021A while(PINB.4==1); //Ждем 0 на MISO
; 0000 021B    SPI_SEND(adr | 0x80);   // Старший бит определяет операцию
; 0000 021C    reg= SPI_SEND(0x00);
; 0000 021D    return reg;
; 0000 021E PORTB.2=1; // SPI_SS OFF
; 0000 021F }
;//**********************************************************************************************
; void INIT_TR(void) //Функция инициализации трансивера
; 0000 0222  {
_INIT_TR:
; 0000 0223 
; 0000 0224 
; 0000 0225   for (i=0;i<35;i++)
	RCALL SUBOPT_0x5
_0x92:
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	RCALL SUBOPT_0x6
	BRSH _0x93
; 0000 0226    {
; 0000 0227     WRITE_REG(init[i]);
	MOVW R30,R8
	LDI  R26,LOW(_init*2)
	LDI  R27,HIGH(_init*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	RCALL SUBOPT_0x4
	RCALL _WRITE_REG
; 0000 0228     };
	RCALL SUBOPT_0x8
	RJMP _0x92
_0x93:
; 0000 0229 
; 0000 022A 
; 0000 022B 
; 0000 022C  }
	RET
; //********************************************************************************************
;void WRITE_PATABLE(void)    //Запись таблицы мощности
; 0000 022F {
_WRITE_PATABLE:
; 0000 0230 PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 0231 while(PINB.4==1); //Ждем 0 на MISO
_0x96:
	SBIC 0x16,4
	RJMP _0x96
; 0000 0232 WRITE_REG(0x3EC0);         //Запись значения выходной мощности передатчика +10dbm
	LDI  R30,LOW(16064)
	LDI  R31,HIGH(16064)
	RCALL SUBOPT_0x4
	RCALL _WRITE_REG
; 0000 0233   PORTB.2=1; // SPI_SS OFF
_0x20C0004:
	SBI  0x18,2
; 0000 0234 }
	RET
;//*********************************************************************************************
;void STROB(unsigned char strob)  //Запись строб-команды
; 0000 0237 {
_STROB:
; 0000 0238 PORTB.2=0; // SPI_SS ON
;	strob -> Y+0
	CBI  0x18,2
; 0000 0239 while(PINB.4==1); //Ждем 0 на MISO
_0x9D:
	SBIC 0x16,4
	RJMP _0x9D
; 0000 023A  SPI_SEND(strob);
	LD   R30,Y
	RCALL SUBOPT_0x15
; 0000 023B   PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 023C }
	RJMP _0x20C0003
;//******************************************************************************************
;unsigned char STATUS(void)  //Получение статуса трансивера
; 0000 023F { unsigned char st;
; 0000 0240 PORTB.2=0; // SPI_SS ON
;	st -> R17
; 0000 0241 while(PINB.4==1); //Ждем 0 на MISO
; 0000 0242 st=SPI_SEND(SNOP);
; 0000 0243  PORTB.2=1; // SPI_SS OFF
; 0000 0244 return st;
; 0000 0245 }
;//********************************************************************************************
;void SEND_PAKET(unsigned char pktlen) //Функция передачи пакета
; 0000 0248 {
_SEND_PAKET:
; 0000 0249   STROB(SIDLE);  //Переход в режим IDLE
;	pktlen -> Y+0
	RCALL SUBOPT_0x16
; 0000 024A   STROB(SFRX);  //Очистка приемного буфера
; 0000 024B   STROB(SFTX); //Очистка передающего буфера
; 0000 024C   delay_ms(1);
	RCALL SUBOPT_0x17
; 0000 024D   PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 024E   while(PINB.4==1); //Ждем 0 на MISO
_0xAB:
	SBIC 0x16,4
	RJMP _0xAB
; 0000 024F   SPI_SEND(0x7F);   //Открытие буфера на запись
	LDI  R30,LOW(127)
	RCALL SUBOPT_0x15
; 0000 0250   SPI_SEND(pktlen); //Запись длинны пакета
	LD   R30,Y
	RCALL SUBOPT_0x15
; 0000 0251   for (i=0;i<pktlen;i++)  //Запмсь пакета
	RCALL SUBOPT_0x5
_0xAF:
	LD   R30,Y
	RCALL SUBOPT_0x18
	BRSH _0xB0
; 0000 0252   {
; 0000 0253    SPI_SEND(SPI_buffer[i]);
	RCALL SUBOPT_0x19
	LD   R30,X
	RCALL SUBOPT_0x15
; 0000 0254   }
	RCALL SUBOPT_0x8
	SBIW R30,1
	RJMP _0xAF
_0xB0:
; 0000 0255   PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 0256   GICR=0x40; //Запрет прерывания по приему пакета
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0257   STROB(STX); //Включение передачи
	LDI  R30,LOW(53)
	RCALL SUBOPT_0x1A
; 0000 0258 
; 0000 0259   while(PIND.3==0); //Ожидание начала передачи
_0xB3:
	SBIS 0x10,3
	RJMP _0xB3
; 0000 025A   while(PIND.3==1); //Ожидание конца передачи
_0xB6:
	SBIC 0x10,3
	RJMP _0xB6
; 0000 025B   STROB(SIDLE);  //Переход в режим IDLE
	RCALL SUBOPT_0x16
; 0000 025C   STROB(SFRX);  //Очистка приемного буфера
; 0000 025D   STROB(SFTX); //Очистка передающего буфера
; 0000 025E   GIFR|=0x80;  //Сброс флага прерывания
	IN   R30,0x3A
	ORI  R30,0x80
	OUT  0x3A,R30
; 0000 025F   GICR=0xC0;   //Разрешение прерывания по приему пакета
	LDI  R30,LOW(192)
	OUT  0x3B,R30
; 0000 0260 }
_0x20C0003:
	ADIW R28,1
	RET
;//********************************************************************************************
;unsigned char RECEIVE_PAKET(void) //Функция приема пакета
; 0000 0263 {
_RECEIVE_PAKET:
; 0000 0264 unsigned char pktlen;
; 0000 0265 STROB(SIDLE);  //Переход в режим IDLE
	ST   -Y,R17
;	pktlen -> R17
	LDI  R30,LOW(54)
	RCALL SUBOPT_0x1A
; 0000 0266 PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 0267 while(PINB.4==1); //Ждем 0 на MISO
_0xBB:
	SBIC 0x16,4
	RJMP _0xBB
; 0000 0268 SPI_SEND(0xFF);  //Открытие буфера приема
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x15
; 0000 0269 pktlen=SPI_SEND(0x00); //Считывание длинны пакета
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x15
	MOV  R17,R30
; 0000 026A for (i=0;i<pktlen;i++)    //Считывание пакета
	RCALL SUBOPT_0x5
_0xBF:
	MOV  R30,R17
	RCALL SUBOPT_0x18
	BRSH _0xC0
; 0000 026B    {
; 0000 026C    SPI_buffer[i]=SPI_SEND(0x00);
	MOVW R30,R8
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x15
	POP  R26
	POP  R27
	ST   X,R30
; 0000 026D    }
	RCALL SUBOPT_0x8
	SBIW R30,1
	RJMP _0xBF
_0xC0:
; 0000 026E PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 026F STROB(SFRX);
	LDI  R30,LOW(58)
	RCALL SUBOPT_0x1A
; 0000 0270 return pktlen; //Возврат длинны пакета
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0271  }
; //*******************************************************************************************
; void CLEAR_SPI_buffer(void) //Очистка SPI буфера
; 0000 0274  { for (i=0;i<64;i++)
_CLEAR_SPI_buffer:
	RCALL SUBOPT_0x5
_0xC4:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RCALL SUBOPT_0x6
	BRSH _0xC5
; 0000 0275    {
; 0000 0276     SPI_buffer[i]=0x00;
	RCALL SUBOPT_0x19
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0277    }
	RCALL SUBOPT_0x8
	RJMP _0xC4
_0xC5:
; 0000 0278  }
	RET
; //********************************************************************************************
;  // Запись строки в SPI буффер
; unsigned char Write_SPI_buffer(flash char *str)
; 0000 027C  {
_Write_SPI_buffer:
; 0000 027D   i=0;
;	*str -> Y+0
	RCALL SUBOPT_0x5
; 0000 027E   while(*str)
_0xC6:
	RCALL SUBOPT_0x1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0xC8
; 0000 027F   {
; 0000 0280   SPI_buffer[i++]=*str++;
	RCALL SUBOPT_0x8
	SBIW R30,1
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	MOVW R26,R30
	RCALL SUBOPT_0x2
	ST   X,R30
; 0000 0281 
; 0000 0282   }
	RJMP _0xC6
_0xC8:
; 0000 0283  return i;
	MOV  R30,R8
_0x20C0002:
	ADIW R28,2
	RET
; 0000 0284   }
;//********************************************************************************************
;
;//+++++++++++++++ПРЕРЫВАНИЯ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;//********************************************************************************************
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void) //Прерывание по сработке датчика
; 0000 028B {   GICR=0x80;
_ext_int0_isr:
	RCALL SUBOPT_0x1B
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 028C     delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0xC
; 0000 028D 
; 0000 028E    if ((z==0x0F)&&(PIND.2==1))
	LDI  R30,LOW(15)
	CP   R30,R7
	BRNE _0xCA
	SBIC 0x10,2
	RJMP _0xCB
_0xCA:
	RJMP _0xC9
_0xCB:
; 0000 028F    {  //LightDiode('G');
; 0000 0290     #asm("sei")
	sei
; 0000 0291 
; 0000 0292              for (i=0;i<5;i++)
	RCALL SUBOPT_0x5
_0xCD:
	RCALL SUBOPT_0x1C
	BRSH _0xCE
; 0000 0293        {delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 0294        LightDiode('G');
	RCALL SUBOPT_0x1E
; 0000 0295        delay_ms(300);
; 0000 0296        LightDiode('R');
	RCALL SUBOPT_0x1F
; 0000 0297        }
	RCALL SUBOPT_0x8
	RJMP _0xCD
_0xCE:
; 0000 0298          //delay_ms(10);
; 0000 0299 
; 0000 029A                  /*
; 0000 029B 
; 0000 029C         SEND_Str("AT+CSTA=145\r");
; 0000 029D         delay_ms(100);
; 0000 029E          SEND_Str("AT*PSSTKI=1\r");
; 0000 029F         delay_ms(100);
; 0000 02A0         SEND_Str("AT*PSCSSC=1\r");
; 0000 02A1          delay_ms(100);
; 0000 02A2         SEND_Str("ATD\"+79132425434\";\r");
; 0000 02A3                        */
; 0000 02A4                        /*
; 0000 02A5       do{SEND_Str("AT+CMGF=0\r");     // Установка PDU режима
; 0000 02A6        }while(TEST_OK()==0);
; 0000 02A7 
; 0000 02A8     do{ CLEAR_BUF();
; 0000 02A9      SEND_Str("AT+CMGS=39\r");  //    Ввод команды отправки сообщения
; 0000 02AA       }while (strrchr(rx_buffer, '>')==NULL);
; 0000 02AB       CLEAR_BUF();
; 0000 02AC 
; 0000 02AD       SEND_Str("0001000B91");     // Ввод настроек PDU
; 0000 02AE 
; 0000 02AF       for(i=0;i<12;i++)            // Ввод номера
; 0000 02B0       {UART_Transmit(NR[i]);}
; 0000 02B1        SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A"); // Ввод текста сообщения
; 0000 02B2                        */
; 0000 02B3 
; 0000 02B4         SEND_SMS(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _SEND_SMS
; 0000 02B5         CALL(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _CALL
; 0000 02B6                 /*
; 0000 02B7        delay_ms(25000);
; 0000 02B8          for(i=0;i<256;i++)
; 0000 02B9         {
; 0000 02BA         STAT[i]=rx_buffer[i];
; 0000 02BB         }
; 0000 02BC                */
; 0000 02BD 
; 0000 02BE        for (i=0;i<5;i++)
	RCALL SUBOPT_0x5
_0xD0:
	RCALL SUBOPT_0x1C
	BRSH _0xD1
; 0000 02BF        {delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 02C0        LightDiode('G');
	RCALL SUBOPT_0x1E
; 0000 02C1        delay_ms(300);
; 0000 02C2        LightDiode('R');
	RCALL SUBOPT_0x1F
; 0000 02C3        }
	RCALL SUBOPT_0x8
	RJMP _0xD0
_0xD1:
; 0000 02C4 
; 0000 02C5    }
; 0000 02C6 
; 0000 02C7     GIFR|=0x40;
_0xC9:
	IN   R30,0x3A
	ORI  R30,0x40
	OUT  0x3A,R30
; 0000 02C8     GICR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3B,R30
; 0000 02C9 }
	RJMP _0x108
;//********************************************************************************************
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)   //Прерывание по приему пакета
; 0000 02CD {
_ext_int1_isr:
	RCALL SUBOPT_0x1B
; 0000 02CE unsigned char len;
; 0000 02CF while(PIND.3==1);
	ST   -Y,R17
;	len -> R17
_0xD2:
	SBIC 0x10,3
	RJMP _0xD2
; 0000 02D0 len=RECEIVE_PAKET();
	RCALL _RECEIVE_PAKET
	MOV  R17,R30
; 0000 02D1  if (strstr(SPI_buffer,"BRELOK1")!=NULL)
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	RCALL SUBOPT_0x4
	__POINTW1MN _0xD6,0
	RCALL SUBOPT_0x10
	SBIW R30,0
	BREQ _0xD5
; 0000 02D2 
; 0000 02D3     {
; 0000 02D4      if(strstr(SPI_buffer,"CHANGE")!=NULL)
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	RCALL SUBOPT_0x4
	__POINTW1MN _0xD6,8
	RCALL SUBOPT_0x10
	SBIW R30,0
	BREQ _0xD7
; 0000 02D5       {if(z==0x0F) z=0x00;
	LDI  R30,LOW(15)
	CP   R30,R7
	BRNE _0xD8
	CLR  R7
; 0000 02D6       else z=0x0F;}
	RJMP _0xD9
_0xD8:
	LDI  R30,LOW(15)
	MOV  R7,R30
_0xD9:
; 0000 02D7 
; 0000 02D8 
; 0000 02D9     CLEAR_SPI_buffer();
_0xD7:
	RCALL _CLEAR_SPI_buffer
; 0000 02DA     STROB(SIDLE);
	RCALL SUBOPT_0x16
; 0000 02DB     STROB(SFRX);
; 0000 02DC     STROB(SFTX);
; 0000 02DD     if (z==0x0F )
	LDI  R30,LOW(15)
	CP   R30,R7
	BRNE _0xDA
; 0000 02DE     {len=Write_SPI_buffer("SECUR");
	__POINTW1FN _0x0,345
	RCALL SUBOPT_0x4
	RCALL _Write_SPI_buffer
	MOV  R17,R30
; 0000 02DF      LightDiode('R');}
	LDI  R30,LOW(82)
	RJMP _0x106
; 0000 02E0     else {len=Write_SPI_buffer("IDLE");
_0xDA:
	__POINTW1FN _0x0,351
	RCALL SUBOPT_0x4
	RCALL _Write_SPI_buffer
	MOV  R17,R30
; 0000 02E1         LightDiode('G');}
	LDI  R30,LOW(71)
_0x106:
	ST   -Y,R30
	RCALL _LightDiode
; 0000 02E2    delay_ms(3);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0xC
; 0000 02E3    SEND_PAKET(len);
	ST   -Y,R17
	RCALL _SEND_PAKET
; 0000 02E4    delay_ms(1);
	RCALL SUBOPT_0x17
; 0000 02E5    }
; 0000 02E6    STROB(SRX);
_0xD5:
	LDI  R30,LOW(52)
	RCALL SUBOPT_0x1A
; 0000 02E7    CLEAR_SPI_buffer();
	RCALL _CLEAR_SPI_buffer
; 0000 02E8 
; 0000 02E9 }
	LD   R17,Y+
_0x108:
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

	.DSEG
_0xD6:
	.BYTE 0xF
;
;//********************************************************************************************
;/// Функция обработки прерывания по приему символа USART
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 02EE {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 02EF char status,data;
; 0000 02F0 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 02F1 data=UDR;
	IN   R16,12
; 0000 02F2 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xDC
; 0000 02F3    {
; 0000 02F4    if (rx_wr_index != RX_BUFFER_SIZE) rx_buffer[rx_wr_index++]=data;
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CP   R30,R4
	CPC  R31,R5
	BREQ _0xDD
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 02F5 
; 0000 02F6       }
_0xDD:
; 0000 02F7    }
_0xDC:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;//=============================================================================================
;//*****************************ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ*************************************
;//===============================================================================================
;void main(void)
; 0000 02FD {
_main:
; 0000 02FE // Declare your local variables here
; 0000 02FF 
; 0000 0300 // Input/Output Ports initialization
; 0000 0301 // Port B initialization
; 0000 0302 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 0303 // State7=T State6=T State5=0 State4=T State3=0 State2=1 State1=T State0=T
; 0000 0304 PORTB=0x04;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 0305 DDRB=0x2C;
	LDI  R30,LOW(44)
	OUT  0x17,R30
; 0000 0306 
; 0000 0307 // Port C initialization
; 0000 0308 // Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=Out
; 0000 0309 // State6=T State5=0 State4=0 State3=T State2=1 State1=T State0=1
; 0000 030A PORTC=0x05;
	LDI  R30,LOW(5)
	OUT  0x15,R30
; 0000 030B DDRC=0x35;
	LDI  R30,LOW(53)
	OUT  0x14,R30
; 0000 030C 
; 0000 030D // Port D initialization
; 0000 030E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 030F // State7=T State6=T State5=T State4=T State3=T State2=P State1=0 State0=T
; 0000 0310 PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 0311 DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0312 
; 0000 0313 // Timer/Counter 0 initialization
; 0000 0314 // Clock source: System Clock
; 0000 0315 // Clock value: Timer 0 Stopped
; 0000 0316 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0317 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0318 
; 0000 0319 // Timer/Counter 1 initialization
; 0000 031A // Clock source: System Clock
; 0000 031B // Clock value: Timer1 Stopped
; 0000 031C // Mode: Normal top=0xFFFF
; 0000 031D // OC1A output: Discon.
; 0000 031E // OC1B output: Discon.
; 0000 031F // Noise Canceler: Off
; 0000 0320 // Input Capture on Falling Edge
; 0000 0321 // Timer1 Overflow Interrupt: Off
; 0000 0322 // Input Capture Interrupt: Off
; 0000 0323 // Compare A Match Interrupt: Off
; 0000 0324 // Compare B Match Interrupt: Off
; 0000 0325 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0326 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0327 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0328 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0329 ICR1H=0x00;
	OUT  0x27,R30
; 0000 032A ICR1L=0x00;
	OUT  0x26,R30
; 0000 032B OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 032C OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 032D OCR1BH=0x00;
	OUT  0x29,R30
; 0000 032E OCR1BL=0x00;
	OUT  0x28,R30
; 0000 032F 
; 0000 0330 // Timer/Counter 2 initialization
; 0000 0331 // Clock source: System Clock
; 0000 0332 // Clock value: Timer2 Stopped
; 0000 0333 // Mode: Normal top=0xFF
; 0000 0334 // OC2 output: Disconnected
; 0000 0335 ASSR=0x00;
	OUT  0x22,R30
; 0000 0336 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0337 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0338 OCR2=0x00;
	OUT  0x23,R30
; 0000 0339 
; 0000 033A // External Interrupt(s) initialization
; 0000 033B // INT0: On
; 0000 033C // INT0 Mode: Rising Edge
; 0000 033D // INT1: On
; 0000 033E // INT1 Mode: Rising Edge
; 0000 033F GICR|=0xC0;
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 0340 MCUCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x35,R30
; 0000 0341 GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0342 
; 0000 0343 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0344 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0345 
; 0000 0346 // USART initialization
; 0000 0347 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0348 // USART Receiver: On
; 0000 0349 // USART Transmitter: On
; 0000 034A // USART Mode: Asynchronous
; 0000 034B // USART Baud Rate: 115200
; 0000 034C UCSRA=0x00;
	OUT  0xB,R30
; 0000 034D UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 034E UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 034F UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0350 UBRRL=0x01;
	LDI  R30,LOW(1)
	OUT  0x9,R30
; 0000 0351 
; 0000 0352 // Analog Comparator initialization
; 0000 0353 // Analog Comparator: Off
; 0000 0354 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0355 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0356 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0357 
; 0000 0358 // ADC initialization
; 0000 0359 // ADC disabled
; 0000 035A ADCSRA=0x00;
	OUT  0x6,R30
; 0000 035B 
; 0000 035C // SPI initialization
; 0000 035D // SPI Type: Master
; 0000 035E // SPI Clock Rate: 921,600 kHz
; 0000 035F // SPI Clock Phase: Cycle Start
; 0000 0360 // SPI Clock Polarity: Low
; 0000 0361 // SPI Data Order: MSB First
; 0000 0362 SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 0363 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0364 
; 0000 0365 // TWI initialization
; 0000 0366 // TWI disabled
; 0000 0367 TWCR=0x00;
	OUT  0x36,R30
; 0000 0368 
; 0000 0369 #asm("cli")
	cli
; 0000 036A LightDiode('G');
	LDI  R30,LOW(71)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 036B delay_ms(1000);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 036C for(i=0;i<256;i++) STAT[i]=0xFF;
	RCALL SUBOPT_0x5
_0xDF:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	RCALL SUBOPT_0x6
	BRSH _0xE0
	LDI  R26,LOW(_STAT)
	LDI  R27,HIGH(_STAT)
	ADD  R26,R8
	ADC  R27,R9
	LDI  R30,LOW(255)
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x8
	RJMP _0xDF
_0xE0:
; 0000 036E RESET_TR();
	RCALL _RESET_TR
; 0000 036F  delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0xC
; 0000 0370  INIT_TR();
	RCALL _INIT_TR
; 0000 0371  WRITE_PATABLE();
	RCALL _WRITE_PATABLE
; 0000 0372  STROB(SIDLE);
	RCALL SUBOPT_0x16
; 0000 0373  STROB(SFRX);
; 0000 0374  STROB(SFTX);
; 0000 0375  STROB(SRX);
	LDI  R30,LOW(52)
	RCALL SUBOPT_0x1A
; 0000 0376  delay_ms(1);
	RCALL SUBOPT_0x17
; 0000 0377  GIFR|=0x80;
	IN   R30,0x3A
	ORI  R30,0x80
	OUT  0x3A,R30
; 0000 0378 // Global enable interrupts
; 0000 0379 #asm("sei")
	sei
; 0000 037A //============================================ИНИЦИАЛИЗАЦИЯ МОДЕМА======================================================================
; 0000 037B 
; 0000 037C  RESET_MODEM();
	RCALL _RESET_MODEM
; 0000 037D 
; 0000 037E    do{ SEND_Str("AT+COPS?\r");     //Определение оператора сотовой связи
_0xE2:
	__POINTW1FN _0x0,356
	RCALL SUBOPT_0xE
; 0000 037F   delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0xC
; 0000 0380   }while(strstr(rx_buffer, "+COPS:")==NULL);
	RCALL SUBOPT_0xF
	__POINTW1MN _0xE4,0
	RCALL SUBOPT_0x10
	SBIW R30,0
	BREQ _0xE2
; 0000 0381  if( strstr(rx_buffer, "Beeline")!=NULL ) OP=1;
	RCALL SUBOPT_0xF
	__POINTW1MN _0xE4,7
	RCALL SUBOPT_0x10
	SBIW R30,0
	BREQ _0xE5
	LDI  R26,LOW(_OP)
	LDI  R27,HIGH(_OP)
	LDI  R30,LOW(1)
	RJMP _0x107
; 0000 0382   else OP=0;
_0xE5:
	LDI  R26,LOW(_OP)
	LDI  R27,HIGH(_OP)
	LDI  R30,LOW(0)
_0x107:
	RCALL __EEPROMWRB
; 0000 0383    CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0384            /*
; 0000 0385 
; 0000 0386     do{     SEND_Str("AT+CPBF=\"N1\"\r");  // Считывание телефонного номера с SIM карты
; 0000 0387        #asm("wdr")
; 0000 0388       } while(SET_NR()==0);      // Преобразование номера в PDU формат
; 0000 0389 
; 0000 038A    CALL(1);
; 0000 038B             */
; 0000 038C             LightDiode('R');
	RCALL SUBOPT_0x1F
; 0000 038D 
; 0000 038E 
; 0000 038F 
; 0000 0390           SEND_Str("AT+CLIP=1\r");
	__POINTW1FN _0x0,381
	RCALL SUBOPT_0xE
; 0000 0391            CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 0392        for(i=0;i<30;i++)
	RCALL SUBOPT_0x5
_0xE8:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RCALL SUBOPT_0x6
	BRSH _0xE9
; 0000 0393        {
; 0000 0394         if( strstr(rx_buffer, "RING")!=NULL)
	RCALL SUBOPT_0xF
	__POINTW1MN _0xE4,15
	RCALL SUBOPT_0x10
	SBIW R30,0
	BREQ _0xEA
; 0000 0395          {  delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 0396          SEND_Str("ATH\r");
	__POINTW1FN _0x0,397
	RCALL SUBOPT_0xE
; 0000 0397          delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0xC
; 0000 0398          break;
	RJMP _0xE9
; 0000 0399          }
; 0000 039A         delay_ms(1000);
_0xEA:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
; 0000 039B        }
	RCALL SUBOPT_0x8
	RJMP _0xE8
_0xE9:
; 0000 039C 
; 0000 039D         x=strstr(rx_buffer, "\"+7");
	RCALL SUBOPT_0xF
	__POINTW1MN _0xE4,20
	RCALL SUBOPT_0x10
	MOVW R10,R30
; 0000 039E 
; 0000 039F         if(x!=NULL)
	MOV  R0,R10
	OR   R0,R11
	BRNE PC+2
	RJMP _0xEB
; 0000 03A0         {
; 0000 03A1           x=x+1;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 03A2          for(i=0;i<12;i++)
	RCALL SUBOPT_0x5
_0xED:
	RCALL SUBOPT_0x11
	BRSH _0xEE
; 0000 03A3           {NR[i]=*x;
	MOVW R30,R8
	SUBI R30,LOW(-_NR)
	SBCI R31,HIGH(-_NR)
	MOVW R0,R30
	MOVW R26,R10
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 03A4            x=x+1;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 03A5           }
	RCALL SUBOPT_0x8
	RJMP _0xED
_0xEE:
; 0000 03A6 
; 0000 03A7         CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 03A8         delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 03A9 
; 0000 03AA         SEND_Str("AT+CPBF=\"N1\"\r");
	__POINTW1FN _0x0,128
	RCALL SUBOPT_0xE
; 0000 03AB         delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 03AC         // SEND_Str("AT+CPBF=\"N2\"\r");
; 0000 03AD 
; 0000 03AE          if(strstr(rx_buffer, NR)==NULL)
	RCALL SUBOPT_0xF
	LDI  R30,LOW(_NR)
	LDI  R31,HIGH(_NR)
	RCALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0xEF
; 0000 03AF           {
; 0000 03B0            SEND_Str("AT+CPBW=1,\"");
	__POINTW1FN _0x0,402
	RCALL SUBOPT_0xE
; 0000 03B1             for(i=0;i<12;i++)            // Ввод номера
	RCALL SUBOPT_0x5
_0xF1:
	RCALL SUBOPT_0x11
	BRSH _0xF2
; 0000 03B2             {UART_Transmit(NR[i]);}
	LDI  R26,LOW(_NR)
	LDI  R27,HIGH(_NR)
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x8
	RJMP _0xF1
_0xF2:
; 0000 03B3             SEND_Str("\",145,\"N1\"\r");
	__POINTW1FN _0x0,414
	RCALL SUBOPT_0xE
; 0000 03B4             for(i=0;i<5;i++)
	RCALL SUBOPT_0x5
_0xF4:
	RCALL SUBOPT_0x1C
	BRSH _0xF5
; 0000 03B5             { LightDiode('R');
	RCALL SUBOPT_0x1F
; 0000 03B6               delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 03B7               LightDiode('G');
	RCALL SUBOPT_0x1E
; 0000 03B8               delay_ms(300);
; 0000 03B9             }
	RCALL SUBOPT_0x8
	RJMP _0xF4
_0xF5:
; 0000 03BA           }
; 0000 03BB          else{
	RJMP _0xF6
_0xEF:
; 0000 03BC            for(i=0;i<5;i++)
	RCALL SUBOPT_0x5
_0xF8:
	RCALL SUBOPT_0x1C
	BRSH _0xF9
; 0000 03BD             { LightDiode('T');
	LDI  R30,LOW(84)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 03BE               delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 03BF               LightDiode('R');
	RCALL SUBOPT_0x1F
; 0000 03C0               delay_ms(300);
	RCALL SUBOPT_0x1D
; 0000 03C1             }
	RCALL SUBOPT_0x8
	RJMP _0xF8
_0xF9:
; 0000 03C2 
; 0000 03C3          }
_0xF6:
; 0000 03C4         }
; 0000 03C5          delay_ms(100);
_0xEB:
	RCALL SUBOPT_0xD
; 0000 03C6         SEND_Str("AT+CPBS?\r");
	__POINTW1FN _0x0,426
	RCALL SUBOPT_0xE
; 0000 03C7 
; 0000 03C8 
; 0000 03C9 
; 0000 03CA 
; 0000 03CB 
; 0000 03CC     delay_ms(15000);
	LDI  R30,LOW(15000)
	LDI  R31,HIGH(15000)
	RCALL SUBOPT_0xC
; 0000 03CD          for(i=0;i<256;i++)
	RCALL SUBOPT_0x5
_0xFB:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	RCALL SUBOPT_0x6
	BRSH _0xFC
; 0000 03CE         {
; 0000 03CF         STAT[i]=rx_buffer[i];
	MOVW R30,R8
	SUBI R30,LOW(-_STAT)
	SBCI R31,HIGH(-_STAT)
	MOVW R0,R30
	RCALL SUBOPT_0x7
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
; 0000 03D0         }
	RCALL SUBOPT_0x8
	RJMP _0xFB
_0xFC:
; 0000 03D1 
; 0000 03D2  //=====================================================================================================================================
; 0000 03D3         z=0x00;
	CLR  R7
; 0000 03D4         LightDiode('G');
	LDI  R30,LOW(71)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 03D5 
; 0000 03D6 
; 0000 03D7           /*
; 0000 03D8         for(i=0;i<256;i++)
; 0000 03D9         {
; 0000 03DA         STAT[i]=rx_buffer[i];
; 0000 03DB         }
; 0000 03DC              */
; 0000 03DD 
; 0000 03DE 
; 0000 03DF while (1)
_0xFD:
; 0000 03E0       {
; 0000 03E1       // Place your code here
; 0000 03E2 
; 0000 03E3       }
	RJMP _0xFD
; 0000 03E4 }
_0x100:
	RJMP _0x100

	.DSEG
_0xE4:
	.BYTE 0x18

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
_0x20C0001:
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
_rx_buffer:
	.BYTE 0x200
_NR:
	.BYTE 0xC
_SPI_buffer:
	.BYTE 0x40

	.ESEG
_OP:
	.BYTE 0x1
_STAT:
	.BYTE 0x100

	.DSEG
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _UART_Transmit

;OPTIMIZER ADDED SUBROUTINE, CALLED 77 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5:
	CLR  R8
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_rx_buffer)
	LDI  R27,HIGH(_rx_buffer)
	ADD  R26,R8
	ADC  R27,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x8:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	MOVW R26,R18
	LD   R17,X
	RCALL _CLEAR_BUF
	MOV  R30,R17
	RCALL __LOADLOCR4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x4
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x4
	RJMP _SEND_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x4
	RJMP _strstr

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	SBIW R30,1
	SUBI R30,LOW(-_NR)
	SBCI R31,HIGH(-_NR)
	MOVW R0,R30
	MOVW R26,R18
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	ADD  R26,R8
	ADC  R27,R9
	LD   R30,X
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	RJMP _SPI_SEND

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(54)
	ST   -Y,R30
	RCALL _STROB
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL _STROB
	LDI  R30,LOW(59)
	ST   -Y,R30
	RJMP _STROB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOVW R26,R8
	RCALL SUBOPT_0x0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(_SPI_buffer)
	LDI  R27,HIGH(_SPI_buffer)
	ADD  R26,R8
	ADC  R27,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	ST   -Y,R30
	RJMP _STROB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1B:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(71)
	ST   -Y,R30
	RCALL _LightDiode
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(82)
	ST   -Y,R30
	RJMP _LightDiode


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

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
