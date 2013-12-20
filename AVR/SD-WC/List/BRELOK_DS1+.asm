
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny44
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 64 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
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
	RJMP _timer0_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_init:
	.DB  0x8,0xB,0x0,0xC,0x58,0xD,0xE9,0xE
	.DB  0x0,0xF,0xE4,0x10,0xF1,0x11,0x1,0x12
	.DB  0x2,0x13,0xE5,0x14,0x0,0xA,0x4,0x15
	.DB  0x56,0x21,0x10,0x22,0x7,0x16,0x30,0x17
	.DB  0x18,0x18,0x16,0x19,0x6C,0x1A,0xFB,0x1B
	.DB  0x40,0x1C,0x91,0x1D,0xA9,0x23,0xA,0x24
	.DB  0x0,0x25,0x11,0x26,0x59,0x29,0x88,0x2C
	.DB  0x31,0x2D,0xB,0x2E,0x6,0x0,0xE,0x2
	.DB  0x40,0x7,0x5,0x8,0x0,0x9,0xFF,0x6
	.DB  0x7,0x3,0xCF,0x4,0xFC,0x5

_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
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
;Project : BRELOK_DS1+
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
;                             0x10E4,     //5 MDMCFG4 ПАРАМЕТРЫ МОДЕМА ширина полосы пропускания
;                             0x11F1,     //6 MDMCFG3 скорость передачи
;                             0x1201,     //7 MDMCFG2 вид модуляции параметры слова синхронизации
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
;                             0x0006,     //30 IOCFG2 Конфигурация GDO2 - 1при приеме синхрослова 0 пакет принят
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
;
;// Определение глобальных переменных
;unsigned char i;   //Основной счетчик
;eeprom unsigned char STATUS[37];
;//*******************************************************************************************
;void LightDiode(unsigned char n) // Функция управления светодиодом
; 0000 005D {

	.CSEG
_LightDiode:
; 0000 005E  switch (n)
;	n -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x0
; 0000 005F  {
; 0000 0060  case 0:
	SBIW R30,0
	BRNE _0x6
; 0000 0061 			{
; 0000 0062 			PORTB.0=0;
	CBI  0x18,0
; 0000 0063             PORTB.1=0;
	CBI  0x18,1
; 0000 0064 				break;
	RJMP _0x5
; 0000 0065 			}
; 0000 0066  case 1:
_0x6:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
; 0000 0067 			{
; 0000 0068 			PORTB.0=1;
	SBI  0x18,0
; 0000 0069             PORTB.1=0;
	CBI  0x18,1
; 0000 006A 				break;
	RJMP _0x5
; 0000 006B 			}
; 0000 006C  case 2:
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x10
; 0000 006D 			{
; 0000 006E 			PORTB.0=0;
	CBI  0x18,0
; 0000 006F             PORTB.1=1;
	RJMP _0x5D
; 0000 0070 				break;
; 0000 0071  case 3:
_0x10:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5
; 0000 0072 			{
; 0000 0073 			PORTB.0=1;
	SBI  0x18,0
; 0000 0074            PORTB.1=1;
_0x5D:
	SBI  0x18,1
; 0000 0075 				break;
; 0000 0076 			} 			}
; 0000 0077  }
_0x5:
; 0000 0078 
; 0000 0079 }
	RJMP _0x2080002
;//*******************************************************************************************
;//*******************ФУНКЦИИ ДЛЯ РАБОТЫ С ТРАНСИВЕРОМ*****************************************
;//============================================================================================
;// Функция передачи символа по SPI
;unsigned char SPI_SEND(unsigned char data)
; 0000 007F {
_SPI_SEND:
; 0000 0080  USIDR=data;      // Загрузка данных в сдвиговый регистр
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 0081  USISR=(1<<USIOIF);  // Очистка флага переполнения и 4-битного счетчика
	LDI  R30,LOW(64)
	OUT  0xE,R30
; 0000 0082  TIFR0 |= (1<<OCF0A);   // Очистка флага прерывания по совпадению таймера
	IN   R30,0x38
	ORI  R30,2
	OUT  0x38,R30
; 0000 0083  TIMSK0 |= (1<<OCIE0A); // Разрешение прерывания по совпадению
	IN   R30,0x39
	ORI  R30,2
	OUT  0x39,R30
; 0000 0084  while(USISR.USIOIF==0); //Ожидание конца передачи байта
_0x1A:
	SBIS 0xE,6
	RJMP _0x1A
; 0000 0085  TIMSK0=0x00;     //Запрет прерывания
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 0086  return USIDR; // Возврат данных
	IN   R30,0xF
_0x2080002:
	ADIW R28,1
	RET
; 0000 0087  }
;//*******************************************************************************************
; void RESET_TR(void) //Сброс трансивера по включению питания
; 0000 008A {
_RESET_TR:
; 0000 008B USICR=0x00; //Отключение SPI
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 008C PORTA.4=1; //Устанавливаем 1 на SCK
	SBI  0x1B,4
; 0000 008D PORTA.5=0;  // Устанавливаем 0 на MOSI
	CBI  0x1B,5
; 0000 008E PORTA.7=0; // SPI_SS ON
	CBI  0x1B,7
; 0000 008F delay_us(1);
	__DELAY_USB 3
; 0000 0090 PORTA.7=1; // SPI_SS OFF
	SBI  0x1B,7
; 0000 0091 delay_us(40);
	__DELAY_USB 107
; 0000 0092 USICR=0x1A; //Включение SPI
	LDI  R30,LOW(26)
	OUT  0xD,R30
; 0000 0093 PORTA.7=0; // SPI_SS ON
	CBI  0x1B,7
; 0000 0094 while(PORTA.6==1); //Ждем 0 на MISO
_0x27:
	SBIC 0x1B,6
	RJMP _0x27
; 0000 0095 SPI_SEND(SRES);
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x1
; 0000 0096 PORTA.7=1; // SPI_SS OFF
	RJMP _0x2080001
; 0000 0097 }
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
; 0000 00AB   PORTA.7=0; // SPI_SS ON
	SBIW R28,2
	ST   -Y,R17
;	dt -> Y+1
;	err -> R17
	CBI  0x1B,7
; 0000 00AC while(PORTA.6==1); //Ждем 0 на MISO
_0x2E:
	SBIC 0x1B,6
	RJMP _0x2E
; 0000 00AD   do{
_0x32:
; 0000 00AE   for (i=0;i<39;i++)
	CLR  R3
_0x35:
	LDI  R30,LOW(39)
	CP   R3,R30
	BRSH _0x36
; 0000 00AF    {
; 0000 00B0     WRITE_REG(init[i]);
	RCALL SUBOPT_0x2
	ST   -Y,R31
	ST   -Y,R30
	RCALL _WRITE_REG
; 0000 00B1     };
	INC  R3
	RJMP _0x35
_0x36:
; 0000 00B2     err=0;
	LDI  R17,LOW(0)
; 0000 00B3 
; 0000 00B4     for (i=0;i<39;i++)
	CLR  R3
_0x38:
	LDI  R30,LOW(39)
	CP   R3,R30
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
	INC  R3
	RJMP _0x38
_0x39:
; 0000 00B9 
; 0000 00BA     }while(err==1);
	CPI  R17,1
	BREQ _0x32
; 0000 00BB 
; 0000 00BC   PORTA.7=1; // SPI_SS OFF
	SBI  0x1B,7
; 0000 00BD  }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;//********************************************************************************************
;void WRITE_PATABLE(void)    //Запись таблицы мощности
; 0000 00C0 {
_WRITE_PATABLE:
; 0000 00C1 PORTA.7=0; // SPI_SS ON
	CBI  0x1B,7
; 0000 00C2 while(PORTA.6==1); //Ждем 0 на MISO
_0x3F:
	SBIC 0x1B,6
	RJMP _0x3F
; 0000 00C3 WRITE_REG(0x3EFF);         //Запись значения выходной мощности передатчика +1dbm
	LDI  R30,LOW(16127)
	LDI  R31,HIGH(16127)
	RCALL SUBOPT_0x3
	RCALL _WRITE_REG
; 0000 00C4 //SPI_SEND(0x7E);
; 0000 00C5 //SPI_SEND(0x00);
; 0000 00C6 //SPI_SEND(0xFF);
; 0000 00C7 PORTA.7=1; // SPI_SS OFF
_0x2080001:
	SBI  0x1B,7
; 0000 00C8 }
	RET
;//*********************************************************************************************
;
;
;//*********************************************************************************************
;//===========================ПРЕРЫВАНИЯ======================================================
;// Timer 0 output compare A interrupt service routine
;interrupt [TIM0_COMPA] void timer0_compa_isr(void)    //Прерывание по совпадению таймера
; 0000 00D0 {
_timer0_compa_isr:
; 0000 00D1 USICR |= (1<<USITC); // Задание тактового импульса
	SBI  0xD,0
; 0000 00D2 
; 0000 00D3 }
	RETI
;
;//============================================================================================
;//+++++++++++++++++++ОСНОВНАЯ ФУНКЦИЯ ПРОГРАММЫ ++++++++++++++++++++++++++++++++++++++++++++++
;//=============================================================================================
;
;void main(void)
; 0000 00DA {
_main:
; 0000 00DB // Declare your local variables here
; 0000 00DC 
; 0000 00DD // Crystal Oscillator division factor: 1
; 0000 00DE #pragma optsize-
; 0000 00DF CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00E0 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00E1 #ifdef _OPTIMIZE_SIZE_
; 0000 00E2 #pragma optsize+
; 0000 00E3 #endif
; 0000 00E4 
; 0000 00E5 // Input/Output Ports initialization
; 0000 00E6 // Port A initialization
; 0000 00E7 // Func7=Out Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 00E8 // State7=1 State6=T State5=0 State4=0 State3=T State2=T State1=P State0=P
; 0000 00E9 PORTA=0x83;
	LDI  R30,LOW(131)
	OUT  0x1B,R30
; 0000 00EA DDRA=0xB0;
	LDI  R30,LOW(176)
	OUT  0x1A,R30
; 0000 00EB 
; 0000 00EC // Port B initialization
; 0000 00ED // Func3=In Func2=In Func1=Out Func0=Out
; 0000 00EE // State3=T State2=T State1=0 State0=0
; 0000 00EF PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00F0 DDRB=0x03;
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 00F1 
; 0000 00F2 // Timer/Counter 0 initialization
; 0000 00F3 // Clock source: System Clock
; 0000 00F4 // Clock value: 8000,000 kHz
; 0000 00F5 // Mode: Normal top=0xFF
; 0000 00F6 // OC0A output: Disconnected
; 0000 00F7 // OC0B output: Disconnected
; 0000 00F8 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F9 TCCR0B=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 00FA TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00FB OCR0A=0x1F;
	LDI  R30,LOW(31)
	OUT  0x36,R30
; 0000 00FC OCR0B=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00FD 
; 0000 00FE // Timer/Counter 1 initialization
; 0000 00FF // Clock source: System Clock
; 0000 0100 // Clock value: Timer1 Stopped
; 0000 0101 // Mode: Normal top=0xFFFF
; 0000 0102 // OC1A output: Discon.
; 0000 0103 // OC1B output: Discon.
; 0000 0104 // Noise Canceler: Off
; 0000 0105 // Input Capture on Falling Edge
; 0000 0106 // Timer1 Overflow Interrupt: Off
; 0000 0107 // Input Capture Interrupt: Off
; 0000 0108 // Compare A Match Interrupt: Off
; 0000 0109 // Compare B Match Interrupt: Off
; 0000 010A TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 010B TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 010C TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 010D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 010E ICR1H=0x00;
	OUT  0x25,R30
; 0000 010F ICR1L=0x00;
	OUT  0x24,R30
; 0000 0110 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0111 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0112 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0113 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0114 
; 0000 0115 // External Interrupt(s) initialization
; 0000 0116 // INT0: Off
; 0000 0117 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0118 // Interrupt on any change on pins PCINT8-11: Off
; 0000 0119 MCUCR=0x00;
	OUT  0x35,R30
; 0000 011A GIMSK=0x00;
	OUT  0x3B,R30
; 0000 011B 
; 0000 011C // Timer/Counter 0 Interrupt(s) initialization
; 0000 011D TIMSK0=0x00;
	OUT  0x39,R30
; 0000 011E 
; 0000 011F // Timer/Counter 1 Interrupt(s) initialization
; 0000 0120 TIMSK1=0x00;
	OUT  0xC,R30
; 0000 0121 
; 0000 0122 // Universal Serial Interface initialization
; 0000 0123 // Mode: Three Wire (SPI)
; 0000 0124 // Clock source: Reg.=ext. pos. edge, Cnt.=USITC
; 0000 0125 // USI Counter Overflow Interrupt: Off
; 0000 0126 USICR=0x00;
	OUT  0xD,R30
; 0000 0127 
; 0000 0128 // Analog Comparator initialization
; 0000 0129 // Analog Comparator: Off
; 0000 012A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 012B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 012C ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 012D DIDR0=0x00;
	OUT  0x1,R30
; 0000 012E 
; 0000 012F // ADC initialization
; 0000 0130 // ADC disabled
; 0000 0131 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0132 
; 0000 0133 // Global enable interrupts
; 0000 0134 #asm("sei")
	sei
; 0000 0135 
; 0000 0136 while (1)
; 0000 0137       {LightDiode(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 0138       delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x4
; 0000 0139       RESET_TR();
	RCALL _RESET_TR
; 0000 013A       delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x4
; 0000 013B       INIT_TR();
	RCALL _INIT_TR
; 0000 013C       WRITE_PATABLE();
	RCALL _WRITE_PATABLE
; 0000 013D m:
; 0000 013E       LightDiode(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 013F        PORTA.7=0; // SPI_SS ON
	CBI  0x1B,7
; 0000 0140       while(PORTA.6==1); //Ждем 0 на MISO
_0x4A:
	SBIC 0x1B,6
	RJMP _0x4A
; 0000 0141       SPI_SEND(SIDLE); //Переход в режим IDLE
	LDI  R30,LOW(54)
	RCALL SUBOPT_0x1
; 0000 0142       SPI_SEND(SFRX); //Сброс буфера приема
	LDI  R30,LOW(58)
	RCALL SUBOPT_0x1
; 0000 0143       SPI_SEND(SFTX); //Сброс буфера передачи
	LDI  R30,LOW(59)
	RCALL SUBOPT_0x1
; 0000 0144      // SPI_SEND(SRX);
; 0000 0145 
; 0000 0146 
; 0000 0147       SPI_SEND(0x7F);
	LDI  R30,LOW(127)
	RCALL SUBOPT_0x1
; 0000 0148       SPI_SEND(0x08);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x1
; 0000 0149       SPI_SEND('S');
	LDI  R30,LOW(83)
	RCALL SUBOPT_0x1
; 0000 014A       SPI_SEND('E');
	LDI  R30,LOW(69)
	RCALL SUBOPT_0x1
; 0000 014B       SPI_SEND('X');
	LDI  R30,LOW(88)
	RCALL SUBOPT_0x1
; 0000 014C       SPI_SEND('O');
	LDI  R30,LOW(79)
	RCALL SUBOPT_0x1
; 0000 014D       SPI_SEND('N');
	LDI  R30,LOW(78)
	RCALL SUBOPT_0x1
; 0000 014E       SPI_SEND('I');
	LDI  R30,LOW(73)
	RCALL SUBOPT_0x1
; 0000 014F       SPI_SEND('X');
	LDI  R30,LOW(88)
	RCALL SUBOPT_0x1
; 0000 0150 
; 0000 0151       PORTA.7=1; // SPI_SS OFF
	SBI  0x1B,7
; 0000 0152       // LightDiode(0);
; 0000 0153       delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x4
; 0000 0154 
; 0000 0155 
; 0000 0156       PORTA.7=0; // SPI_SS ON
	CBI  0x1B,7
; 0000 0157       while(PORTA.6==1); //Ждем 0 на MISO
_0x51:
	SBIC 0x1B,6
	RJMP _0x51
; 0000 0158               /*
; 0000 0159        SPI_SEND(0xFA);
; 0000 015A       STATUS[0]=SPI_SEND(0xFF);
; 0000 015B       STATUS[1]=SPI_SEND(SNOP);
; 0000 015C               */
; 0000 015D       SPI_SEND(STX);
	LDI  R30,LOW(53)
	RCALL SUBOPT_0x1
; 0000 015E       delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x4
; 0000 015F                      /*
; 0000 0160       STATUS[2]=SPI_SEND(SNOP);
; 0000 0161       delay_ms(100);
; 0000 0162       STATUS[3]=SPI_SEND(SNOP);
; 0000 0163                   */
; 0000 0164      // PORTA.7=1; // SPI_SS OFF
; 0000 0165 
; 0000 0166      //while(PORTA.3==0);
; 0000 0167      LightDiode(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _LightDiode
; 0000 0168      PORTA.7=1; // SPI_SS OFF
	SBI  0x1B,7
; 0000 0169      // while(PORTA.3==1);
; 0000 016A        //LightDiode(0);
; 0000 016B           /*
; 0000 016C      for (i=0;i<37;i++)
; 0000 016D        {
; 0000 016E        data.buf=init[i];
; 0000 016F         STATUS[i]=READ_REG(data.b[1]);}
; 0000 0170                 */
; 0000 0171                 /*
; 0000 0172       PORTA.7=1; // SPI_SS OFF
; 0000 0173          delay_ms(300);
; 0000 0174       LightDiode(2);
; 0000 0175               */
; 0000 0176               while(1);
_0x56:
	RJMP _0x56
; 0000 0177               delay_ms(1000);
; 0000 0178               goto m;
; 0000 0179       while(1);
_0x59:
	RJMP _0x59
; 0000 017A       }
; 0000 017B }
_0x5C:
	RJMP _0x5C

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	RJMP _SPI_SEND

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	MOV  R30,R3
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
	RCALL SUBOPT_0x3
	RJMP _delay_ms


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
