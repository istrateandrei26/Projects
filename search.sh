#!/bin/bash

#colors
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
WHITE='\033[37m'
CYAN='\033[36m'

search_path=/home/kali/Downloads/CRAWL


#stats_found=$(find $search_path -name "*stats.txt")



figlet "Search something :) " | lolcat -a --duration=1 

read -p "Enter here: " words 


printf "${GREEN}Results :\n"
array=()
for i in $words 
do
	files_found=$(find $search_path -name *stats.txt -exec grep -Hi "$i" {} \; | cut -f1 -d" " | sed "s/stats.txt://g" )


	for iterator in $files_found
	do
		real_path=$(echo $iterator | cut -f1,2,3,4,5,6 -d/)
		copied_file=$(echo $iterator | cut -f8 -d/)
		
		simple_path=$(echo $iterator | cut -f1,2,3,4,5,6,7 -d/)
		

		results=$(find $real_path -name $copied_file ! -path $simple_path )
		#echo "$(echo $results | tr [[:space:]] "\n" | grep -v "/simple/" | wc -l) results found"
		array+=($(echo $results | tr [[:space:]] "\n" | grep -v "/simple/" | sed -r "s/(\/home\/kali)/file:\/\/\1/g"))		
	done	
       

 

done


display_array=$(echo ${array[@]} | tr [:space:] "\n" | sort -u)

printf "${BLUE}"
echo ${display_array[@]} | tr [:space:] "\n" | sort -u | nl    # display links 

#last_value=${#display_array[@]}

last_value=$(echo ${display_array[@]} | tr [:space:] "\n" | sort -u | wc -l  )       #	:)


#echo $last_value

if [[ ${#array} -eq 0 ]]
then
	printf "${RED}No results found...Exiting\n"
	sleep 2s
	exit 0
fi


read -p "Choose a link to display : " link_number

while [[ $link_number -gt 0 && $link_number -le $last_value ]]
do
	current_value=$(echo $display_array | tr [:space:] "\n" | sort -u | sed "$link_number!d" )
	xdg-open "$current_value" 2>/dev/null
	sleep 4s
	printf "${GREEN}"
	read -p "Choose another link to display [q(quit)]: " link_number

	if [[ $link_number -eq "q" ]] 
	then
		break
	fi

done



#echo $files_found
#echo $website_directories_found
#echo $website_simple_directories
#echo $array
