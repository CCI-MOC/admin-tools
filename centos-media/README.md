This directory contains scripts for generating custom CentOS
installation media, the main use of which is to supply a custom
kickstart configuration file.

To build a custom iso, simply type:

    sudo make

The resulting image will behave identically to the standard CentOS
minimal iso, but will contain our ks.cfg. A kickstart install can be
started by hitting escape at the bootloader menu, and typing:

    linux ks=cdrom:/ks.cfg

Note that the ks.cfg in this directory isn't terribly useful; it just
complains about missing parameters and stops. Putting something useful
here is still on the todo list.
