#!/bin/bash
# 1. Watch WATCHED_DIR folder recursively.
# 2. in ocr_and_email_92.sh: OCR pdf-images to multipage pdf documents with tex$
#
#change the variable below with the folder you want this script to watch for ne$
WATCHED_DIR=/mnt/pdf_in
export SHELL=/bin/bash

(echo start; inotifywait -mr -e create,moved_to "$WATCHED_DIR" --format "%w%f") |
while read event; do

                 oIFS=$IFS
                 IFS=$'\n'
                 find $WATCHED_DIR -name *.pdf |
                 while read -r file; do
				while :
				do
					if ! [[ `lsof "$file"` ]]
    					then
        				break
    					fi
    					sleep 0.5
					echo "slept 0.5"
				done
                        fileocr="${file/pdf_in/pdf_ocr}"
                        fileorig="${file/pdf_in/pdf_orig}"
                        filename="`basename $file`"
                        case "$filename" in
                        .*.pdf) rm "$file" && echo "$file" "deleted";;
                        *.pdf) OCRmyPDF -f -l eng+nld "$file" "$fileocr" && mv "$file" "$fileorig" && echo "$filename" "OCR-ed"
				mutt -s "$fileocr" -a "$fileocr" -- hulshofw@gmail.com < /dev/null && echo "$filename" "emailed" ;;
                        *) mv "$file" "$fileorig" && echo "$file" "Oops" ;;
                        esac
                 done
                 IFS=$oIFS
done
