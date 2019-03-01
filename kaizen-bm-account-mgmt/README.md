# Kaizen Baremetal access account management

## Preparation:

1. Run these scripts on the bmi host since the scripts require access to both, HIL
and BMI, command lines.

2. Create the useraccount first running these scripts to automatically insert
their HIL Credentials into their .bashrc. Otherwise the HIL Password will be lost.


## What do these scripts do?

`./create-account.sh PROJECT USER` will
* Create a HIL and BMI account.
* create a HIL user.
* Put the generated password in the users home directory.
* Give them access to the bmi provisioning network.

`./insert-key.sh PROJECT IMAGE` will
* Insert the image in the BMI project
* Insert the users SSH key into their copy of the image


