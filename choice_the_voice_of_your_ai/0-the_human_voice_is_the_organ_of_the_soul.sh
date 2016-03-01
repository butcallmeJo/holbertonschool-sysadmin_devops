#!/bin/bash

case "$2" in
    f)
	voice=Samantha
	;;
    m)
	voice=Fred
	;;
    x)
	voice=Zarvox
	;;
    *)
	voice=Whisper
	;;
esac
file=`echo $1 | awk '{print $1}'`

say -v $voice -o $file.m4a $1
scp  -qi ~/.ssh/holbertonServer $file.m4a admin@$3:/usr/share/nginx/html/$file.m4a

echo $file".m4a"
echo "Listen to the message on http://$3/$file.m4a"


#if f:
#   say -v Samantha -o [firstword.m4a] $1
#fi
#if m:
#   say -v Fred -o [firstword.m4a] $1
#fi
#if x:
#   say -v Zarvox -o [firstword.m4a] $1
#fi
#   
#if *:
#   say -v Whisper -o [firstword.m4a] $1
