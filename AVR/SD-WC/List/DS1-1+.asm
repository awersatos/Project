
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
	.DEF _i=R5
	.DEF _z=R4

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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_init:
	.DB  0x8,0xB,0x0,0xC,0x58,0xD,0xE9,0xE
	.DB  0x0,0xF,0x84,0x10,0xF1,0x11,0x4,0x12
	.DB  0x2,0x13,0xE5,0x14,0x0,0xA,0x4,0x15
	.DB  0x56,0x21,0x10,0x22,0x7,0x16,0x30,0x17
	.DB  0x18,0x18,0x16,0x19,0x6C,0x1A,0xFB,0x1B
	.DB  0x40,0x1C,0x91,0x1D,0xA9,0x23,0xA,0x24
	.DB  0x0,0x25,0x11,0x26,0x59,0x29,0x88,0x2C
	.DB  0x31,0x2D,0xB,0x2E,0xE,0x0,0xE,0x2
	.DB  0x40,0x7,0x5,0x8,0x0,0x9,0xFF,0x6
	.DB  0x7,0x3,0xCF,0x4,0xFC,0x5
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;Project :
;Version :
;Date    : 03.04.2012
;Author  :
;Company :
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
;#include <spi.h>
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <stdio.h>
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
;flash unsigned int init[39]={0x0B08,     //0 FSCTRL1  Параметры синтезатора частоты
;                             0x0C00,     //1 FSCTRL0
;                             0x0D58,     //2 FREQ2 Определение базовой несущей частоты
;                             0x0EE9,     //3 FREQ1
;                             0x0F00,     //4 FREQ0
;                             0x1084,     //5 MDMCFG4 ПАРАМЕТРЫ МОДЕМА ширина полосы пропускания
;                             0x11F1,     //6 MDMCFG3 скорость передачи
;                             0x1204,     //7 MDMCFG2 вид модуляции параметры слова синхронизации
;                             0x1302,     //8 MDMCFG1 длинна приамбулы включение FEC
;                             0x14E5,     //9 MDMCFG0 величина разноса каналлов
;                             0x0A00,     //10 CHANNR номер канала
;                             0x1504,     //11 DEVIATN девиация
;                             0x2156,     //12 FREND1
;                             0x2210,     //13 FREND0
;                             0x1607,     //14 MCSM2   ПАРАМЕТРЫ КОНТРОЛЯ РАДИО
;                             0x1730,     //15 MCSM1
;                             0x1818,     //16 MCSM0
;                             0x1916,     //17 FOCCFG компенсация сдвига частоты
;                             0x1A6C,     //18 BSCFG кофигурация побитовой синхронизации
;                             0x1BFB,     //19 AGCCTRL2 Параметры МШУ и порог чувствительности при приеме
;                             0x1C40,     //20 AGCCTRL1
;                             0x1D91,     //21 AGCCTRL0
;                             0x23A9,     //22 FSCAL3  Параметры калибровки синтезатора
;                             0x240A,     //23 FSCAL2
;                             0x2500,     //24 FSCAL1
;                             0x2611,     //25 FSCAL0
;                             0x2959,     //26 FSTEST
;                             0x2C88,     //27 TEST2
;                             0x2D31,     //28 TEST1
;                             0x2E0B,     //29 TEST0
;                             0x000E,     //30 IOCFG2 Конфигурация GDO2 - 1при приеме синхрослова 0 пакет принят
;                             0x020E,     //31 IOCFG0 Конфигурация GDO0 - обнаружение несущей
;                             0x0740,     //32 PKTCTRL1 Конфигурация пакета
;                             0x0805,     //33 PKTCTRL0
;                             0x0900,     //34 ADDR Адрес устройства
;                             0x06FF,     //35 PKTLEN Длинна пакета
;                             0x0307,      //36 FIFOTHR граница переполнения FIFO
;                             0x04CF,      //37
;                             0x05FC,       //38
;                             } ;
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;union U      // Определение объединения
;		{
;			unsigned int buf;
;			unsigned char b[2];
;		};
;
;union U data;
;// Определение глобальных переменных
;eeprom unsigned char STATUS[128];
;unsigned char i; //Основной счетчик
; unsigned char z;
;//********************************************************************************************
;void LightDiode(unsigned char n) // Функция управления светодиодом
; 0000 005F {

	.CSEG
_LightDiode:
; 0000 0060  switch (n)
;	n -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x0
; 0000 0061  {
; 0000 0062  case 0:
	SBIW R30,0
	BRNE _0x6
; 0000 0063 			{
; 0000 0064 			PORTC.4=0;
	CBI  0x15,4
; 0000 0065             PORTC.5=0;
	CBI  0x15,5
; 0000 0066 				break;
	RJMP _0x5
; 0000 0067 			}
; 0000 0068  case 1:
_0x6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
; 0000 0069 			{
; 0000 006A 			PORTC.4=1;
	SBI  0x15,4
; 0000 006B             PORTC.5=0;
	CBI  0x15,5
; 0000 006C 				break;
	RJMP _0x5
; 0000 006D 			}
; 0000 006E  case 2:
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10
; 0000 006F 			{
; 0000 0070 			PORTC.4=0;
	CBI  0x15,4
; 0000 0071             PORTC.5=1;
	RJMP _0x6B
; 0000 0072 				break;
; 0000 0073  case 3:
_0x10:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5
; 0000 0074 			{
; 0000 0075 			PORTC.4=1;
	SBI  0x15,4
; 0000 0076             PORTC.5=1;
_0x6B:
	SBI  0x15,5
; 0000 0077 				break;
; 0000 0078 			} 			}
; 0000 0079  }
_0x5:
; 0000 007A 
; 0000 007B }
	RJMP _0x20C0002
;//****************************************************************************************************
;//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
;//============================================================================================
;//*********************************************************************************************
;unsigned char SPI_SEND(unsigned char data)  // Передать/принять байт  по SPI
; 0000 0081 {
_SPI_SEND:
; 0000 0082 SPDR = data;
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 0083 		while (!(SPSR & (1<<SPIF)));
_0x1A:
	SBIS 0xE,7
	RJMP _0x1A
; 0000 0084 		return SPDR;
	IN   R30,0xF
_0x20C0002:
	ADIW R28,1
	RET
; 0000 0085 }
;
;//*******************************************************************************************
;void RESET_TR(void) //Сброс трансивера по включению питания
; 0000 0089 {
_RESET_TR:
; 0000 008A SPCR=0x00; //Отключение SPI
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 008B PORTB.5=1; //Устанавливаем 1 на SCK
	SBI  0x18,5
; 0000 008C PORTB.3=0;  // Устанавливаем 0 на MOSI
	CBI  0x18,3
; 0000 008D PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 008E delay_us(1);
	__DELAY_USB 1
; 0000 008F PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 0090 delay_us(40);
	__DELAY_USB 49
; 0000 0091 SPCR=0x50; //Включение SPI
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 0092 PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 0093 while(PORTB.4==1); //Ждем 0 на MISO
_0x27:
	SBIC 0x18,4
	RJMP _0x27
; 0000 0094 SPI_SEND(SRES);
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x1
; 0000 0095 PORTB.2=1; // SPI_SS OFF
	RJMP _0x20C0001
; 0000 0096 }
;
;//*******************************************************************************************
;void WRITE_REG( unsigned int reg) // Функция записи регистра
; 0000 009A {
_WRITE_REG:
; 0000 009B  union U dat;
; 0000 009C  dat.buf=reg;
	SBIW R28,2
;	reg -> Y+2
;	dat -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   Y,R30
	STD  Y+1,R31
; 0000 009D  SPI_SEND(dat.b[1]);  //Адрес регистра
	LDD  R30,Y+1
	RCALL SUBOPT_0x1
; 0000 009E  SPI_SEND(dat.b[0]);  //Значение регистра
	LD   R30,Y
	RCALL SUBOPT_0x1
; 0000 009F }
	ADIW R28,4
	RET
;//********************************************************************************************
;unsigned char READ_REG(unsigned char adr)  // Функция чтения регистра
; 0000 00A2 {  unsigned char reg;
_READ_REG:
; 0000 00A3    SPI_SEND(adr | 0x80);   // Старший бит определяет операцию
	ST   -Y,R17
;	adr -> Y+1
;	reg -> R17
	LDD  R30,Y+1
	ORI  R30,0x80
	RCALL SUBOPT_0x1
; 0000 00A4    reg= SPI_SEND(0xFF);
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x1
	MOV  R17,R30
; 0000 00A5    return reg;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,2
	RET
; 0000 00A6 }
;//**********************************************************************************************
; void INIT_TR(void) //Функция инициализации трансивера
; 0000 00A9  { union U dt;
_INIT_TR:
; 0000 00AA    unsigned char err;
; 0000 00AB   PORTB.2=0; // SPI_SS ON
	SBIW R28,2
	ST   -Y,R17
;	dt -> Y+1
;	err -> R17
	CBI  0x18,2
; 0000 00AC   while(PORTB.4==1); //Ждем 0 на MISO
_0x2E:
	SBIC 0x18,4
	RJMP _0x2E
; 0000 00AD   do{
_0x32:
; 0000 00AE   for (i=0;i<39;i++)
	CLR  R5
_0x35:
	LDI  R30,LOW(39)
	CP   R5,R30
	BRSH _0x36
; 0000 00AF    {
; 0000 00B0     WRITE_REG(init[i]);
	RCALL SUBOPT_0x2
	ST   -Y,R31
	ST   -Y,R30
	RCALL _WRITE_REG
; 0000 00B1     };
	INC  R5
	RJMP _0x35
_0x36:
; 0000 00B2     err=0;
	LDI  R17,LOW(0)
; 0000 00B3 
; 0000 00B4     for (i=0;i<39;i++)
	CLR  R5
_0x38:
	LDI  R30,LOW(39)
	CP   R5,R30
	BRSH _0x39
; 0000 00B5      {
; 0000 00B6      dt.buf=init[i];
	RCALL SUBOPT_0x2
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 00B7      if(dt.b[0]!=READ_REG(dt.b[1])){ err=1; }
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _READ_REG
	LDD  R26,Y+1
	CP   R30,R26
	BREQ _0x3A
	LDI  R17,LOW(1)
; 0000 00B8      }
_0x3A:
	INC  R5
	RJMP _0x38
_0x39:
; 0000 00B9 
; 0000 00BA     }while(err==1);
	CPI  R17,1
	BREQ _0x32
; 0000 00BB 
; 0000 00BC    PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 00BD  }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;//********************************************************************************************
;void WRITE_PATABLE(void)    //Запись таблицы мощности
; 0000 00C0 {
_WRITE_PATABLE:
; 0000 00C1 PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 00C2 while(PORTB.4==1); //Ждем 0 на MISO
_0x3F:
	SBIC 0x18,4
	RJMP _0x3F
; 0000 00C3 WRITE_REG(0x3EFF);         //Запись значения выходной мощности передатчика +1dbm
	LDI  R30,LOW(16127)
	LDI  R31,HIGH(16127)
	RCALL SUBOPT_0x3
	RCALL _WRITE_REG
; 0000 00C4 //SPI_SEND(0x7E);
; 0000 00C5 //SPI_SEND(0x00);
; 0000 00C6 //SPI_SEND(0xFF);
; 0000 00C7 PORTB.2=1; // SPI_SS OFF
_0x20C0001:
	SBI  0x18,2
; 0000 00C8 }
	RET
;//*********************************************************************************************
;//++++++++++++++++++++++++++++++++ПРЕРЫВАНИЯ++++++++++++++++++++++++++++++++++++++++++++++++++
;//***********************************************************************************************
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void) //Прерывание по приему пакета
; 0000 00CE {  LightDiode(2);
_ext_int1_isr:
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
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x4
; 0000 00CF  //while(PORTD.3==1);
; 0000 00D0   //while(1);
; 0000 00D1  delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x5
; 0000 00D2  SPI_SEND(SIDLE);
	LDI  R30,LOW(54)
	RCALL SUBOPT_0x1
; 0000 00D3   SPI_SEND(0xFB);
	LDI  R30,LOW(251)
	RCALL SUBOPT_0x1
; 0000 00D4  z=SPI_SEND(0xFF);
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x1
	MOV  R4,R30
; 0000 00D5   STATUS[0]=z;
	MOV  R30,R4
	LDI  R26,LOW(_STATUS)
	LDI  R27,HIGH(_STATUS)
	RCALL __EEPROMWRB
; 0000 00D6   PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 00D7 
; 0000 00D8  PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 00D9    while(PORTB.4==1); //Ждем 0 на MISO
_0x48:
	SBIC 0x18,4
	RJMP _0x48
; 0000 00DA    SPI_SEND(0xFF);
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x1
; 0000 00DB    for(i=1;i<z;i++)
	LDI  R30,LOW(1)
	MOV  R5,R30
_0x4C:
	CP   R5,R4
	BRSH _0x4D
; 0000 00DC    {   STATUS[i]=SPI_SEND(0x00);
	MOV  R30,R5
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_STATUS)
	SBCI R31,HIGH(-_STATUS)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x1
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 00DD     //if( SPI_SEND(0xFF)==0xD3)  { LightDiode(0); while(1);}
; 0000 00DE 
; 0000 00DF     //if (SPI_SEND(0xFF)==0x91){LightDiode(1); while(1);}   }          ;
; 0000 00E0    }
	INC  R5
	RJMP _0x4C
_0x4D:
; 0000 00E1    PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 00E2 
; 0000 00E3   PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 00E4    while(PORTB.4==1); //Ждем 0 на MISO
_0x52:
	SBIC 0x18,4
	RJMP _0x52
; 0000 00E5     SPI_SEND(SFRX);
	LDI  R30,LOW(58)
	RCALL SUBOPT_0x1
; 0000 00E6     SPI_SEND(SRX);
	LDI  R30,LOW(52)
	RCALL SUBOPT_0x1
; 0000 00E7     PORTB.2=1; // SPI_SS OFF
	SBI  0x18,2
; 0000 00E8 
; 0000 00E9  //while(1);
; 0000 00EA  LightDiode(1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4
; 0000 00EB 
; 0000 00EC           /*
; 0000 00ED // if(PORTD.3==0)    LightDiode(0);
; 0000 00EE   PORTB.2=0; // SPI_SS ON
; 0000 00EF    while(PORTB.4==1); //Ждем 0 на MISO
; 0000 00F0  STATUS[0]=SPI_SEND(SNOP);
; 0000 00F1   while(PORTD.3==1);
; 0000 00F2   STATUS[1]=SPI_SEND(SNOP);
; 0000 00F3 
; 0000 00F4 
; 0000 00F5     delay_ms(100);
; 0000 00F6     STATUS[2]=SPI_SEND(SNOP);
; 0000 00F7      SPI_SEND(SIDLE);
; 0000 00F8      SPI_SEND(SFRX);
; 0000 00F9      SPI_SEND(SRX);
; 0000 00FA       PORTB.2=1; // SPI_SS OFF
; 0000 00FB                */
; 0000 00FC 
; 0000 00FD 
; 0000 00FE }
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
;//*********************************************************************************************
;//============================================================================================
;//+++++++++++++ ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ ++++++++++++++++++++++++++++++++++++++++++++++++++
;//============================================================================================
;void main(void)
; 0000 0104 {
_main:
; 0000 0105 // Declare your local variables here
; 0000 0106 
; 0000 0107 // Input/Output Ports initialization
; 0000 0108 // Port B initialization
; 0000 0109 // Func7=In Func6=In Func5=Out Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 010A // State7=T State6=T State5=0 State4=T State3=1 State2=1 State1=T State0=T
; 0000 010B PORTB=0x0D;
	LDI  R30,LOW(13)
	OUT  0x18,R30
; 0000 010C DDRB=0x2C;
	LDI  R30,LOW(44)
	OUT  0x17,R30
; 0000 010D 
; 0000 010E // Port C initialization
; 0000 010F // Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0110 // State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0111 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0112 DDRC=0x30;
	LDI  R30,LOW(48)
	OUT  0x14,R30
; 0000 0113 
; 0000 0114 // Port D initialization
; 0000 0115 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0116 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0117 PORTD=0x08;
	LDI  R30,LOW(8)
	OUT  0x12,R30
; 0000 0118 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0119 
; 0000 011A // Timer/Counter 0 initialization
; 0000 011B // Clock source: System Clock
; 0000 011C // Clock value: Timer 0 Stopped
; 0000 011D TCCR0=0x00;
	OUT  0x33,R30
; 0000 011E TCNT0=0x00;
	OUT  0x32,R30
; 0000 011F 
; 0000 0120 // Timer/Counter 1 initialization
; 0000 0121 // Clock source: System Clock
; 0000 0122 // Clock value: Timer1 Stopped
; 0000 0123 // Mode: Normal top=0xFFFF
; 0000 0124 // OC1A output: Discon.
; 0000 0125 // OC1B output: Discon.
; 0000 0126 // Noise Canceler: Off
; 0000 0127 // Input Capture on Falling Edge
; 0000 0128 // Timer1 Overflow Interrupt: Off
; 0000 0129 // Input Capture Interrupt: Off
; 0000 012A // Compare A Match Interrupt: Off
; 0000 012B // Compare B Match Interrupt: Off
; 0000 012C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 012D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 012E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 012F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0130 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0131 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0132 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0133 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0134 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0135 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0136 
; 0000 0137 // Timer/Counter 2 initialization
; 0000 0138 // Clock source: System Clock
; 0000 0139 // Clock value: Timer2 Stopped
; 0000 013A // Mode: Normal top=0xFF
; 0000 013B // OC2 output: Disconnected
; 0000 013C ASSR=0x00;
	OUT  0x22,R30
; 0000 013D TCCR2=0x00;
	OUT  0x25,R30
; 0000 013E TCNT2=0x00;
	OUT  0x24,R30
; 0000 013F OCR2=0x00;
	OUT  0x23,R30
; 0000 0140 
; 0000 0141 // External Interrupt(s) initialization
; 0000 0142 // INT0: Off
; 0000 0143 // INT1: On
; 0000 0144 // INT1 Mode: Rising Edge
; 0000 0145 GICR=0x00;
	OUT  0x3B,R30
; 0000 0146 MCUCR=0x0C;
	LDI  R30,LOW(12)
	OUT  0x35,R30
; 0000 0147 GIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0148 
; 0000 0149 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 014A TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 014B 
; 0000 014C // USART initialization
; 0000 014D // USART disabled
; 0000 014E UCSRB=0x00;
	OUT  0xA,R30
; 0000 014F 
; 0000 0150 // Analog Comparator initialization
; 0000 0151 // Analog Comparator: Off
; 0000 0152 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0153 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0154 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0155 
; 0000 0156 // ADC initialization
; 0000 0157 // ADC disabled
; 0000 0158 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0159 
; 0000 015A // SPI initialization
; 0000 015B // SPI Type: Master
; 0000 015C // SPI Clock Rate: 921,600 kHz
; 0000 015D // SPI Clock Phase: Cycle Start
; 0000 015E // SPI Clock Polarity: Low
; 0000 015F // SPI Data Order: MSB First
; 0000 0160 SPCR=0x50;
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 0161 SPSR=0x00;
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0162 
; 0000 0163 // TWI initialization
; 0000 0164 // TWI disabled
; 0000 0165 TWCR=0x00;
	OUT  0x36,R30
; 0000 0166      #asm("sei")
	sei
; 0000 0167 while (1)
; 0000 0168       {
; 0000 0169         for(i=0;i<128;i++)
	CLR  R5
_0x5B:
	LDI  R30,LOW(128)
	CP   R5,R30
	BRSH _0x5C
; 0000 016A         {
; 0000 016B         STATUS[i]=0xFF;
	MOV  R26,R5
	LDI  R27,0
	SUBI R26,LOW(-_STATUS)
	SBCI R27,HIGH(-_STATUS)
	LDI  R30,LOW(255)
	RCALL __EEPROMWRB
; 0000 016C         }
	INC  R5
	RJMP _0x5B
_0x5C:
; 0000 016D      // delay_ms(1000);
; 0000 016E 
; 0000 016F       RESET_TR();
	RCALL _RESET_TR
; 0000 0170       delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x5
; 0000 0171       INIT_TR();
	RCALL _INIT_TR
; 0000 0172       WRITE_PATABLE();
	RCALL _WRITE_PATABLE
; 0000 0173 
; 0000 0174 
; 0000 0175 
; 0000 0176       delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RCALL SUBOPT_0x5
; 0000 0177       PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 0178       while(PORTB.4==1); //Ждем 0 на MISO
_0x5F:
	SBIC 0x18,4
	RJMP _0x5F
; 0000 0179       SPI_SEND(SIDLE); //Переход в режим IDLE
	LDI  R30,LOW(54)
	RCALL SUBOPT_0x1
; 0000 017A       SPI_SEND(SFRX); //Сброс буфера приема
	LDI  R30,LOW(58)
	RCALL SUBOPT_0x1
; 0000 017B       SPI_SEND(SFTX); //Сброс буфера передачи
	LDI  R30,LOW(59)
	RCALL SUBOPT_0x1
; 0000 017C       SPI_SEND(SRX);  //Переход в режим RX
	LDI  R30,LOW(52)
	RCALL SUBOPT_0x1
; 0000 017D         delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x5
; 0000 017E        LightDiode(1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4
; 0000 017F      // GIFR=0x80;   // Сброс флага прерывания
; 0000 0180      // GICR|=0x80;  //Разрешение прерывания по приему пакета
; 0000 0181 
; 0000 0182       /*
; 0000 0183         SPI_SEND(0x7F);
; 0000 0184       SPI_SEND(0x07);
; 0000 0185       SPI_SEND('S');
; 0000 0186       SPI_SEND('E');
; 0000 0187       SPI_SEND('X');
; 0000 0188       SPI_SEND('O');
; 0000 0189       SPI_SEND('N');
; 0000 018A       SPI_SEND('I');
; 0000 018B       SPI_SEND('X');
; 0000 018C       PORTB.2=1; // SPI_SS OFF
; 0000 018D 
; 0000 018E       PORTB.2=0; // SPI_SS ON
; 0000 018F       while(PORTB.4==1); //Ждем 0 на MISO
; 0000 0190       SPI_SEND(STX);
; 0000 0191             */
; 0000 0192       //STATUS[0]=READ_REG(0x04);
; 0000 0193       //STATUS[1]=READ_REG(0x05);
; 0000 0194                /*
; 0000 0195          LightDiode(0);
; 0000 0196       for (i=1;i<128;i++)
; 0000 0197        {
; 0000 0198          SPI_SEND(0xF4);
; 0000 0199          STATUS[i]=SPI_SEND(0xFF);
; 0000 019A          delay_ms(10);
; 0000 019B 
; 0000 019C 
; 0000 019D         }
; 0000 019E          SPI_SEND(0xFB);
; 0000 019F          STATUS[0]=SPI_SEND(0xFF);
; 0000 01A0       PORTB.2=1; // SPI_SS OFF
; 0000 01A1             LightDiode(1);
; 0000 01A2                   */
; 0000 01A3                 /*
; 0000 01A4 
; 0000 01A5       PORTB.2=0; // SPI_SS ON
; 0000 01A6       while(PORTB.4==1); //Ждем 0 на MISO
; 0000 01A7 
; 0000 01A8        for (i=0;i<37;i++)
; 0000 01A9        {
; 0000 01AA        data.buf=init[i];
; 0000 01AB         STATUS[i]=READ_REG(data.b[1]);
; 0000 01AC        }
; 0000 01AD 
; 0000 01AE       STATUS[0]=0xAA;
; 0000 01AF       STATUS[1]=READ_REG(0x3E);
; 0000 01B0       STATUS[2]=0xAA;
; 0000 01B1       STATUS[3]=SPI_SEND(SNOP);
; 0000 01B2       PORTB.2=1; // SPI_SS OFF
; 0000 01B3 
; 0000 01B4 
; 0000 01B5         // delay_ms(3000);
; 0000 01B6           LightDiode(1);
; 0000 01B7           PORTB.2=0; // SPI_SS ON
; 0000 01B8       while(PORTB.4==1); //Ждем 0 на MISO
; 0000 01B9           STATUS[5]=SPI_SEND(SNOP);
; 0000 01BA       PORTB.2=1; // SPI_SS OFF
; 0000 01BB 
; 0000 01BC        // LightDiode(0);
; 0000 01BD        // while(PORTB.0==0);
; 0000 01BE         // LightDiode(2);
; 0000 01BF         */
; 0000 01C0       GIFR=0x80;   // Сброс флага прерывания
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 01C1       GICR|=0x80;  //Разрешение прерывания по приему пакета
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 01C2      //PORTB.2=0; // SPI_SS ON
; 0000 01C3      // while(PORTB.4==1); //Ждем 0 на MISO
; 0000 01C4                  /*
; 0000 01C5       for (i=0;i<128;i++)
; 0000 01C6       { STATUS[i]=SPI_SEND(0xF4);
; 0000 01C7        delay_ms(1);}
; 0000 01C8                   */
; 0000 01C9 
; 0000 01CA        while(1);
_0x62:
	RJMP _0x62
; 0000 01CB 
; 0000 01CC        while(1)  {
_0x65:
; 0000 01CD                    if (PORTB.0==1){ LightDiode(2);
	SBIS 0x18,0
	RJMP _0x68
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x4
; 0000 01CE                        delay_ms(100);}
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x5
; 0000 01CF        else LightDiode(1);
	RJMP _0x69
_0x68:
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4
; 0000 01D0        }
_0x69:
	RJMP _0x65
; 0000 01D1 
; 0000 01D2       }
; 0000 01D3 }
_0x6A:
	RJMP _0x6A
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

	.ESEG
_STATUS:
	.BYTE 0x80

	.DSEG
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	RJMP _SPI_SEND

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	MOV  R30,R5
	LDI  R26,LOW(_init*2)
	LDI  R27,HIGH(_init*2)
	RCALL SUBOPT_0x0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	RJMP _LightDiode

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x3
	RJMP _delay_ms


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

;END OF CODE MARKER
__END_OF_CODE:
