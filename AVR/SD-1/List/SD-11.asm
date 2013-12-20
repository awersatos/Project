
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 3,686400 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

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
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R3
	.DEF _j=R2
	.DEF _rdata=R5
	.DEF _rx_wr_index=R4
	.DEF _rx_rd_index=R7
	.DEF _rx_counter=R6

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

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
	RJMP _usart_rx_isr
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

_csms2:
	.DB  0x2C,0x31,0x34,0x35,0x0
_nsms:
	.DB  0x41,0x54,0x2B,0x43,0x4D,0x47,0x53,0x3D
	.DB  0x0
_tsms:
	.DB  0x44,0x4F,0x4F,0x52,0x20,0x4F,0x50,0x45
	.DB  0x4E
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : SD-1
;Version : 001
;Date    : 27.06.2011
;Author  : Alexandr Gordejchik
;Company : NTS
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 3,686400 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#define CR 0xD
;#define LF 0xA
;#define ctrl_Z 0x1A
;flash char msms[]="AT+CMGF=1";
;//flash char csmp[]="AT+CSMP=17,167,0,0"  ;
;// ���������� � ������������� ������� ����� ������
;//flash char csms[]="AT+CSCA=" ;
;//flash char csms1[]="+79037011111";
;flash char csms2[]=",145" ;
;flash char nsms[]="AT+CMGS=";
;eeprom char nsms1[12] ;
;flash char get[]="AT+CPBF=" ;
;// ���������� � ������������� ������� ������ SMS
;flash char tsms[]={0x44,0x4F,0x4F,0x52,0x20,0x4F,0x50,0x45,0x4E};
;eeprom char eebuffer[72];
;flash char off[]="AT+QPOWD=1";
;unsigned char i;
;unsigned char j;
;char rdata;
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
;#define RX_BUFFER_SIZE 72
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;//***********************************************************************************************************
;void UART_Transmit(char data)
; 0000 005C {

	.CSEG
_UART_Transmit:
; 0000 005D while (!(UCSRA & (1<<UDRE))) {};
;	data -> Y+0
_0x3:
	SBIS 0xB,5
	RJMP _0x3
; 0000 005E UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 005F }
	ADIW R28,1
	RET
;//************************************************************************************************************
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0066 {
_getchar:
; 0000 0067 char data;
; 0000 0068 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R6
	BREQ _0x6
; 0000 0069 data=rx_buffer[rx_rd_index++];
	MOV  R30,R7
	INC  R7
	SUBI R30,-LOW(_rx_buffer)
	LD   R17,Z
; 0000 006A #if RX_BUFFER_SIZE != 256
; 0000 006B if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(72)
	CP   R30,R7
	BRNE _0x9
	CLR  R7
; 0000 006C #endif
; 0000 006D #asm("cli")
_0x9:
	cli
; 0000 006E --rx_counter;
	DEC  R6
; 0000 006F #asm("sei")
	sei
; 0000 0070 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0071 }
;#pragma used-
;#endif
;//***********************************************************************************************************
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0077 {
_ext_int1_isr:
; 0000 0078 // Place your code here
; 0000 0079 
; 0000 007A }
	RETI
;
;//************************************************************************************************************
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 007F {
_usart_rx_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0080 char status,data;
; 0000 0081 status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0082 data=UDR;
	IN   R16,12
; 0000 0083 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xA
; 0000 0084    {
; 0000 0085    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R4
	INC  R4
	SUBI R30,-LOW(_rx_buffer)
	ST   Z,R16
; 0000 0086 #if RX_BUFFER_SIZE == 256
; 0000 0087    // special case for receiver buffer size=256
; 0000 0088    if (++rx_counter == 0)
; 0000 0089       {
; 0000 008A #else
; 0000 008B    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(72)
	CP   R30,R4
	BRNE _0xB
	CLR  R4
; 0000 008C    if (++rx_counter == RX_BUFFER_SIZE)
_0xB:
	INC  R6
	LDI  R30,LOW(72)
	CP   R30,R6
	BRNE _0xC
; 0000 008D       {
; 0000 008E       rx_counter=0;
	CLR  R6
; 0000 008F #endif
; 0000 0090       rx_buffer_overflow=1;
	SBI  0x13,0
; 0000 0091       }
; 0000 0092    }
_0xC:
; 0000 0093 }
_0xA:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;//************************************************************************************************************
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 009C {
_main:
; 0000 009D // Declare your local variables here
; 0000 009E 
; 0000 009F // Crystal Oscillator division factor: 1
; 0000 00A0 #pragma optsize-
; 0000 00A1 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00A2 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00A3 #ifdef _OPTIMIZE_SIZE_
; 0000 00A4 #pragma optsize+
; 0000 00A5 #endif
; 0000 00A6 
; 0000 00A7 // Input/Output Ports initialization
; 0000 00A8 // Port A initialization
; 0000 00A9 // Func2=In Func1=In Func0=In
; 0000 00AA // State2=T State1=T State0=T
; 0000 00AB PORTA=0x00;
	OUT  0x1B,R30
; 0000 00AC DDRA=0x00;
	OUT  0x1A,R30
; 0000 00AD 
; 0000 00AE // Port B initialization
; 0000 00AF // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=Out
; 0000 00B0 // State7=T State6=T State5=T State4=0 State3=0 State2=T State1=T State0=1
; 0000 00B1 PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 00B2 DDRB=0x19;
	LDI  R30,LOW(25)
	OUT  0x17,R30
; 0000 00B3 
; 0000 00B4 // Port D initialization
; 0000 00B5 // Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 00B6 // State6=0 State5=T State4=0 State3=P State2=P State1=T State0=T
; 0000 00B7 PORTD=0x0C;
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 00B8 DDRD=0x50;
	LDI  R30,LOW(80)
	OUT  0x11,R30
; 0000 00B9 
; 0000 00BA // Timer/Counter 0 initialization
; 0000 00BB // Clock source: System Clock
; 0000 00BC // Clock value: Timer 0 Stopped
; 0000 00BD // Mode: Normal top=0xFF
; 0000 00BE // OC0A output: Disconnected
; 0000 00BF // OC0B output: Disconnected
; 0000 00C0 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00C1 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 00C2 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00C3 OCR0A=0x00;
	OUT  0x36,R30
; 0000 00C4 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00C5 
; 0000 00C6 // Timer/Counter 1 initialization
; 0000 00C7 // Clock source: System Clock
; 0000 00C8 // Clock value: Timer1 Stopped
; 0000 00C9 // Mode: Normal top=0xFFFF
; 0000 00CA // OC1A output: Discon.
; 0000 00CB // OC1B output: Discon.
; 0000 00CC // Noise Canceler: Off
; 0000 00CD // Input Capture on Falling Edge
; 0000 00CE // Timer1 Overflow Interrupt: Off
; 0000 00CF // Input Capture Interrupt: Off
; 0000 00D0 // Compare A Match Interrupt: Off
; 0000 00D1 // Compare B Match Interrupt: Off
; 0000 00D2 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00D3 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00D4 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00D5 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00D6 ICR1H=0x00;
	OUT  0x25,R30
; 0000 00D7 ICR1L=0x00;
	OUT  0x24,R30
; 0000 00D8 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D9 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00DA OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00DB OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00DC 
; 0000 00DD // External Interrupt(s) initialization
; 0000 00DE // INT0: Off
; 0000 00DF // INT1: On
; 0000 00E0 // INT1 Mode: Low level
; 0000 00E1 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00E2 GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 00E3 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00E4 EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 00E5 
; 0000 00E6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E7 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00E8 
; 0000 00E9 // Universal Serial Interface initialization
; 0000 00EA // Mode: Disabled
; 0000 00EB // Clock source: Register & Counter=no clk.
; 0000 00EC // USI Counter Overflow Interrupt: Off
; 0000 00ED USICR=0x00;
	OUT  0xD,R30
; 0000 00EE 
; 0000 00EF // USART initialization
; 0000 00F0 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00F1 // USART Receiver: On
; 0000 00F2 // USART Transmitter: On
; 0000 00F3 // USART Mode: Asynchronous
; 0000 00F4 // USART Baud Rate: 9600
; 0000 00F5 UCSRA=0x00;
	OUT  0xB,R30
; 0000 00F6 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00F7 UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 00F8 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00F9 UBRRL=0x17;
	LDI  R30,LOW(23)
	OUT  0x9,R30
; 0000 00FA 
; 0000 00FB // Analog Comparator initialization
; 0000 00FC // Analog Comparator: Off
; 0000 00FD // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00FE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00FF DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0100 
; 0000 0101 // Global enable interrupts
; 0000 0102 #asm("sei")
	sei
; 0000 0103  // PORTB.3=1;
; 0000 0104 while (1)
; 0000 0105  {
; 0000 0106       // Place your code here
; 0000 0107       PORTB.3=0;
	CBI  0x18,3
; 0000 0108 PORTB.4=1;
	SBI  0x18,4
; 0000 0109 //while(PIND.2==0);
; 0000 010A 
; 0000 010B PORTB.0=0;
	CBI  0x18,0
; 0000 010C PORTD.6=0;
	CBI  0x12,6
; 0000 010D delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x0
; 0000 010E PORTB.0=1;
	SBI  0x18,0
; 0000 010F //PORTD.4=0;
; 0000 0110 //while(PIND.5==1) {};
; 0000 0111 PORTB.4=0;
	CBI  0x18,4
; 0000 0112 delay_ms(9000);
	LDI  R30,LOW(9000)
	LDI  R31,HIGH(9000)
	RCALL SUBOPT_0x0
; 0000 0113  #asm("sei")
	sei
; 0000 0114 m1:    UART_Transmit('a');
_0x1E:
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x1
; 0000 0115     UART_Transmit('t');
	LDI  R30,LOW(116)
	RCALL SUBOPT_0x1
; 0000 0116     UART_Transmit(CR);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x1
; 0000 0117      goto m1;
	RJMP _0x1E
; 0000 0118 
; 0000 0119     delay_ms(3000) ;
; 0000 011A       for (i=0; i<72; i++)
_0x20:
	LDI  R30,LOW(72)
	CP   R3,R30
	BRSH _0x21
; 0000 011B  {eebuffer[i]=rx_buffer[i];}
	RCALL SUBOPT_0x2
	INC  R3
	RJMP _0x20
_0x21:
; 0000 011C   PORTB.3=1;
	SBI  0x18,3
; 0000 011D 
; 0000 011E   while(1);
_0x24:
	RJMP _0x24
; 0000 011F 
; 0000 0120     while(!((rdata=='O') || (rdata=='o')))
_0x27:
	LDI  R30,LOW(79)
	CP   R30,R5
	BREQ _0x2A
	LDI  R30,LOW(111)
	CP   R30,R5
	BRNE _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 0121     {rdata=getchar();}
	RCALL _getchar
	MOV  R5,R30
	RJMP _0x27
_0x29:
; 0000 0122     while(!((rdata=='K') || (rdata=='k')))
_0x2C:
	LDI  R30,LOW(75)
	CP   R30,R5
	BREQ _0x2F
	LDI  R30,LOW(107)
	CP   R30,R5
	BRNE _0x30
_0x2F:
	RJMP _0x2E
_0x30:
; 0000 0123     {rdata=getchar();}
	RCALL _getchar
	MOV  R5,R30
	RJMP _0x2C
_0x2E:
; 0000 0124    delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 0125 
; 0000 0126      for (i=0; i<72; i++)
	CLR  R3
_0x32:
	LDI  R30,LOW(72)
	CP   R3,R30
	BRSH _0x33
; 0000 0127  {eebuffer[i]=rx_buffer[i];}
	RCALL SUBOPT_0x2
	INC  R3
	RJMP _0x32
_0x33:
; 0000 0128   PORTB.3=1;
	SBI  0x18,3
; 0000 0129   while(1);
_0x36:
	RJMP _0x36
; 0000 012A      /*
; 0000 012B    for (i=0; i<9; i++)
; 0000 012C  {UART_Transmit(msms[i]);}
; 0000 012D  UART_Transmit(CR);
; 0000 012E 
; 0000 012F delay_ms(6000);
; 0000 0130 
; 0000 0131 
; 0000 0132 for (i=0; i<8; i++)
; 0000 0133  {UART_Transmit(get[i]);}
; 0000 0134   UART_Transmit(0x22);
; 0000 0135    UART_Transmit(0x30);
; 0000 0136    // UART_Transmit('e');
; 0000 0137     //UART_Transmit('t');
; 0000 0138     UART_Transmit(0x22);
; 0000 0139   UART_Transmit(CR);
; 0000 013A   rx_wr_index=0;
; 0000 013B   delay_ms(4000);
; 0000 013C 
; 0000 013D 
; 0000 013E 
; 0000 013F   i=0;
; 0000 0140   while(rdata!=',')
; 0000 0141   {rdata=rx_buffer[i++];}
; 0000 0142   rdata=rx_buffer[i++];
; 0000 0143 
; 0000 0144   if (rdata==0x22)
; 0000 0145   {for (j=0; j<12; j++){nsms1[j]=rx_buffer[i++];}}
; 0000 0146 
; 0000 0147 for (i=0; i<8; i++)
; 0000 0148  {UART_Transmit(csms[i]);}
; 0000 0149   UART_Transmit(0x22);
; 0000 014A  for (i=0; i<12; i++)
; 0000 014B  {UART_Transmit(csms1[i]);}
; 0000 014C  UART_Transmit(0x22);
; 0000 014D  for (i=0; i<4; i++)
; 0000 014E  {UART_Transmit(csms2[i]);}
; 0000 014F   UART_Transmit(CR); */
; 0000 0150 
; 0000 0151   delay_ms(200);
; 0000 0152  for (i=0; i<8; i++)
_0x3A:
	LDI  R30,LOW(8)
	CP   R3,R30
	BRSH _0x3B
; 0000 0153  {UART_Transmit(nsms[i]);}
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_nsms*2)
	SBCI R31,HIGH(-_nsms*2)
	LPM  R30,Z
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x3A
_0x3B:
; 0000 0154    UART_Transmit(0x22);
	LDI  R30,LOW(34)
	RCALL SUBOPT_0x1
; 0000 0155   for (i=0; i<12; i++)
	CLR  R3
_0x3D:
	LDI  R30,LOW(12)
	CP   R3,R30
	BRSH _0x3E
; 0000 0156  {UART_Transmit(nsms1[i]);}
	MOV  R26,R3
	LDI  R27,0
	SUBI R26,LOW(-_nsms1)
	SBCI R27,HIGH(-_nsms1)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x3D
_0x3E:
; 0000 0157   UART_Transmit(0x22);
	LDI  R30,LOW(34)
	RCALL SUBOPT_0x1
; 0000 0158  for (i=0; i<4; i++)
	CLR  R3
_0x40:
	LDI  R30,LOW(4)
	CP   R3,R30
	BRSH _0x41
; 0000 0159  {UART_Transmit(csms2[i]);}
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_csms2*2)
	SBCI R31,HIGH(-_csms2*2)
	LPM  R30,Z
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x40
_0x41:
; 0000 015A  UART_Transmit(CR);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x1
; 0000 015B   delay_ms(200);
	RCALL SUBOPT_0x3
; 0000 015C 
; 0000 015D  for (i=0; i<9; i++)
	CLR  R3
_0x43:
	LDI  R30,LOW(9)
	CP   R3,R30
	BRSH _0x44
; 0000 015E   {UART_Transmit(tsms[i]);}
	RCALL SUBOPT_0x4
	SUBI R30,LOW(-_tsms*2)
	SBCI R31,HIGH(-_tsms*2)
	LPM  R30,Z
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x43
_0x44:
; 0000 015F 
; 0000 0160 
; 0000 0161    delay_ms(4000);
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	RCALL SUBOPT_0x0
; 0000 0162  UART_Transmit(ctrl_Z);
	LDI  R30,LOW(26)
	RCALL SUBOPT_0x1
; 0000 0163 
; 0000 0164 
; 0000 0165 
; 0000 0166  // #asm("cli")
; 0000 0167  /*for (i=0; i<10; i++)
; 0000 0168  {UART_Transmit(off[i]);}
; 0000 0169   UART_Transmit(CR);
; 0000 016A  delay_ms(1000);   */
; 0000 016B /* for (i=0; i<72; i++)
; 0000 016C  {eebuffer[i]=rx_buffer[i];}
; 0000 016D   PORTB.3=1;  */
; 0000 016E 
; 0000 016F     while(1);
_0x45:
	RJMP _0x45
; 0000 0170 
; 0000 0171  // while(PIND.2==1);
; 0000 0172    //delay_ms(4500);
; 0000 0173   // while(PIND.2==1);
; 0000 0174       }
; 0000 0175 }
_0x48:
	RJMP _0x48
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.ESEG
_nsms1:
	.BYTE 0xC
_eebuffer:
	.BYTE 0x48

	.DSEG
_rx_buffer:
	.BYTE 0x48

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	RJMP _UART_Transmit

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	MOV  R30,R3
	LDI  R31,0
	SUBI R30,LOW(-_eebuffer)
	SBCI R31,HIGH(-_eebuffer)
	MOVW R0,R30
	LDI  R26,LOW(_rx_buffer)
	ADD  R26,R3
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	MOV  R30,R3
	LDI  R31,0
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

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
