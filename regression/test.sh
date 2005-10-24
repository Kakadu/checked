#!/bin/sh

if test $# = 0; then
    echo "usage: $0 <file prefix>"
    exit 1
fi
      
FILE=`basename $1`

if [ ! -x $FILE ]; then
    echo "File $FILE does not exist or not executable"
    exit -1
fi

./$FILE > $FILE.log

ERROR=0
if ! diff -u orig/$FILE.log $FILE.log > $FILE.diff; then
    echo "$FILE: FAILED (see $FILE.diff)"
    ERROR=$(($ERROR + 1))
else
    rm -f $FILE.diff
fi

if [ $ERROR -eq 0 ]; then
    #echo "$FILE: passed"
    exit 0
else
    exit $ERROR
fi
