
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
;Data Stack size          : 36 byte(s)
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
	.EQU __DSTACK_SIZE=0x0024
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
	.DEF _z=R3
	.DEF _i=R2
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7

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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x2C,0x22,0x2B,0x37,0x0,0x45,0x52,0x52
	.DB  0x4F,0x52,0x0,0x41,0x54,0x2B,0x43,0x4D
	.DB  0x47,0x46,0x3D,0x30,0xD,0x0,0x41,0x54
	.DB  0x2B,0x43,0x4D,0x47,0x53,0x3D,0x34,0x33
	.DB  0xD,0x0,0x30,0x30,0x30,0x31,0x30,0x30
	.DB  0x30,0x42,0x39,0x31,0x0,0x30,0x30,0x31
	.DB  0x38,0x31,0x45,0x30,0x34,0x31,0x32,0x30
	.DB  0x34,0x33,0x37,0x30,0x34,0x34,0x46,0x30
	.DB  0x34,0x34,0x32,0x30,0x34,0x33,0x45,0x30
	.DB  0x30,0x32,0x30,0x30,0x34,0x33,0x44,0x30
	.DB  0x34,0x33,0x30,0x30,0x30,0x32,0x30,0x30
	.DB  0x34,0x33,0x45,0x30,0x34,0x34,0x35,0x30
	.DB  0x34,0x34,0x30,0x30,0x34,0x33,0x30,0x30
	.DB  0x34,0x33,0x44,0x30,0x34,0x34,0x33,0x1A
	.DB  0x0,0x41,0x54,0xD,0x0,0x41,0x54,0x2B
	.DB  0x43,0x52,0x45,0x47,0x3F,0xD,0x0,0x41
	.DB  0x54,0x2B,0x43,0x50,0x42,0x46,0x3D,0x22
	.DB  0x4E,0x22,0xD,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4D,0x47,0x53,0x3D,0x33,0x39,0xD,0x0
	.DB  0x30,0x30,0x30,0x38,0x31,0x41,0x30,0x34
	.DB  0x31,0x34,0x30,0x34,0x33,0x32,0x30,0x34
	.DB  0x33,0x35,0x30,0x34,0x34,0x30,0x30,0x34
	.DB  0x34,0x43,0x30,0x30,0x32,0x30,0x30,0x34
	.DB  0x33,0x45,0x30,0x34,0x34,0x32,0x30,0x34
	.DB  0x33,0x41,0x30,0x34,0x34,0x30,0x30,0x34
	.DB  0x34,0x42,0x30,0x34,0x34,0x32,0x30,0x34
	.DB  0x33,0x30,0x1A,0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0xC
	.DW  _0x0*2

	.DW  0x06
	.DW  _0x11
	.DW  _0x0*2+5

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
	.ORG 0x84

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : SD-N
;Version : 0
;Date    : 12.08.2011
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
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;#define CR 0xD     // Определение служебных символов
;#define LF 0xA
;#define ctrl_Z 0x1A
;
; char z;
;eeprom char eebuffer[56];
;unsigned char i;
; char NR[12];
;//char *n;
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
;#define RX_BUFFER_SIZE 50
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
;void UART_Transmit(char data) // Функция передачи символа через UART
; 0000 0056 {

	.CSEG
_UART_Transmit:
; 0000 0057 while (!(UCSRA & (1<<UDRE))) {};
;	data -> Y+0
_0x3:
	SBIS 0xB,5
	RJMP _0x3
; 0000 0058 UDR=data;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0059 }
	ADIW R28,1
	RET
;
;//**********************************************************************************************************
;       void SEND_Str(flash char *str) {        // Функция передачи строки  из флеш памяти
; 0000 005C void SEND_Str(flash char *str) {
_SEND_Str:
; 0000 005D         while(*str) {
;	*str -> Y+0
_0x6:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x8
; 0000 005E        UART_Transmit(*str++);
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	RCALL _UART_Transmit
; 0000 005F 
; 0000 0060     };
	RJMP _0x6
_0x8:
; 0000 0061     delay_ms(20);
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x0
	RCALL _delay_ms
; 0000 0062 }
	RJMP _0x2060001
;
;//**********************************************************************************************************
; /* void SEND_Str_EEPROM(eeprom char *str) {        // Функция передачи строки из eeprom
;        while(*str) {
;       UART_Transmit(*str++);
;
;    };
;    delay_ms(20);
;}   */
;//**********************************************************************************************************
; /* void SEND_Str_RAM(char *str) {        // Функция передачи строки из оперативной памяти
;        while(*str) {
;       UART_Transmit(*str++);
;
;    };
;    delay_ms(20);
;} */
;//**********************************************************************************************************
;void CLEAR_BUF(void)   // Функция очистки буффера приема
; 0000 0076 {
_CLEAR_BUF:
; 0000 0077 for (i=0;i<RX_BUFFER_SIZE;i++) {
	CLR  R2
_0xA:
	LDI  R30,LOW(50)
	CP   R2,R30
	BRSH _0xB
; 0000 0078       rx_buffer[i]=0;
	LDI  R26,LOW(_rx_buffer)
	ADD  R26,R2
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0079     };
	INC  R2
	RJMP _0xA
_0xB:
; 0000 007A    rx_wr_index=0;
	CLR  R5
; 0000 007B }
	RET
;//**********************************************************************************************************
;  char TEST_OK(void)     // Функция проверки ответа ОК на команду
; 0000 007E   {
_TEST_OK:
; 0000 007F   char c;
; 0000 0080   char *d;
; 0000 0081   char OK[]="OK";
; 0000 0082   d=strstr(rx_buffer, OK);
	SBIW R28,3
	LDI  R30,LOW(79)
	ST   Y,R30
	LDI  R30,LOW(75)
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	RCALL SUBOPT_0x1
;	c -> R17
;	*d -> R16
;	OK -> Y+2
; 0000 0083   c=*d;
	RCALL SUBOPT_0x2
; 0000 0084  CLEAR_BUF();
; 0000 0085    return c;
	ADIW R28,5
	RET
; 0000 0086 
; 0000 0087   }
;//**********************************************************************************************************
;  char REG_NET(void)   // Функция проверки регистрации в сети
; 0000 008A   {
_REG_NET:
; 0000 008B   char c;
; 0000 008C   char *d;
; 0000 008D   char REG[]="+CREG:";
; 0000 008E   d=strstr(rx_buffer, REG);
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
	RCALL SUBOPT_0x1
;	c -> R17
;	*d -> R16
;	REG -> Y+2
; 0000 008F   d=d+9;
	SUBI R16,-LOW(9)
; 0000 0090   c=*d;
	RCALL SUBOPT_0x2
; 0000 0091   CLEAR_BUF();
; 0000 0092   return c;
	ADIW R28,9
	RET
; 0000 0093   }
;//**********************************************************************************************************
;char SET_NR(void) // Функция считывания телефонного номера с SIM карты
; 0000 0096 {
_SET_NR:
; 0000 0097 char c;
; 0000 0098 char *d;
; 0000 0099 
; 0000 009A d=strstr(rx_buffer, ",\"+7");
	RCALL __SAVELOCR2
;	c -> R17
;	*d -> R16
	LDI  R30,LOW(_rx_buffer)
	ST   -Y,R30
	__POINTB1MN _0xC,0
	ST   -Y,R30
	RCALL _strstr
	MOV  R16,R30
; 0000 009B if (d==NULL){c=0;
	CPI  R16,0
	BRNE _0xD
	LDI  R17,LOW(0)
; 0000 009C           return c;}
	RJMP _0x2060002
; 0000 009D   d=d+4;
_0xD:
	SUBI R16,-LOW(4)
; 0000 009E   i=0;
	CLR  R2
; 0000 009F   while(i<12)
_0xE:
	LDI  R30,LOW(12)
	CP   R2,R30
	BRSH _0x10
; 0000 00A0   {
; 0000 00A1   NR[i++]=*d;
	RCALL SUBOPT_0x3
; 0000 00A2    d=d--;
	DEC  R16
; 0000 00A3    NR[i++]=*d;
	RCALL SUBOPT_0x3
; 0000 00A4    d=d+3;
	SUBI R16,-LOW(3)
; 0000 00A5   }
	RJMP _0xE
_0x10:
; 0000 00A6   NR[10]='F';
	LDI  R30,LOW(70)
	__PUTB1MN _NR,10
; 0000 00A7   CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 00A8   c=1;
	LDI  R17,LOW(1)
; 0000 00A9   return c;
_0x2060002:
	MOV  R30,R17
	RCALL __LOADLOCR2P
	RET
; 0000 00AA }

	.DSEG
_0xC:
	.BYTE 0x5
;//**********************************************************************************************************
;char TEST_ERROR(void)   // Функция проверки на ошибку
; 0000 00AD {

	.CSEG
_TEST_ERROR:
; 0000 00AE char *d;
; 0000 00AF d=strstr(rx_buffer, "ERROR");
	ST   -Y,R17
;	*d -> R17
	LDI  R30,LOW(_rx_buffer)
	ST   -Y,R30
	__POINTB1MN _0x11,0
	ST   -Y,R30
	RCALL _strstr
	MOV  R17,R30
; 0000 00B0  CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 00B1  return *d;
	MOV  R26,R17
	LD   R30,X
	LD   R17,Y+
	RET
; 0000 00B2 }

	.DSEG
_0x11:
	.BYTE 0x6
;//**********************************************************************************************************
;// External Interrupt 0 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 00B6 {

	.CSEG
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
; 0000 00B7 delay_us(200);
	__DELAY_USB 246
; 0000 00B8 if (PIND.3==0) {
	SBIC 0x10,3
	RJMP _0x12
; 0000 00B9 
; 0000 00BA if (z==0)
	TST  R3
	BRNE _0x13
; 0000 00BB {z=128;
	LDI  R30,LOW(128)
	MOV  R3,R30
; 0000 00BC       PORTD.6=0;  // Открытие порта
	CBI  0x12,6
; 0000 00BD       PORTD.4=0;
	CBI  0x12,4
; 0000 00BE       while(PIND.5==1);
_0x18:
	SBIC 0x10,5
	RJMP _0x18
; 0000 00BF                             /*
; 0000 00C0       //while(TEST_OK()==0) { SEND_Str("AT\r");}  // Проверка ответа модема
; 0000 00C1        // SEND_Str("AT+CREG?\r");
; 0000 00C2      while(REG_NET()!='1') {           // Проверка регистрации в сети
; 0000 00C3 
; 0000 00C4        SEND_Str("AT+CREG?\r");
; 0000 00C5       //delay_ms(1000);
; 0000 00C6       }
; 0000 00C7                       */
; 0000 00C8    while(TEST_OK()==0) {   SEND_Str("AT+CMGF=0\r"); }    // Установка PDU режима
_0x1B:
	RCALL SUBOPT_0x4
	BRNE _0x1D
	RCALL SUBOPT_0x5
	RJMP _0x1B
_0x1D:
; 0000 00C9      //  if (TEST_OK()==0) goto mx3 ;
; 0000 00CA 
; 0000 00CB       SEND_Str("AT+CMGS=43\r");  //    Ввод команды отправки сообщения
	__POINTW1FN _0x0,22
	RCALL SUBOPT_0x6
; 0000 00CC 
; 0000 00CD 
; 0000 00CE    /*   if (strrchr(rx_buffer, '>')==NULL)
; 0000 00CF       {CLEAR_BUF();
; 0000 00D0       goto mx4;}
; 0000 00D1       CLEAR_BUF();    */
; 0000 00D2 
; 0000 00D3       SEND_Str("0001000B91");     // Ввод настроек PDU
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x6
; 0000 00D4 
; 0000 00D5       for(i=0;i<12;i++)            // Ввод номера
	CLR  R2
_0x1F:
	LDI  R30,LOW(12)
	CP   R2,R30
	BRSH _0x20
; 0000 00D6       {UART_Transmit(NR[i]);}
	RCALL SUBOPT_0x7
	INC  R2
	RJMP _0x1F
_0x20:
; 0000 00D7 
; 0000 00D8        SEND_Str("00181E04120437044F0442043E0020043D04300020043E044504400430043D0443\x1A");
	__POINTW1FN _0x0,45
	RCALL SUBOPT_0x6
; 0000 00D9     //  if (TEST_ERROR()=='E') goto mx4;         // Ввод текста SMS
; 0000 00DA        PORTD.4=1; // RTS
	SBI  0x12,4
; 0000 00DB        PORTD.6=1;  // DTR    */
	SBI  0x12,6
; 0000 00DC }
; 0000 00DD else {z=0;}
	RJMP _0x25
_0x13:
	CLR  R3
_0x25:
; 0000 00DE  PORTB.4=1;
	SBI  0x18,4
; 0000 00DF   PORTB.3=1;
	SBI  0x18,3
; 0000 00E0   delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x8
; 0000 00E1  while(PIND.3==0);
_0x2A:
	SBIS 0x10,3
	RJMP _0x2A
; 0000 00E2 PORTB.4=0;
	CBI  0x18,4
; 0000 00E3   PORTB.3=0;}
	CBI  0x18,3
; 0000 00E4 
; 0000 00E5 }
_0x12:
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
;// Функция обработки прерывания по приему символа USART
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 00E9 {
_usart_rx_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00EA char status,data;
; 0000 00EB status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 00EC data=UDR;
	IN   R16,12
; 0000 00ED if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x31
; 0000 00EE    {
; 0000 00EF    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	SUBI R30,-LOW(_rx_buffer)
	ST   Z,R16
; 0000 00F0 #if RX_BUFFER_SIZE == 256
; 0000 00F1    // special case for receiver buffer size=256
; 0000 00F2    if (++rx_counter == 0)
; 0000 00F3       {
; 0000 00F4 #else
; 0000 00F5    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(50)
	CP   R30,R5
	BRNE _0x32
	CLR  R5
; 0000 00F6    if (++rx_counter == RX_BUFFER_SIZE)
_0x32:
	INC  R7
	LDI  R30,LOW(50)
	CP   R30,R7
	BRNE _0x33
; 0000 00F7       {
; 0000 00F8       rx_counter=0;
	CLR  R7
; 0000 00F9 #endif
; 0000 00FA       rx_buffer_overflow=1;
	SBI  0x13,0
; 0000 00FB       }
; 0000 00FC    }
_0x33:
; 0000 00FD }
_0x31:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
; //*************************************************************************
; // функция считывания символа из буфера приема
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0106 {
; 0000 0107 char data;
; 0000 0108 while (rx_counter==0);
;	data -> R17
; 0000 0109 data=rx_buffer[rx_rd_index++];
; 0000 010A #if RX_BUFFER_SIZE != 256
; 0000 010B if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 010C #endif
; 0000 010D #asm("cli")
; 0000 010E --rx_counter;
; 0000 010F #asm("sei")
; 0000 0110 return data;
; 0000 0111 }
;#pragma used-
;#endif
;//***************************************************************************
;
;
;// ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ
;void main(void)
; 0000 0119 {
_main:
; 0000 011A // Declare your local variables here
; 0000 011B 
; 0000 011C // Crystal Oscillator division factor: 1
; 0000 011D #pragma optsize-
; 0000 011E CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 011F CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0120 #ifdef _OPTIMIZE_SIZE_
; 0000 0121 #pragma optsize+
; 0000 0122 #endif
; 0000 0123 
; 0000 0124 // Input/Output Ports initialization
; 0000 0125 // Port A initialization
; 0000 0126 // Func2=In Func1=In Func0=In
; 0000 0127 // State2=T State1=T State0=T
; 0000 0128 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0129 DDRA=0x00;
	OUT  0x1A,R30
; 0000 012A 
; 0000 012B // Port B initialization
; 0000 012C // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=Out
; 0000 012D // State7=T State6=T State5=T State4=0 State3=0 State2=T State1=T State0=1
; 0000 012E PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 012F DDRB=0x19;
	LDI  R30,LOW(25)
	OUT  0x17,R30
; 0000 0130 
; 0000 0131 // Port D initialization
; 0000 0132 // Func6=Out Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0133 // State6=1 State5=T State4=1 State3=T State2=T State1=T State0=T
; 0000 0134 PORTD=0x50;
	LDI  R30,LOW(80)
	OUT  0x12,R30
; 0000 0135 DDRD=0x50;
	OUT  0x11,R30
; 0000 0136 
; 0000 0137 // Timer/Counter 0 initialization
; 0000 0138 // Clock source: System Clock
; 0000 0139 // Clock value: Timer 0 Stopped
; 0000 013A // Mode: Normal top=0xFF
; 0000 013B // OC0A output: Disconnected
; 0000 013C // OC0B output: Disconnected
; 0000 013D TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 013E TCCR0B=0x00;
	OUT  0x33,R30
; 0000 013F TCNT0=0x00;
	OUT  0x32,R30
; 0000 0140 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0141 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 0142 
; 0000 0143 // Timer/Counter 1 initialization
; 0000 0144 // Clock source: System Clock
; 0000 0145 // Clock value: Timer1 Stopped
; 0000 0146 // Mode: Normal top=0xFFFF
; 0000 0147 // OC1A output: Discon.
; 0000 0148 // OC1B output: Discon.
; 0000 0149 // Noise Canceler: Off
; 0000 014A // Input Capture on Falling Edge
; 0000 014B // Timer1 Overflow Interrupt: Off
; 0000 014C // Input Capture Interrupt: Off
; 0000 014D // Compare A Match Interrupt: Off
; 0000 014E // Compare B Match Interrupt: Off
; 0000 014F TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0150 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0151 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0152 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0153 ICR1H=0x00;
	OUT  0x25,R30
; 0000 0154 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0155 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0156 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0157 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0158 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0159 
; 0000 015A // External Interrupt(s) initialization
; 0000 015B // INT0: Off
; 0000 015C // INT1: On
; 0000 015D // INT1 Mode: Low level
; 0000 015E // Interrupt on any change on pins PCINT0-7: Off
; 0000 015F GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 0160 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0161 EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0162 
; 0000 0163 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0164 TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0165 
; 0000 0166 // Universal Serial Interface initialization
; 0000 0167 // Mode: Disabled
; 0000 0168 // Clock source: Register & Counter=no clk.
; 0000 0169 // USI Counter Overflow Interrupt: Off
; 0000 016A USICR=0x00;
	OUT  0xD,R30
; 0000 016B 
; 0000 016C // USART initialization
; 0000 016D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 016E // USART Receiver: On
; 0000 016F // USART Transmitter: On
; 0000 0170 // USART Mode: Asynchronous
; 0000 0171 // USART Baud Rate: 115200
; 0000 0172 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0173 UCSRB=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0174 UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 0175 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0176 UBRRL=0x01;
	LDI  R30,LOW(1)
	OUT  0x9,R30
; 0000 0177 
; 0000 0178 // Analog Comparator initialization
; 0000 0179 // Analog Comparator: Off
; 0000 017A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 017B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 017C DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 017D      PORTB.3=1;
	SBI  0x18,3
; 0000 017E      PORTB.4=1;
	SBI  0x18,4
; 0000 017F // Global enable interrupts
; 0000 0180 #asm("sei")
	sei
; 0000 0181       PORTB.0=0;     //Включение модема
	CBI  0x18,0
; 0000 0182       delay_ms(1000);
	RCALL SUBOPT_0x9
; 0000 0183       PORTB.0=1;
	SBI  0x18,0
; 0000 0184        delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x8
; 0000 0185 
; 0000 0186        PORTD.6=0;  // Открытие порта
	CBI  0x12,6
; 0000 0187       PORTD.4=0;
	CBI  0x12,4
; 0000 0188       while(PIND.5==1);
_0x46:
	SBIC 0x10,5
	RJMP _0x46
; 0000 0189 
; 0000 018A m01:      SEND_Str("AT\r");  // Проверка ответа модема
_0x49:
	__POINTW1FN _0x0,113
	RCALL SUBOPT_0x6
; 0000 018B 
; 0000 018C       if (TEST_OK()==0) goto m01 ;
	RCALL SUBOPT_0x4
	BREQ _0x49
; 0000 018D 
; 0000 018E 
; 0000 018F m02:    SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
_0x4B:
	__POINTW1FN _0x0,117
	RCALL SUBOPT_0x6
; 0000 0190 
; 0000 0191       if (REG_NET()!='1')
	RCALL _REG_NET
	CPI  R30,LOW(0x31)
	BREQ _0x4C
; 0000 0192       {
; 0000 0193       delay_ms(1000);
	RCALL SUBOPT_0x9
; 0000 0194       goto m02;
	RJMP _0x4B
; 0000 0195       }
; 0000 0196 
; 0000 0197 
; 0000 0198 m03:      SEND_Str("AT+CPBF=\"N\"\r");  // Считывание телефонного номера с SIM карты
_0x4C:
_0x4D:
	__POINTW1FN _0x0,127
	RCALL SUBOPT_0x6
; 0000 0199       if (SET_NR()==0) goto m03;      // Преобразование номера в PDU формат
	RCALL _SET_NR
	CPI  R30,0
	BREQ _0x4D
; 0000 019A PORTB.3=0;
	CBI  0x18,3
; 0000 019B PORTB.4=1;
	SBI  0x18,4
; 0000 019C       z=1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 019D while (1)
_0x53:
; 0000 019E       {
; 0000 019F      // PORTB.4=1;
; 0000 01A0       while((PIND.2==1)||(z==0)){
_0x56:
	SBIC 0x10,2
	RJMP _0x59
	LDI  R30,LOW(0)
	CP   R30,R3
	BRNE _0x58
_0x59:
; 0000 01A1       if (z==0){PORTB.4=0;}
	TST  R3
	BRNE _0x5B
	CBI  0x18,4
; 0000 01A2       else {PORTB.4=1;}
	RJMP _0x5E
_0x5B:
	SBI  0x18,4
_0x5E:
; 0000 01A3       }
	RJMP _0x56
_0x58:
; 0000 01A4       PORTB.4=0;
	CBI  0x18,4
; 0000 01A5       //while(z==0);
; 0000 01A6         delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x8
; 0000 01A7       while(PIND.2==0){ PORTB.3=1;}
_0x63:
	SBIC 0x10,2
	RJMP _0x65
	SBI  0x18,3
	RJMP _0x63
_0x65:
; 0000 01A8       PORTB.3=0;
	CBI  0x18,3
; 0000 01A9 
; 0000 01AA      PORTD.6=0;  // Открытие порта
	CBI  0x12,6
; 0000 01AB       PORTD.4=0;
	CBI  0x12,4
; 0000 01AC       while(PIND.5==1);
_0x6E:
	SBIC 0x10,5
	RJMP _0x6E
; 0000 01AD 
; 0000 01AE m1:      SEND_Str("AT\r");  // Проверка ответа модема
_0x71:
	__POINTW1FN _0x0,113
	RCALL SUBOPT_0x6
; 0000 01AF 
; 0000 01B0       if (TEST_OK()==0) goto m1 ;
	RCALL SUBOPT_0x4
	BREQ _0x71
; 0000 01B1 
; 0000 01B2 
; 0000 01B3 m2:    SEND_Str("AT+CREG?\r");   // Проверка регистрации в сети
_0x73:
	__POINTW1FN _0x0,117
	RCALL SUBOPT_0x6
; 0000 01B4 
; 0000 01B5       if (REG_NET()!='1')
	RCALL _REG_NET
	CPI  R30,LOW(0x31)
	BREQ _0x74
; 0000 01B6       {
; 0000 01B7       delay_ms(1000);
	RCALL SUBOPT_0x9
; 0000 01B8       goto m2;
	RJMP _0x73
; 0000 01B9       }
; 0000 01BA     //  z='R';
; 0000 01BB             /*
; 0000 01BC m3:      SEND_Str("AT+CPBF=\"N\"\r");  // Считывание телефонного номера с SIM карты
; 0000 01BD       if (SET_NR()==0) goto m3;      // Преобразование номера в PDU формат
; 0000 01BE                     */
; 0000 01BF m4:      SEND_Str("AT+CMGF=0\r");     // Установка PDU режима
_0x74:
_0x75:
	RCALL SUBOPT_0x5
; 0000 01C0        if (TEST_OK()==0) goto m4 ;
	RCALL SUBOPT_0x4
	BREQ _0x75
; 0000 01C1 
; 0000 01C2 m5:       SEND_Str("AT+CMGS=39\r");  //    Ввод команды отправки сообщения
_0x77:
	__POINTW1FN _0x0,140
	RCALL SUBOPT_0x6
; 0000 01C3 
; 0000 01C4 
; 0000 01C5       if (strrchr(rx_buffer, '>')==NULL)
	LDI  R30,LOW(_rx_buffer)
	ST   -Y,R30
	LDI  R30,LOW(62)
	ST   -Y,R30
	RCALL _strrchr
	CPI  R30,0
	BRNE _0x78
; 0000 01C6       {CLEAR_BUF();
	RCALL _CLEAR_BUF
; 0000 01C7       goto m5;}
	RJMP _0x77
; 0000 01C8       CLEAR_BUF();
_0x78:
	RCALL _CLEAR_BUF
; 0000 01C9 
; 0000 01CA       SEND_Str("0001000B91");     // Ввод настроек PDU
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x6
; 0000 01CB 
; 0000 01CC       for(i=0;i<12;i++)            // Ввод номера
	CLR  R2
_0x7A:
	LDI  R30,LOW(12)
	CP   R2,R30
	BRSH _0x7B
; 0000 01CD       {UART_Transmit(NR[i]);}
	RCALL SUBOPT_0x7
	INC  R2
	RJMP _0x7A
_0x7B:
; 0000 01CE 
; 0000 01CF        SEND_Str("00081A0414043204350440044C0020043E0442043A0440044B04420430\x1A");
	__POINTW1FN _0x0,152
	RCALL SUBOPT_0x6
; 0000 01D0       if (TEST_ERROR()=='E') goto m5;         // Ввод текста SMS
	RCALL _TEST_ERROR
	CPI  R30,LOW(0x45)
	BREQ _0x77
; 0000 01D1 
; 0000 01D2              /*
; 0000 01D3 
; 0000 01D4        SEND_Str("AT+CSQ?\r");
; 0000 01D5         delay_ms(1000);
; 0000 01D6        #asm("cli")
; 0000 01D7       for (i=0; i<50; i++)    // Запись буфера приема в eeprom
; 0000 01D8       {eebuffer[i]=rx_buffer[i];}
; 0000 01D9               */
; 0000 01DA         PORTD.4=1; // RTS
	SBI  0x12,4
; 0000 01DB        PORTD.6=1;  // DTR
	SBI  0x12,6
; 0000 01DC 
; 0000 01DD 
; 0000 01DE       }
	RJMP _0x53
; 0000 01DF }
_0x81:
	RJMP _0x81
;
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
_strrchr:
    ld   r22,y+
    ld   r26,y+
    clr  r27
    clr  r30
strrchr0:
    ld   r23,x
    cp   r22,r23
    brne strrchr1
    mov  r30,r26
strrchr1:
    adiw r26,1
    tst  r23
    brne strrchr0
    ret
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
_0x2060001:
	ADIW R28,2
	RET

	.CSEG

	.DSEG
_NR:
	.BYTE 0xC
_rx_buffer:
	.BYTE 0x32

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	RCALL __SAVELOCR2
	LDI  R30,LOW(_rx_buffer)
	ST   -Y,R30
	MOV  R30,R28
	SUBI R30,-(3)
	ST   -Y,R30
	RCALL _strstr
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	MOV  R26,R16
	LD   R17,X
	RCALL _CLEAR_BUF
	MOV  R30,R17
	RCALL __LOADLOCR2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	MOV  R30,R2
	INC  R2
	SUBI R30,-LOW(_NR)
	MOV  R0,R30
	MOV  R26,R16
	LD   R30,X
	MOV  R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL _TEST_OK
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__POINTW1FN _0x0,11
	RCALL SUBOPT_0x0
	RJMP _SEND_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x0
	RJMP _SEND_Str

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_NR)
	ADD  R26,R2
	LD   R30,X
	ST   -Y,R30
	RJMP _UART_Transmit

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x8


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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
