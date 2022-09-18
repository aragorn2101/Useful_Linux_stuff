# Useful_Linux_stuff

## mytex.sh

This is a script for those who use the TeX Live typesetting software on the Bash command line. `mytex.sh` runs the latex command for you in a non-stop mode, that is, it will _not hang_ at errors in the LaTeX source file. If one is generating bibliography using BibTeX, a sequence of `latex` and `bibtex` commands is usually required to compile the source file correctly. `mytex.sh` does this automatically if given the `-b` option. The default `latex` command generally produces a ".dvi" file when compilation is successfull, while the `pdflatex` command generates a pdf output. `mytex.sh` will also output a ".dvi" file by default but generates pdf automatically when given the `-p` option. Finally, the script can also compile LaTeX source files making use of the __minted__ package for syntax highlighting when typesetting code. For this purpose the Python Pygmentize package is required and `mytex.sh` checks for this dependency on one's system before compiling.

It is recommended to copy `mytex.sh` into `/usr/local/bin`, rename it to **mytex**, and make it executable.
```
# cp mytex.sh /usr/local/bin/mytex
# chmod 755 /usr/local/bin/mytex
```

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


## up.sh

The script contains a handy function (the `up()` function) which goes a certain number of directories *up* when browsing on the Bash command line interface. The function takes at most one argument. When executed without argument, the effect is to go up one directory, identical to the `cd ..` command. When given a positive integer, the function goes up that number of directories in the hierarchy. The purpose of the function is to allow faster browsing in the Bash environment, especially when going up several levels of directories. Furthermore, `cd -` gets the user back to the working directory in which `up` was called.

**NOTE:** if the integer argument exceeds the number of levels from the *present working directory* to the *root directory* `/`, the `up()` function simply goes back to `/`.
```
Usage: up [NUM_LEVELS]
NUM_LEVELS: blank or integer in the set {1, 2, 3, ...}
```

The script can be placed in `/usr/local/lib` for example, or any other custom path, and made readable.
```
# cp up.sh /usr/local/lib
# chmod 644 /usr/local/lib/up.sh
```

Then, it is sourced by the user's local bashrc script. So, add the following lines to `${HOME}/.bashrc`, and modify with the correct path accordingly:
```
# Source /usr/local/lib/up.sh
if [ -f /usr/local/lib/up.sh ]; then
  . /usr/local/lib/up.sh
fi
```
Examples:
```
user1@Desktop:~/Documents/dir1/dir-2/dir\ 3/dir\ 4/dir_5/dir6$ pwd
/home/user1/Documents/dir1/dir-2/dir 3/dir 4/dir_5/dir6

user1@Desktop:~/Documents/dir1/dir-2/dir\ 3/dir\ 4/dir_5/dir6$ up
/home/user1/Documents/dir1/dir-2/dir 3/dir 4/dir_5
user1@Desktop:~/Documents/dir1/dir-2/dir\ 3/dir\ 4/dir_5$

user1@Desktop:~/Documents/dir1/dir-2/dir\ 3/dir\ 4/dir_5$ up 3
/home/user1/Documents/dir1/dir-2
user1@Desktop:~/Documents/dir1/dir-2$

user1@Desktop:~/Documents/dir1/dir-2$ up 10
/
user1@Desktop:/$
```

## rename_spaces.sh
`rename_spaces.sh` is a script which renames files and directories by replacing every whitespace, '` `', in the file names by underscores, '`_`' . A whitespace in the Bash environment is a special character. Bash uses whitespaces to determine where words begin and end. Having whitespaces in file names might cause issues, especially when using the file names in scripts. Therefore, users must always escape whitespaces when they are found in file names, which can be quite tedious. Furthermore, scripts become much more complicated to write when catering for whitespaces in file names. Thus, it is quite useful to have a tool which renames files automatically and only replaces whitespaces while keeping every other word in the file names untouched.

The script can handle many input arguments/file names simultaneously. By default, if the input argument is a directory, the script will rename the directory and   its contents recursively. The `-d` option can be used to avoid recursive renaming. If the full path to a regular file is given the regular file only will be subject to renaming.

It is recommended that the script is copied to `/usr/local/bin` and renamed to **rename_spaces**.
```
# cp rename_spaces.sh /usr/local/bin/rename_spaces
# chmod 755 /usr/local/bin/rename_spaces
```

```
Usage: rename_spaces.sh [FILE1 FILE2 FILE3 ...] [DIR1 DIR2 DIR3 ...]  

Available options are
  -d  renames only directories themselves, not their contents  
  -h  prints this help message and exit  
  
Exit status:  
    0      if OK or if help requested by option,  
    1      an unsupported option was given as input argument,  
    2      error due to no input argument.
```
**e.g. 1**
```
$ rename_spaces  file\ 1\ a.txt
```
*Result:* `file_1_a.txt`

**e.g. 2**
```
$ rename_spaces  dir\ A  /home/user1/Documents/file\ 3  /home/user1/Western\ Music/2022\ -\ song\ no.\ 1.mp3
```
*Results:*
- `dir_A`, and  all the contents of `dir_A` renamed recursively.
- `/home/user1/Documents/file_3`
- `/home/user1/Western\ Music/2022_-_song_no._1.mp3`

**e.g. 3**
```
$ rename_spaces  -d  /home/user1/Video\ Files/  /mnt/hdisk1/Users/user2/Documents\ and\ Settings/  /mnt/hdisk1/Users/user2/Documents\ and\ Settings/2014\ -\ Article\ B\ -\ part*.pdf
```
*Results:*
- `/home/user1/Video_Files` and its contents left as is.
- `/mnt/hdisk1/Users/user2/Documents_and_Settings` and its contents left untouched.
- `/mnt/hdisk1/Users/user2/Documents_and_Settings/2014_-_Article_B_-_part_1.pdf`
- `/mnt/hdisk1/Users/user2/Documents_and_Settings/2014_-_Article_B_-_part_2.pdf`


## Weather Research Forecasting (WRF)

The Weather Research Forecasting (WRF) Model is a state-of-the-art atmospheric modeling system designed for both meteorological research and numerical weather prediction. It offers a host of  options for atmospheric processes and can run on a variety of computing platforms. WRF excels in a broad range of applications across scales ranging from tens of meters to thousands of kilometers The Mesoscale and Microscale Meteorology Laboratory of NCAR supports the WRF system to the user community, and maintains the WRF code on GitHub. Check out [https://www.mmm.ucar.edu/weather-research-and-forecasting-model](https://www.mmm.ucar.edu/weather-research-and-forecasting-model) for more.

We propose Bash scripts to install WRF in a custom local path in both Slackware 14.2 and 15.0. The scripts install all the compilation and runtime dependencies in the custom path alongside the WRF install.



