#!/bin/bash

# @see http://lame.sourceforge.net/
# apt-get install lame

WAVE="-V 1"
DIRECTORY="./"
MAXDEPTH="-maxdepth 1"
BACKUP=false
NOT_FOUND=true

if !( hash lame 2>/dev/null ); then
  echo "Please install lame. See http://lame.sourceforge.net/"
  exit 0
fi

if [ -d "$1" ]
then
  DIRECTORY="$1"
  NOT_FOUND=false
fi

while test $# != 0
do
    case "$1" in
    -h|--help)
      # TODO:
      exit 0;;
    -r|--recurcive)
      MAXDEPTH="";;
    -b|--backup)
      BACKUP=true;;
    --) shift; break;;
    *)  usage ;;
    esac
    shift
done

if $NOT_FOUND;
then
  echo "Directory not found. Use the default value – $DIRECTORY"
fi

find $DIRECTORY -name '*.mp3' $MAXDEPTH | while read line; do
  echo "Processing file '$line'"

  NAME=$line
  BACK_NAME="${line%.*}.back.mp3"

  mv $NAME $BACK_NAME
  lame $WAVE "$BACK_NAME" "$NAME"

  if [ $BACKUP != true ]
  then
    rm -rf $BACK_NAME
  fi
done
