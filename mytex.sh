#!/bin/bash
#
#  mytex
#  Script to run the latex command in non-stop mode along with the bibtex
#  command sequences to generate the bibliography automatically. The script
#  also provides the commands with pdf and minted functionalities.
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
#  cp mytex.sh /usr/local/bin/mytex
#  chmod 755 /usr/local/bin/mytex
#
# ----------------------------------------------------------------------------
#

###
###  Function to print the help message.
###
printhelp()
{
  echo "Usage: `basename ${0}` [OPTIONS] FILE"

  echo "`basename ${0}` is a utility to execute the latex or pdflatex commands together with the"
  echo "bibtex command on FILE. It runs the commands the required number of times in"
  echo "the correct sequence to set up the bibliography according to BibTeX standards."
  echo "LaTeX compilation can also include the use of the minted package."
  echo
  echo "Available options are"
  echo "  -b  executes the bibtex command as well"
  echo "  -h  display this help and exit"
  echo "  -m  uses the Python Pygmentize package"
  echo "  -p  execute pdflatex instead"
  echo
  echo "Exit status:"
  echo "    0      if OK,"
  echo "    1      if required dependent programs (latex or bibtex) are not found on the system,"
  echo "    2      script executed without input file name,"
  echo "    3      input file cannot be accessed."
  echo
  echo "Report `basename ${0}` bugs to <lrugratz@gmail.com>"
  echo
}
###



###  BEGIN Main script  ###

# Declare variables
COMMAND=
BIBCOMMAND=


###  Verify if the command latex is available  ###
type -pa latex 1> /dev/null
if [ $? -ne 0 ]; then
  echo "`basename ${0}`: latex command not found."
  echo "The program latex (from the TeX Live package) is essential for `basename ${0}`"
  echo "to work properly."
  exit 1
else
  COMMAND=`type -pa latex`
fi


###  BEGIN Parse command line options  ###
while getopts 'bmhp' ARG; do
  case "${ARG}" in
    b)
      ###  Verify if bibtex command is available
      type -pa bibtex 1> /dev/null
      if [ $? -ne 0 ]; then
        echo "`basename ${0}`: bibtex command not found."
        echo "The program bibtex (from the TeX Live package) is essential for `basename ${0}`"
        echo "to work properly when given the -b option."
        exit 1
      else
        BIBCOMMAND=`type -pa bibtex`
      fi

      ;;

    p)
      ###  Verify if pdflatex command is available
      type -pa pdflatex 1> /dev/null
      if [ $? -ne 0 ]; then
        echo "`basename ${0}`: pdflatex command not found."
        echo "The program pdflatex (from the TeX Live package) is essential for `basename ${0}`"
        echo "to work properly when given the -p option."
        exit 1
      else
        COMMAND=`type -pa pdflatex`
      fi

      ;;

    m)
      ###  Verify if the Python Pygmentize package is available
      type -pa pygmentize 1> /dev/null
      if [ $? -ne 0 ]; then
        echo "`basename ${0}`: pygmentize command not found."
        echo "This indicates that the Python Pygmentize package is not available on this"
        echo "system. The latter is required to be able to use the minted package requested"
        echo "with the -m option."
        exit 1
      else
        COMMAND="${COMMAND} --shell-escape"
      fi
      ;;

    ?|h)
      printhelp
      exit 0
      ;;
  esac
done
shift "$(( $OPTIND - 1 ))"
###  END Parse command line options  ###


COMMAND="${COMMAND} \\\\nonstopmode\\\\input"

# Check if file name is given as argument
if [ $# -eq 0 ]; then
  printhelp
  exit 2
else
  # Set base file name
  BASEFILE="${1%.*}"

  # Check if file exists
  if ! [ -f ${1} ]; then
    echo "`basename ${0}`: Cannot access ${1}!"
    exit 3
  else

    # Run the sequence of bibtex commands if BibTeX was requested.
    if [ -n "${BIBCOMMAND}" ]; then
      eval "${COMMAND} ${1}"
      eval "${BIBCOMMAND} ${BASEFILE}.aux"
      eval "${COMMAND} ${1}"

      # Check if there is nomenclature and make index if necessary
      if [ -f ${BASEFILE}.nlo ]; then
        makeindex ${BASEFILE}.nlo -s nomencl.ist -o ${BASEFILE}.nls
        eval "${COMMAND} ${1}"
      fi

      eval "${COMMAND} ${1}"
      RETVAL=$?
    else
      eval "${COMMAND} ${1}"

      # Check if there is nomenclature and make index if necessary
      if [ -f ${BASEFILE}.nlo ]; then
        makeindex ${BASEFILE}.nlo -s nomencl.ist -o ${BASEFILE}.nls
        eval "${COMMAND} ${1}"
      fi

      eval "${COMMAND} ${1}"
      RETVAL=$?
    fi

    exit ${RETVAL}
  fi
fi
###  END Main script  ###
