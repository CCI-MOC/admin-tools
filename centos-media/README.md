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
the directory specified by COPY_FILES will be present as /copy-files on
the cdrom.

Both the KS and COPY_FILES parameters must be provided.
