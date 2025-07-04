# The Weather Research and Forecasting (WRF) model

We propose installation scripts for WRF ARW (Advanced Research WRF). The source for WRF can be obtained from the ARW users' page (https://www2.mmm.ucar.edu/wrf/users/). By default, WRF ARW is compiled in a directory where the user has write access, and the full source code is kept. This is because WRF and its pre-processor, WPS, are usually executed directly from the compiled source code directories. We will install WRF 4.6.1 along with WPS 4.6.0.

The main system requirement is a 64-bit processor and operating system. The script were tested using 64-bit Slackware 14.2 or 15.0 GNU/Linux installed on the same Intel Core i7-7700K machine. Building and installing all the software on this machine takes less than 15 minutes. Since we have a high-end processor and lots of RAM, a longer build time would be expected on other machines. The final space taken on disk is around 1.1 GB for the WRF software only, and around 30 GB when the geographical static data is included.

**NOTE:** we have included two installation scripts, namely `install_wrfv4.sh` and `install_wrfv4_slack.sh`. The "slack" version is meant for the Slackware distro since it uses the option `--build=$ARCH-slackware-linux`. The `install_wrfv4.sh` script is meant for any GNU/Linux distro.


## install_wrfv4.sh

The script installs WRF and all its dependencies in a custom location. The later sections give details about the source code archives to be downloaded. The last section describes how to install NCAR Graphics and NCL separately in a Python environment.

All the source code archives of WRF, WPS and all the dependencies must be downloaded and put in the same directory as the script. The generic call `./install_wrfv4.sh` will install WRF and its dependencies in a directory called `wrfv4` under the user's home directory (`${HOME}`). If the user wishes to install WRF in a different location, the call should be
```
$ OUTPUT=CUSTOM_PATH ./install_wrfv4.sh
```

WRF will be compiled in parallel using a default number of threads/cores calculated from the number of processors present on the machine. If a computer features 4 cores, then the number of cores used to build WRF is 3. If the user wishes to specify the number of threads/cores to use for building WRF, the call should be made as follows
```
$ NUMJOBS=NUMBER_OF_CORES_OR_THREADS ./install_wrfv4.sh
```

After installation in a path `OUTPUT` the final directory tree will look like this:
```
- [OUTPUT]/
  - wrfv4.4/
    - DATA/
    - GEOG/
    - WPS/
    - WRF/
    - deps/
    - env.sh
    - utils/
```
The script will set all permissions with respect to the user executing it.

The `DATA` and `GEOG` directories are empty. These are created to allow the user to store input data close to the WRF software. Directory `DATA` normally would contain GRIB or netCDF files. It is recommended that the content of the archive containing the geographical input data mandatory fields is directly extracted to the `GEOG` as follows:
```
$ tar -C ${OUTPUT}/wrfv4/GEOG --strip-components=1 -zxf GEOG_MANDATORY_DATA.tar.gz
```
Then, the field `geog_data_path`, in namelist.wps, can be set to `${OUTPUT}/wrfv4/GEOG`.

Directory `deps` contains dependency libraries and `utils` contains ncview, which is a useful tool to visualize netCDF files.

The WPS directory contains the WRF pre-processor source code and the executable resulting from compilation: `geogrid.exe`, `ungrib.exe` and `metgrid.exe`. The WRF directory is where the WRF source code resides and after compilation it contains the four executables: `real.exe`, `ndown.exe`, `wrf.exe` and `tc.exe` under test/em\_real.


## WRF

- WRF 4.6.1 </br>
``v4.6.1.tar.gz`` </br>
[https://github.com/wrf-model/WRF/releases](https://github.com/wrf-model/WRF/releases)

WRF is compiled by the script with the ``(dmpar) GNU (gfortran/gcc)`` option. It means that it is compiled for an architecture supporting Dynamic Memory Parallelism using a GNU/Linux operating system. This is implemented usually by the MPI standard on multi-core CPUs. It is option number 34 from the list shown below. This list is obtained by running WRF's internal configure script manually (list is given below).
```
  1. (serial)   2. (smpar)   3. (dmpar)   4. (dm+sm)   PGI (pgf90/gcc)
  5. (serial)   6. (smpar)   7. (dmpar)   8. (dm+sm)   PGI (pgf90/pgcc): SGI MPT
  9. (serial)  10. (smpar)  11. (dmpar)  12. (dm+sm)   PGI (pgf90/gcc): PGI accelerator
 13. (serial)  14. (smpar)  15. (dmpar)  16. (dm+sm)   INTEL (ifort/icc)
                                         17. (dm+sm)   INTEL (ifort/icc): Xeon Phi (MIC architecture)
 18. (serial)  19. (smpar)  20. (dmpar)  21. (dm+sm)   INTEL (ifort/icc): Xeon (SNB with AVX mods)
 22. (serial)  23. (smpar)  24. (dmpar)  25. (dm+sm)   INTEL (ifort/icc): SGI MPT
 26. (serial)  27. (smpar)  28. (dmpar)  29. (dm+sm)   INTEL (ifort/icc): IBM POE
 30. (serial)               31. (dmpar)                PATHSCALE (pathf90/pathcc)
 32. (serial)  33. (smpar)  34. (dmpar)  35. (dm+sm)   GNU (gfortran/gcc)
 36. (serial)  37. (smpar)  38. (dmpar)  39. (dm+sm)   IBM (xlf90_r/cc_r)
 40. (serial)  41. (smpar)  42. (dmpar)  43. (dm+sm)   PGI (ftn/gcc): Cray XC CLE
 44. (serial)  45. (smpar)  46. (dmpar)  47. (dm+sm)   CRAY CCE (ftn $(NOOMP)/cc): Cray XE and XC
 48. (serial)  49. (smpar)  50. (dmpar)  51. (dm+sm)   INTEL (ftn/icc): Cray XC
 52. (serial)  53. (smpar)  54. (dmpar)  55. (dm+sm)   PGI (pgf90/pgcc)
 56. (serial)  57. (smpar)  58. (dmpar)  59. (dm+sm)   PGI (pgf90/gcc): -f90=pgf90
 60. (serial)  61. (smpar)  62. (dmpar)  63. (dm+sm)   PGI (pgf90/pgcc): -f90=pgf90
 64. (serial)  65. (smpar)  66. (dmpar)  67. (dm+sm)   INTEL (ifort/icc): HSW/BDW
 68. (serial)  69. (smpar)  70. (dmpar)  71. (dm+sm)   INTEL (ifort/icc): KNL MIC
 72. (serial)  73. (smpar)  74. (dmpar)  75. (dm+sm)   AMD (flang/clang) :  AMD ZEN1/ ZEN2/ ZEN3 Architectures
 76. (serial)  77. (smpar)  78. (dmpar)  79. (dm+sm)   INTEL (ifx/icx) : oneAPI LLVM
 80. (serial)  81. (smpar)  82. (dmpar)  83. (dm+sm)   FUJITSU (frtpx/fccpx): FX10/FX100 SPARC64 IXfx/Xlfx
```

The install script also sets the nesting option to ``basic``. It is option 1 from the list available:
```
Compile for nesting? (1=basic, 2=preset moves, 3=vortex following) [default 1]
```
The above two options are set in the configuration section, just before compiling WRF.  If you have a different machine or need for other nesting options, please feel free to modify the install script.


## WRF pre-processing system (WPS)

- WPS 4.6.0 </br>
`WPS-4.6.0.tar.gz` </br>
[https://github.com/wrf-model/WPS/releases](https://github.com/wrf-model/WPS/releases)
The source code for WPS is required for a fully functional WRF package. As opposed to the WRF source code, the archive linked to by **Source code (tar.gz)** should be downloaded.

WPS is compiled with the option ``Linux x86_64, gfortran (dmpar)``. It is option 3 of the following list, which is obtained by manually calling the WPS internal configure script. The option is set by the install script in the configuration section of the process of building WPS. Again, if you are on a different platform, modify accordingly.
```
   1.  Linux x86_64, gfortran    (serial)
   2.  Linux x86_64, gfortran    (serial_NO_GRIB2)
   3.  Linux x86_64, gfortran    (dmpar)
   4.  Linux x86_64, gfortran    (dmpar_NO_GRIB2)
   5.  Linux x86_64, PGI compiler   (serial)
   6.  Linux x86_64, PGI compiler   (serial_NO_GRIB2)
   7.  Linux x86_64, PGI compiler   (dmpar)
   8.  Linux x86_64, PGI compiler   (dmpar_NO_GRIB2)
   9.  Linux x86_64, PGI compiler, SGI MPT   (serial)
  10.  Linux x86_64, PGI compiler, SGI MPT   (serial_NO_GRIB2)
  11.  Linux x86_64, PGI compiler, SGI MPT   (dmpar)
  12.  Linux x86_64, PGI compiler, SGI MPT   (dmpar_NO_GRIB2)
  13.  Linux x86_64, IA64 and Opteron    (serial)
  14.  Linux x86_64, IA64 and Opteron    (serial_NO_GRIB2)
  15.  Linux x86_64, IA64 and Opteron    (dmpar)
  16.  Linux x86_64, IA64 and Opteron    (dmpar_NO_GRIB2)
  17.  Linux x86_64, Intel compiler    (serial)
  18.  Linux x86_64, Intel compiler    (serial_NO_GRIB2)
  19.  Linux x86_64, Intel compiler    (dmpar)
  20.  Linux x86_64, Intel compiler    (dmpar_NO_GRIB2)
  21.  Linux x86_64, Intel compiler, SGI MPT    (serial)
  22.  Linux x86_64, Intel compiler, SGI MPT    (serial_NO_GRIB2)
  23.  Linux x86_64, Intel compiler, SGI MPT    (dmpar)
  24.  Linux x86_64, Intel compiler, SGI MPT    (dmpar_NO_GRIB2)
  25.  Linux x86_64, Intel compiler, IBM POE    (serial)
  26.  Linux x86_64, Intel compiler, IBM POE    (serial_NO_GRIB2)
  27.  Linux x86_64, Intel compiler, IBM POE    (dmpar)
  28.  Linux x86_64, Intel compiler, IBM POE    (dmpar_NO_GRIB2)
  29.  Linux x86_64 g95 compiler     (serial)
  30.  Linux x86_64 g95 compiler     (serial_NO_GRIB2)
  31.  Linux x86_64 g95 compiler     (dmpar)
  32.  Linux x86_64 g95 compiler     (dmpar_NO_GRIB2)
  33.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial)
  34.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial_NO_GRIB2)
  35.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar)
  36.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar_NO_GRIB2)
  37.  Cray XC CLE/Linux x86_64, Intel compiler   (serial)
  38.  Cray XC CLE/Linux x86_64, Intel compiler   (serial_NO_GRIB2)
  39.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar)
  40.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar_NO_GRIB2)
```

## Dependencies and utilities

The versions and the source tar balls that the script expect are listed below. The links to the webpages where they can be obtained are included.

- zlib 1.3.1 </br>
`zlib-1.3.1.tar.gz` </br>
Homepage: [https://zlib.net/](https://zlib.net/) </br>
Source: [https://github.com/madler/zlib](https://github.com/madler/zlib)

- libpng 1.2.59 (libpng12) </br>
`libpng 1.2.59.tar.gz` </br>
Homepage: [http://www.libpng.org/pub/png/libpng.html](http://www.libpng.org/pub/png/libpng.html) </br>
Source: [https://sourceforge.net/projects/libpng/files/](https://sourceforge.net/projects/libpng/files/)

- JasPer 1.900.29 </br>
`jasper-1.900.29.tar.gz` </br>
[https://ece.engr.uvic.ca/~frodo/jasper/](https://ece.engr.uvic.ca/~frodo/jasper/)

- HDF5 1.14.4-2 </br>
`hdf5-1.14.4-2.tar.gz` </br>
Homepage: [https://www.hdfgroup.org/solutions/hdf5/](https://www.hdfgroup.org/solutions/hdf5/) </br>
Source: [https://github.com/HDFGroup/hdf5](https://github.com/HDFGroup/hdf5)

- netCDF 4.7.4 </br>
`netcdf-c-4.7.4.tar.gz` </br>
Homepage: [https://www.unidata.ucar.edu/software/netcdf/](https://www.unidata.ucar.edu/software/netcdf/) </br>
Source: [https://github.com/Unidata/netcdf-c](https://github.com/Unidata/netcdf-c)

- netCDF Fortran 4.5.4 </br>
`netcdf-fortran-4.5.4.tar.gz` </br>
Homepage: [https://www.unidata.ucar.edu/software/netcdf/](https://www.unidata.ucar.edu/software/netcdf/) </br>
Source: [https://github.com/Unidata/netcdf-fortran](https://github.com/Unidata/netcdf-fortran)

- OpenMPI 4.1.6 </br>
`openmpi-4.1.6.tar.bz2` </br>
[https://www.open-mpi.org/software/ompi/v4.1/](https://www.open-mpi.org/software/ompi/v4.1/)

- udunits 2.2.28 </br>
`udunits-2.2.28.tar.gz` </br>
[https://www.unidata.ucar.edu/downloads/udunits/](https://www.unidata.ucar.edu/downloads/udunits/)

- Ncview 2.1.11 </br>
`ncview-2.1.11.tar.gz` </br>
[https://cirrus.ucsd.edu/ncview/](https://cirrus.ucsd.edu/ncview/)


## Running WPS and WRF after install

After install, open a new terminal, source the environment script and you are good to go:
```
$ source ${HOME}/wrfv4/env.sh
```
The above command must be run every time you need to run WRF/WPS in a new terminal. The `env.sh` script sets up the proper environment variables (e.g. `PATH`, `JASPERLIB`, `NETCDF`, ...) required for the good functioning of WRF.


#### WRF 4.4 with OpenMPI

On the WRF & MPAS forum, MPICH was originally used for the WRF installations based on their experience. However, we had issues on th MPICH on Slackware 15.0. First, the latter was not compiling unless the ``-fallow-argument-mismatch`` option was added to ``FFLAGS``. Then, although both WRF and WPS compiled successfully, geogrid.exe was encountering segmentation faults at runtime.

Therefore, we decided to adopt OpenMPI, with which WRF and WPS work just fine. Moreover, OpenMPI gives the opportunity to explicitly specify using threads instead of cores when executing a program. For example, when using Intel processors there are hyperthreads available which can be used to launch jobs, analogous to having distinct physical cores. The functionality is used as follows:
```
mpirun --use-hwthread-cpus -np [NUM] wrf.exe
```


## Ncview

Ncview is a utility for browsing netCDF files. It is a very useful tool to visualise the data. If the data involves a time series, a "movie" of the data can be generated quickly. Our script includes ncview in a `utils` directory under `wrfv4`. It can be run on the command line by just calling `ncview` (provided the environment has been set properly by `env.sh` as described above).


## NCAR Graphics & NCL

NCAR Graphics is a library containing Fortran/C applications and utilities used in displaying, editing and manipulating graphical output for scientific visualization. The NCAR Command Language (NCL) is an interpreted language (written in scripts) designed specifically for this purpose. The WPS/util directory contains NCL scripts, which are very useful to visualize the gridded domains for example.

When installing WRF in Slackware 14.2, we provided NCAR graphics and NCL as a utility alongside. The NCL scripts are very useful to visualize setup parameters and data, thus helping to properly tune simulations. We were previously using the pre-compiled binaries for NCAR graphics. However, these binaries do not work in the new Slackware as they were compiled with earlier versions of libgfortran, while Slackware 15.0 comes with libgfortran.so.5. Therefore, we now recommend installing NCL as part of a Python environment such as conda ([https://docs.conda.io](https://docs.conda.io)).

If you already have a conda installed, you can jump to step 2. Otherwise, we explain how to install a minimal conda environment below.

#### Step 1: install Miniconda

- Go to [https://docs.conda.io/en/latest/miniconda.html](https://docs.conda.io/en/latest/miniconda.html) and browse down to **Linux installers**.

- Get the **Miniconda3 Linux 64-bit** script with **Python 3.9**.

- Be sure to check the integrity of the downloaded script using the SHA256 hash:
```
$ sha256sum Miniconda3-py39_${VERSION}-Linux-x86_64.sh
```

- Run the script:
```
$ chmod +x Miniconda3-py39_${VERSION}-Linux-x86_64.sh
$ ./Miniconda3-py39_${VERSION}-Linux-x86_64.sh
```

The latter prompts you at each step of the installation. You need to say "yes" to accept the *license terms* and when it asks to *initialize Miniconda3*. For the installation path you can just press ENTER and Miniconda will be placed under your home directory, e.g. `/home/USERNAME/miniconda3`.

**NOTE:** after installation, any new terminal which is opened will have conda activated automatically; it will change the prompt visually (usually `(base)` is added at the beginning). Automatic activation on launch is not desirable in a Slackware Linux environment (in my humble opinion) as it will override the system Python. So, we need to disable automatic activation with the following:
```
$ conda config --set auto_activate_base false
```
The above will create a .condarc script in your home directory to initialize the ``auto_activate_base`` variable with a ``false`` value. The .bashrc script in your home directory will already contain the appropriate paths to activate and run conda at any time. So, each time the conda environment is required, execute the following:
```
$ conda activate
```

#### Step 2: install NCL

NCL is installed in conda as follows:
```
$ conda create -n ncl_stable -c conda-forge ncl
```
Then, every time a user is to employ NCL, it is recommended to open a new terminal and do the following:
```
$ conda activate
(base) $ source activate ncl_stable
(ncl_stable) $
```
Then, for example, to plot the domains set up in WPS, browse to wrfv4/WPS, and execute the following:
```
(ncl_stable) $ ncl util/plotgrids_new.ncl
```

