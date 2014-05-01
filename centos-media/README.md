This directory contains scripts for generating custom CentOS
installation media, the main use of which is to supply a custom
kickstart configuration file.

To build a custom iso, simply type:

    sudo make

The resulting image will behave identically to the standard CentOS
minimal iso, except that (1) the bootloader timeout is shorter (3
seconds), and (2) The default boot option is to preform a kickstart
installation with the provided ks.cfg.

Note that the ks.cfg in this directory isn't terribly useful; it just
complains about missing parameters and stops. Putting something useful
here is still on the todo list.
