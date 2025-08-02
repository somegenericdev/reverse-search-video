#!/bin/bash
set -euo pipefail

video_path="$1"
desired_searches="10"
tmp_dir=$(mktemp -d)

if [[ $video_path == *.gif ]]
then
    echo "#####IS GIF"
    ffmpeg -i "$video_path" "${tmp_dir}/frame_%d.jpg"
else
    ffmpeg -i "$video_path" "${tmp_dir}/frame_%d.jpg"
fi


echo "#####TMPDIR IS ${tmp_dir}"

cd "$tmp_dir"


search_urls_array=()


max_index=$(ls | grep -Eo '[0-9]+' | sort -n | tail -n1)
step=$(( max_index / desired_searches ))
current_index="1"

search_count="0"

while [[ $search_count != "$desired_searches" ]]
do
    filename="frame_${current_index}.jpg"

    for i in 1 2 3 4 5; #retry 5 times if it fails; avoids rate limiting
    do 
        search_url=$(get-yandex-url.py "${tmp_dir}/${filename}") && break || sleep 15
    done


    firefox "$search_url" &
    search_urls_array=("${search_urls_array[@]}" "$search_url")

    current_index=$((current_index + step))
    search_count=$((search_count + "1"))

done

echo "${search_urls_array[@]}"
