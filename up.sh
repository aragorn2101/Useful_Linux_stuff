#!/bin/bash

# up.sh
# Script containing the function up, which goes up in the directory hierarchy
# depending on the argument passed to the function.
#
# Copyright (C) 2022  Nitish Ragoomundun, Mauritius
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ----------------------------------------------------------------------------
# This script can be placed in /usr/local/lib for example and change
# permissions to 644:
# chmod 644 /usr/local/lib/up.sh
#
# Then, put the following lines in ${HOME}/.bashrc or /etc/bashrc to be able
# to call the function up from inside the shell environment:
#
# Source /usr/local/lib/up.sh
# if [ -f /usr/local/lib/up.sh ]; then
#   . /usr/local/lib/up.sh
# fi
#
# ----------------------------------------------------------------------------


up ()
{
  #  If there is an argument but first argument is not a positive integer
  if [ ${#} -ge 1 ] && ! [[ "${1}" =~ ^[0-9]+$ ]] ; then
    echo "Usage: up [NUM_LEVELS]"
    echo "NUM_LEVELS: blank or integer in the set {1, 2, 3, ...}"
    return 1

  #  If first argument is 0
  elif [ ${#} -ge 1 ] && [ ${1} -eq 0 ] ; then
    echo "Usage: up [NUM_LEVELS]"
    echo "NUM_LEVELS: blank or integer in the set {1, 2, 3, ...}"
    return 2

  #  Normal execution
  else

    #  Set number of directories to go up
    if [ ${#} -eq 0 ]; then
      i=1
    else
      i=${1}
    fi

    #  Set target directory to current working directory
    TARGET=$( pwd )

    #  Determine destination path
    until [ ${i} == 0 ]; do
      #  Remove right-most directory from path
      TARGET=${TARGET%/*}

      #  If argument was higher than number of directories
      #  from /, then go to / directly.
      if [ "${TARGET}" == "" ]; then
        TARGET="/"
        i=0
      else
        (( i-- ))
      fi
    done

    # cd to target destination
    echo "${TARGET}"
    cd "${TARGET}"
    return 0

  fi
}
