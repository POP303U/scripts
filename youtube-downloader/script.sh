echo "Enter song name: (example: 'Alan Aztec - Disco Panzer (feat. R5on11c)')"
read song_name
echo "Enter youtube url: (example: 'https://youtu.be/uRSAatLI2QY?list=PLI7GiZMfTF51C6Pj2atVhhlPSKKQFIbpY')"
read url
echo "Enter path (or default /mnt/sdc1/Music): "
read path

echo "$path/$song_name"
echo "$url"

if [ "$path" == "default" ] || [ "$path" == "" ]; then
    path="/mnt/sdc1/Music"
fi

yt-dlp -o "$path/$song_name" -x "$url"
