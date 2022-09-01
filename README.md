# Useful_Linux_stuff

## mytex.sh

This is a script for those who use the TeX Live typesetting software on the Bash command line. `mytex.sh` runs the latex command for you in a non-stop mode, that is, it will _not hang_ at errors in the LaTeX source file. If one is generating bibliography using BibTeX, a sequence of `latex` and `bibtex` commands is usually required to compile the source file correctly. `mytex.sh` does this automatically if given the `-b` option. The default `latex` command generally produces a ".dvi" file when compilation is successfull, while the `pdflatex` command generates a pdf output. `mytex.sh` will also output a ".dvi" file by default but generates pdf automatically when given the `-p` option. Finally, the script can also compile LaTeX source files making use of the __minted__ package for syntax highlighting when documenting code. For this purpose the Python Pygmentize package is required and `mytex.sh` checks for this dependency before compiling.

It is recommended to copy `mytex.sh` into `/usr/local/bin` and rename it to `mytex`.
```
Usage: mytex [OPTIONS] FILE

Available options are
  -b  executes the bibtex command as well
  -h  display this help and exit
  -m  uses the Python Pygmentize package
  -p  execute pdflatex instead

Exit status:
    0      if OK,
    1      if required dependent programs (latex or bibtex) are not found on the system.
    2      script executed without input file name,
    3      input file cannot be accessed.
```
Examples:
- Makes pdf directly
```
$ mytex -p srcfile1.tex
```
- Uses minted package and BibTeX to generate bibliography.
```
$ mytex -bm srcfile2.txt
```
__NOTE:__ the file extension/suffix is not important. It can be anything, or absent, and the script will still run successfully. However, it is good practice to name LaTeX source files with a ".tex" suffix.


## Weather Research Forecasting (WRF)

The Weather Research Forecasting (WRF) Model is a state-of-the-art atmospheric modeling system designed for both meteorological research and numerical weather prediction. It offers a host of  options for atmospheric processes and can run on a variety of computing platforms. WRF excels in a broad range of applications across scales ranging from tens of meters to thousands of kilometers The Mesoscale and Microscale Meteorology Laboratory of NCAR supports the WRF system to the user community, and maintains the WRF code on GitHub. Check out [https://www.mmm.ucar.edu/weather-research-and-forecasting-model](https://www.mmm.ucar.edu/weather-research-and-forecasting-model) for more.

We propose Bash scripts to install WRF in a custom local path in Slackware 14.2 and 15.0. The scripts install all the compilation and runtime dependencies in the custom path alongside the WRF install.


