#!/bin/bash
hash="\#\$y\$j9T\$S254BXS6H0Dssl8urssl80\$7emMSZx5Tbx7yzz2jkoEZ6PL9MFU2OByuLSM9v.26Z6"
#echo $hash
spider_script_path=$(find ~ -name "drawSpider.sh" 2>/dev/null)

for i in $spider_script_path
do
	extracted_hash=$(cat $i | head -n2 | tail -n1)
	if [[ $extracted_hash == $hash ]] 
	then
		spider_script_path=$i
		break;
	fi
done


#cat $0


$spider_script_path

#set -x 
#colors
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
WHITE='\033[37m'
CYAN='\033[36m'

delimiter="${WHITE}\n#########################\n${YELLOW}"


#echo $0

download_path=/home/kali/Downloads/CRAWL

#no of files downloaded
no=0



while [[ ! -d $download_path ]]
do
	mkdir $download_path 2>/dev/null
	
	if [[ ! $? -eq 0 ]] 
	then
		printf "${RED}[-] Default directory $download_path could not be created\n"
		printf "${YELLOW} Please choose another path : "
		read download_path
	fi
	 
done

download_path2=$(echo $download_path | sed -r 's/\//\\\//g')
sed -z -i -r "s/(download_path=)[^\n]*(.*) /\1"$download_path2"\2/" $0


################################################################################################################################################################################



function simple_download() {
	


	if [[ ! $# -eq 2 ]]
	then
		printf "${RED}[-]${YELLOW} No parameters received ... \n      Abort..."
		exit 0
	fi
	

	local website_full=$1
	local website=$( echo $website_full | sed -r "s/https?:\/\///g" )
	

	# trebuie vazut daca e fisier sau director ca sa mi descarce si indexul
	#verific daca resursa a mai fost descarcata
	
	if [[ -d $download_path/$website && -f $download_path/$website.html ]]
	then
		return 0
	
	elif [[ -f $download_path/$website ]]
	then	
		return 0
	fi

	

	printf "$delimiter"



	#trebuie testat site-ul sa vedem daca exista
	printf "\n\n${GREEN}[+]${YELLOW} Searching for --\"$website_full\"-- ...\n"
	wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" -q --spider $website_full



	if [[ ! $? -eq 0 ]]
	then

		printf "${RED}[-]${YELLOW} Resource not found\n"
		return 0
	fi




	printf "${GREEN}[+]${YELLOW} Resource was found\n"
	printf  "${GREEN}[+]${YELLOW} DOWNLOADING ...\n"
	
	wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" -q -p -E -P $download_path $website_full
      	
	printf "${GREEN}[+]${YELLOW} Successully downloaded\n\n"
	



	#verificarea nivelului de adancime a recursivitatii
	if [[ $(($2-1)) -eq 0 ]]
	then
		
		return 0
	fi


	local find_path=$(echo $download_path/$website | egrep -o "(.*)\/")   # for websites which don't contain '/'
	if [[ $download_path/ == $find_path ]]
	then
		find_path+=/$website
	fi

	local website_files=$(find $find_path -type f | sed "s/ /%20/g" | sed "s/\"/%22/g")
        #website_files=$(echo $website_files | sed "s/ /\n/g"  | sed -r "s/^\.(.*)/\1/")

        local files=""
        
	for i in $website_files
        do
            
	    	src=$(echo "$i" | sed "s/%20/ /g" | sed "s/%22/\"/g")
                files+=" "
                files+=$(echo "'$src'" | xargs cat | egrep -o  "(href|src|url)( )*=?\(?( )*(\"[^\"]*\"|'[^']*')" | sed "s/'/\"/g" | cut -f 2 -d "\"" | grep -v "^#.*" | sort -u)
	
	done

#	local website_files=$(find $find_path -type f)
	
#	website_files=$(echo $website_files | sed "s/ /\n/g"  | sed -r "s/^\.(.*)/\1/")


#	local files=""
#	for i in $website_files
#	do
#		files+=" "
#		files+=$(cat $i | egrep -o  "(href|src|url)( )*=?\(?( )*\"[^\"]*\"" | cut -f 2 -d "\"" | grep -v "^#.*" | sort -u)	





	files=$( echo $files | sed "s/ /\n/g" | sort -u )
	
	
	# trebuie ca un fisier sa inceapa cu "/" sau sa inceapa cu root-ul website-ului
	#    altfel se va considera a fi un website diferit

	if [[ $(($2-1)) -eq 0 ]]
	then
		
		return 0
	fi

	
	website_root=$(echo $website| cut -f 1 -d"/")
	
	for i in $files
	do
		#local name_to_find=$(echo $i | egrep -o "/[^/]*$" | cut -f2 -d/ )
		#local my_bool=$(find $find_path -name $name_to_find )

		# trebuie vazut daca e fisier sau director ca sa mi descarce si indexul

		# daca fisierul a fost gasit nu se va mai descarca 
		#if [[ -d $find_path/$name_to_find && -f $find_path/$name_to_find.html ]]
		#then
		#	continue

		#elif [[ ! -z $my_bool ]]
		#then
		#	continue
		#fi	

		#set -x
		if [[ $i == {https://,http://}* && $i == *$website* ]]
		then
			aux=$(echo $i | sed "s/\/\//\//g2")
			simple_download $aux $(($2-1))

		elif [[ ${i:0:1} == "/" ]]
		then
			aux="$website_root/$i"
 			aux=$(echo $aux | sed "s/\/\//\//g")
			simple_download $aux $(($2-1))

		elif [[ $bool_related_links == Y ]]
		then
			#trebuie testat site-ul sa vedem daca exista
			printf "${GREEN}[+]${YELLOW} Searching for $website_full ...\n"
			wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" -q --spider $website_full
			

			if [[ $? -eq 0 ]]
			then
				printf "$delimiter"
				
				printf "${GREEN}[+]${YELLOW} Resource found\n"
				printf "${GREEN}[+]${YELLOW} DOWNLOADING ...\n"
				wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" -q -p -E -P $download_path $i
				printf "$GREEN[+]${YELLOW} Successfully downloaded\n"
			
			else
				printf "${RED}[-]${YELLOW} Resource was not found\n"
			fi
		fi
		#set +x





	done
}

function is_crawled() {
	
	flag=0
	site=$(echo "$1" | cut -f3 -d/)
	if [[ $machine_stuff == *$site* ]]  
		then
			printf "\n${RED}[-]${YELLOW} $site has been already crawled\n"
			flag=1                               #continue    -> see main function !
		fi

}




################################################################################################################################################################################
# Step 1 : enter filename with links to be downloaded ...
# Step 2 : press enter ... 
# Step 3 : take argument and use wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" to download it ( options !! ) 
#
#
#
#

# parse link into a variable ...
	
	

	printf "\n\t\t${YELLOW}Let's crawl it !\n\n"

	read -p "Enter input file : " filename	

	##
# now we have to verify if resource exists , that would require '--spider' options ... 
	
	# verify if resource exists on our machine
	machine_stuff=$(ls $download_path)


	PS3="Choose your option: " 

	select ITEM in "Same level for all" "Custom levels" 
	do
		case $REPLY in
			1) 	 ok=0
				 echo ""
			   	 read -p "Enter level: " level	
				;;

			2)  ok=1	
				;;

			*) printf "${RED}[-]${YELLOW} Invalid option\n"
				;;

		esac

		if [[ ! -z $ok ]]  
		then
			break
		fi
	done

	link_list=$(cat $filename)
	for URL in $link_list
	do
		# verify if resource has been already crawled
		is_crawled $URL	
		
		if [[ $flag -eq 1 ]]
		then
			continue
		fi

		# verify if resource exists
		printf "\n\n${GREEN}[+]${YELLOW} Searching for resource ...\n"
		wget -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36" -q --spider $URL
		if [[ $? -eq 0 ]] 
		then

			printf "${GREEN}[+]${YELLOW} Resource $URL was found\n"
	
				
			#verify custom or same level
			if [[ $ok -eq 1 ]]
			then
				
			
				
				echo -e "\n\n"
				read -r -p "Enter level-depth for this link: $URL [none]: " level
				echo -e "\n"
				read -p  "Do you want to download related links? [Y/n]: " bool_related_links
				
				while [[ 1 ]] 	
				do
					case $level in
						[1-3])
							before=$(date +%s) 
							simple_download $URL $level							

							break
							;;
						*) read -p "Re-Enter valid level : " level ;;
					esac
				done
			
			else
				echo -e "\n"
				read -p  "Do you want to download related links? [Y/n]: " bool_related_links
				
				before=$(date +%s)
				simple_download $URL $level
			fi
		
		else
			printf "${RED}[-]${YELLOW} Resource $URL was not found\n" 
		fi
	
	
		after=$(date +%s)
		seconds=$(($after-$before))
		
		site=$( echo $URL | sed -r "s/https?:\/\///g" | cut -f1 -d/ )

		file_root=$( find  $download_path -maxdepth 1 -name  $site )

		if [[ ! -z $file_root ]]
		then
			no=$( find $file_root -type f | wc-l)
		else
			no=?
		fi

		total_time=$(date-d@$seconds-u+"%H:%M:%S")
		printf"${CYAN}Timeelapsed:(DAY)$(($seconds/86400))(hh:mm:ss)$total_time\n"
		
		
		printf"Totalfilesdownloaded:$no\n\n${WHITE}"
	
	done

