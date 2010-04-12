#!/bin/bash
# Last modified $Id$
# $HeadURL$
# -*- sh -*-

# set -e
# set -x
set -u


# usage: $0

# fixme: you need to understand csplit better.  When you do this: 
#
# csplit -sk allinone.org  '/^\* /' '{40}' 2>/dev/null, then 
# 
# then it seems like this is left over
#
#	  - MacOSX version. Fixed bug with FEC R/S selection. Encoder was always using Parity.
#	  - All: CELP codec memory leak fixed (encoder/decoder)
#	  - Better bitrate/less drops for fractional frame-rates (1/2,1/3... FPS).
#	  - Minimum delay is 0.4 for 1/20 FPS and 0.2 for other FPS
#
#	  * Streambox SD win32/64 encoder
#
# see the last line?  This "* Streambox SD win32/64 encoder" is left
# over in the Streambox-SD-osx-encoder.txt file.  Here is the order:
#
#* Streambox SD osx encoder
#* Streambox SD win32/64 encoder
#
# So csplit leaves "* Streambox SD win32/64 encoder" in the file that's
# second to last namely the "Streambox-SD-osx-encoder.txt" file.  More
# generally, it takes the last regexp match and puts it at the end of
# the second to last.  Explorer this more.
#

	            
TMP=`mktemp -t main.sh.XXXXXX`

perl parse-notes.pl > allinone.org
cat >$TMP<<EOF
# -*- Mode: org -*- 
#+TITLE:     
#+AUTHOR:    Taylor Monacelli
#+EMAIL:     taylor.monacelli@streambox.com
#+LANGUAGE:  en
#+OPTIONS:   H:3 num:nil toc:t \n:nil @:t ::t |:t ^:nil -:t f:t *:t TeX:nil LaTeX:nil skip:t d:nil tags:not-in-toc
EOF
cat allinone.org >> $TMP
cat $TMP > allinone.org
csplit -sk allinone.org  '/^\* /' '{40}' 2>/dev/null # creates innocuous
				# error, but try to find a way around this
./rename.sh
trap "rm $TMP* 2>/dev/null" 0