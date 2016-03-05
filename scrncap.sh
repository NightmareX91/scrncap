now="$(date +"%s")"
ext=
filename="SS_$now. + $ext"
capturing=false

show_help () {
    echo "---------------scrncap---------------"
    echo "| -h : Displays help                |"
    echo "| -r : Region capture               |"
    echo "| -w : Window capture               |"
    echo "| -f : Fullscreen capture           |"
    echo "| -c : Upload image from clipboard  |"
    echo "| -u : Upload file. Takes 1 arg.    |"
    echo "-------------------------------------"
}

up_scrnsht () {
    ext=".png"
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
}

up_file () {
    if [ -s $1 ]
    then
        echo "Uploading file"
        curl -Ls -o /dev/null -w %{url_effective} -F "fileToUpload=@$1" http://meanwhile.rocks/upload.php | xclip -selection c
        echo ""
        notify-send "File uploaded!"
    else
        echo "Path doesn't exist"
        notify-send "Path doesn't exist!"
    fi
}

while getopts "hrwfcu:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        r)
            if [ "$capturing" = true ]
            then
                echo "You can't use -r at the same time as -w, -f or -c!"
            else
                capturing=true
                shutter -s -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
                up_scrnsht
            fi
            ;;
        w)
            if [ "$capturing" = true ]
            then
                echo "You can't use -w at the same time as -r, -f or -c!"
            else
                capturing=true
                shutter -w -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
                up_scrnsht
            fi
            ;;
        f)
            if [ "$capturing" = true ]
            then
                echo "You can't use -f at the same time as -r, -w or -c!"
            else
                capturing=true
                shutter -f -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
                up_scrnsht
            fi
            ;;
        c)
            if [ "$capturing" = true ]
            then
                echo "You can't use -c at the same time as -r, -w or -f!"
            else
                capturing=true
                xclip -selection c -t image/png -o >> "/home/meanwhile/Pictures/scrncap/$filename"
                up_scrnsht
            fi
            ;;
        u)
            up_file $OPTARG
            ;;
        \?)
            echo "Invalid option: $1" >&2
            exit 0
            ;;
        :)
            echo "Option $1 requires an argument." >&2
            exit 0
            ;;
    esac
done

shift $((OPTIND-1))

#shutter -s -c -e -n -o="/home/meanwhile/Pictures/scrncap/$filename"
