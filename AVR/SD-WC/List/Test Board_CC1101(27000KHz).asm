
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny44
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 64 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny44
	#pragma AVRPART MEMORY PROG_FLASH 4096
	#pragma AVRPART MEMORY EEPROM 256
	#pragma AVRPART MEMORY INT_SRAM SIZE 351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
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
	.EQU __SRAM_END=0x015F
	.EQU __DSTACK_SIZE=0x0040
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R3
	.DEF _len=R2

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
	RJMP _pin_change_isr0
	RJMP _pin_change_isr1
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
	RJMP 0x00
	RJMP 0x00

_init:
	.DB  0xE,0x0,0x6,0x2,0xFF,0x6,0x4,0x7
	.DB  0x5,0x8,0x1,0x9,0x2F,0xA,0x6,0xB
	.DB  0x0,0xC,0x10,0xD,0x9,0xE,0x7B,0xF
	.DB  0x85,0x10,0x78,0x11,0x3,0x12,0x2,0x13
	.DB  0xE5,0x14,0x14,0x15,0x30,0x17,0x18,0x18
	.DB  0x16,0x19,0x6C,0x1A,0xC0,0x1B,0x0,0x1C
	.DB  0xB2,0x1D,0xB6,0x21,0x10,0x22,0xE9,0x23
	.DB  0x2A,0x24,0x0,0x25,0x1F,0x26,0x59,0x29
	.DB  0x81,0x2C,0x35,0x2D,0x9,0x2E

_0x0:
	.DB  0x53,0x45,0x43,0x55,0x52,0x0,0x49,0x44
	.DB  0x4C,0x45,0x0,0x43,0x4C,0x45,0x41,0x52
	.DB  0x5F,0x4F,0x4B,0x0,0x44,0x41,0x54,0x43
	.DB  0x48,0x49,0x4B,0x31,0x32,0x38,0x31,0x32
	.DB  0x38,0x0,0x42,0x52,0x45,0x4C,0x4F,0x4B
	.DB  0x31,0x2D,0x52,0x45,0x41,0x44,0x0,0x42
	.DB  0x52,0x45,0x4C,0x4F,0x4B,0x31,0x2D,0x43
	.DB  0x48,0x41,0x4E,0x47,0x45,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _0x61
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x61+6
	.DW  _0x0*2+6

	.DW  0x09
	.DW  _0x61+11
	.DW  _0x0*2+11

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
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCSR,R31
	OUT  WDTCSR,R30

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
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xA0

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Test Board_CC1101(26800KHz)
;Version : 1
;Date    : 06.05.2012
;Author  : Alexandr Gordejchik
;Company : NTS
;Comments:
;
;
;Chip type               : ATtiny44
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 64
;*****************************************************/
;
;#include <tiny44.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;
;
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
;#define SPWD 0x39  //Переходв SLEEP режим
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; // Массив инициализации регистров (старший байт - адрес, младший - значение)
;flash unsigned int init[35]=
;{
; 0x000E, //0 IOGFG2 Обнаружение несущей
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
;union U      // Определение объединения
;		{
;			unsigned int buf;
;			unsigned char b[2];
;		};
;
;//union U FREQ;
;//union U FR1;
;//union U FR0;
;
;// Определение глобальных переменных
;unsigned char i;   //Основной счетчик
;unsigned char SPI_buffer[64];
;unsigned char len;
;//eeprom unsigned char ST;
;eeprom unsigned char STAT[37];
;//*******************************************************************************************
;//*******************************************************************************************
;//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
;//============================================================================================
;// Функция передачи символа по SPI
;unsigned char SPI_SEND(unsigned char data)
; 0000 0067 {

	.CSEG
_SPI_SEND:
; 0000 0068  USIDR=data;      // Загрузка данных в сдвиговый регистр
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 0069  USISR=(1<<USIOIF);  // Очистка флага переполнения и 4-битного счетчика
	LDI  R30,LOW(64)
	OUT  0xE,R30
; 0000 006A  TIFR0 |= (1<<OCF0A);   // Очистка флага прерывания по совпадению таймера
	IN   R30,0x38
	ORI  R30,2
	OUT  0x38,R30
; 0000 006B  TIMSK0 |= (1<<OCIE0A); // Разрешение прерывания по совпадению
	IN   R30,0x39
	ORI  R30,2
	OUT  0x39,R30
; 0000 006C  while(USISR.USIOIF==0); //Ожидание конца передачи байта
_0x3:
	SBIS 0xE,6
	RJMP _0x3
; 0000 006D  TIMSK0=0x00;     //Запрет прерывания
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 006E  return USIDR; // Возврат данных
	IN   R30,0xF
	RJMP _0x2080002
; 0000 006F  }
;
;//*******************************************************************************************
; void RESET_TR(void) //Сброс трансивера по включению питания
; 0000 0073 {
_RESET_TR:
; 0000 0074 USICR=0x00; //Отключение SPI
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 0075 PORTA.4=1; //Устанавливаем 1 на SCK
	SBI  0x1B,4
; 0000 0076 PORTA.5=0;  // Устанавливаем 0 на MOSI
	CBI  0x1B,5
; 0000 0077 PORTA.3=0; // SPI_SS ON
	CBI  0x1B,3
; 0000 0078 delay_us(1);
	__DELAY_USB 3
; 0000 0079 PORTA.3=1; // SPI_SS OFF
	SBI  0x1B,3
; 0000 007A delay_us(40);
	__DELAY_USB 107
; 0000 007B USICR=0x1A; //Включение SPI
	LDI  R30,LOW(26)
	OUT  0xD,R30
; 0000 007C PORTA.3=0; // SPI_SS ON
	CBI  0x1B,3
; 0000 007D while(PINA.6==1); //Ждем 0 на MISO
_0x10:
	SBIC 0x19,6
	RJMP _0x10
; 0000 007E SPI_SEND(SRES);
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 007F PORTA.3=1; // SPI_SS OFF
	RJMP _0x2080003
; 0000 0080 }
;//*******************************************************************************************
;void WRITE_REG( unsigned int reg) // Функция записи регистра
; 0000 0083 {  union U dat;
_WRITE_REG:
; 0000 0084 PORTA.3=0; // SPI_SS ON
	SBIW R28,2
;	reg -> Y+2
;	dat -> Y+0
	CBI  0x1B,3
; 0000 0085 while(PINA.6==1); //Ждем 0 на MISO
_0x17:
	SBIC 0x19,6
	RJMP _0x17
; 0000 0086 
; 0000 0087  dat.buf=reg;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   Y,R30
	STD  Y+1,R31
; 0000 0088  SPI_SEND(dat.b[1]);  //Адрес регистра
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 0089  SPI_SEND(dat.b[0]);  //Значение регистра
	LD   R30,Y
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 008A  PORTA.3=1; // SPI_SS OFF
	SBI  0x1B,3
; 0000 008B }
	RJMP _0x2080001
;//********************************************************************************************
;unsigned char READ_REG(unsigned char adr)  // Функция чтения регистра
; 0000 008E {  unsigned char reg;
; 0000 008F    PORTA.3=0; // SPI_SS ON
;	adr -> Y+1
;	reg -> R17
; 0000 0090    while(PINA.6==1); //Ждем 0 на MISO
; 0000 0091    SPI_SEND(adr | 0x80);   // Старший бит определяет операцию
; 0000 0092    reg= SPI_SEND(0x00);
; 0000 0093    return reg;
; 0000 0094    PORTA.3=1; // SPI_SS OFF
; 0000 0095 }
;//**********************************************************************************************
; void INIT_TR(void) //Функция инициализации трансивера
; 0000 0098  {
_INIT_TR:
; 0000 0099 
; 0000 009A 
; 0000 009B   for (i=0;i<35;i++)
	CLR  R3
_0x24:
	LDI  R30,LOW(35)
	CP   R3,R30
	BRSH _0x25
; 0000 009C    {
; 0000 009D     WRITE_REG(init[i]);
	MOV  R30,R3
	LDI  R26,LOW(_init*2)
	LDI  R27,HIGH(_init*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	ST   -Y,R31
	ST   -Y,R30
	RCALL _WRITE_REG
; 0000 009E     };
	INC  R3
	RJMP _0x24
_0x25:
; 0000 009F 
; 0000 00A0 
; 0000 00A1 
; 0000 00A2  }
	RET
;//********************************************************************************************
;void WRITE_PATABLE(void)    //Запись таблицы мощности
; 0000 00A5 {
_WRITE_PATABLE:
; 0000 00A6 PORTA.3=0; // SPI_SS ON
	CBI  0x1B,3
; 0000 00A7    while(PINA.6==1); //Ждем 0 на MISO
_0x28:
	SBIC 0x19,6
	RJMP _0x28
; 0000 00A8 WRITE_REG(0x3EC0);         //Запись значения выходной мощности передатчика +1dbm
	LDI  R30,LOW(16064)
	LDI  R31,HIGH(16064)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _WRITE_REG
; 0000 00A9    PORTA.3=1; // SPI_SS OFF
_0x2080003:
	SBI  0x1B,3
; 0000 00AA }
	RET
;//*********************************************************************************************
;void STROB(unsigned char strob)  //Запись строб-команды
; 0000 00AD {
_STROB:
; 0000 00AE PORTA.3=0; // SPI_SS ON
;	strob -> Y+0
	CBI  0x1B,3
; 0000 00AF  while(PINA.6==1); //Ждем 0 на MISO
_0x2F:
	SBIC 0x19,6
	RJMP _0x2F
; 0000 00B0  SPI_SEND(strob);
	LD   R30,Y
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 00B1   PORTA.3=1; // SPI_SS OFF
	SBI  0x1B,3
; 0000 00B2 }
	RJMP _0x2080002
;//******************************************************************************************
;unsigned char STATUS(void)
; 0000 00B5 { unsigned char st;
; 0000 00B6 PORTA.3=0; // SPI_SS ON
;	st -> R17
; 0000 00B7 while(PINA.6==1); //Ждем 0 на MISO
; 0000 00B8 st=SPI_SEND(SNOP);
; 0000 00B9 PORTA.3=1; // SPI_SS OFF
; 0000 00BA return st;
; 0000 00BB }
;//********************************************************************************************
;void SEND_PAKET(unsigned char pktlen) //Функция передачи пакета
; 0000 00BE {
_SEND_PAKET:
; 0000 00BF   STROB(SIDLE);  //Переход в режим IDLE
;	pktlen -> Y+0
	LDI  R30,LOW(54)
	ST   -Y,R30
	RCALL _STROB
; 0000 00C0   STROB(SFRX);  //Очистка приемного буфера
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL _STROB
; 0000 00C1   STROB(SFTX); //Очистка передающего буфера
	LDI  R30,LOW(59)
	ST   -Y,R30
	RCALL _STROB
; 0000 00C2   delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 00C3   PORTA.3=0; // SPI_SS ON
	CBI  0x1B,3
; 0000 00C4  while(PINA.6==1); //Ждем 0 на MISO
_0x3D:
	SBIC 0x19,6
	RJMP _0x3D
; 0000 00C5   SPI_SEND(0x7F);   //Открытие буфера на запись
	LDI  R30,LOW(127)
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 00C6   SPI_SEND(pktlen); //Запись длинны пакета
	LD   R30,Y
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 00C7   for (i=0;i<pktlen;i++)  //Запмсь пакета
	CLR  R3
_0x41:
	LD   R30,Y
	CP   R3,R30
	BRSH _0x42
; 0000 00C8   {
; 0000 00C9    SPI_SEND(SPI_buffer[i]);
	MOV  R30,R3
	LDI  R31,0
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	LD   R30,Z
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 00CA   }
	INC  R3
	RJMP _0x41
_0x42:
; 0000 00CB PORTA.3=1; // SPI_SS OFF
	SBI  0x1B,3
; 0000 00CC   //GICR=0x00; //Запрет прерывания по приему пакета
; 0000 00CD   STROB(STX); //Включение передачи
	LDI  R30,LOW(53)
	ST   -Y,R30
	RCALL _STROB
; 0000 00CE 
; 0000 00CF  while(PINA.0==0);
_0x45:
	SBIS 0x19,0
	RJMP _0x45
; 0000 00D0  while(PINA.0==1);
_0x48:
	SBIC 0x19,0
	RJMP _0x48
; 0000 00D1   STROB(SIDLE);  //Переход в режим IDLE
	LDI  R30,LOW(54)
	ST   -Y,R30
	RCALL _STROB
; 0000 00D2   STROB(SFRX);  //Очистка приемного буфера
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL _STROB
; 0000 00D3   STROB(SFTX); //Очистка передающего буфера
	LDI  R30,LOW(59)
	ST   -Y,R30
	RCALL _STROB
; 0000 00D4  // GIFR=0xFF;  //Сброс флага прерывания
; 0000 00D5   //GICR=0xC0;   //Разрешение прерывания по приему пакета
; 0000 00D6 }
_0x2080002:
	ADIW R28,1
	RET
;//********************************************************************************************
;unsigned char RECEIVE_PAKET(void) //Функция приема пакета
; 0000 00D9 {
_RECEIVE_PAKET:
; 0000 00DA unsigned char pktlen;
; 0000 00DB STROB(SIDLE);  //Переход в режим IDLE
	ST   -Y,R17
;	pktlen -> R17
	LDI  R30,LOW(54)
	ST   -Y,R30
	RCALL _STROB
; 0000 00DC PORTB.2=0; // SPI_SS ON
	CBI  0x18,2
; 0000 00DD  PORTA.3=0; // SPI_SS ON
	CBI  0x1B,3
; 0000 00DE  while(PINA.6==1); //Ждем 0 на MISO
_0x4F:
	SBIC 0x19,6
	RJMP _0x4F
; 0000 00DF  SPI_SEND(0xFF);  //Открытие буфера приема
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _SPI_SEND
; 0000 00E0 pktlen=SPI_SEND(0x00); //Считывание длинны пакета
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _SPI_SEND
	MOV  R17,R30
; 0000 00E1 for (i=0;i<pktlen;i++)    //Считывание пакета
	CLR  R3
_0x53:
	CP   R3,R17
	BRSH _0x54
; 0000 00E2    {
; 0000 00E3    SPI_buffer[i]=SPI_SEND(0x00);
	MOV  R30,R3
	LDI  R31,0
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
; 0000 00E4    }
	INC  R3
	RJMP _0x53
_0x54:
; 0000 00E5 PORTA.3=1; // SPI_SS OFF
	SBI  0x1B,3
; 0000 00E6 STROB(SFRX);
	LDI  R30,LOW(58)
	ST   -Y,R30
	RCALL _STROB
; 0000 00E7 return pktlen; //Возврат длинны пакета
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00E8  }
; //*******************************************************************************************
; void CLEAR_SPI_buffer(void) //Очистка SPI буфера
; 0000 00EB  { for (i=0;i<64;i++)
_CLEAR_SPI_buffer:
	CLR  R3
_0x58:
	LDI  R30,LOW(64)
	CP   R3,R30
	BRSH _0x59
; 0000 00EC    {
; 0000 00ED     SPI_buffer[i]=0x00;
	MOV  R30,R3
	LDI  R31,0
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00EE    }
	INC  R3
	RJMP _0x58
_0x59:
; 0000 00EF  }
	RET
; //********************************************************************************************
;  // Запись строки в SPI буффер
; unsigned char Write_SPI_buffer(flash char *str)
; 0000 00F3  {
_Write_SPI_buffer:
; 0000 00F4   i=0;
;	*str -> Y+0
	CLR  R3
; 0000 00F5   while(*str)
_0x5A:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x5C
; 0000 00F6   {
; 0000 00F7   SPI_buffer[i++]=*str++;
	MOV  R30,R3
	INC  R3
	LDI  R31,0
	SUBI R30,LOW(-_SPI_buffer)
	SBCI R31,HIGH(-_SPI_buffer)
	MOVW R26,R30
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   X,R30
; 0000 00F8 
; 0000 00F9   }
	RJMP _0x5A
_0x5C:
; 0000 00FA  return i;
	MOV  R30,R3
	ADIW R28,2
	RET
; 0000 00FB   }
;//*******************************************************************************************
;//===========================ПРЕРЫВАНИЯ======================================================
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)    //Прерывание по совпадению таймера
; 0000 0100 {   #asm("sei")
_timer0_compa_isr:
	sei
; 0000 0101 USICR |= (1<<USITC); // Задание тактового импульса
	SBI  0xD,0
; 0000 0102 
; 0000 0103 }
	RETI
;//*******************************************************************************************
;// Pin change 0-7 interrupt service routine
;interrupt [PC_INT0] void pin_change_isr0(void)
; 0000 0107 { // PORTA.2=1; //Светодиод 1
_pin_change_isr0:
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
; 0000 0108    //PORTA.7=0; //Светодиод 2
; 0000 0109       GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 010A       #asm("sei")
	sei
; 0000 010B      while(PINA.0==1);
_0x5D:
	SBIC 0x19,0
	RJMP _0x5D
; 0000 010C       len=RECEIVE_PAKET();
	RCALL _RECEIVE_PAKET
	MOV  R2,R30
; 0000 010D 
; 0000 010E        if (strstr(SPI_buffer,"SECUR")!=NULL)
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x61,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strstr
	SBIW R30,0
	BREQ _0x60
; 0000 010F        { PORTA.2=1; //Светодиод 1
	SBI  0x1B,2
; 0000 0110         PORTA.7=0;} //Светодиод 2
	CBI  0x1B,7
; 0000 0111         if (strstr(SPI_buffer,"IDLE")!=NULL)
_0x60:
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x61,6
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strstr
	SBIW R30,0
	BREQ _0x66
; 0000 0112         {  PORTA.2=0; //Светодиод 1
	CBI  0x1B,2
; 0000 0113            PORTA.7=1;} //Светодиод 2
	SBI  0x1B,7
; 0000 0114          if (strstr(SPI_buffer,"CLEAR_OK")!=NULL)
_0x66:
	LDI  R30,LOW(_SPI_buffer)
	LDI  R31,HIGH(_SPI_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x61,11
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strstr
	SBIW R30,0
	BREQ _0x6B
; 0000 0115             {for(i=0;i<5;i++)
	CLR  R3
_0x6D:
	LDI  R30,LOW(5)
	CP   R3,R30
	BRSH _0x6E
; 0000 0116               {PORTA.2=0; //Светодиод 1
	CBI  0x1B,2
; 0000 0117                PORTA.7=1;  //Светодиод 2
	SBI  0x1B,7
; 0000 0118                delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0119                PORTA.2=1; //Светодиод 1
	SBI  0x1B,2
; 0000 011A                PORTA.7=0;  //Светодиод 2
	CBI  0x1B,7
; 0000 011B                delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 011C 
; 0000 011D 
; 0000 011E 
; 0000 011F               }
	INC  R3
	RJMP _0x6D
_0x6E:
; 0000 0120             }
; 0000 0121 
; 0000 0122          CLEAR_SPI_buffer();
_0x6B:
	RCALL _CLEAR_SPI_buffer
; 0000 0123          delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0124 }
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
_0x61:
	.BYTE 0x14
;//********************************************************************************************
;// Pin change 8-11 interrupt service routine
;interrupt [PC_INT1] void pin_change_isr1(void)
; 0000 0128 {

	.CSEG
_pin_change_isr1:
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
; 0000 0129 GIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 012A #asm("sei")
	sei
; 0000 012B RESET_TR();
	RCALL _RESET_TR
; 0000 012C delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 012D INIT_TR();
	RCALL _INIT_TR
; 0000 012E WRITE_PATABLE();
	RCALL _WRITE_PATABLE
; 0000 012F 
; 0000 0130 
; 0000 0131 
; 0000 0132 delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0133 if((PINB.0==0)&&(PINB.1==0))
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x78
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x79
_0x78:
	RJMP _0x77
_0x79:
; 0000 0134 { PORTA.2=1; //Светодиод 1
	SBI  0x1B,2
; 0000 0135   PORTA.7=1; //Светодиод 2
	SBI  0x1B,7
; 0000 0136   delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0137   if((PINB.0==0)&&(PINB.1==0))SEND_PAKET(Write_SPI_buffer("DATCHIK128128"));
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x7F
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x80
_0x7F:
	RJMP _0x7E
_0x80:
	__POINTW1FN _0x0,20
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write_SPI_buffer
	ST   -Y,R30
	RCALL _SEND_PAKET
; 0000 0138 
; 0000 0139 
; 0000 013A  }
_0x7E:
; 0000 013B  else{
	RJMP _0x81
_0x77:
; 0000 013C if((PINB.0==0))  SEND_PAKET(Write_SPI_buffer("BRELOK1-READ"));
	SBIC 0x16,0
	RJMP _0x82
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write_SPI_buffer
	ST   -Y,R30
	RCALL _SEND_PAKET
; 0000 013D if((PINB.1==0))  SEND_PAKET(Write_SPI_buffer("BRELOK1-CHANGE")); }
_0x82:
	SBIC 0x16,1
	RJMP _0x83
	__POINTW1FN _0x0,47
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Write_SPI_buffer
	ST   -Y,R30
	RCALL _SEND_PAKET
_0x83:
_0x81:
; 0000 013E  CLEAR_SPI_buffer();
	RCALL _CLEAR_SPI_buffer
; 0000 013F   GIFR|=0x10;
	IN   R30,0x3A
	ORI  R30,0x10
	OUT  0x3A,R30
; 0000 0140   GIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x3B,R30
; 0000 0141   STROB(SRX);
	LDI  R30,LOW(52)
	ST   -Y,R30
	RCALL _STROB
; 0000 0142    delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0143    while ((PINB.0==0)||(PINB.1==0));
_0x84:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x87
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x86
_0x87:
	RJMP _0x84
_0x86:
; 0000 0144    GIFR|=0x30;
	IN   R30,0x3A
	ORI  R30,LOW(0x30)
	OUT  0x3A,R30
; 0000 0145    GIMSK=0x20;
	LDI  R30,LOW(32)
	OUT  0x3B,R30
; 0000 0146    PORTA.2=0; //Светодиод 1
	CBI  0x1B,2
; 0000 0147   PORTA.7=0; //Светодиод 2
	CBI  0x1B,7
; 0000 0148 }
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
;//============================================================================================
;//+++++++++++++++++++ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ ++++++++++++++++++++++++++++++++++++++++++++++
;//=============================================================================================
;void main(void)
; 0000 014E {
_main:
; 0000 014F // Declare your local variables here
; 0000 0150 
; 0000 0151 // Crystal Oscillator division factor: 1
; 0000 0152 #pragma optsize-
; 0000 0153 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0154 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0155 #ifdef _OPTIMIZE_SIZE_
; 0000 0156 #pragma optsize+
; 0000 0157 #endif
; 0000 0158 
; 0000 0159 // Input/Output Ports initialization
; 0000 015A // Port A initialization
; 0000 015B // Func7=Out Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
; 0000 015C // State7=0 State6=T State5=0 State4=0 State3=1 State2=0 State1=T State0=T
; 0000 015D PORTA=0x08;
	LDI  R30,LOW(8)
	OUT  0x1B,R30
; 0000 015E DDRA=0xBC;
	LDI  R30,LOW(188)
	OUT  0x1A,R30
; 0000 015F 
; 0000 0160 // Port B initialization
; 0000 0161 // Func3=In Func2=In Func1=In Func0=In
; 0000 0162 // State3=T State2=T State1=P State0=P
; 0000 0163 PORTB=0x03;
	LDI  R30,LOW(3)
	OUT  0x18,R30
; 0000 0164 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0165 
; 0000 0166 // Timer/Counter 0 initialization
; 0000 0167 // Clock source: System Clock
; 0000 0168 // Clock value: 8000,000 kHz
; 0000 0169 // Mode: Normal top=0xFF
; 0000 016A // OC0A output: Disconnected
; 0000 016B // OC0B output: Disconnected
; 0000 016C TCCR0A=0x00;
	OUT  0x30,R30
; 0000 016D TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 016E TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 016F OCR0A=0x1F;
	LDI  R30,LOW(31)
	OUT  0x36,R30
; 0000 0170 OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0171 
; 0000 0172 // Timer/Counter 1 initialization
; 0000 0173 // Clock source: System Clock
; 0000 0174 // Clock value: Timer1 Stopped
; 0000 0175 // Mode: Normal top=0xFFFF
; 0000 0176 // OC1A output: Discon.
; 0000 0177 // OC1B output: Discon.
; 0000 0178 // Noise Canceler: Off
; 0000 0179 // Input Capture on Falling Edge
; 0000 017A // Timer1 Overflow Interrupt: Off
; 0000 017B // Input Capture Interrupt: Off
; 0000 017C // Compare A Match Interrupt: Off
; 0000 017D // Compare B Match Interrupt: Off
; 0000 017E TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 017F TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0180 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0181 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0182 ICR1H=0x00;
	OUT  0x25,R30
; 0000 0183 ICR1L=0x00;
	OUT  0x24,R30
; 0000 0184 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0185 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0186 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0187 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0188 
; 0000 0189 // External Interrupt(s) initialization
; 0000 018A // INT0: Off
; 0000 018B // Interrupt on any change on pins PCINT0-7: On
; 0000 018C // Interrupt on any change on pins PCINT8-11: On
; 0000 018D MCUCR=0x00;
	OUT  0x35,R30
; 0000 018E PCMSK0=0x01;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 018F PCMSK1=0x03;
	LDI  R30,LOW(3)
	OUT  0x20,R30
; 0000 0190 GIMSK=0x20;
	LDI  R30,LOW(32)
	OUT  0x3B,R30
; 0000 0191 GIFR=0x30;
	LDI  R30,LOW(48)
	OUT  0x3A,R30
; 0000 0192 // Timer/Counter 0 Interrupt(s) initialization
; 0000 0193 TIMSK0=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0194 
; 0000 0195 // Timer/Counter 1 Interrupt(s) initialization
; 0000 0196 TIMSK1=0x00;
	LDI  R30,LOW(0)
	OUT  0xC,R30
; 0000 0197 
; 0000 0198 // Universal Serial Interface initialization
; 0000 0199 // Mode: Three Wire (SPI)
; 0000 019A // Clock source: Reg.=ext. pos. edge, Cnt.=USITC
; 0000 019B // USI Counter Overflow Interrupt: Off
; 0000 019C USICR=0x1A;
	LDI  R30,LOW(26)
	OUT  0xD,R30
; 0000 019D 
; 0000 019E // Analog Comparator initialization
; 0000 019F // Analog Comparator: Off
; 0000 01A0 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01A1 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01A2 ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 01A3 DIDR0=0x00;
	OUT  0x1,R30
; 0000 01A4 
; 0000 01A5 // ADC initialization
; 0000 01A6 // ADC disabled
; 0000 01A7 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01A8 
; 0000 01A9 // Global enable interrupts
; 0000 01AA #asm("sei")
	sei
; 0000 01AB  PORTA.2=1; //Светодиод 1
	SBI  0x1B,2
; 0000 01AC  PORTA.7=0; //Светодиод 2
	CBI  0x1B,7
; 0000 01AD       delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 01AE 
; 0000 01AF       RESET_TR();
	RCALL _RESET_TR
; 0000 01B0       delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 01B1       INIT_TR();
	RCALL _INIT_TR
; 0000 01B2       WRITE_PATABLE();
	RCALL _WRITE_PATABLE
; 0000 01B3 
; 0000 01B4 while (1)
_0x91:
; 0000 01B5 
; 0000 01B6       {  PORTA.2=0; //Светодиод 1
	CBI  0x1B,2
; 0000 01B7          PORTA.7=0; //Светодиод 2
	CBI  0x1B,7
; 0000 01B8         STROB(SPWD);
	LDI  R30,LOW(57)
	ST   -Y,R30
	RCALL _STROB
; 0000 01B9         delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 01BA         MCUCR|=0x30 ; //Разрешение перехода в спящий режим
	IN   R30,0x35
	ORI  R30,LOW(0x30)
	OUT  0x35,R30
; 0000 01BB         #asm("SLEEP")
	SLEEP
; 0000 01BC         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 01BD       }
	RJMP _0x91
; 0000 01BE }
_0x98:
	RJMP _0x98

	.CSEG
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
_0x2080001:
	ADIW R28,4
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_SPI_buffer:
	.BYTE 0x40
__seed_G101:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
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

;END OF CODE MARKER
__END_OF_CODE:
