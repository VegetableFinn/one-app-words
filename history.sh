#!/bin/bash

RESET="\e[0m"
RED="${RESET}\e[0;31m"
GREEN="${RESET}\e[0;32m"
YELLOW="${RESET}\e[0;33m"
BLUE="${RESET}\e[0;34m"
PINK="${RESET}\e[0;35m"
CYAN="${RESET}\e[0;36m"

REQUEST_URL="http://v3.wufazhuce.com:8000/api/hp/bymonth/"
REQUEST_URL_2=""

WORK_DIR=$(cd "$(dirname "$0")" && pwd)
TEMP_FILE="$WORK_DIR/.one.temp"
USER_AGENT="mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36"

_p() {
    printf "$(date '+[%Y-%m-%d %H:%M:%S]') "
    printf "$@"
    printf "${RESET}\n"
}
_letsGetSomeWords() {
	body=$(http -b $REQUEST_URL_2)
	len=$(echo "$body" | jq '.data | length')
	count=0
	while [ $count -lt $len ]
	do
		title=$(echo "$body" | jq '.data['$count'].hp_title')
		author_tmp=$(echo "$body" | jq '.data['$count'].hp_author')
		author=${author_tmp//&/ and };
		img_url=$(echo "$body" | jq '.data['$count'].ipad_url')
		content=$(echo "$body" | jq '.data['$count'].hp_content')
		hp_makettime=$(echo "$body" | jq '.data['$count'].hp_makettime')
		mysql -uuser -ppasswd -e "use one_app;insert into one (title, img_url, author, content, hp_makettime) values ('$title','$img_url','$author','$content','$hp_makettime');"
		((count++));
	done
}	

while true
do
	printf "> "
    read data
    if [ -z "$data" ]; then
        continue
    fi
    REQUEST_URL_2=${REQUEST_URL}${data}
	_letsGetSomeWords
done
