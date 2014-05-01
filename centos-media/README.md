This directory contains scripts for generating custom CentOS
installation media, the main use of which is to supply a custom
kickstart configuration file.

To build a custom iso, simply type:

    sudo make KS=/path/to/kickstart-file

The resulting image will behave identically to the standard CentOS
minimal iso, except that (1) the bootloader timeout is shorter (3
seconds), and (2) The default boot option is to preform a kickstart
installation with the provided kickstart file.

If the KS parameter is not specified, it defaults to `ks.cfg` (in the
current directory). At present there's a `ks.cfg` provided as part of
this repository, but it isn't actually functional, and probably will be
removed.
