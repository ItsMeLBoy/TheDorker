#!/bin/bash

#color(bold)
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'
white='\e[1;37m'

#menu + banner
echo -e '''               \e[1;31mv.0.1\e[1;37m
               ┌┬┐┬ ┬┌─┐  ┌┬┐┌─┐┬─┐┬┌─┌─┐┬─┐
                │ ├─┤├┤    │││ │├┬┘├┴┐├┤ ├┬┘
                ┴ ┴ ┴└─┘  ─┴┘└─┘┴└─┴ ┴└─┘┴└─    
             \e[1;37m[ Using : Google \e[1;31m-\e[1;37m Yahoo \e[1;31m-\e[1;37m Bing ]        
[ Author : \e[1;34m./Lolz \e[1;31m-\e[1;37m Thanks to : IndoSec \e[1;31m-\e[1;37m \e[1;34mJavaGhost \e[1;31m-\e[1;37m Widhisec ]                                                                              

1]. Get domain \e[1;31m+\e[1;37m path \e[1;31m[ \e[1;37mex : \e[1;32mhttps://localhost:1337/path/../.. \e[1;31m]\e[1;37m
2]. Just get domain name \e[1;31m[ \e[1;37mex : \e[1;32mhttps://localhost:1337 \e[1;31m]
'''

read -p $'\e[1;37mWhat do you want: \e[1;32m' ask
read -p $'\e[1;37mInput dork: \e[1;32m' dork

function google(){
	google=$(curl -s 'https://www.google.com/search?q='$(echo "$dork" | jq -sRr @uri)'&start='$i'' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36' -L)
	if [[ $google = "captcha-form" ]] || [[ $google =~ "" ]]; then
		echo -e "${white}Google say ${green}'${red}captcha found${green}'${white}"
	elif [[ $google = "tidak cocok dengan dokumen apa pun." ]]; then
		echo -e "No matching keywords found for : ${green}${dork}${white}"
		exit
	else
		if [[ $ask = "1" ]]; then
			echo -e "${white}${google}${white}" | grep -Po '(?<=<div class="rc"><div class="r"><a href=").*?(?=")'
		elif [[ $ask = "2" ]]; then
				echo -e "${white}${google}${white}" | grep -Po '(?<=<div class="rc"><div class="r"><a href=").*?(?=")' | cut -d "/" -f1,2,3
		fi
	fi
}

function yahoo(){
	yahoo=$(curl -s 'https://search.yahoo.com/search?p='$(echo "$dork" | jq -sRr @uri)'&b='$i'&pz='$i'' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36')
	if [[ $yahoo =~ "Kami tidak menemukan hasil untuk" ]]; then
		echo -e "No matching keywords found for : ${green}${dork}${white}"
		exit
	else
		if [[ $ask = "1" ]]; then
			echo -e "${white}${yahoo}${white}" | grep -Po '(?<=<span class=" fz-ms fw-m fc-12th wr-bw lh-17">).*?(?=")' | sed 's,<b>,,g;s,</b>,,g' | cut -d "<" -f1
		elif [[ $ask = "2" ]]; then
				echo -e "${white}${yahoo}${white}" | grep -Po '(?<=<span class=" fz-ms fw-m fc-12th wr-bw lh-17">).*?(?=")' | sed 's,<b>,,g;s,</b>,,g' | cut -d "<" -f1 | cut -d "/" -f1
		fi
	fi
}

function bing(){
	bing=$(curl -s 'https://www.bing.com/search?q='$(echo "$dork" | jq -sRr @uri)'&first='$i'' -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36')
	if [[ $bing =~ "There are no results for" ]]; then
		echo -e "No matching keywords found for : ${green}${dork}${white}"
		exit
	else
		if [[ $ask = "1" ]]; then
			echo -e "${white}${bing}${white}" | grep -Po '(?<=<li class="b_algo"><h2><a href=").*?(?=")'
		elif [[ $ask = "2" ]]; then
				echo -e "${white}${bing}${white}" | grep -Po '(?<=<li class="b_algo"><h2><a href=").*?(?=")' | cut -d "/" -f1,2,3
		fi
	fi
}

(
	for i in $(seq 10); do
		((thread=thread%100)); ((thread++==0)) && wait
		google "$i" &
		yahoo "$i" &
		bing "$i" &
	done
	wait
)
