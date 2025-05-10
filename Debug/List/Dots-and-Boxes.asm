
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _turn=R4
	.DEF _turn_msb=R5
	.DEF _symbol=R7
	.DEF _inputI=R8
	.DEF _inputI_msb=R9
	.DEF __lcd_x=R6
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	.DB  0x39,0x2A,0x30,0x23
_0x4:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20
_0x5:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x0,0x0
	.DB  0x0,0x0,0xFF,0xFF
_0x6:
	.DB  0x41,0x42
_0x7:
	.DB  0x2D,0x2D
_0x0:
	.DB  0x53,0x61,0x64,0x65,0x67,0x68,0x69,0x61
	.DB  0x6E,0x0,0x70,0x72,0x65,0x73,0x73,0x20
	.DB  0x61,0x6E,0x79,0x20,0x6B,0x65,0x79,0x0
	.DB  0x74,0x6F,0x20,0x73,0x74,0x61,0x72,0x74
	.DB  0x0,0x20,0x30,0x31,0x32,0x33,0x34,0x35
	.DB  0x36,0x37,0x38,0x39,0x0,0x41,0x2A,0x50
	.DB  0x31,0x3D,0x25,0x64,0x0,0x42,0x23,0x50
	.DB  0x32,0x3D,0x25,0x64,0x0,0x4E,0x3D,0x0
	.DB  0x2D,0x3E,0x0,0x20,0x20,0x0,0x69,0x6E
	.DB  0x76,0x61,0x6C,0x69,0x64,0x20,0x69,0x6E
	.DB  0x70,0x75,0x74,0x0,0x6F,0x75,0x74,0x20
	.DB  0x6F,0x66,0x20,0x72,0x61,0x6E,0x67,0x65
	.DB  0x20,0x69,0x6E,0x70,0x75,0x74,0x0,0x63
	.DB  0x68,0x6F,0x73,0x65,0x6E,0x20,0x62,0x6F
	.DB  0x78,0x20,0x69,0x73,0x20,0x74,0x61,0x6B
	.DB  0x65,0x6E,0x0,0x75,0x6E,0x6B,0x6E,0x6F
	.DB  0x77,0x6E,0x20,0x65,0x72,0x72,0x6F,0x72
	.DB  0x0,0x70,0x72,0x65,0x73,0x73,0x20,0x61
	.DB  0x6E,0x79,0x20,0x6B,0x65,0x79,0x20,0xA
	.DB  0x74,0x6F,0x20,0x63,0x6F,0x6E,0x74,0x69
	.DB  0x6E,0x75,0x65,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x2A,0x3D
	.DB  0x63,0x6F,0x6E,0x66,0x69,0x72,0x6D,0x0
	.DB  0x23,0x2A,0x0,0x50,0x31,0x20,0x69,0x73
	.DB  0x20,0x77,0x69,0x6E,0x6E,0x65,0x72,0x21
	.DB  0x0,0x50,0x32,0x20,0x69,0x73,0x20,0x77
	.DB  0x69,0x6E,0x6E,0x65,0x72,0x21,0x0,0x20
	.DB  0x6D,0x61,0x74,0x63,0x68,0x20,0x74,0x69
	.DB  0x65,0x64,0x21,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0C
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x1E
	.DW  _initial_board
	.DW  _0x4*2

	.DW  0x0C
	.DW  _directions
	.DW  _0x5*2

	.DW  0x02
	.DW  _flags
	.DW  _0x6*2

	.DW  0x02
	.DW  _inputS
	.DW  _0x7*2

	.DW  0x0A
	.DW  _0x1E
	.DW  _0x0*2

	.DW  0x0E
	.DW  _0x1E+10
	.DW  _0x0*2+10

	.DW  0x09
	.DW  _0x1E+24
	.DW  _0x0*2+24

	.DW  0x0C
	.DW  _0x1F
	.DW  _0x0*2+33

	.DW  0x03
	.DW  _0x26
	.DW  _0x0*2+61

	.DW  0x03
	.DW  _0x27
	.DW  _0x0*2+64

	.DW  0x03
	.DW  _0x27+3
	.DW  _0x0*2+67

	.DW  0x0E
	.DW  _0x2C
	.DW  _0x0*2+70

	.DW  0x13
	.DW  _0x2C+14
	.DW  _0x0*2+84

	.DW  0x14
	.DW  _0x2C+33
	.DW  _0x0*2+103

	.DW  0x0E
	.DW  _0x2C+53
	.DW  _0x0*2+123

	.DW  0x1B
	.DW  _0x2C+67
	.DW  _0x0*2+137

	.DW  0x0A
	.DW  _0x34
	.DW  _0x0*2+164

	.DW  0x0A
	.DW  _0x34+10
	.DW  _0x0*2+174

	.DW  0x03
	.DW  _0x37
	.DW  _0x0*2+184

	.DW  0x03
	.DW  _0x37+3
	.DW  _0x0*2+184

	.DW  0x0E
	.DW  _0x57
	.DW  _0x0*2+187

	.DW  0x0E
	.DW  _0x57+14
	.DW  _0x0*2+201

	.DW  0x0D
	.DW  _0x57+28
	.DW  _0x0*2+215

	.DW  0x0E
	.DW  _0x57+41
	.DW  _0x0*2+10

	.DW  0x0C
	.DW  _0x57+55
	.DW  _0x0*2+152

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/9/2025
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <alcd.h>
;
;#include <delay.h>
;
;#include <stdio.h>
;
;#include <string.h>
;
;#include <stdbool.h>
;
;char keypad[4][3] = {
;    '1','2','3',
;    '4','5','6',
;    '7','8','9',
;    '*','0','#'
;};

	.DSEG
;
;char initial_board[3][10] = {
;    ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
;    ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',
;    ' ',' ',' ',' ',' ',' ',' ',' ',' ',' '
;};
;char board[3][10];
;
;int directions[4][2] = {
;        {-1, -1},
;        {-1,  0},
;        { 0, -1},
;        { 0,  0}
;};
;
;int scores[2] = {0,0};
;
;int turn = 0;
;char symbol;
;char flags[2] = {
;    'A','B'
;};
;
;char inputS[3] = {'-','-','\0'};
;int digits[2];
;int inputI;
;
;char scanKeypad();
;
;void startGame();
;
;void printBoard();
;
;void printScores();
;
;void printInput();
;
;void printTurn();
;
;void printLCD();
;
;void printError(int error);
;
;void getInput();
;
;bool checkInput();
;
;bool updateScore();
;
;bool gameOver();
;
;void printWinner();
;
;void main(void)
; 0000 0060 {

	.CSEG
_main:
; .FSTART _main
; 0000 0061 {
; 0000 0062 // Input/Output Ports initialization
; 0000 0063 // Port A initialization
; 0000 0064 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0065 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0066 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0067 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0068 
; 0000 0069 // Port B initialization
; 0000 006A // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 006B DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(31)
	OUT  0x17,R30
; 0000 006C // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 006D PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 006E 
; 0000 006F // Port C initialization
; 0000 0070 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0071 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(31)
	OUT  0x14,R30
; 0000 0072 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0073 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0074 
; 0000 0075 // Port D initialization
; 0000 0076 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0077 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0078 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0079 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(240)
	OUT  0x12,R30
; 0000 007A 
; 0000 007B // Port E initialization
; 0000 007C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007D DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 007E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007F PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 0080 
; 0000 0081 // Port F initialization
; 0000 0082 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0083 DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 0084 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0085 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 0086 
; 0000 0087 // Port G initialization
; 0000 0088 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0089 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 008A // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008B PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 008C 
; 0000 008D // Timer/Counter 0 initialization
; 0000 008E // Clock source: System Clock
; 0000 008F // Clock value: Timer 0 Stopped
; 0000 0090 // Mode: Normal top=0xFF
; 0000 0091 // OC0 output: Disconnected
; 0000 0092 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0093 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0094 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0095 OCR0=0x00;
	OUT  0x31,R30
; 0000 0096 
; 0000 0097 // Timer/Counter 1 initialization
; 0000 0098 // Clock source: System Clock
; 0000 0099 // Clock value: Timer1 Stopped
; 0000 009A // Mode: Normal top=0xFFFF
; 0000 009B // OC1A output: Disconnected
; 0000 009C // OC1B output: Disconnected
; 0000 009D // OC1C output: Disconnected
; 0000 009E // Noise Canceler: Off
; 0000 009F // Input Capture on Falling Edge
; 0000 00A0 // Timer1 Overflow Interrupt: Off
; 0000 00A1 // Input Capture Interrupt: Off
; 0000 00A2 // Compare A Match Interrupt: Off
; 0000 00A3 // Compare B Match Interrupt: Off
; 0000 00A4 // Compare C Match Interrupt: Off
; 0000 00A5 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00A6 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00A7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00A8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00AA ICR1L=0x00;
	OUT  0x26,R30
; 0000 00AB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00AC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00AD OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00AE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00AF OCR1CH=0x00;
	STS  121,R30
; 0000 00B0 OCR1CL=0x00;
	STS  120,R30
; 0000 00B1 
; 0000 00B2 // Timer/Counter 2 initialization
; 0000 00B3 // Clock source: System Clock
; 0000 00B4 // Clock value: Timer2 Stopped
; 0000 00B5 // Mode: Normal top=0xFF
; 0000 00B6 // OC2 output: Disconnected
; 0000 00B7 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00B8 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00B9 OCR2=0x00;
	OUT  0x23,R30
; 0000 00BA 
; 0000 00BB // Timer/Counter 3 initialization
; 0000 00BC // Clock source: System Clock
; 0000 00BD // Clock value: Timer3 Stopped
; 0000 00BE // Mode: Normal top=0xFFFF
; 0000 00BF // OC3A output: Disconnected
; 0000 00C0 // OC3B output: Disconnected
; 0000 00C1 // OC3C output: Disconnected
; 0000 00C2 // Noise Canceler: Off
; 0000 00C3 // Input Capture on Falling Edge
; 0000 00C4 // Timer3 Overflow Interrupt: Off
; 0000 00C5 // Input Capture Interrupt: Off
; 0000 00C6 // Compare A Match Interrupt: Off
; 0000 00C7 // Compare B Match Interrupt: Off
; 0000 00C8 // Compare C Match Interrupt: Off
; 0000 00C9 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 00CA TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 00CB TCNT3H=0x00;
	STS  137,R30
; 0000 00CC TCNT3L=0x00;
	STS  136,R30
; 0000 00CD ICR3H=0x00;
	STS  129,R30
; 0000 00CE ICR3L=0x00;
	STS  128,R30
; 0000 00CF OCR3AH=0x00;
	STS  135,R30
; 0000 00D0 OCR3AL=0x00;
	STS  134,R30
; 0000 00D1 OCR3BH=0x00;
	STS  133,R30
; 0000 00D2 OCR3BL=0x00;
	STS  132,R30
; 0000 00D3 OCR3CH=0x00;
	STS  131,R30
; 0000 00D4 OCR3CL=0x00;
	STS  130,R30
; 0000 00D5 
; 0000 00D6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00D7 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 00D8 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 00D9 
; 0000 00DA // External Interrupt(s) initialization
; 0000 00DB // INT0: Off
; 0000 00DC // INT1: Off
; 0000 00DD // INT2: Off
; 0000 00DE // INT3: Off
; 0000 00DF // INT4: Off
; 0000 00E0 // INT5: Off
; 0000 00E1 // INT6: Off
; 0000 00E2 // INT7: Off
; 0000 00E3 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 00E4 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 00E5 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 00E6 
; 0000 00E7 // USART0 initialization
; 0000 00E8 // USART0 disabled
; 0000 00E9 UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 00EA 
; 0000 00EB // USART1 initialization
; 0000 00EC // USART1 disabled
; 0000 00ED UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 00EE 
; 0000 00EF // Analog Comparator initialization
; 0000 00F0 // Analog Comparator: Off
; 0000 00F1 // The Analog Comparator's positive input is
; 0000 00F2 // connected to the AIN0 pin
; 0000 00F3 // The Analog Comparator's negative input is
; 0000 00F4 // connected to the AIN1 pin
; 0000 00F5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F6 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00F7 
; 0000 00F8 // ADC initialization
; 0000 00F9 // ADC disabled
; 0000 00FA ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00FB 
; 0000 00FC // SPI initialization
; 0000 00FD // SPI disabled
; 0000 00FE SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00FF 
; 0000 0100 // TWI initialization
; 0000 0101 // TWI disabled
; 0000 0102 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 0103 
; 0000 0104 // Alphanumeric LCD initialization
; 0000 0105 // Connections are specified in the
; 0000 0106 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0107 // RS - PORTA Bit 0
; 0000 0108 // RD - PORTA Bit 1
; 0000 0109 // EN - PORTA Bit 2
; 0000 010A // D4 - PORTA Bit 4
; 0000 010B // D5 - PORTA Bit 5
; 0000 010C // D6 - PORTA Bit 6
; 0000 010D // D7 - PORTA Bit 7
; 0000 010E // Characters/line: 20
; 0000 010F lcd_init(20);
	LDI  R26,LOW(20)
	CALL _lcd_init
; 0000 0110 }
; 0000 0111 while (1)
_0x8:
; 0000 0112       {
; 0000 0113       startGame();
	RCALL _startGame
; 0000 0114       printLCD();
	RCALL _printLCD
; 0000 0115       while (!gameOver()) {
_0xB:
	RCALL _gameOver
	CPI  R30,0
	BRNE _0xD
; 0000 0116             symbol = (turn == 0) ? '*' : '#';
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRNE _0xE
	LDI  R30,LOW(42)
	RJMP _0xF
_0xE:
	LDI  R30,LOW(35)
_0xF:
	MOV  R7,R30
; 0000 0117             printTurn();
	RCALL _printTurn
; 0000 0118             getInput();
	RCALL _getInput
; 0000 0119             board[digits[0] - 1][digits[1]] = symbol;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R7
; 0000 011A             if (updateScore() == false ){
	RCALL _updateScore
	CPI  R30,0
	BRNE _0x11
; 0000 011B                 turn = 1 - turn;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	SUB  R30,R4
	SBC  R31,R5
	MOVW R4,R30
; 0000 011C             } else {
	RJMP _0x12
_0x11:
; 0000 011D                 printScores();
	RCALL _printScores
; 0000 011E             }
_0x12:
; 0000 011F             printBoard();
	RCALL _printBoard
; 0000 0120       }
	RJMP _0xB
_0xD:
; 0000 0121       printWinner();
	RCALL _printWinner
; 0000 0122     }
	RJMP _0x8
; 0000 0123 }
_0x13:
	RJMP _0x13
; .FEND
;
;char scanKeypad() {
; 0000 0125 char scanKeypad() {
_scanKeypad:
; .FSTART _scanKeypad
; 0000 0126     int row,col;
; 0000 0127     while (1) {
	CALL __SAVELOCR4
;	row -> R16,R17
;	col -> R18,R19
_0x14:
; 0000 0128         for (row = 0; row < 4; row++) {
	__GETWRN 16,17,0
_0x18:
	__CPWRN 16,17,4
	BRGE _0x19
; 0000 0129             PORTD &= ~(1 << row);
	CALL SUBOPT_0x2
	COM  R30
	AND  R30,R1
	OUT  0x12,R30
; 0000 012A             for (col = 0; col < 3; col++) {
	__GETWRN 18,19,0
_0x1B:
	__CPWRN 18,19,3
	BRGE _0x1C
; 0000 012B                 if (!(PIND & (1 << (col + 4)))) {
	IN   R1,16
	MOVW R30,R18
	ADIW R30,4
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x1D
; 0000 012C                     delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
; 0000 012D                     PORTD |= (1 << row);
	CALL SUBOPT_0x2
	OR   R30,R1
	OUT  0x12,R30
; 0000 012E                     return keypad[row][col];
	__MULBNWRU 16,17,3
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	ADD  R30,R18
	ADC  R31,R19
	LD   R30,Z
	RJMP _0x2080006
; 0000 012F                 }
; 0000 0130             }
_0x1D:
	__ADDWRN 18,19,1
	RJMP _0x1B
_0x1C:
; 0000 0131             PORTD |= (1 << row);
	CALL SUBOPT_0x2
	OR   R30,R1
	OUT  0x12,R30
; 0000 0132         }
	__ADDWRN 16,17,1
	RJMP _0x18
_0x19:
; 0000 0133     }
	RJMP _0x14
; 0000 0134 
; 0000 0135 }
; .FEND
;
;void startGame() {
; 0000 0137 void startGame() {
_startGame:
; .FSTART _startGame
; 0000 0138 
; 0000 0139     lcd_clear();
	CALL _lcd_clear
; 0000 013A     memcpy(board, initial_board, sizeof(board));
	LDI  R30,LOW(_board)
	LDI  R31,HIGH(_board)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_initial_board)
	LDI  R31,HIGH(_initial_board)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _memcpy
; 0000 013B     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 013C     PORTC = 0x00;
	OUT  0x15,R30
; 0000 013D     scores[0] = scores[1] = digits[0] = digits[1] = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _digits,2
	STS  _digits,R30
	STS  _digits+1,R31
	__PUTW1MN _scores,2
	STS  _scores,R30
	STS  _scores+1,R31
; 0000 013E     turn = 0;
	CLR  R4
	CLR  R5
; 0000 013F 
; 0000 0140     lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x3
; 0000 0141     lcd_puts("Sadeghian");
	__POINTW2MN _0x1E,0
	CALL _lcd_puts
; 0000 0142     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
; 0000 0143     lcd_puts("press any key");
	__POINTW2MN _0x1E,10
	CALL _lcd_puts
; 0000 0144     lcd_gotoxy(6,2);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x5
; 0000 0145     lcd_puts("to start");
	__POINTW2MN _0x1E,24
	RJMP _0x2080005
; 0000 0146     scanKeypad();
; 0000 0147     lcd_clear();
; 0000 0148 }
; .FEND

	.DSEG
_0x1E:
	.BYTE 0x21
;
;void printBoard() {
; 0000 014A void printBoard() {

	.CSEG
_printBoard:
; .FSTART _printBoard
; 0000 014B     int row,col;
; 0000 014C     lcd_gotoxy(0,0);
	CALL __SAVELOCR4
;	row -> R16,R17
;	col -> R18,R19
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 014D     lcd_puts(" 0123456789");
	__POINTW2MN _0x1F,0
	CALL _lcd_puts
; 0000 014E     for (row = 0;row < 3;row++) {
	__GETWRN 16,17,0
_0x21:
	__CPWRN 16,17,3
	BRGE _0x22
; 0000 014F         lcd_gotoxy(0,(row + 1));
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R16
	SUBI R26,-LOW(1)
	CALL _lcd_gotoxy
; 0000 0150         lcd_putchar(('0' + row + 1));
	MOV  R26,R16
	SUBI R26,-LOW(49)
	CALL _lcd_putchar
; 0000 0151         for (col = 0;col < 10;col++) {
	__GETWRN 18,19,0
_0x24:
	__CPWRN 18,19,10
	BRGE _0x25
; 0000 0152             lcd_putchar(board[row][col]);
	CALL SUBOPT_0x6
	CALL _lcd_putchar
; 0000 0153         };
	__ADDWRN 18,19,1
	RJMP _0x24
_0x25:
; 0000 0154     };
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 0155     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0156 }
	RJMP _0x2080006
; .FEND

	.DSEG
_0x1F:
	.BYTE 0xC
;
;void printScores() {
; 0000 0158 void printScores() {

	.CSEG
_printScores:
; .FSTART _printScores
; 0000 0159     char buffer[6];
; 0000 015A 
; 0000 015B     lcd_gotoxy(13,0);
	SBIW R28,6
;	buffer -> Y+0
	LDI  R30,LOW(13)
	CALL SUBOPT_0x3
; 0000 015C     sprintf(buffer, "A*P1=%d", scores[0]);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,45
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_scores
	LDS  R31,_scores+1
	CALL SUBOPT_0x7
; 0000 015D     lcd_puts(buffer);
; 0000 015E     PORTB = scores[0];
	LDS  R30,_scores
	OUT  0x18,R30
; 0000 015F 
; 0000 0160     lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0x4
; 0000 0161     sprintf(buffer, "B#P2=%d", scores[1]);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,53
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x7
; 0000 0162     lcd_puts(buffer);
; 0000 0163     PORTC = scores[1];
	__GETB1MN _scores,2
	OUT  0x15,R30
; 0000 0164 
; 0000 0165     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0166 
; 0000 0167 }
	JMP  _0x2080001
; .FEND
;
;void printInput() {
; 0000 0169 void printInput() {
_printInput:
; .FSTART _printInput
; 0000 016A     lcd_gotoxy(15,3);
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
; 0000 016B     lcd_puts("N=");
	__POINTW2MN _0x26,0
	CALL _lcd_puts
; 0000 016C     lcd_gotoxy(17,3);
	LDI  R30,LOW(17)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
; 0000 016D     lcd_puts(inputS);
	LDI  R26,LOW(_inputS)
	LDI  R27,HIGH(_inputS)
	RJMP _0x208000A
; 0000 016E     lcd_gotoxy(0,0);
; 0000 016F 
; 0000 0170 }
; .FEND

	.DSEG
_0x26:
	.BYTE 0x3
;
;void printLCD () {
; 0000 0172 void printLCD () {

	.CSEG
_printLCD:
; .FSTART _printLCD
; 0000 0173     lcd_clear();
	CALL _lcd_clear
; 0000 0174     printBoard();
	RCALL _printBoard
; 0000 0175     printScores();
	RCALL _printScores
; 0000 0176     printInput();
	RCALL _printInput
; 0000 0177     printTurn();
	RCALL _printTurn
; 0000 0178     lcd_gotoxy(0,0);
	RJMP _0x2080009
; 0000 0179 }
; .FEND
;
;void printTurn() {
; 0000 017B void printTurn() {
_printTurn:
; .FSTART _printTurn
; 0000 017C     lcd_gotoxy(11,turn);
	LDI  R30,LOW(11)
	ST   -Y,R30
	MOV  R26,R4
	RCALL _lcd_gotoxy
; 0000 017D     lcd_puts("->");
	__POINTW2MN _0x27,0
	CALL _lcd_puts
; 0000 017E     lcd_gotoxy(11,(1 - turn));
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(1)
	SUB  R30,R4
	MOV  R26,R30
	RCALL _lcd_gotoxy
; 0000 017F     lcd_puts("  ");
	__POINTW2MN _0x27,3
_0x208000A:
	CALL _lcd_puts
; 0000 0180     lcd_gotoxy(0,0);
_0x2080009:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 0181 }
	RET
; .FEND

	.DSEG
_0x27:
	.BYTE 0x6
;
;void printError(int error) {
; 0000 0183 void printError(int error) {

	.CSEG
_printError:
; .FSTART _printError
; 0000 0184     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
;	error -> Y+0
	RCALL _lcd_clear
; 0000 0185     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0186     PORTC = 0x00;
	OUT  0x15,R30
; 0000 0187 
; 0000 0188     switch (error) {
	LD   R30,Y
	LDD  R31,Y+1
; 0000 0189         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2B
; 0000 018A             lcd_puts("invalid input");
	__POINTW2MN _0x2C,0
	RJMP _0x5B
; 0000 018B             break;
; 0000 018C 
; 0000 018D         case 2:
_0x2B:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D
; 0000 018E             lcd_puts("out of range input");
	__POINTW2MN _0x2C,14
	RJMP _0x5B
; 0000 018F             break;
; 0000 0190 
; 0000 0191         case 3:
_0x2D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F
; 0000 0192             lcd_puts("chosen box is taken");
	__POINTW2MN _0x2C,33
	RJMP _0x5B
; 0000 0193             break;
; 0000 0194 
; 0000 0195         default:
_0x2F:
; 0000 0196             lcd_puts("unknown error");
	__POINTW2MN _0x2C,53
_0x5B:
	RCALL _lcd_puts
; 0000 0197         };
; 0000 0198     lcd_gotoxy(0,2);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x5
; 0000 0199     lcd_puts("press any key \nto continue");
	__POINTW2MN _0x2C,67
	RCALL _lcd_puts
; 0000 019A     scanKeypad();
	RCALL _scanKeypad
; 0000 019B     lcd_clear();
	RCALL _lcd_clear
; 0000 019C     printLCD();
	RCALL _printLCD
; 0000 019D }
	RJMP _0x2080004
; .FEND

	.DSEG
_0x2C:
	.BYTE 0x5E
;
;void getInput() {
; 0000 019F void getInput() {

	.CSEG
_getInput:
; .FSTART _getInput
; 0000 01A0     get:
_0x30:
; 0000 01A1     do {
_0x32:
; 0000 01A2         inputS[0] = '-', inputS[1] = '-';
	CALL SUBOPT_0x9
; 0000 01A3         printInput();
	RCALL _printInput
; 0000 01A4         lcd_gotoxy(11,2);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x5
; 0000 01A5         lcd_puts("         ");
	__POINTW2MN _0x34,0
	RCALL _lcd_puts
; 0000 01A6         inputS[0] = scanKeypad();
	RCALL _scanKeypad
	STS  _inputS,R30
; 0000 01A7         printInput();
	RCALL _printInput
; 0000 01A8         inputS[1] = scanKeypad();
	RCALL _scanKeypad
	__PUTB1MN _inputS,1
; 0000 01A9         printInput();
	RCALL _printInput
; 0000 01AA         lcd_gotoxy(11,2);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x5
; 0000 01AB         lcd_puts("*=confirm");
	__POINTW2MN _0x34,10
	RCALL _lcd_puts
; 0000 01AC         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x3
; 0000 01AD     } while (scanKeypad() != '*');
	RCALL _scanKeypad
	CPI  R30,LOW(0x2A)
	BRNE _0x32
; 0000 01AE     if (checkInput() != true) {
	RCALL _checkInput
	CPI  R30,LOW(0x1)
	BRNE _0x30
; 0000 01AF         goto get;
; 0000 01B0     }
; 0000 01B1     inputS[0] = '-', inputS[1] = '-';
	CALL SUBOPT_0x9
; 0000 01B2 }
	RET
; .FEND

	.DSEG
_0x34:
	.BYTE 0x14
;
;bool checkInput() {
; 0000 01B4 _Bool checkInput() {

	.CSEG
_checkInput:
; .FSTART _checkInput
; 0000 01B5     if (strchr("#*", inputS[0]) || strchr("#*", inputS[1])) {
	__POINTW1MN _0x37,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_inputS
	CALL _strchr
	SBIW R30,0
	BRNE _0x38
	__POINTW1MN _0x37,3
	ST   -Y,R31
	ST   -Y,R30
	__GETB2MN _inputS,1
	CALL _strchr
	SBIW R30,0
	BREQ _0x36
_0x38:
; 0000 01B6         printError(1);
	LDI  R26,LOW(1)
	RJMP _0x2080008
; 0000 01B7         return false;
; 0000 01B8     }
; 0000 01B9     digits[0] = (inputS[0] - '0');
_0x36:
	LDS  R30,_inputS
	LDI  R31,0
	SBIW R30,48
	STS  _digits,R30
	STS  _digits+1,R31
; 0000 01BA     digits[1] = (inputS[1] - '0');
	__GETB1MN _inputS,1
	LDI  R31,0
	SBIW R30,48
	__PUTW1MN _digits,2
; 0000 01BB     inputI = digits[0] * 10 + digits[1];
	CALL SUBOPT_0x0
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R30
	__GETW1MN _digits,2
	ADD  R30,R26
	ADC  R31,R27
	MOVW R8,R30
; 0000 01BC     if (inputI < 10 || inputI > 39) {
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x3B
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x3A
_0x3B:
; 0000 01BD         printError(2);
	LDI  R26,LOW(2)
	RJMP _0x2080008
; 0000 01BE         return false;
; 0000 01BF     }
; 0000 01C0     if (board[digits[0] - 1][digits[1]] != ' ') {
_0x3A:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x20)
	BREQ _0x3D
; 0000 01C1         printError(3);
	LDI  R26,LOW(3)
_0x2080008:
	LDI  R27,0
	RCALL _printError
; 0000 01C2         return false;
	LDI  R30,LOW(0)
	RET
; 0000 01C3     }
; 0000 01C4     return true;
_0x3D:
	LDI  R30,LOW(1)
	RET
; 0000 01C5 }
; .FEND

	.DSEG
_0x37:
	.BYTE 0x6
;
;bool updateScore() {
; 0000 01C7 _Bool updateScore() {

	.CSEG
_updateScore:
; .FSTART _updateScore
; 0000 01C8     int i;
; 0000 01C9     char r = digits[0] - 1;
; 0000 01CA     char c = digits[1];
; 0000 01CB     int nr;
; 0000 01CC     int nc;
; 0000 01CD     for (i = 0; i < 4; i++) {
	SBIW R28,2
	CALL __SAVELOCR6
;	i -> R16,R17
;	r -> R19
;	c -> R18
;	nr -> R20,R21
;	nc -> Y+6
	LDS  R30,_digits
	SUBI R30,LOW(1)
	MOV  R19,R30
	__GETB1MN _digits,2
	MOV  R18,R30
	__GETWRN 16,17,0
_0x3F:
	__CPWRN 16,17,4
	BRLT PC+2
	RJMP _0x40
; 0000 01CE         nr = r + directions[i][0];
	MOV  R0,R19
	CALL SUBOPT_0xA
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	ADD  R30,R0
	ADC  R31,R1
	MOVW R20,R30
; 0000 01CF         nc = c + directions[i][1];
	MOV  R0,R18
	CALL SUBOPT_0xA
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,2
	CALL __GETW1P
	ADD  R30,R0
	ADC  R31,R1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 01D0 
; 0000 01D1         if (nr >= 0 && nr < 2 && nc >= 0 && nc < 9) {
	TST  R21
	BRMI _0x42
	__CPWRN 20,21,2
	BRGE _0x42
	LDD  R26,Y+7
	TST  R26
	BRMI _0x42
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,9
	BRLT _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 01D2             if ((board[nr][nc]     == symbol || board[nr][nc]     == flags[turn]) &&
; 0000 01D3                 (board[nr][nc + 1] == symbol || board[nr][nc + 1] == flags[turn]) &&
; 0000 01D4                 (board[nr + 1][nc] == symbol || board[nr + 1][nc] == flags[turn]) &&
; 0000 01D5                 (board[nr + 1][nc + 1] == symbol || board[nr + 1][nc + 1] == flags[turn])) {
	CALL SUBOPT_0xB
	MOVW R22,R30
	CALL SUBOPT_0xC
	LD   R26,X
	CP   R7,R26
	BREQ _0x45
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	BRNE _0x47
_0x45:
	CALL SUBOPT_0xE
	LD   R26,X
	CP   R7,R26
	BREQ _0x48
	CALL SUBOPT_0xE
	CALL SUBOPT_0xD
	BRNE _0x47
_0x48:
	CALL SUBOPT_0xF
	LD   R26,X
	CP   R7,R26
	BREQ _0x4A
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	BRNE _0x47
_0x4A:
	CALL SUBOPT_0x10
	LD   R26,X
	CP   R7,R26
	BREQ _0x4C
	CALL SUBOPT_0x10
	CALL SUBOPT_0xD
	BRNE _0x47
_0x4C:
	RJMP _0x4E
_0x47:
	RJMP _0x44
_0x4E:
; 0000 01D6                 scores[turn] += 1;
	MOVW R30,R4
	LDI  R26,LOW(_scores)
	LDI  R27,HIGH(_scores)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL SUBOPT_0x11
; 0000 01D7                 board[nr][nc] = board[nr][nc + 1] = board[nr + 1][nc] = board[nr + 1][nc + 1] = flags[turn];
	CALL SUBOPT_0xB
	MOVW R0,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	CALL SUBOPT_0x12
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0x12
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDI  R26,LOW(_flags)
	LDI  R27,HIGH(_flags)
	ADD  R26,R4
	ADC  R27,R5
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	MOVW R26,R22
	ST   X,R30
	MOVW R26,R24
	ST   X,R30
	POP  R26
	POP  R27
	ST   X,R30
; 0000 01D8                 return true;
	LDI  R30,LOW(1)
	RJMP _0x2080007
; 0000 01D9             }
; 0000 01DA         }
_0x44:
; 0000 01DB     }
_0x41:
	__ADDWRN 16,17,1
	RJMP _0x3F
_0x40:
; 0000 01DC     return false;
	LDI  R30,LOW(0)
_0x2080007:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 01DD }
; .FEND
;
;bool gameOver() {
; 0000 01DF _Bool gameOver() {
_gameOver:
; .FSTART _gameOver
; 0000 01E0     int i,j;
; 0000 01E1     for (i = 0; i < 4; i++) {
	CALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x50:
	__CPWRN 16,17,4
	BRGE _0x51
; 0000 01E2         for (j = 0; j < 10; j++) {
	__GETWRN 18,19,0
_0x53:
	__CPWRN 18,19,10
	BRGE _0x54
; 0000 01E3             if (board[i][j] == ' ') {
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x20)
	BRNE _0x55
; 0000 01E4                 return false;
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01E5             };
_0x55:
; 0000 01E6         };
	__ADDWRN 18,19,1
	RJMP _0x53
_0x54:
; 0000 01E7     };
	__ADDWRN 16,17,1
	RJMP _0x50
_0x51:
; 0000 01E8     return true;
	LDI  R30,LOW(1)
_0x2080006:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 01E9 }
; .FEND
;
;void printWinner() {
; 0000 01EB void printWinner() {
_printWinner:
; .FSTART _printWinner
; 0000 01EC     lcd_clear();
	RCALL _lcd_clear
; 0000 01ED     lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x3
; 0000 01EE     if (scores[0] > scores[1]) {
	CALL SUBOPT_0x8
	LDS  R26,_scores
	LDS  R27,_scores+1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x56
; 0000 01EF         lcd_puts("P1 is winner!");
	__POINTW2MN _0x57,0
	RJMP _0x5C
; 0000 01F0     } else if (scores[0] < scores[1]) {
_0x56:
	CALL SUBOPT_0x8
	LDS  R26,_scores
	LDS  R27,_scores+1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x59
; 0000 01F1         lcd_puts("P2 is winner!");
	__POINTW2MN _0x57,14
	RJMP _0x5C
; 0000 01F2     } else {
_0x59:
; 0000 01F3         lcd_puts(" match tied!");
	__POINTW2MN _0x57,28
_0x5C:
	RCALL _lcd_puts
; 0000 01F4     }
; 0000 01F5     lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4
; 0000 01F6     lcd_puts("press any key");
	__POINTW2MN _0x57,41
	RCALL _lcd_puts
; 0000 01F7     lcd_gotoxy(5,2);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x5
; 0000 01F8     lcd_puts("to continue");
	__POINTW2MN _0x57,55
_0x2080005:
	RCALL _lcd_puts
; 0000 01F9     scanKeypad();
	RCALL _scanKeypad
; 0000 01FA     lcd_clear();
	RCALL _lcd_clear
; 0000 01FB }
	RET
; .FEND

	.DSEG
_0x57:
	.BYTE 0x43
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080003
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080003
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LDD  R11,Y+0
_0x2080004:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x13
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x13
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R6,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R6,R10
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R11
	MOV  R26,R11
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080003
_0x2000007:
_0x2000004:
	INC  R6
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080003
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080003:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x11
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x11
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
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
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x15
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x15
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x16
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x17
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x16
	CALL SUBOPT_0x19
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x19
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x15
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x17
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x17
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x1A
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080002
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x1A
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_memcpy:
; .FSTART _memcpy
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
_0x2080001:
	ADIW R28,6
	RET
; .FEND
_strchr:
; .FSTART _strchr
	ST   -Y,R26
    ld   r26,y+
    ld   r30,y+
    ld   r31,y+
strchr0:
    ld   r27,z
    cp   r26,r27
    breq strchr1
    adiw r30,1
    tst  r27
    brne strchr0
    clr  r30
    clr  r31
strchr1:
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND

	.CSEG

	.DSEG
_keypad:
	.BYTE 0xC
_initial_board:
	.BYTE 0x1E
_board:
	.BYTE 0x1E
_directions:
	.BYTE 0x10
_scores:
	.BYTE 0x4
_flags:
	.BYTE 0x2
_inputS:
	.BYTE 0x3
_digits:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDS  R30,_digits
	LDS  R31,_digits+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	SBIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	MOVW R26,R30
	__GETW1MN _digits,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	IN   R1,18
	MOV  R30,R16
	LDI  R26,LOW(1)
	CALL __LSLB12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	__MULBNWRU 16,17,10
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	ADD  R30,R18
	ADC  R31,R19
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	MOVW R26,R28
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETW1MN _scores,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(45)
	STS  _inputS,R30
	__PUTB1MN _inputS,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CLR  R1
	MOVW R30,R16
	LDI  R26,LOW(_directions)
	LDI  R27,HIGH(_directions)
	CALL __LSLW2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	__MULBNWRU 20,21,10
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD:
	LD   R0,X
	LDI  R26,LOW(_flags)
	LDI  R27,HIGH(_flags)
	ADD  R26,R4
	ADC  R27,R5
	LD   R30,X
	CP   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	MOVW R26,R22
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	MOVW R30,R20
	ADIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	MOVW R30,R20
	ADIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	MOVW R30,R20
	ADIW R30,1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12U
	SUBI R30,LOW(-_board)
	SBCI R31,HIGH(-_board)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

;END OF CODE MARKER
__END_OF_CODE:
