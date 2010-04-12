#!/bin/bash
# Last modified $Id$
# $HeadURL$
# -*- sh -*-


for f in `ls xx[0-9][0-9]`; do 

    header=$(head -1 $f|sed -e 's,^\* ,,;s, ,-,g;s,/,-,')
    echo \#$f: $header;
    mv $f $header.txt
done;