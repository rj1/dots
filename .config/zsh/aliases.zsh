# config
alias mitmproxy="mitmproxy --set confdir=$XDG_CONFIG_HOME/mitmproxy"
alias mitmweb="mitmweb --set confdir=$XDG_CONFIG_HOME/mitmproxy"
alias mbsync="mbsync -c $XDG_CONFIG_HOME/mbsync/config"
alias wget="wget --hsts-file=/tmp/.wget-hsts"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias g="git"
alias music="ncmpcpp"
alias rm="rm -i"
alias ls="ls --color"
alias l="ls -lah"
alias grep="grep --color"
alias task="dstask"
alias fd="fd --color=auto"
alias campv="mpv av://v4l2:/dev/video0"
alias ip='ip -color=auto'
alias busy="cat /dev/urandom | hexdump -C | grep '1a cc'"
alias tz="php ~/scripts/time.php"
alias checkencoding="ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1"
alias clip2qr="wl-paste | qrencode -t ANSI"
alias sshfs="sshfs -oauto_cache,reconnect"
alias studev="sshfs -oauto_cache,reconnect stu:/home/stu ~/mount/stu"
alias mp3='yt-dlp -f bestaudio --extract-audio --audio-format mp3 --add-metadata -o "%(title)s.%(ext)s"'
alias mp3tor='mp3 --proxy socks5://127.0.0.1:9050'
alias mp3album='yt-dlp -f bestaudio --extract-audio --audio-format mp3 --split-chapters -o "chapter:%(section_title)s.%(ext)s" --add-metadata --parse-metadata "title:%(artist)s - %(album)s"'
alias password="</dev/urandom tr -dc '123450!@#$%6789qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c32"
alias passgen="pass generate -c"
alias sc="source $XDG_CONFIG_HOME/zsh/.zshrc"
alias diff="nvim -d"
alias d="sudo docker"
alias sctl='sudo systemctl'
alias uctl='systemctl --user'
alias a=artisan
alias nvimdiff="nvim -d"
alias c=clear
alias ta="transmission-remote -a"
alias tl="transmission-remote --list"
alias mpv="mpv --input-ipc-server=/tmp/mpv"
alias e=edit
alias playwright="npx playwright"

urlencode() {
    php -r "echo urlencode('$1');"
}
urldecode() {
    php -r "echo urldecode('$1');"
}

# xbps
alias xbi="sudo xbps-install"
alias xbr="sudo xbps-remove"
alias xbq="xbps-query"

for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "${method}"="curl -X '${method}'"
done

ipi() {
    curl -s https://ipinfo.io/$1
}

upload() {
    if [ $# -lt 1 ]; then
        echo "filename parameter required"
        return
    fi

    if [ $1 = "img" ]; then
        file="$HOME/img/sshot/$(/usr/bin/ls -Art $HOME/img/sshot | tail -n 1)"
    elif [ $1 = "vid" ]; then
        file="$HOME/vid/screencast/$(/usr/bin/ls -Art $HOME/vid/screencast | tail -n 1 )"
    else
        file=$1
    fi

    filename=$(basename $file)

    curl -fsSL  -F "file=@\"${file}\"" -F "url_len=5" https://u.rj1.su/upload
}
alias up=upload

cpsshot() {
    if [ $# -lt 1 ]; then
        echo "filename parameter required"
        return
    fi

    file="$HOME/img/sshot/$(/usr/bin/ls -Art $HOME/img/sshot | tail -n 1)"
    cp -f ${file} $1
    rm -f ${file}
    echo "moved ${file}"
}

cpvid() {
    if [ $# -lt 1 ]; then
        echo "filename parameter required"
        return
    fi

    file="$HOME/vid/screencast/$(/usr/bin/ls -Art $HOME/vid/screencast | tail -n 1)"
    cp -f ${file} $1
    rm -f ${file}
    echo "moved ${file}"
}

androidproxy() {
    if [ $# -lt 1 ]; then
        echo "parameter required: on/off"
        return
    fi

    if [ $1 = "on" ]; then
        adb shell settings put global http_proxy 192.168.0.10:8080
    elif [ $1 = "off" ]; then
        adb shell settings put global http_proxy :0
    else
        echo "parameter required: on/off"
    fi
}
alias ap=androidproxy

function calc() {
  echo "$@" | bc -l
}

function cur() {
  php ~/scripts/cur.php $1 $2 $3
}

function wgetsite() {
  wget \
    --recursive \
    --page-requisites \
    --html-extension \
    --convert-links \
    --restrict-file-names=windows \
    --domains $1 \
    --no-parent \
    https://$1
}

function wavs2mp3() {
  for i in *.wav; do
    ffmpeg -i "$i" -ab 320k -ac 2 -ar 44100 -joint_stereo 0 "${i%.*}.mp3";
  done
}

function blurborder() {
  convert $1 -bordercolor black -fill white \
    \( -clone 0 -colorize 100 -shave 10x10 -border 10x10 -blur 0x10 \) \
    -compose copyopacity -composite $2
} 

function send2kindle() {
    scp "${1}" kindle:/mnt/us/documents/
}

# ping - https://gist.github.com/schappim/1d958254a2907f073cf3b70091ab4b0f
function ping() {
 local new_args=()
 local url_found=0

 for arg in "$@"; do
     if [[ "$arg" =~ ^http ]] && [ $url_found -eq 0 ]; then
         # Process the URL
         local url="$arg"
         url=${url#*://}  # Remove protocol
         url=${url%%/*}   # Remove path
         url=${url%%:*}   # Remove port
         url=${url%%@*}   # Remove user info
         new_args+=("$url")
         url_found=1
     else
         # Add the argument as is
         new_args+=("$arg")
     fi
 done

 # Call the original ping command with the new argument list
 command ping "${new_args[@]}"
}

