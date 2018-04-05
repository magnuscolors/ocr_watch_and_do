FROM alpine

RUN apk update && apk upgrade && apk add --no-cache inotify-tools bash gawk sed grep bc coreutils jq rsync
RUN apk add --update curl

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

