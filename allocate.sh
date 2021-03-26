#!/bin/bash
if [ "$1" = "" ]
then
      echo "Please provide the remaining space you want on the filesystem in KBs"
      exit
fi

echo "$1"

FILENAME=/tmp/large_file

SPACE_BEFORE=`df -h /dev/sda1 --output=avail | tail -1`
echo $SPACE_BEFORE
SPACE_AVAILABLE=`df /dev/sda1 | grep sda | awk '{print $4}'`
echo $SPACE_AVAILABLE
SPACE_REMAINDER=$1
echo "This is: $SPACE_REMAINDER"
SPACE_REMAINDER=expr $SPACE_REMAINDER * 1024
echo "This is: $SPACE_REMAINDER"
SPACE_CONSUME=`expr $SPACE_AVAILABLE - $SPACE_REMAINDER`
echo $SPACE_CONSUME
if [ $SPACE_CONSUME -le 0 ]
then
      echo "Enough space already consumed!"
else
      echo "Consuming `expr $SPACE_CONSUME / 1024`M of space so that `expr $SPACE_REMAINDER / 1024`M remains."
      fallocate -l ${SPACE_CONSUME}K $FILENAME
fi
SPACE_AFTER=`df -h /dev/sda1 --output=avail | tail -1`

echo ""
echo "Remaining space on /"
echo "    Before: ${SPACE_BEFORE}"
echo "    After:  ${SPACE_AFTER}"
echo ""
echo "To free up space run the following command:"
echo "    $ rm ${FILENAME}"
echo ""
