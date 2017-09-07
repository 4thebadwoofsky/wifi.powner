#!/bin/bash
clear
echo -e "\e[2J"
termW=`tput cols`

logoWS=57
logoW=89
scale=1

if [ $logoW -lt $termW ]; then # Wenn die Vollversion passt
	scale=2
	logoX=$(((termW-logoW)/2))
	logoY=0
else
	if [ $logoWS -lt $termW ]; then
		scale=1
		logoX=$(((termW-logoWS)/2))
		logoY=0
	else
		scale=0
	fi
fi
#logofeed text
logofeed(){
	#Variabeln
	text=$1
	cx=$logoX
	cy=$2
	cy=$((cy+logoY))
	color=$nrm
	#Jeden Buchstaben durchgehen
	echo "$text" | fold -w1 | while read char
	do
		iscolor=1
		case "$char" in
			# RAAINBOOOW farben
			A) echo -n -e "\e[31m";;
			B) echo -n -e "\e[32m";;
			C) echo -n -e "\e[33m";;
			D) echo -n -e "\e[34m";;
			E) echo -n -e "\e[35m";;
			F) echo -n -e "\e[36m";;
			G) echo -n -e "\e[31m";;
			H) echo -n -e "\e[32m";;
			I) echo -n -e "\e[33m";;
			J) echo -n -e "\e[34m";;

			N) echo -n -e "\e[0m";;
			#backslash ersatz wegen WTF
			Z) iscolor=0;echo -e "\e["$cy";"$cx"H\\";;
			#ansonsten an koordinaten printen
			*) iscolor=0;echo -e "\e["$cy";"$cx"H"$char;;
		esac
		if [ $iscolor -eq 0 ]; then
			cx=$((cx+1))
		fi
	done
}
#logosub text
logosub(){
	text=$1
	cx=$logoX
	cy=$2
	cy=$((cy+logoY))
	echo "$text" | fold -w1 | while read char
	do
		case "$char" in
			a) echo -n -e "\e[31m";;
			b) echo -n -e "\e[32m";;
			c) echo -n -e "\e[33m";;
			d) echo -n -e "\e[34m";;
			e) echo -n -e "\e[35m";;
			f) echo -n -e "\e[36m";;
			z) echo -n -e "\e[39m";;
			*) echo -e "\e["$cy";"$cx"H$char";;
		esac
		cx=$((cx+1))
	done
}
#kleinere Version anzeigen
if [ $scale -eq 1 ]; then
	logofeed "A _      __B____C____B____    E___  F___G _      __H_  __I____J___ " 1
	logofeed "A| | /| / /B  _/C __/B  _/D___E/ _ ZF/ _ ZG | /| / /H |/ /I __/J _ Z" 2
	logofeed "A| |/ |/ /B/ //C _/B_/ //D___/E ___/F // / G|/ |/ /H    /I _//J , _/" 3
	logofeed "A|__/|__/B___/C_/ B/___/   E/_/   ZF___/G|__/|__/H_/|_/I___/J_/|_|" 4
	logosub "aINJECTz bTROLLz cSNIFF dCRACK eHONEYPOT fATTACK" 5
fi
#Vollversion
if [ $scale -eq 2 ]; then
	logofeed "A _      __  B ____   C____   B____        E___   F___  G _      __   H_  __   I____   J___" 1
	logofeed "A| | /| / /  B/  _/  C/ __/  B/  _/ D____  E/ _ Z F/ _ Z G| | /| / /  H/ |/ /  I/ __/  J/ _ Z" 2
	logofeed "A| |/ |/ /  B_/ /   C/ _/   B_/ /  D/___/ E/ ___/F/ // / G| |/ |/ /  H/    /  I/ _/   J/ , _/" 3
	logofeed "A|__/|__/  B/___/  C/_/    B/___/       E/_/    FZ___/  GZ__/|__/  H/_/|_/  I/___/  J/_/|_|" 4
	logosub "aINJECT  bTROLL cSNIFF  dCRACK  eHONEYPOT fATTACK" 5
fi
echo -e "\e[0m\e[0;0H"
