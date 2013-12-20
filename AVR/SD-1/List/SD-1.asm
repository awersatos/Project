
;CodeVisionAVR C Compiler V2.05.0 Evaluation
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
	.DEF _rdata=R2

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

_msms:
	.DB  0x61,0x74,0x2B,0x63,0x6D,0x67,0x66,0x3D
	.DB  0x31,0x0
_nsms:
	.DB  0x61,0x74,0x2B,0x63,0x6D,0x67,0x73,0x3D
	.DB  0x2B,0x37,0x39,0x31,0x33,0x39,0x32,0x34
	.DB  0x33,0x39,0x39,0x39,0x2C,0x31,0x34,0x35
	.DB  0x0
_tsms:
	.DB  0x64,0x6F,0x6F,0x72,0x20,0x6F,0x70,0x65
	.DB  0x6E,0x0
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
;CodeWizardAVR V2.05.0 Evaluation
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
;#define UDRE 5
;#define RXC 7
;#define CR 0xD
;#define LF 0xA
;#define ctrl_Z 0x1A
;flash char msms[]="at+cmgf=1";
;// ќбъ€вление и инициализаци€ массива ввода номера
;flash char nsms[]="at+cmgs=+79139243999,145";
;// ќбъ€вление и инициализаци€ массива текста SMS
;flash char tsms[]="door open";
;unsigned char i;
;unsigned char rdata;
;void UART_Transmit(char data)
; 0000 0026 {

	.CSEG
_UART_Transmit:
; 0000 0027 while (!(UCSRA & (1<<UDRE))) {};
;	data -> Y+0
_0x3:
	SBIS 0xB,5
	RJMP _0x3
; 0000 0028 UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0029 }
	ADIW R28,1
	RET
;
;char UART_Receive(void)
; 0000 002C { while (!(UCSRA & (1<<RXC)));
_UART_Receive:
_0x6:
	SBIS 0xB,7
	RJMP _0x6
; 0000 002D   return UDR;
	IN   R30,0xC
	RET
; 0000 002E   }
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0031 {
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
; 0000 0032 PORTB.3=0;
	CBI  0x18,3
; 0000 0033 PORTB.4=1;
	SBI  0x18,4
; 0000 0034 
; 0000 0035 PORTB.0=0;
	CBI  0x18,0
; 0000 0036 PORTD.6=0;
	CBI  0x12,6
; 0000 0037 delay_ms(2000);
	RCALL SUBOPT_0x0
; 0000 0038 PORTB.0=1;
	SBI  0x18,0
; 0000 0039 PORTD.4=0;
	CBI  0x12,4
; 0000 003A while(PIND.5==1) {};
_0x15:
	SBIC 0x10,5
	RJMP _0x15
; 0000 003B PORTB.4=0;
	CBI  0x18,4
; 0000 003C delay_ms(2000);
	RCALL SUBOPT_0x0
; 0000 003D m1: UART_Transmit('a');
_0x1A:
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x1
; 0000 003E     UART_Transmit('t');
	LDI  R30,LOW(116)
	RCALL SUBOPT_0x1
; 0000 003F     UART_Transmit(CR);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x1
; 0000 0040 
; 0000 0041 rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0042 if (rdata!=CR) {goto m1;}
	LDI  R30,LOW(13)
	CP   R30,R2
	BRNE _0x1A
; 0000 0043 rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0044 if (rdata!=LF) {goto m1;}
	LDI  R30,LOW(10)
	CP   R30,R2
	BRNE _0x1A
; 0000 0045 rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0046 if (!((rdata=='O') || (rdata=='o'))) {goto m1;} ;
	LDI  R30,LOW(79)
	CP   R30,R2
	BREQ _0x1E
	LDI  R30,LOW(111)
	CP   R30,R2
	BRNE _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
	RJMP _0x1A
_0x1D:
; 0000 0047  rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0048 if (!((rdata=='K') || (rdata=='k'))) {goto m1;}
	LDI  R30,LOW(75)
	CP   R30,R2
	BREQ _0x21
	LDI  R30,LOW(107)
	CP   R30,R2
	BRNE _0x22
_0x21:
	RJMP _0x20
_0x22:
	RJMP _0x1A
; 0000 0049 PORTB.3=1;
_0x20:
	SBI  0x18,3
; 0000 004A delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 004B 
; 0000 004C m2: for (i=0; i<11; i++)
_0x25:
	CLR  R3
_0x27:
	LDI  R30,LOW(11)
	CP   R3,R30
	BRSH _0x28
; 0000 004D  {UART_Transmit(msms[i]);}
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_msms*2)
	SBCI R31,HIGH(-_msms*2)
	LPM  R30,Z
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x27
_0x28:
; 0000 004E  UART_Transmit(CR);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x1
; 0000 004F 
; 0000 0050 rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0051 if (rdata!=CR) {goto m2;}
	LDI  R30,LOW(13)
	CP   R30,R2
	BRNE _0x25
; 0000 0052 rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0053 if (rdata!=LF) {goto m2;}
	LDI  R30,LOW(10)
	CP   R30,R2
	BRNE _0x25
; 0000 0054 rdata=UART_Receive();
	RCALL SUBOPT_0x2
; 0000 0055 if (!((rdata=='O') || (rdata=='o'))) {goto m2;}
	LDI  R30,LOW(79)
	CP   R30,R2
	BREQ _0x2C
	LDI  R30,LOW(111)
	CP   R30,R2
	BRNE _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
	RJMP _0x25
; 0000 0056  rdata=UART_Receive();
_0x2B:
	RCALL SUBOPT_0x2
; 0000 0057 if (!((rdata=='K') || (rdata=='k'))) {goto m2;}
	LDI  R30,LOW(75)
	CP   R30,R2
	BREQ _0x2F
	LDI  R30,LOW(107)
	CP   R30,R2
	BRNE _0x30
_0x2F:
	RJMP _0x2E
_0x30:
	RJMP _0x25
; 0000 0058 PORTB.3=0;
_0x2E:
	CBI  0x18,3
; 0000 0059 PORTB.4=1;
	SBI  0x18,4
; 0000 005A 
; 0000 005B for (i=0; i<24; i++)
	CLR  R3
_0x36:
	LDI  R30,LOW(24)
	CP   R3,R30
	BRSH _0x37
; 0000 005C  {UART_Transmit(nsms[i]);}
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_nsms*2)
	SBCI R31,HIGH(-_nsms*2)
	LPM  R30,Z
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x36
_0x37:
; 0000 005D  UART_Transmit(CR);
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x1
; 0000 005E  for (i=0; i<11; i++)
	CLR  R3
_0x39:
	LDI  R30,LOW(11)
	CP   R3,R30
	BRSH _0x3A
; 0000 005F  {UART_Transmit(tsms[i]);}
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_tsms*2)
	SBCI R31,HIGH(-_tsms*2)
	LPM  R30,Z
	RCALL SUBOPT_0x1
	INC  R3
	RJMP _0x39
_0x3A:
; 0000 0060  UART_Transmit(ctrl_Z);
	LDI  R30,LOW(26)
	RCALL SUBOPT_0x1
; 0000 0061  PORTB.4=0;
	CBI  0x18,4
; 0000 0062 
; 0000 0063 
; 0000 0064 
; 0000 0065 
; 0000 0066 
; 0000 0067 
; 0000 0068 
; 0000 0069 }
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
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 0071 {
_main:
; 0000 0072 // Declare your local variables here
; 0000 0073 
; 0000 0074 // Crystal Oscillator division factor: 1
; 0000 0075 #pragma optsize-
; 0000 0076 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0077 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0078 #ifdef _OPTIMIZE_SIZE_
; 0000 0079 #pragma optsize+
; 0000 007A #endif
; 0000 007B 
; 0000 007C // Input/Output Ports initialization
; 0000 007D // Port A initialization
; 0000 007E // Func2=In Func1=In Func0=In
; 0000 007F // State2=T State1=T State0=T
; 0000 0080 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0081 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0082 
; 0000 0083 // Port B initialization
; 0000 0084 // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=Out
; 0000 0085 // State7=T State6=T State5=T State4=0 State3=0 State2=T State1=T State0=1
; 0000 0086 PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 0087 DDRB=0x19;
	LDI  R30,LOW(25)
	OUT  0x17,R30
; 0000 0088 
; 0000 0089 // Port D initialization
; 0000 008A // Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 008B // State6=0 State5=T State4=0 State3=P State2=P State1=T State0=T
; 0000 008C PORTD=0x0C;
	LDI  R30,LOW(12)
	OUT  0x12,R30
; 0000 008D DDRD=0x50;
	LDI  R30,LOW(80)
	OUT  0x11,R30
; 0000 008E 
; 0000 008F // Timer/Counter 0 initialization
; 0000 0090 // Clock source: System Clock
; 0000 0091 // Clock value: Timer 0 Stopped
; 0000 0092 // Mode: Normal top=0xFF
; 0000 0093 // OC0A output: Disconnected
; 0000 0094 // OC0B output: Disconnected
; 0000 0095 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0096 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 0097 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0098 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0099 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 009A 
; 0000 009B // Timer/Counter 1 initialization
; 0000 009C // Clock source: System Clock
; 0000 009D // Clock value: Timer1 Stopped
; 0000 009E // Mode: Normal top=0xFFFF
; 0000 009F // OC1A output: Discon.
; 0000 00A0 // OC1B output: Discon.
; 0000 00A1 // Noise Canceler: Off
; 0000 00A2 // Input Capture on Falling Edge
; 0000 00A3 // Timer1 Overflow Interrupt: Off
; 0000 00A4 // Input Capture Interrupt: Off
; 0000 00A5 // Compare A Match Interrupt: Off
; 0000 00A6 // Compare B Match Interrupt: Off
; 0000 00A7 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00A8 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00A9 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00AA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00AB ICR1H=0x00;
	OUT  0x25,R30
; 0000 00AC ICR1L=0x00;
	OUT  0x24,R30
; 0000 00AD OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00AE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00AF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00B0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00B1 
; 0000 00B2 // External Interrupt(s) initialization
; 0000 00B3 // INT0: Off
; 0000 00B4 // INT1: On
; 0000 00B5 // INT1 Mode: Low level
; 0000 00B6 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00B7 GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 00B8 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00B9 EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 00BA 
; 0000 00BB // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00BC TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00BD 
; 0000 00BE // Universal Serial Interface initialization
; 0000 00BF // Mode: Disabled
; 0000 00C0 // Clock source: Register & Counter=no clk.
; 0000 00C1 // USI Counter Overflow Interrupt: Off
; 0000 00C2 USICR=0x00;
	OUT  0xD,R30
; 0000 00C3 
; 0000 00C4 // USART initialization
; 0000 00C5 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00C6 // USART Receiver: On
; 0000 00C7 // USART Transmitter: On
; 0000 00C8 // USART Mode: Asynchronous
; 0000 00C9 // USART Baud Rate: 9600
; 0000 00CA UCSRA=0x00;
	OUT  0xB,R30
; 0000 00CB UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00CC UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 00CD UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00CE UBRRL=0x17;
	LDI  R30,LOW(23)
	OUT  0x9,R30
; 0000 00CF 
; 0000 00D0 // Analog Comparator initialization
; 0000 00D1 // Analog Comparator: Off
; 0000 00D2 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D3 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D4 DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00D5 
; 0000 00D6 // Global enable interrupts
; 0000 00D7 #asm("sei")
	sei
; 0000 00D8  PORTB.3=1;
	SBI  0x18,3
; 0000 00D9 while (1)
_0x3F:
; 0000 00DA       {
; 0000 00DB       // Place your code here
; 0000 00DC 
; 0000 00DD       }
	RJMP _0x3F
; 0000 00DE }
_0x42:
	RJMP _0x42
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	RJMP _UART_Transmit

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	RCALL _UART_Receive
	MOV  R2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
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

;END OF CODE MARKER
__END_OF_CODE:
