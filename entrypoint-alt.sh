#!/bin/bash
# 1. Loop through pdf-in/subdir's to find new files and generate pathnames
# 2. Delete .*.pdf files
# 3. Call script to OCR and email OCRed files

# read email adresses and generate samba filesystem accordingly
# email adresses are in ocremailconfig.txt

find $WATCHED_DIR -name *.pdf |
        while read -r file
        do
        fileocr="${file/pdf_in/pdf_ocr}"
        fileorig="${file/pdf_in/pdf_orig}"
        filename="`basename $file`"
	email=`echo "$file" | cut -d "/" -f4`
        if [ $email == "crediteuren" ]
	then
	domein="@eurogroupconsulting.nl"
        else
	domein="magnus.nl"
	fi
.*.pdf) rm "$file" && echo "$file" "deleted";;
        *.pdf) . ocr_and_email_03.sh ;;
        *) mv "$file" "$fileorig" && echo "$file" "Oops" ;;
        esac
        done

IFS=$oIFS
