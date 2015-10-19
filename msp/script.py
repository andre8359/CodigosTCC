#! /usr/bin/env python

import sys
import os 

NAME = sys.argv[1]
MCU="msp430g2553"
CC = "msp430-gcc "
AFLAGS = " -Os -Wall -g "


if len(sys.argv) == 1 :
	print "Erro com parametros!!!!"
	exit(0)
else :
	print "######################### COMPILANDO #####################################"
	print "Criando arquivo assembly "+NAME+".s"

	os.system(CC+AFLAGS + "-S "+" -mmcu="+MCU+" -o "+NAME+".s "+NAME+".c ")

	print "Compilando codigo assembly"
	os.system(CC + AFLAGS + " -mmcu="+MCU+" -o "+NAME+"-"+MCU+".elf "+NAME+".s ")

	print "######################## ENVIANDO ########################################"

	os.system("sudo mspdebug rf2500 \"prog "+NAME+"-"+MCU+".elf \"")
	
	print "DONE!!"
