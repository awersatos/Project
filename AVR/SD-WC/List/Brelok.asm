
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313A
;Program type             : Application
;Clock frequency          : 4,000000 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATtiny2313A
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
	.DEF _pktlen=R2
	.DEF _Error=R5

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
	RJMP _timer0_compa_isr
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

_0x3:
	.DB  0x42,0x52,0x45,0x4C,0x4F,0x4B,0x2D,0x53
	.DB  0x45,0x4E,0x44
_0x0:
	.DB  0x42,0x52,0x45,0x4C,0x4F,0x4B,0x0,0x44
	.DB  0x45,0x56,0x49,0x43,0x45,0x0,0x43,0x48
	.DB  0x41,0x4E,0x47,0x45,0x0,0x52,0x45,0x41
	.DB  0x44,0x0,0x53,0x74,0x61,0x74,0x75,0x73
	.DB  0x0,0x53,0x45,0x43,0x55,0x52,0x0,0x49
	.DB  0x44,0x4C,0x45,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  _SPI_buffer
	.DW  _0x3*2

	.DW  0x07
	.DW  _0x5C
	.DW  _0x0*2+7

	.DW  0x07
	.DW  _0x5C+7
	.DW  _0x0*2+26

	.DW  0x06
	.DW  _0x5C+14
	.DW  _0x0*2+33

	.DW  0x05
	.DW  _0x5C+20
	.DW  _0x0*2+39

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

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
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Brelok
;Version : 1
;Date    : 20.10.2011
;Author  : Alexandr Gordejchik
;Company : NTS
;Comments:
;
;
;Chip type               : ATtiny2313A
;AVR Core Clock frequency: 4,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;#include <tiny2313a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
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
;
;union U            //Объединение 2 переменных
;		{
;			unsigned int buf;
;			unsigned char b[2];
;		};
;                    /*ОБЪЯВЛЕНИЕ ГЛОБАЛЬНЫХ ПЕРЕМЕННЫХ*/
;unsigned char i; //Счетчик
;char SPI_buffer[32]={"BRELOK-SEND\x00"};  // Буффер обмена

	.DSEG
;//char SPI_buffer2[12];
;
;unsigned char pktlen;
;char Error; //Байт ошибки
;//eeprom char eebuffer[64];
;flash unsigned char CH=78; //Номер канала
;flash unsigned char SW=9; // Делитель частоты
;
;         // значения для инициализации кадра
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
;        // значения для инициализации передатчика               //   15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
;        flash unsigned char tbl_rfinit[54]  = {0x09,0x21,0x01,  //9   0  0  1  0  0  0 0 1 0 0 0 0 0 0 0 1
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
;//*******************************************************************************************
;void LightDiode(unsigned char n) // Функция управления светодиодом
; 0000 0065 {

	.CSEG
_LightDiode:
; 0000 0066  switch (n)
;	n -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x0
; 0000 0067  {
; 0000 0068  case 0:
	SBIW R30,0
	BRNE _0x7
; 0000 0069 			{
; 0000 006A 			PORTB.3=0;
	CBI  0x18,3
; 0000 006B             PORTB.4=0;
	CBI  0x18,4
; 0000 006C 				break;
	RJMP _0x6
; 0000 006D 			}
; 0000 006E  case 1:
_0x7:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC
; 0000 006F 			{
; 0000 0070 			PORTB.3=1;
	SBI  0x18,3
; 0000 0071             PORTB.4=0;
	CBI  0x18,4
; 0000 0072 				break;
	RJMP _0x6
; 0000 0073 			}
; 0000 0074  case 2:
_0xC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x11
; 0000 0075 			{
; 0000 0076 			PORTB.3=0;
	CBI  0x18,3
; 0000 0077             PORTB.4=1;
	RJMP _0x73
; 0000 0078 				break;
; 0000 0079  case 3:
_0x11:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6
; 0000 007A 			{
; 0000 007B 			PORTB.3=1;
	SBI  0x18,3
; 0000 007C             PORTB.4=1;
_0x73:
	SBI  0x18,4
; 0000 007D 				break;
; 0000 007E 			} 			}
; 0000 007F  }
_0x6:
; 0000 0080 
; 0000 0081 }
	RJMP _0x2080003
;//*********************************************************************************************
;// Функция передачи символа по SPI
;unsigned char SPI_SEND(unsigned char data)
; 0000 0085 {
_SPI_SEND:
; 0000 0086  USIDR=data;      // Загрузка данных в сдвиговый регистр
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 0087  USISR=(1<<USIOIF);  // Очистка флага переполнения и 4-битного счетчика
	LDI  R30,LOW(64)
	OUT  0xE,R30
; 0000 0088  TIFR |= (1<<OCF0A);   // Очистка флага прерывания по совпадению таймера
	IN   R30,0x38
	ORI  R30,1
	OUT  0x38,R30
; 0000 0089  TIMSK |= (1<<OCIE0A); // Разрешение прерывания по совпадению
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0000 008A  while(USISR.USIOIF==0); //Ожидание конца передачи байта
_0x1B:
	SBIS 0xE,6
	RJMP _0x1B
; 0000 008B  TIMSK=0x00;     //Запрет прерывания
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 008C  return USIDR; // Возврат данных
	IN   R30,0xF
_0x2080003:
	ADIW R28,1
	RET
; 0000 008D }
;//***********************************************************************************************
;//записать в регистр трансивера значение
;	void TR24_Wrtie(unsigned char reg,unsigned int data)
; 0000 0091 	{
_TR24_Wrtie:
; 0000 0092 
; 0000 0093        union U dat;
; 0000 0094 	  dat.buf=data;
	SBIW R28,2
;	reg -> Y+4
;	data -> Y+2
;	dat -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x1
; 0000 0095 
; 0000 0096 		PORTB.1=0;       // SPI_SS ON
	CBI  0x18,1
; 0000 0097 		SPI_SEND(reg);    //регистр
	LDD  R30,Y+4
	RCALL SUBOPT_0x2
; 0000 0098 		delay_us(2);
; 0000 0099 		SPI_SEND(dat.b[1]);   //старшая часть
	LDD  R30,Y+1
	RCALL SUBOPT_0x2
; 0000 009A 		delay_us(2);
; 0000 009B 		SPI_SEND(dat.b[0]);   //младшая часть
	LD   R30,Y
	RCALL SUBOPT_0x2
; 0000 009C 		delay_us(2);
; 0000 009D 		PORTB.1=1;     // SPI_SS OFF
	SBI  0x18,1
; 0000 009E 
; 0000 009F 	}//end writeByte
	ADIW R28,5
	RET
;//**********************************************************************************************
; //Чтение из регистра трансивера
;	unsigned int TR24A_Read(unsigned char reg)
; 0000 00A3 	{
_TR24A_Read:
; 0000 00A4 
; 0000 00A5            union U dat;
; 0000 00A6 		PORTB.1=0;       // SPI_SS ON
	SBIW R28,2
;	reg -> Y+2
;	dat -> Y+0
	CBI  0x18,1
; 0000 00A7 		SPI_SEND(reg |0x80);   //Старший бит определяет операцию
	LDD  R30,Y+2
	ORI  R30,0x80
	RCALL SUBOPT_0x2
; 0000 00A8 		delay_us(2);
; 0000 00A9 		dat.b[1]=SPI_SEND(0x0FF);
	RCALL SUBOPT_0x3
	STD  Y+1,R30
; 0000 00AA 		delay_us(2);
	__DELAY_USB 3
; 0000 00AB 		dat.b[0]=SPI_SEND(0x0FF);
	RCALL SUBOPT_0x3
	ST   Y,R30
; 0000 00AC 		delay_us(2);
	__DELAY_USB 3
; 0000 00AD 		PORTB.1=1;     // SPI_SS OFF
	SBI  0x18,1
; 0000 00AE 
; 0000 00AF 		return dat.buf;
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2080002
; 0000 00B0 	}//end readByte
;//*********************************************************************************************
;//Инициализация трансивера
;    void TR24A_INIT(void)
; 0000 00B4     {
_TR24A_INIT:
; 0000 00B5     	        union U dt;
; 0000 00B6                 /*
; 0000 00B7 		chanel=76;   //канал по умолчанию
; 0000 00B8 		swallow=9;    //делитель частоты по умолчанию
; 0000 00B9 		Error.byte=0; //обнулить все ошибки
; 0000 00BA 		ProgCRC=0;    //программное CRC выкл
; 0000 00BB 		TrState=0;    //предыдущей режим работы трансивера, необходимо для приема пакета
; 0000 00BC                   */
; 0000 00BD 	 unsigned char i;
; 0000 00BE 
; 0000 00BF 
; 0000 00C0 		for(i=0;i<30;i=i+3)				//инициализация кадра
	SBIW R28,2
	ST   -Y,R17
;	dt -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x27:
	CPI  R17,30
	BRSH _0x28
; 0000 00C1 		{
; 0000 00C2 			dt.b[1]=tbl_frame[i+1];
	RCALL SUBOPT_0x4
	__ADDW1FN _tbl_frame,1
	LPM  R0,Z
	STD  Y+2,R0
; 0000 00C3 			dt.b[0]=tbl_frame[i+2];
	RCALL SUBOPT_0x4
	__ADDW1FN _tbl_frame,2
	LPM  R0,Z
	STD  Y+1,R0
; 0000 00C4 			TR24_Wrtie(tbl_frame[i],dt.buf);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 00C5 		}
	SUBI R17,-LOW(3)
	RJMP _0x27
_0x28:
; 0000 00C6 
; 0000 00C7 		delay_ms(5);
	RCALL SUBOPT_0x7
; 0000 00C8 		for(i=0;i<54;i=i+3)		       //инициализация передатчика
	LDI  R17,LOW(0)
_0x2A:
	CPI  R17,54
	BRSH _0x2B
; 0000 00C9 		{
; 0000 00CA 			dt.b[1]=tbl_rfinit[i+1];
	RCALL SUBOPT_0x4
	__ADDW1FN _tbl_rfinit,1
	LPM  R0,Z
	STD  Y+2,R0
; 0000 00CB 			dt.b[0]=tbl_rfinit[i+2];
	RCALL SUBOPT_0x4
	__ADDW1FN _tbl_rfinit,2
	LPM  R0,Z
	STD  Y+1,R0
; 0000 00CC 			TR24_Wrtie(tbl_rfinit[i],dt.buf);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x6
; 0000 00CD 		}
	SUBI R17,-LOW(3)
	RJMP _0x2A
_0x2B:
; 0000 00CE            Error='N';
	LDI  R30,LOW(78)
	MOV  R5,R30
; 0000 00CF 		//Проверить правильность инициализации трансивера
; 0000 00D0 
; 0000 00D1 		for(i=0;i<54;i=i+3)
	LDI  R17,LOW(0)
_0x2D:
	CPI  R17,54
	BRSH _0x2E
; 0000 00D2 		{
; 0000 00D3 			dt.buf=TR24A_Read(tbl_rfinit[i]);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 00D4 
; 0000 00D5 			if(dt.b[1]!=tbl_rfinit[i+1])
	__ADDW1FN _tbl_rfinit,1
	LPM  R30,Z
	LDD  R26,Y+2
	CP   R30,R26
	BRNE _0x74
; 0000 00D6 			{
; 0000 00D7 				Error='E';
; 0000 00D8 			}
; 0000 00D9 			else if(dt.b[0]!=tbl_rfinit[i+2])
	RCALL SUBOPT_0x4
	__ADDW1FN _tbl_rfinit,2
	LPM  R30,Z
	LDD  R26,Y+1
	CP   R30,R26
	BREQ _0x31
; 0000 00DA 			{
; 0000 00DB 				Error='E';
_0x74:
	LDI  R30,LOW(69)
	MOV  R5,R30
; 0000 00DC 			}
; 0000 00DD 
; 0000 00DE 		}
_0x31:
	SUBI R17,-LOW(3)
	RJMP _0x2D
_0x2E:
; 0000 00DF 
; 0000 00E0 		for(i=0;i<30;i=i+3)
	LDI  R17,LOW(0)
_0x33:
	CPI  R17,30
	BRSH _0x34
; 0000 00E1 		{
; 0000 00E2 			dt.buf=TR24A_Read(tbl_frame[i]);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x9
; 0000 00E3 
; 0000 00E4 			if(dt.b[1]!=tbl_frame[i+1])
	__ADDW1FN _tbl_frame,1
	LPM  R30,Z
	LDD  R26,Y+2
	CP   R30,R26
	BRNE _0x75
; 0000 00E5 			{
; 0000 00E6 				Error='E';
; 0000 00E7 			}
; 0000 00E8 			else if(dt.b[0]!=tbl_frame[i+2])
	RCALL SUBOPT_0x4
	__ADDW1FN _tbl_frame,2
	LPM  R30,Z
	LDD  R26,Y+1
	CP   R30,R26
	BREQ _0x37
; 0000 00E9 			{
; 0000 00EA 				Error='E';
_0x75:
	LDI  R30,LOW(69)
	MOV  R5,R30
; 0000 00EB 			}
; 0000 00EC 		}
_0x37:
	SUBI R17,-LOW(3)
	RJMP _0x33
_0x34:
; 0000 00ED 
; 0000 00EE 	}//end init
	LDD  R17,Y+0
_0x2080002:
	ADIW R28,3
	RET
;//********************************************************************************************
;//перейти в режим передачи данніх
;	void TR24A_TX(void)
; 0000 00F2 	{
_TR24A_TX:
; 0000 00F3 		DATA buf;
; 0000 00F4 
; 0000 00F5 		buf.data=TR24A_Read(0x07);
	RCALL SUBOPT_0xA
;	buf -> Y+0
; 0000 00F6 		buf.byte[1]=(SW<<1);
; 0000 00F7 		buf.byte[0]=CH;
; 0000 00F8 		buf.Bit.b8=1;
	ORI  R30,1
	STD  Y+1,R30
; 0000 00F9 		buf.Bit.b7=0;
	LD   R30,Y
	ANDI R30,0x7F
	RCALL SUBOPT_0xB
; 0000 00FA 
; 0000 00FB 		TR24_Wrtie(0x07,buf.data);
; 0000 00FC 
; 0000 00FD 	}//end TransmitMode
	RJMP _0x2080001
;//********************************************************************************************
;
;//Режим приема данных
;	void TR24A_RX(void)
; 0000 0102 	{
_TR24A_RX:
; 0000 0103 		DATA buf;
; 0000 0104 
; 0000 0105 
; 0000 0106 		buf.data=TR24A_Read(0x07);
	RCALL SUBOPT_0xA
;	buf -> Y+0
; 0000 0107 		buf.byte[1]=(SW<<1);
; 0000 0108 		buf.byte[0]=CH;
; 0000 0109 		buf.Bit.b8=0;
	ANDI R30,0xFE
	STD  Y+1,R30
; 0000 010A 		buf.Bit.b7=1;
	LD   R30,Y
	ORI  R30,0x80
	RCALL SUBOPT_0xB
; 0000 010B 
; 0000 010C 		TR24_Wrtie(0x07,buf.data);  // переход в режим RX, задаем канал
; 0000 010D 		delay_us(10);
	__DELAY_USB 13
; 0000 010E 
; 0000 010F 	}//end ReciveMode
	RJMP _0x2080001
;//********************************************************************************************
;//Прием пакта
;  unsigned char TR24A_RXPKT(void)
; 0000 0113   {
_TR24A_RXPKT:
; 0000 0114    unsigned char len; //Длинна пакета
; 0000 0115    unsigned char j;   //Счетчик
; 0000 0116 
; 0000 0117   PORTB.1=0;       // SPI_SS ON
	RCALL __SAVELOCR2
;	len -> R17
;	j -> R16
	CBI  0x18,1
; 0000 0118 
; 0000 0119   SPI_SEND(0x50|(1<<7));   //reg80
	LDI  R30,LOW(208)
	RCALL SUBOPT_0xC
; 0000 011A   delay_us(3);
; 0000 011B   len=SPI_SEND(0xFF);
	RCALL SUBOPT_0x3
	MOV  R17,R30
; 0000 011C   for(j=0;j<len;j++)  //получить пакет
	LDI  R16,LOW(0)
_0x3B:
	CP   R16,R17
	BRSH _0x3C
; 0000 011D 		{
; 0000 011E 			delay_us(3);
	RCALL SUBOPT_0xD
; 0000 011F 			SPI_buffer[j] = SPI_SEND(0xFF);
	MOV  R30,R16
	SUBI R30,-LOW(_SPI_buffer)
	PUSH R30
	RCALL SUBOPT_0x3
	POP  R26
	ST   X,R30
; 0000 0120 		}
	SUBI R16,-1
	RJMP _0x3B
_0x3C:
; 0000 0121 
; 0000 0122   PORTB.1=1;     // SPI_SS OFF
	SBI  0x18,1
; 0000 0123   return len;
	MOV  R30,R17
	RCALL __LOADLOCR2P
	RET
; 0000 0124   }
;
;
;//*********************************************************************************************
; //Передача пакета
; void TR24A_TXPKT(void)
; 0000 012A  {
_TR24A_TXPKT:
; 0000 012B       TR24_Wrtie(0x52,0x8000); // Сброс буффера
	LDI  R30,LOW(82)
	ST   -Y,R30
	LDI  R30,LOW(32768)
	LDI  R31,HIGH(32768)
	RCALL SUBOPT_0xE
	RCALL _TR24_Wrtie
; 0000 012C 
; 0000 012D       PORTB.1=0;       // SPI_SS ON
	CBI  0x18,1
; 0000 012E       delay_us(3);
	RCALL SUBOPT_0xD
; 0000 012F       SPI_SEND(0x50);
	LDI  R30,LOW(80)
	RCALL SUBOPT_0xC
; 0000 0130       delay_us(3);
; 0000 0131       SPI_SEND(pktlen);
	ST   -Y,R2
	RCALL _SPI_SEND
; 0000 0132       for (i=0;i<pktlen;i++)
	CLR  R3
_0x42:
	CP   R3,R2
	BRSH _0x43
; 0000 0133      {
; 0000 0134        delay_us(3);
	RCALL SUBOPT_0xD
; 0000 0135       SPI_SEND(SPI_buffer[i]);
	LDI  R26,LOW(_SPI_buffer)
	ADD  R26,R3
	LD   R30,X
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 0136     };
	INC  R3
	RJMP _0x42
_0x43:
; 0000 0137 
; 0000 0138       PORTB.1=1;       // SPI_SS OFF
	SBI  0x18,1
; 0000 0139       TR24A_TX();
	RCALL _TR24A_TX
; 0000 013A       delay_us(3);
	RCALL SUBOPT_0xD
; 0000 013B  }
	RET
;//********************************************************************************************
; // Запись строки в SPI буффер
; void Write_SPI_buffer(flash char *str)
; 0000 013F  {
_Write_SPI_buffer:
; 0000 0140   i=0;
;	*str -> Y+0
	CLR  R3
; 0000 0141   while(*str)
_0x46:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x48
; 0000 0142   {
; 0000 0143   SPI_buffer[i++]=*str++;
	MOV  R30,R3
	INC  R3
	SUBI R30,-LOW(_SPI_buffer)
	MOV  R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	RCALL SUBOPT_0x1
	SBIW R30,1
	LPM  R30,Z
	ST   X,R30
; 0000 0144 
; 0000 0145   }
	RJMP _0x46
_0x48:
; 0000 0146   pktlen=i;
	MOV  R2,R3
; 0000 0147  }
	RJMP _0x2080001
;//********************************************************************************************
;// Прерывание по совпадению таймера
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)
; 0000 014B {
_timer0_compa_isr:
; 0000 014C USICR |= (1<<USITC); // Задание тактового импульса
	SBI  0xD,0
; 0000 014D 
; 0000 014E }
	RETI
;//***********************************************************************************************
;
;// Declare your global variables here
;
;void main(void)
; 0000 0154 {
_main:
; 0000 0155 // Declare your local variables here
; 0000 0156 
; 0000 0157 // Crystal Oscillator division factor: 1
; 0000 0158 #pragma optsize-
; 0000 0159 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 015A CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 015B #ifdef _OPTIMIZE_SIZE_
; 0000 015C #pragma optsize+
; 0000 015D #endif
; 0000 015E 
; 0000 015F // Input/Output Ports initialization
; 0000 0160 // Port A initialization
; 0000 0161 // Func2=In Func1=In Func0=In
; 0000 0162 // State2=T State1=T State0=T
; 0000 0163 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0164 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0165 
; 0000 0166 // Port B initialization
; 0000 0167 // Func7=Out Func6=Out Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0000 0168 // State7=0 State6=0 State5=T State4=0 State3=0 State2=1 State1=1 State0=T
; 0000 0169 PORTB=0x06;
	LDI  R30,LOW(6)
	OUT  0x18,R30
; 0000 016A DDRB=0xDE;
	LDI  R30,LOW(222)
	OUT  0x17,R30
; 0000 016B 
; 0000 016C // Port D initialization
; 0000 016D // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 016E // State6=T State5=T State4=T State3=P State2=P State1=T State0=T
; 0000 016F PORTD=0x0C;
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 0170 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0171 
; 0000 0172 // Timer/Counter 0 initialization
; 0000 0173 // Clock source: System Clock
; 0000 0174 // Clock value: 4000,000 kHz
; 0000 0175 // Mode: Normal top=0xFF
; 0000 0176 // OC0A output: Disconnected
; 0000 0177 // OC0B output: Disconnected
; 0000 0178 TCCR0A=0x00;
	OUT  0x30,R30
; 0000 0179 TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 017A TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 017B OCR0A=0x1F;
	LDI  R30,LOW(31)
	OUT  0x36,R30
; 0000 017C OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 017D 
; 0000 017E // Timer/Counter 1 initialization
; 0000 017F // Clock source: System Clock
; 0000 0180 // Clock value: Timer1 Stopped
; 0000 0181 // Mode: Normal top=0xFFFF
; 0000 0182 // OC1A output: Discon.
; 0000 0183 // OC1B output: Discon.
; 0000 0184 // Noise Canceler: Off
; 0000 0185 // Input Capture on Falling Edge
; 0000 0186 // Timer1 Overflow Interrupt: Off
; 0000 0187 // Input Capture Interrupt: Off
; 0000 0188 // Compare A Match Interrupt: Off
; 0000 0189 // Compare B Match Interrupt: Off
; 0000 018A TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 018B TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 018C TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 018D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 018E ICR1H=0x00;
	OUT  0x25,R30
; 0000 018F ICR1L=0x00;
	OUT  0x24,R30
; 0000 0190 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0191 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0192 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0193 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0194 
; 0000 0195 // External Interrupt(s) initialization
; 0000 0196 // INT0: Off
; 0000 0197 // INT1: Off
; 0000 0198 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0199 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 019A MCUCR=0x00;
	OUT  0x35,R30
; 0000 019B 
; 0000 019C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 019D TIMSK=0x00;
	OUT  0x39,R30
; 0000 019E 
; 0000 019F // Universal Serial Interface initialization
; 0000 01A0 // Mode: Three Wire (SPI)
; 0000 01A1 // Clock source: Reg.=ext. neg. edge, Cnt.=USITC
; 0000 01A2 // USI Counter Overflow Interrupt: Off
; 0000 01A3 USICR=0x1E;
	LDI  R30,LOW(30)
	OUT  0xD,R30
; 0000 01A4 
; 0000 01A5 // USART initialization
; 0000 01A6 // USART disabled
; 0000 01A7 UCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 01A8 
; 0000 01A9 // Analog Comparator initialization
; 0000 01AA // Analog Comparator: Off
; 0000 01AB // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01AC ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AD DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 01AE 
; 0000 01AF // Global enable interrupts
; 0000 01B0 #asm("sei")
	sei
; 0000 01B1 //============================================================================================
; 0000 01B2 //*************************АКТИВАЦИЯ ТРАНСИВЕРА**********************************************
; 0000 01B3   LightDiode(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 01B4     delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0xF
; 0000 01B5   mx0:    PORTB.1=0;      // Сброс трансивера перед инициализацией
_0x49:
	CBI  0x18,1
; 0000 01B6       delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0xF
; 0000 01B7       PORTB.1=1;
	SBI  0x18,1
; 0000 01B8       delay_ms(5);
	RCALL SUBOPT_0x7
; 0000 01B9        TR24A_INIT();  // Инициализация трансивера
	RCALL _TR24A_INIT
; 0000 01BA        if(Error=='E') goto mx0;   // Если инициализация ошибочна возврат к сбросу
	LDI  R30,LOW(69)
	CP   R30,R5
	BREQ _0x49
; 0000 01BB 
; 0000 01BC      //LightDiode(0);
; 0000 01BD 
; 0000 01BE //=============================================================================================
; 0000 01BF while (1)
; 0000 01C0       {
; 0000 01C1  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0000 01C2 
; 0000 01C3   Write_SPI_buffer("BRELOK");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0xE
	RCALL _Write_SPI_buffer
; 0000 01C4    TR24A_TXPKT() ;
	RCALL _TR24A_TXPKT
; 0000 01C5     for (i=0;i<25;i++)
	CLR  R3
_0x53:
	RCALL SUBOPT_0x10
	BRSH _0x54
; 0000 01C6     {
; 0000 01C7      if(PINB.0==1) break;
	SBIC 0x16,0
	RJMP _0x54
; 0000 01C8      delay_ms(1);
	RCALL SUBOPT_0x11
; 0000 01C9     };
	INC  R3
	RJMP _0x53
_0x54:
; 0000 01CA 
; 0000 01CB  //  while(PINB.0==0);
; 0000 01CC 
; 0000 01CD    TR24A_RX();
	RCALL _TR24A_RX
; 0000 01CE    for (i=0;i<25;i++)
	CLR  R3
_0x57:
	RCALL SUBOPT_0x10
	BRSH _0x58
; 0000 01CF     {
; 0000 01D0      if(PINB.0==1) break;
	SBIC 0x16,0
	RJMP _0x58
; 0000 01D1      delay_ms(1);
	RCALL SUBOPT_0x11
; 0000 01D2     };
	INC  R3
	RJMP _0x57
_0x58:
; 0000 01D3 
; 0000 01D4      if(PINB.0==1)
	SBIS 0x16,0
	RJMP _0x5A
; 0000 01D5      {  pktlen=TR24A_RXPKT();
	RCALL _TR24A_RXPKT
	MOV  R2,R30
; 0000 01D6       if (strstr(SPI_buffer,"DEVICE")!=NULL)
	RCALL SUBOPT_0x12
	__POINTB1MN _0x5C,0
	RCALL SUBOPT_0x13
	BREQ _0x5B
; 0000 01D7    {
; 0000 01D8 
; 0000 01D9  //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 0000 01DA 
; 0000 01DB   if(PIND.2==0) Write_SPI_buffer("CHANGE");
	SBIC 0x10,2
	RJMP _0x5D
	__POINTW1FN _0x0,14
	RJMP _0x76
; 0000 01DC   /* if(PIND.3==0)*/ else Write_SPI_buffer("READ");
_0x5D:
	__POINTW1FN _0x0,21
_0x76:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write_SPI_buffer
; 0000 01DD 
; 0000 01DE   TR24A_TXPKT() ;
	RCALL _TR24A_TXPKT
; 0000 01DF 
; 0000 01E0    for (i=0;i<25;i++)
	CLR  R3
_0x60:
	RCALL SUBOPT_0x10
	BRSH _0x61
; 0000 01E1     {
; 0000 01E2      if(PINB.0==1) break;
	SBIC 0x16,0
	RJMP _0x61
; 0000 01E3      delay_ms(1);
	RCALL SUBOPT_0x11
; 0000 01E4     };
	INC  R3
	RJMP _0x60
_0x61:
; 0000 01E5  // while(PINB.0==0);
; 0000 01E6 
; 0000 01E7    TR24A_RX();
	RCALL _TR24A_RX
; 0000 01E8     for (i=0;i<25;i++)
	CLR  R3
_0x64:
	RCALL SUBOPT_0x10
	BRSH _0x65
; 0000 01E9     {
; 0000 01EA      if(PINB.0==1) break;
	SBIC 0x16,0
	RJMP _0x65
; 0000 01EB      delay_ms(1);
	RCALL SUBOPT_0x11
; 0000 01EC     };
	INC  R3
	RJMP _0x64
_0x65:
; 0000 01ED 
; 0000 01EE      if(PINB.0==1)
	SBIS 0x16,0
	RJMP _0x67
; 0000 01EF    {
; 0000 01F0   // delay_ms(6);
; 0000 01F1       pktlen=TR24A_RXPKT();
	RCALL _TR24A_RXPKT
	MOV  R2,R30
; 0000 01F2      if(pktlen!=0)
	TST  R2
	BREQ _0x68
; 0000 01F3   {
; 0000 01F4 
; 0000 01F5      if (strstr(SPI_buffer,"Status")!=NULL)
	RCALL SUBOPT_0x12
	__POINTB1MN _0x5C,7
	RCALL SUBOPT_0x13
	BREQ _0x69
; 0000 01F6      {
; 0000 01F7       if(strstr(SPI_buffer,"SECUR")!=NULL) { LightDiode(2);
	RCALL SUBOPT_0x12
	__POINTB1MN _0x5C,14
	RCALL SUBOPT_0x13
	BREQ _0x6A
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 01F8                                             while(1);
_0x6B:
	RJMP _0x6B
; 0000 01F9                                             }
; 0000 01FA 
; 0000 01FB         if(strstr(SPI_buffer,"IDLE")!=NULL) { LightDiode(1);
_0x6A:
	RCALL SUBOPT_0x12
	__POINTB1MN _0x5C,20
	RCALL SUBOPT_0x13
	BREQ _0x6E
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 01FC                                             while(1);
_0x6F:
	RJMP _0x6F
; 0000 01FD                                             }
; 0000 01FE      }
_0x6E:
; 0000 01FF      }
_0x69:
; 0000 0200           }
_0x68:
; 0000 0201 //+++++++++++
; 0000 0202 
; 0000 0203    }
_0x67:
; 0000 0204  }
_0x5B:
; 0000 0205 
; 0000 0206  //+++++++++++++
; 0000 0207      // delay_ms(100);
; 0000 0208       goto mx0;
_0x5A:
	RJMP _0x49
; 0000 0209       }
; 0000 020A 
; 0000 020B }
_0x72:
	RJMP _0x72

	.DSEG
_0x5C:
	.BYTE 0x19

	.CSEG
_strstr:
    ldd  r26,y+1
    clr  r27
    mov  r24,r26
strstr0:
    ld   r30,y
    clr  r31
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    mov  r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    inc  r24
    mov  r26,r24
    tst  r22
    brne strstr0
    clr  r30
strstr3:
_0x2080001:
	ADIW R28,2
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_SPI_buffer:
	.BYTE 0x20
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	RCALL _SPI_SEND
	__DELAY_USB 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(255)
	ST   -Y,R30
	RJMP _SPI_SEND

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	MOV  R30,R17
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_tbl_frame*2)
	SBCI R31,HIGH(-_tbl_frame*2)
	LPM  R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP _TR24_Wrtie

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	SUBI R30,LOW(-_tbl_rfinit*2)
	SBCI R31,HIGH(-_tbl_rfinit*2)
	LPM  R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL _TR24A_Read
	STD  Y+1,R30
	STD  Y+1+1,R31
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	SBIW R28,2
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _TR24A_Read
	RCALL SUBOPT_0x1
	LDI  R30,LOW(18)
	STD  Y+1,R30
	LDI  R30,LOW(78)
	ST   Y,R30
	LDD  R30,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	ST   Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	RJMP _TR24_Wrtie

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	RCALL _SPI_SEND
	__DELAY_USB 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	__DELAY_USB 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xE
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(25)
	CP   R3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_SPI_buffer)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	ST   -Y,R30
	RCALL _strstr
	CPI  R30,0
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x3E8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

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
