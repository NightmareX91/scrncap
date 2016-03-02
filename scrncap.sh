now="$(date +"%s")"
filename="SS_$now.png"

while getopts "rwfc" opt; do
    case "$opt" in
        r)
            shutter -s -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
            ;;
        w)
            shutter -w -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
            ;;
        f)
            shutter -f -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
            ;;
        c)
            xclip -selection c -t image/png -o >> "/home/meanwhile/Pictures/scrncap/$filename"
            ;;
    esac
done

shift $((OPTIND-1))

#shutter -s -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"

sleep 1

if [ -s "/home/meanwhile/Pictures/scrncap/$filename" ]
then
    echo "Uploading screenshot"
    curl -Ls -o /dev/null -w %{url_effective} -F "fileToUpload=@/home/meanwhile/Pictures/scrncap/$filename" http://meanwhile.rocks/upload.php | xclip -selection c
    echo ""
    notify-send "Screenshot uploaded!"
else
    echo "Failed to take screenshot"
    notify-send "Failed to upload screenshot!"
fi
