#!/bin/bash
# Last modified $Id$
# $HeadURL$
# -*- sh -*-


for f in `ls xx[0-9][0-9]`; do 

    header=$(head -1 $f|sed -e 's,^\* ,,;s, ,-,g;s,/,-,')
    echo \#$f: $header;
    mv $f $header.txt
    flip -d $header.txt
done;


#
#hd win encoder/decoder
#sd win encoder/decoder
#hd osx encoder
#sd osx encoder
#


tmp1=$(mktemp '/tmp/XXXXXXXXXXXXXX')


{

    echo Since this release 3.93 encoder, our activation process is now handled by our activation server.  If you would like to update the encoder to a newer version, you should contact support@stremabox.com to issue serial number.
    echo

} > $tmp1

{ 

    cat $tmp1

    cat Streambox-HD-win32-64-encoder.txt
    echo 
    cat Streambox-HD-win32-64-decoder.txt 

} > hd-win.txt

flip -m hd-win.txt

{ 
    cat $tmp1

    cat Streambox-SD-win32-64-encoder.txt 
    echo 
    cat Streambox-SD-win32-64-decoder.txt 
} > sd-win.txt

flip -m sd-win.txt


{
    cat $tmp1

    cat Streambox-HD-osx-encoder.txt 
} > hd-osx.txt

flip -m hd-osx.txt


{
    cat $tmp1

    cat Streambox-SD-osx-encoder.txt 

} > sd-osx.txt


flip -m sd-osx.txt