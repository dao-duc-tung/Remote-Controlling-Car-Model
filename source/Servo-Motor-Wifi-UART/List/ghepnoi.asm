
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _i=R10
	.DEF _l_ap=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x4E,0x69,0x6E,0x6A,0x61,0x20,0x57,0x61
	.DB  0x79,0x0,0x49,0x50,0x20,0x41,0x50,0x20
	.DB  0x61,0x6E,0x64,0x0,0x49,0x50,0x20,0x53
	.DB  0x54,0x41,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  _0x18
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x53
	.DW  _0x0*2+10

	.DW  0x07
	.DW  _0x53+10
	.DW  _0x0*2+20

	.DW  0x0A
	.DW  _0x53+17
	.DW  _0x0*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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

	JMP  _main

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
;Date    : 18-Dec-2015
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdint.h>
;#include <string.h>
;#include <delay.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#define WLeft_1 PORTC.4
;#define WLeft_2 PORTC.3
;#define WRight_1 PORTC.2
;#define WRight_2 PORTD.7
;#define LedTest PORTD.6
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
;#define RX_BUFFER_SIZE 8
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
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0057 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0058 char status,data;
; 0000 0059 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 005A data=UDR;
	IN   R16,12
; 0000 005B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 005C    {
; 0000 005D    rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 005E #if RX_BUFFER_SIZE == 256
; 0000 005F    // special case for receiver buffer size=256
; 0000 0060    if (++rx_counter == 0)
; 0000 0061       {
; 0000 0062 #else
; 0000 0063    if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0064    if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0065       {
; 0000 0066       rx_counter=0;
	CLR  R7
; 0000 0067 #endif
; 0000 0068       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0069       }
; 0000 006A    }
_0x5:
; 0000 006B }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x86
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0072 {
_getchar:
; 0000 0073 char data;
; 0000 0074 while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 0075 data=rx_buffer[rx_rd_index++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0076 #if RX_BUFFER_SIZE != 256
; 0000 0077 if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0078 #endif
; 0000 0079 #asm("cli")
_0x9:
	cli
; 0000 007A --rx_counter;
	DEC  R7
; 0000 007B #asm("sei")
	sei
; 0000 007C return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 007D }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 008D {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008E if (tx_counter)
	TST  R8
	BREQ _0xA
; 0000 008F    {
; 0000 0090    --tx_counter;
	DEC  R8
; 0000 0091    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0092 #if TX_BUFFER_SIZE != 256
; 0000 0093    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
; 0000 0094 #endif
; 0000 0095    }
_0xB:
; 0000 0096 }
_0xA:
_0x86:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 009D {
; 0000 009E while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 009F #asm("cli")
; 0000 00A0 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
; 0000 00A1    {
; 0000 00A2    tx_buffer[tx_wr_index++]=c;
; 0000 00A3 #if TX_BUFFER_SIZE != 256
; 0000 00A4    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 00A5 #endif
; 0000 00A6    ++tx_counter;
; 0000 00A7    }
; 0000 00A8 else
; 0000 00A9    UDR=c;
; 0000 00AA #asm("sei")
; 0000 00AB }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;int i; // running variable
;char AP[15]; // Save IP Address of Access Point
;char STA[15]; // save IP Address of Station Point
;int l_ap, l_sta; //the length of IP of AP and STA
;int cmd[3]; // save command to exec
;char LCD_Buff[16]; // buffer of LCD
;
;// prototype
;void Exec_Cmd(int mode);
;int Get_Cmd(char c);
;
;void Control_mode0(int dir, int state);
;void Control_mode1(int state);
;void Control_mode5();
;void ShowIP();
;
;// mode 0
;void Stop();
;void Forward();
;void Backward();
;void Straight();
;void Left();
;void Right();
;
;// mode 1
;//void Stop();
;//void Forward();
;//void Backward();
;void Turn_Left();
;void Turn_Right();
;
;// External Interrupt 0 service routine
;//interrupt [EXT_INT0] void ext_int0_isr(void){
;//
;//    // Place your code here
;//    //putchar('2'); // send command to ESP
;//    //Control_mode2(); // receiver data from ESP
;//    LedTest = 1;
;////    delay_ms(2000);
;////    LedTest = 0;
;//}
;
;// Get IP Server on ESP and display to LCD
;interrupt [EXT_INT1] void ext_int1_isr(void){
; 0000 00DF interrupt [3] void ext_int1_isr(void){
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
; 0000 00E0 
; 0000 00E1     // Place your code here
; 0000 00E2     LedTest = 1;
	SBI  0x12,6
; 0000 00E3     ShowIP();
	RCALL _ShowIP
; 0000 00E4     LedTest = 0;
	CBI  0x12,6
; 0000 00E5 }
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
;void main(void)
; 0000 00E8 {
_main:
; 0000 00E9 // Declare your local variables here
; 0000 00EA 
; 0000 00EB // Input/Output Ports initialization
; 0000 00EC // Port A initialization
; 0000 00ED // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 00EE // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 00EF PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00F0 DDRA=0xF0;
	LDI  R30,LOW(240)
	OUT  0x1A,R30
; 0000 00F1 
; 0000 00F2 // Port B initialization
; 0000 00F3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00F4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00F5 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00F6 DDRB=0x00;
	OUT  0x17,R30
; 0000 00F7 
; 0000 00F8 // Port C initialization
; 0000 00F9 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 00FA // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=T State0=T
; 0000 00FB PORTC=0x00;
	OUT  0x15,R30
; 0000 00FC DDRC=0x1C; //C2 (Right 1),3 (Left 2),4 (Left 1): output
	LDI  R30,LOW(28)
	OUT  0x14,R30
; 0000 00FD 
; 0000 00FE // Port D initialization
; 0000 00FF // Func7=In Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=In
; 0000 0100 // State7=T State6=T State5=0 State4=0 State3=T State2=T State1=0 State0=P
; 0000 0101 PORTD=0x09;
	LDI  R30,LOW(9)
	OUT  0x12,R30
; 0000 0102 DDRD=0xF2; //D1 (TxD),4 (OC1B - Reserved),5 (OC1A),6 (led test),7 (Right 2): output; D0 (RxD), D3 (INT1): input
	LDI  R30,LOW(242)
	OUT  0x11,R30
; 0000 0103 
; 0000 0104 // Timer/Counter 0 initialization
; 0000 0105 // Clock source: System Clock
; 0000 0106 // Clock value: Timer 0 Stopped
; 0000 0107 // Mode: Normal top=0xFF
; 0000 0108 // OC0 output: Disconnected
; 0000 0109 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 010A TCNT0=0x00;
	OUT  0x32,R30
; 0000 010B OCR0=0x00;
	OUT  0x3C,R30
; 0000 010C 
; 0000 010D // Timer/Counter 1 initialization
; 0000 010E // Clock source: System Clock
; 0000 010F // Clock value: 1000.000 kHz
; 0000 0110 // Mode: Fast PWM top=ICR1
; 0000 0111 // OC1A output: Non-Inv.
; 0000 0112 // OC1B output: Non-Inv.
; 0000 0113 // Noise Canceler: Off
; 0000 0114 // Input Capture on Falling Edge
; 0000 0115 // Timer1 Overflow Interrupt: Off
; 0000 0116 // Input Capture Interrupt: Off
; 0000 0117 // Compare A Match Interrupt: Off
; 0000 0118 // Compare B Match Interrupt: Off
; 0000 0119 TCCR1A=0xA2;
	LDI  R30,LOW(162)
	OUT  0x2F,R30
; 0000 011A TCCR1B=0x1A;
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 011B TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 011C TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 011D ICR1H=0x4E;
	LDI  R30,LOW(78)
	OUT  0x27,R30
; 0000 011E ICR1L=0x20;
	LDI  R30,LOW(32)
	OUT  0x26,R30
; 0000 011F OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0120 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0121 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0122 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0123 
; 0000 0124 // Timer/Counter 2 initialization
; 0000 0125 // Clock source: System Clock
; 0000 0126 // Clock value: Timer2 Stopped
; 0000 0127 // Mode: Normal top=0xFF
; 0000 0128 // OC2 output: Disconnected
; 0000 0129 ASSR=0x00;
	OUT  0x22,R30
; 0000 012A TCCR2=0x00;
	OUT  0x25,R30
; 0000 012B TCNT2=0x00;
	OUT  0x24,R30
; 0000 012C OCR2=0x00;
	OUT  0x23,R30
; 0000 012D 
; 0000 012E // External Interrupt(s) initialization
; 0000 012F // INT0: Off
; 0000 0130 // INT1: On
; 0000 0131 // INT2: Off
; 0000 0132 GICR|=0x80;
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0133 MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 0134 GIFR = 0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0135 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0136 
; 0000 0137 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0138 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0139 
; 0000 013A // USART initialization
; 0000 013B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 013C // USART Receiver: On
; 0000 013D // USART Transmitter: On
; 0000 013E // USART Mode: Asynchronous
; 0000 013F // USART Baud Rate: 9600
; 0000 0140 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0141 UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0142 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0143 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0144 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0145 
; 0000 0146 // Analog Comparator initialization
; 0000 0147 // Analog Comparator: Off
; 0000 0148 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0149 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 014A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 014B 
; 0000 014C // ADC initialization
; 0000 014D // ADC disabled
; 0000 014E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 014F 
; 0000 0150 // SPI initialization
; 0000 0151 // SPI disabled
; 0000 0152 SPCR=0x00;
	OUT  0xD,R30
; 0000 0153 
; 0000 0154 // TWI initialization
; 0000 0155 // TWI disabled
; 0000 0156 TWCR=0x00;
	OUT  0x36,R30
; 0000 0157 
; 0000 0158 // Alphanumeric LCD initialization
; 0000 0159 // Connections specified in the
; 0000 015A // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 015B // RS - PORTC Bit 5
; 0000 015C // RD - PORTC Bit 6
; 0000 015D // EN - PORTC Bit 7
; 0000 015E // D4 - PORTA Bit 3
; 0000 015F // D5 - PORTA Bit 2
; 0000 0160 // D6 - PORTA Bit 1
; 0000 0161 // D7 - PORTA Bit 0
; 0000 0162 // Characters/line: 16
; 0000 0163 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0164 lcd_clear();
	CALL SUBOPT_0x0
; 0000 0165 lcd_gotoxy(0,0);
; 0000 0166 lcd_puts("Ninja Way");
	__POINTW1MN _0x18,0
	CALL SUBOPT_0x1
; 0000 0167 
; 0000 0168 // Global enable interrupts
; 0000 0169 #asm("sei")
	sei
; 0000 016A 
; 0000 016B LedTest = 0;
	CBI  0x12,6
; 0000 016C OCR1A = 700;
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 016D delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x2
; 0000 016E OCR1A = 1150;
	LDI  R30,LOW(1150)
	LDI  R31,HIGH(1150)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 016F Control_mode0(0,0);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Control_mode0
; 0000 0170 
; 0000 0171 while (1)
_0x1B:
; 0000 0172       {
; 0000 0173         // Place your code here
; 0000 0174         cmd[0] = Get_Cmd(getchar()); // get MODE
	CALL SUBOPT_0x3
	STS  _cmd,R30
	STS  _cmd+1,R31
; 0000 0175         Exec_Cmd(cmd[0]); // Executing
	ST   -Y,R31
	ST   -Y,R30
	RCALL _Exec_Cmd
; 0000 0176       }
	RJMP _0x1B
; 0000 0177 }
_0x1E:
	RJMP _0x1E

	.DSEG
_0x18:
	.BYTE 0xA
;
;// mode 0, 1
;// byte 0: mode
;// byte 1: mode 0: dir  , mode 1: x    , mode 2: ..
;// byte 2: mode 0: state, mode 1: state, mode 2: ..
;
;// mode 2: after get the first byte of data through UART into cmd[0] (value = 2 --> mode 2)
;// the next 2 bytes: a one digit number -- the number of bytes of the number of bytes of the IP address, Subnet Mask, respectively (just only equal 1)
;// the next bytes: the 2 numbers of bytes of the IP address, Subnet Mask, respectively (just only is a one or two digit number)
;// the next bytes: the IP address, Subnet Mask of Server on ESP, respectively
;// For examlpe: an array of bytes when mode 2 is activated
;// 2 2 2 1 1 1 3 1 9 2 . 1 6 8 . 4 . 1 2 5 5 . 2 5 5 . 2 5 5 .0
;// Explaining:
;// 192.168.4.1 includes 11 bytes, 255.255.255.0 includes 13 bytes
;// 11 is a number including 2 bytes, and 13 is too
;
;// mode 0: direct by 2 front wheels
;// mode 1: direct by 2 behind wheels
;// mode 2: print IP ESP to LCD
;// mode 4: disconnect wifi - process in ESP
;void Exec_Cmd(int mode){
; 0000 018C void Exec_Cmd(int mode){

	.CSEG
_Exec_Cmd:
; 0000 018D     switch(mode){
;	mode -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 018E         case 0: for(i = 1; i < 3; i++) cmd[i] = Get_Cmd(getchar()); Control_mode0(cmd[1], cmd[2]); break;
	SBIW R30,0
	BRNE _0x22
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
_0x24:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x25
	CALL SUBOPT_0x4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x24
_0x25:
	__GETW1MN _cmd,2
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5
	RCALL _Control_mode0
	RJMP _0x21
; 0000 018F         case 1: for(i = 1; i < 3; i++) cmd[i] = Get_Cmd(getchar()); Control_mode1(cmd[2]);         break;
_0x22:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x26
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
_0x28:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R10,R30
	CPC  R11,R31
	BRGE _0x29
	CALL SUBOPT_0x4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x28
_0x29:
	CALL SUBOPT_0x5
	RCALL _Control_mode1
	RJMP _0x21
; 0000 0190         case 5: {
_0x26:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2B
; 0000 0191             Control_mode5();
	RCALL _Control_mode5
; 0000 0192         }break;
; 0000 0193         default: ;
_0x2B:
; 0000 0194     }
_0x21:
; 0000 0195 }
	RJMP _0x2080002
;
;// Sub 48 for getting the number in Binary, not in ASCII
;int Get_Cmd(char c){
; 0000 0198 int Get_Cmd(char c){
_Get_Cmd:
; 0000 0199     return c - 48;
;	c -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBIW R30,48
	JMP  _0x2080001
; 0000 019A }
;
;//
;void Control_mode0(int dir, int state){
; 0000 019D void Control_mode0(int dir, int state){
_Control_mode0:
; 0000 019E     switch(dir){
;	dir -> Y+2
;	state -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
; 0000 019F         case 0: Straight(); break;
	SBIW R30,0
	BREQ _0x82
; 0000 01A0         case 1: Left(); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x30
	RCALL _Left
	RJMP _0x2E
; 0000 01A1         case 2: Right(); break;
_0x30:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x32
	RCALL _Right
	RJMP _0x2E
; 0000 01A2         default: Straight(); break;
_0x32:
_0x82:
	RCALL _Straight
; 0000 01A3     }
_0x2E:
; 0000 01A4 
; 0000 01A5     switch(state){
	LD   R30,Y
	LDD  R31,Y+1
; 0000 01A6         case 0: Stop(); break;
	SBIW R30,0
	BREQ _0x83
; 0000 01A7         case 1: Forward(); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x37
	RCALL _Forward
	RJMP _0x35
; 0000 01A8         case 2: Backward(); break;
_0x37:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x39
	RCALL _Backward
	RJMP _0x35
; 0000 01A9         default: Stop(); break;
_0x39:
_0x83:
	RCALL _Stop
; 0000 01AA     }
_0x35:
; 0000 01AB }
	ADIW R28,4
	RET
;
;// 0: Stop, 1: Go Forward, 2: Go Backward, 3: Turn Left, 4: Turn Right
;void Control_mode1(int state){
; 0000 01AE void Control_mode1(int state){
_Control_mode1:
; 0000 01AF     switch(state){
;	state -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 01B0         case 0: Stop(); break;
	SBIW R30,0
	BREQ _0x84
; 0000 01B1         case 1: Forward(); break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3E
	RCALL _Forward
	RJMP _0x3C
; 0000 01B2         case 2: Backward(); break;
_0x3E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3F
	RCALL _Backward
	RJMP _0x3C
; 0000 01B3         case 3: Turn_Left(); break;
_0x3F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40
	RCALL _Turn_Left
	RJMP _0x3C
; 0000 01B4         case 4: Turn_Right(); break;
_0x40:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x42
	RCALL _Turn_Right
	RJMP _0x3C
; 0000 01B5         default: Stop(); break;
_0x42:
_0x84:
	RCALL _Stop
; 0000 01B6     }
_0x3C:
; 0000 01B7 }
	RJMP _0x2080002
;
;//
;void Control_mode5(){
; 0000 01BA void Control_mode5(){
_Control_mode5:
; 0000 01BB     char len_len_ap, len_len_sta; // the number of bytes of the number of bytes of the IP address, Subnet Mask, respectively (just only equal 1)
; 0000 01BC     char len_ap[2], len_sta[2]; // the number of bytes of the IP address, Subnet Mask, respectively (just only is a one or two digit number)
; 0000 01BD 
; 0000 01BE 
; 0000 01BF     len_len_ap = Get_Cmd(getchar());
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	len_len_ap -> R17
;	len_len_sta -> R16
;	len_ap -> Y+4
;	len_sta -> Y+2
	CALL SUBOPT_0x3
	MOV  R17,R30
; 0000 01C0     len_len_sta = Get_Cmd(getchar());
	CALL SUBOPT_0x3
	MOV  R16,R30
; 0000 01C1 
; 0000 01C2     for(i = 0; i < len_len_ap; i++) len_ap[i] = Get_Cmd(getchar());
	CLR  R10
	CLR  R11
_0x44:
	MOV  R30,R17
	CALL SUBOPT_0x6
	BRGE _0x45
	MOVW R30,R10
	MOVW R26,R28
	ADIW R26,4
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X,R30
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
	RJMP _0x44
_0x45:
; 0000 01C3 for(i = 0; i < len_len_sta; i++) len_sta[i] = Get_Cmd(getchar());
	CLR  R10
	CLR  R11
_0x47:
	MOV  R30,R16
	CALL SUBOPT_0x6
	BRGE _0x48
	MOVW R30,R10
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	ST   X,R30
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
	RJMP _0x47
_0x48:
; 0000 01C5 if(len_len_ap == 1) l_ap = len_ap[0];
	CPI  R17,1
	BRNE _0x49
	LDD  R12,Y+4
	CLR  R13
; 0000 01C6     else l_ap = len_ap[1] + len_ap[0] * 10;
	RJMP _0x4A
_0x49:
	LDD  R22,Y+5
	CLR  R23
	LDD  R26,Y+4
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ADC  R31,R23
	MOVW R12,R30
; 0000 01C7     if(len_len_sta == 1) l_sta = len_sta[0];
_0x4A:
	CPI  R16,1
	BRNE _0x4B
	LDD  R30,Y+2
	LDI  R31,0
	RJMP _0x85
; 0000 01C8     else l_sta = len_sta[1] + len_sta[0] * 10;
_0x4B:
	LDD  R22,Y+3
	CLR  R23
	LDD  R26,Y+2
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R22
	ADC  R31,R23
_0x85:
	STS  _l_sta,R30
	STS  _l_sta+1,R31
; 0000 01C9 
; 0000 01CA     for(i = 0; i < l_ap; i++) { AP[i] = getchar();}
	CLR  R10
	CLR  R11
_0x4E:
	__CPWRR 10,11,12,13
	BRGE _0x4F
	MOVW R30,R10
	SUBI R30,LOW(-_AP)
	SBCI R31,HIGH(-_AP)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x4E
_0x4F:
; 0000 01CB     for(i = 0; i < l_sta; i++) { STA[i] = getchar();}
	CLR  R10
	CLR  R11
_0x51:
	CALL SUBOPT_0x7
	BRGE _0x52
	MOVW R30,R10
	SUBI R30,LOW(-_STA)
	SBCI R31,HIGH(-_STA)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x51
_0x52:
; 0000 01CC 
; 0000 01CD     ShowIP();
	RCALL _ShowIP
; 0000 01CE }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;void ShowIP(){
; 0000 01D0 void ShowIP(){
_ShowIP:
; 0000 01D1     lcd_clear();
	CALL SUBOPT_0x0
; 0000 01D2     lcd_gotoxy(0,0);
; 0000 01D3     lcd_puts("IP AP and");
	__POINTW1MN _0x53,0
	CALL SUBOPT_0x1
; 0000 01D4     lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01D5     lcd_puts("IP STA");
	__POINTW1MN _0x53,10
	CALL SUBOPT_0x1
; 0000 01D6     delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
; 0000 01D7     lcd_clear();
	CALL SUBOPT_0x0
; 0000 01D8 
; 0000 01D9     lcd_gotoxy(0,0);
; 0000 01DA     for(i = 0; i < l_ap; i++) lcd_putchar(AP[i]);
	CLR  R10
	CLR  R11
_0x55:
	__CPWRR 10,11,12,13
	BRGE _0x56
	LDI  R26,LOW(_AP)
	LDI  R27,HIGH(_AP)
	CALL SUBOPT_0x9
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x55
_0x56:
; 0000 01DC lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01DD     for(i = 0; i < l_sta; i++) lcd_putchar(STA[i]);
	CLR  R10
	CLR  R11
_0x58:
	CALL SUBOPT_0x7
	BRGE _0x59
	LDI  R26,LOW(_STA)
	LDI  R27,HIGH(_STA)
	CALL SUBOPT_0x9
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x58
_0x59:
; 0000 01DF delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
; 0000 01E0     lcd_clear();
	CALL _lcd_clear
; 0000 01E1     lcd_puts("Ninja Way");
	__POINTW1MN _0x53,17
	CALL SUBOPT_0x1
; 0000 01E2 }
	RET

	.DSEG
_0x53:
	.BYTE 0x1B
;
;void Stop(){
; 0000 01E4 void Stop(){

	.CSEG
_Stop:
; 0000 01E5     WLeft_1 = 0;
	CBI  0x15,4
; 0000 01E6     WLeft_2 = 0;
	CBI  0x15,3
; 0000 01E7     WRight_1 = 0;
	CBI  0x15,2
; 0000 01E8     WRight_2 = 0;
	RJMP _0x2080005
; 0000 01E9 }
;
;void Forward(){
; 0000 01EB void Forward(){
_Forward:
; 0000 01EC     WLeft_1 = 0;
	CBI  0x15,4
; 0000 01ED     WLeft_2 = 1;
	SBI  0x15,3
; 0000 01EE     WRight_1 = 0;
	RJMP _0x2080003
; 0000 01EF     WRight_2 = 1;
; 0000 01F0 }
;
;void Backward(){
; 0000 01F2 void Backward(){
_Backward:
; 0000 01F3     WLeft_1 = 1;
	SBI  0x15,4
; 0000 01F4     WLeft_2 = 0;
	CBI  0x15,3
; 0000 01F5     WRight_1 = 1;
	RJMP _0x2080004
; 0000 01F6     WRight_2 = 0;
; 0000 01F7 }
;
;void Straight(){
; 0000 01F9 void Straight(){
_Straight:
; 0000 01FA     OCR1A = 1150;
	LDI  R30,LOW(1150)
	LDI  R31,HIGH(1150)
	RJMP _0x2080006
; 0000 01FB }
;
;void Left(){
; 0000 01FD void Left(){
_Left:
; 0000 01FE     OCR1A = 700;
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	RJMP _0x2080006
; 0000 01FF }
;
;void Right(){
; 0000 0201 void Right(){
_Right:
; 0000 0202     OCR1A = 1520;
	LDI  R30,LOW(1520)
	LDI  R31,HIGH(1520)
_0x2080006:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0203 }
	RET
;
;void Turn_Left(){
; 0000 0205 void Turn_Left(){
_Turn_Left:
; 0000 0206     WLeft_1 = 0;
	CBI  0x15,4
; 0000 0207     WLeft_2 = 1;
	SBI  0x15,3
; 0000 0208     WRight_1 = 1;
_0x2080004:
	SBI  0x15,2
; 0000 0209     WRight_2 = 0;
_0x2080005:
	CBI  0x12,7
; 0000 020A }
	RET
;
;void Turn_Right(){
; 0000 020C void Turn_Right(){
_Turn_Right:
; 0000 020D     WLeft_1 = 1;
	SBI  0x15,4
; 0000 020E     WLeft_2 = 0;
	CBI  0x15,3
; 0000 020F     WRight_1 = 0;
_0x2080003:
	CBI  0x15,2
; 0000 0210     WRight_2 = 1;
	SBI  0x12,7
; 0000 0211 }
	RET

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x1B,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x1B,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x1B,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x1B,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x1B,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x1B,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x1B,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x1B,0
_0x202000B:
	__DELAY_USB 5
	SBI  0x15,7
	__DELAY_USB 13
	CBI  0x15,7
	__DELAY_USB 13
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080002:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0xA
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0xA
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,5
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,5
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x1A,3
	SBI  0x1A,2
	SBI  0x1A,1
	SBI  0x1A,0
	SBI  0x14,7
	SBI  0x14,5
	SBI  0x14,6
	CBI  0x15,7
	CBI  0x15,5
	CBI  0x15,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x2
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	CALL SUBOPT_0xB
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_AP:
	.BYTE 0xF
_STA:
	.BYTE 0xF
_l_sta:
	.BYTE 0x2
_cmd:
	.BYTE 0x6
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3:
	CALL _getchar
	ST   -Y,R30
	JMP  _Get_Cmd

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	MOVW R30,R10
	LDI  R26,LOW(_cmd)
	LDI  R27,HIGH(_cmd)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	__GETW1MN _cmd,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	MOVW R26,R10
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDS  R30,_l_sta
	LDS  R31,_l_sta+1
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ADD  R26,R10
	ADC  R27,R11
	LD   R30,X
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


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

;END OF CODE MARKER
__END_OF_CODE:
