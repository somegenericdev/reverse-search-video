#!/bin/bash

video_path="$1"
tmp_dir=$(mktemp -d)
ffmpeg -i "$video_path" -vf fps=1/10 "${tmp_dir}/img%03d.jpg" #one frame every 10 secs

cd "$tmp_dir"

#chromium #opens a window

search_urls_array=()

for filename in *.jpg; do

    search_url=$(get-yandex-url.py "${tmp_dir}/${filename}")
    #chromium "$search_url"
    firefox "$search_url" &
    search_urls_array=("${search_urls_array[@]}" "$search_url")
done
echo "${search_urls_array[@]}"
#firefox "${search_urls_array[@]}" &
