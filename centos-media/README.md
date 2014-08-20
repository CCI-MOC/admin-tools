This directory contains scripts for generating custom CentOS
installation media, the main use of which is to supply a custom
kickstart configuration file.

Both CentOS 6.5 and 7.0 are supported. To build a custom iso, cd into
the appropriate directory and type:

    sudo make KS=/path/to/kickstart-file COPY_FILES=/path/to/files

The resulting image will behave identically to the standard CentOS
minimal iso, except that (1) the bootloader timeout is shorter (3
seconds), (2) The default boot option is to preform a kickstart
installation with the provided kickstart file, and (3) the contents of
the directory specified by COPY_FILES will be present in /copy-files on
the cdrom.

If the KS parameter is not specified, it defaults to `ks.cfg` (in the
current directory). At present there's a `ks.cfg` provided as part of
this repository, but it isn't actually functional, and probably will be
removed. COPY_FILES defaults to `copy-files` in the current directory.
