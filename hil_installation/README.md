# HIL Installation Script

This installs and configures the following:

* HIL
* Postgres Server
* Apache

There's also an additional script to configure postgres, create a HIL admin user and set your environment
variables to talk to HIL.

Note: This only works on centos/RHEL.

The script **does not** install OBMd. You can download the OBMd binary from github and run it.

The config file it uses sets the database password to `hil`, so don't forget to change that.

