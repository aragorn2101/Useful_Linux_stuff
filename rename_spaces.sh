#!/bin/bash
#
#  rename_spaces
#  Script to rename file(s) using same filename but with spaces replaced with
#  underscores.
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
#
# ----------------------------------------------------------------------------
#  Place this script in /usr/local/bin and set permission to execute:
#  cp mytex.sh /usr/local/bin/rename_spaces
#  chmod 755 /usr/local/bin/rename_spaces
#
# ----------------------------------------------------------------------------
#


###
###  Function to print help message
###
print_help()
{
  echo
  echo "Usage: `basename ${0}` [FILE1 FILE2 FILE3 ...] [DIR1 DIR2 DIR3 ...]"
  echo
  echo "Replaces space characters in file names by the underscore character, '-'. If"
  echo "input file is a directory, by default the script will rename the directory and"
  echo "its contents recursively. If the full path to a regular file is given the"
  echo "regular file only will be subject to renaming. Several files or directories can"
  echo "be processed in a single call of the script; the distinct files/directories"
  echo "should be passed as separate command line arguments."
  echo
  echo "Available options are"
  echo "  -d  renames only directories themselves, not their contents"
  echo "  -h  prints this help message and exit"
  echo
  echo "Exit status:"
  echo "    0      if OK or if help requested by option,"
  echo "    1      an unsupported option was given as input argument,"
  echo "    2      error due to no input argument."
  echo
  echo "Report `basename ${0}` bugs to <lrugratz@gmail.com>"
  echo
}


###
###  Function to test if a string contains a substring
###
#
#  Usage: TestStrSubstr STRING SUBSTRING
#  Function checks if STRING constains SUBSTRING
#
#  Return values:
#  1  STRING contains SUBSTRING
#  0  STRING does not contain SUBSTRING
#
TestStrSubstr()
{
  if [ -z "${2}" ] || ([ -z "${1##*$2*}" ] && [ -n "${1}" ]); then
    return 0
  else
    return 1
  fi
}


###
###  Function to replace spaces in file names
###
#
#  Usage: replace_spaces FILENAME
#
replace_spaces()
{
  local DIRPATH
  local NEWNAME
  local FILE

  local OLDNAME="${1}"
  local CWD=$( pwd )

  # Check if argument is a directory
  if [ -d "${OLDNAME}" ]; then  # 1

    # Check for a trailing slash in cases of directories
    if [ "${OLDNAME:(-1)}" == "/" ]; then
      OLDNAME="${OLDNAME%/}" # Remove the trailing slash
    fi

    # Check if directory is executable
    if [ -x "${OLDNAME}" ]; then  # 2

      if [ "${RECURSIVE}" == "true" ]; then  # 3
        # Browse directory and rename recursively
        # before renaming directory itself
        cd "${OLDNAME}"
        for FILE in *; do
          replace_spaces "${FILE}"
        done
        cd "${CWD}"
      fi  # 3

    else  # 2
      FILE=$( realpath "${DIRPATH}/${OLDNAME}" )
      echo "`basename ${0}`: cannot access ${FILE}"
      echo
    fi  # 2

  fi  # 1

  # Find path and filename
  DIRPATH="${OLDNAME%/*}"
  OLDNAME="${OLDNAME##*/}"

  # If argument was just a single file name
  if [ "${DIRPATH}" == "${OLDNAME}" ]; then
    DIRPATH="."
  fi

  # Check if argument has space character within its file name
  if $( TestStrSubstr "${OLDNAME}" " " ) ; then  # 1

    # Check if write permission is available to rename file
    if [ -w "${DIRPATH}/${OLDNAME}" ]; then  # 2

      # Compose new name with space characters replaced by underscores
      NEWNAME="${OLDNAME// /_}"

      # Check if there are existing files with the new name
      # in the target directory
      if [ -e "${DIRPATH}/${NEWNAME}" ]; then  # 3
        FILE=$( realpath "${DIRPATH}/${OLDNAME}" )
        echo "`basename ${0}`: cannot rename ${FILE}"
        FILE=$( realpath "${DIRPATH}/${NEWNAME}" )
        echo "since ${FILE} already exists!"
        echo
      else  # 3
        mv "${DIRPATH}/${OLDNAME}" "${DIRPATH}/${NEWNAME}"
      fi  # 3

    else  # 2
      FILE=$( realpath "${DIRPATH}/${OLDNAME}" )
      echo "`basename ${0}`: cannot access ${FILE}"
      echo
    fi  # 2

  fi  # 1
}



###  BEGIN Main script body  ###

# Rename directories recursively by default
RECURSIVE="true"

# Parse command line arguments
while getopts 'dh' ARG; do
  case "${ARG}" in
    d)
      RECURSIVE="false"
      ;;

    h)
      print_help
      exit 0
      ;;

    ?)
      print_help
      exit 1
      ;;
  esac
done
shift "$(( $OPTIND - 1 ))"


if [ $# -eq 0 ]; then
  print_help
  exit 2
else

  # Browse through arguments and rename
  for i in $( seq 1 $# ); do
    replace_spaces "${1}"
    shift
  done

  exit 0
fi

###  END Main script body  ###
