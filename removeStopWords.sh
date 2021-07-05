#!/bin/bash

set -x


# remove unimportant words from text
# executes on ../CRAWL


# take input file with all website

path=/home/kali/Downloads/CRAWL
stopwords_path=/home/kali/stopwords.txt

website_list=$(ls $path) 
stopwords=$(cat $stopwords_path) 

#website_list="www.w3schools.com"

for i in $website_list
do
	simple_dir=$path/$i/"simple"
	
	if [[ -d $simple_dir ]] 
	then 
		continue
	fi

	htmls=$(find $path/$i -name *.html) #-exec bash -c " sed 's/$var//g' {} " \; 	# ...
	
	mkdir $simple_dir 
	
		for file in $htmls
		do
			cp $file $simple_dir		
		done
		
		html_file=$(ls $simple_dir)
		
		for file in $html_file	
		do
			
			absolute_path=$path/$i/"simple"/$file
	

			sed -i "s/<[^>]*>//g"	 	$absolute_path
			sed -i "s/&.*//g" 	 	$absolute_path  
			sed -i "s/(\(.*\))//g" 		$absolute_path
			sed -i "s/ //g"		 	$absolute_path
                        sed -i "s/[^[[:alpha:]]]*//g"	$absolute_path
			
			#for each html file , sort content :
			#cat $absolute_path | sort -u > $absolute_path
				
			for word in $stopwords
			do
				var=" $word " 
			
				sed -i "s/$var//g" $absolute_path	

			
			done

		cat $absolute_path | grep -v "^$" > $simple_dir/"aux_file.txt"
		cat $simple_dir/"aux_file.txt" | sort -d | uniq -c | sort -rn -k1 | head -n 50 | sed "/\(Element\)\|\(log\)\|\(else\)\|\(if\)\|\(var\)\|\(txt\)\|\(xhttp\)\|\(Event\)\|\(style\)\|\(substr\)\|\(background\)\|\(border\)\|\(border\)\|\(font\)\|\(folder\)\|\(margin\)\|\(box\)\|\(padding\)\|\(px\)\|\(width\)\|\(border\)\|\(body\)/ d" > $simple_dir/$file"stats.txt"	


		done


done
