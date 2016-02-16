#!/bin/bash

RESET="\e[0m"
RED="${RESET}\e[0;31m"
GREEN="${RESET}\e[0;32m"
YELLOW="${RESET}\e[0;33m"
BLUE="${RESET}\e[0;34m"
PINK="${RESET}\e[0;35m"
CYAN="${RESET}\e[0;36m"

REQUEST_URL="http://v3.wufazhuce.com:8000/api/hp/more/0"

WORK_DIR=$(cd "$(dirname "$0")" && pwd)
TEMP_FILE="$WORK_DIR/.one.temp"
USER_AGENT="mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.152 Safari/537.36"

_p() {
    printf "$(date '+[%Y-%m-%d %H:%M:%S]') "
    printf "$@"
    printf "${RESET}\n"
}

_check() {
    exec=(jq http)
    ret=0
    for var in ${exec[@]};
    do
        type $var >/dev/null 2>/dev/null
        if [ $? -ne 0 ]; then
            _p "${RED}脚本依赖的执行程序${var}不存在，安装参考README.md"
            ret=1
        fi
    done
}

_letsGetSomeWords() {
	body=$(http -b $REQUEST_URL)
	_p "hpcontent_id : $(echo "$body" | jq '.data[0].hpcontent_id')"
	title = "hp_title : $(echo "$body" | jq '.data[0].hp_title')"
	_p "author_id : $(echo "$body" | jq '.data[0].author_id')"
	_p "hp_img_url : $(echo "$body" | jq '.data[0].hp_img_url')"
	_p "hp_img_original_url : $(echo "$body" | jq '.data[0].hp_img_original_url')"
	author = "hp_author : $(echo "$body" | jq '.data[0].hp_author')"
	img_url = "ipad_url : $(echo "$body" | jq '.data[0].ipad_url')"
	content = "hp_content : $(echo "$body" | jq '.data[0].hp_content')"
	hp_makettime = "hp_makettime : $(echo "$body" | jq '.data[0].hp_makettime')"
	_p "last_update_date : $(echo "$body" | jq '.data[0].last_update_date')"
	_p "web_url : $(echo "$body" | jq '.data[0].web_url')"
	_p "praisenum : $(echo "$body" | jq '.data[0].praisenum')"
	mysql -uroot -ppasswd <<EOF
	use one_app;
		insert into one (title, img_url, author, content, hp_makettime) values ('$title','$img_url','$author','$content','$hp_makettime');
	EOF
}

_check
_p "check completed."
_letsGetSomeWords