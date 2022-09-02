# Weather Research Forecasting (WRF)

We propose installation scripts for WRF ARW (Advanced Research WRF) on the Slackware GNU/Linux 14.2 and 15.0 distributions. The source for WRF can be obtained from the ARW users' page ([https://www2.mmm.ucar.edu/wrf/users/](https://www2.mmm.ucar.edu/wrf/users/)). By default, WRF ARW is compiled in a directory where the user has write access, and the full source code is kept. This is because WRF and its pre-processor, WPS, are usually executed directly from the compiled source code directories.

On Slackware 14.2 we managed to install WRF 3.8.1/WPS 3.8.1 and WRF 4.2.2/WPS 4.2. However, WRF 4.2.2 and earlier versions presented issues when compiled with GCC 11.x on Slackware 15.0. So, the install script for Slackware 15.0 installs WRF 4.4/WPS 4.4.

There are two ways of installing WRF on Slackware:

- The default method, taught by the official WRF ARW website, where the dependencies are installed in a directory alongside the WRF compiled source code, in a custom location.
- The other method is the natural "Slackware way" of installing dependencies using SlackBuilds and compile WRF in a custom directory or make a SlackBuild script for it.

**NOTE:** Our scripts implement the *first* method.

The main system requirement is a 64-bit processor and operating system. All the scripts were tested using 64-bit Slackware 14.2 or 15.0 GNU/Linux installed on the same Intel Core i7-7700K machine. Building and installing all the software on this machine takes less than 15 minutes. Since we have a high-end processor and lots of RAM, a longer build time would be expected on other machines. The final space taken on disk is around 1.1 GB for the WRF software only, and around 30 GB when the geographical static data is included.
