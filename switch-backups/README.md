# Switch backup scripts

This script is used to backup the running configuration on a switch.

The following table contains what type of switches are supported and the software version the script was tested with.
The `switch_type` is the parameter required in the configuration file.

| Switch | Model | Operating System | Versions | switch_type parameter |
|-|-|-|-|-|
| Brocade| VDX 6740 | NOS | 7.0.2 | vdx6740|
| Brocade | ICX6610 | NOS? | 08.0.10dT7f1 | icx6610 |
| Brocade | ICX7450-48 | NOS?  | 08.0.20T211 | icx6610 |
| Cisco | Nexus 5672UP (6000) | (NX-OS) | 7.0(1)N1(1) | nexus6000 |
| IBM | accton,as4610_54cumulus  | Cumulus Linux |  3.4.3 | cumulus |
| IBM | RackSwitch G8000 | IBM NOS | 7.1.16.0 | ibm_rack |
| Mellanox | MSB7800 | MLNX-OS | 3.6.3004 | mellanox |
| Mellanox | eth-single-switch | MLNX-OS | 3.4.1122, 3.4.3002| mellanox |

## What does it exactly do?

The script will login to a switch and run the command to copy the configuration file to a tftp server. It will create configuration file of the format `config_hostname_DayOfWeek` e.g.; `config_10.0.0.1_Mon`. It will start overwriting week old configuration files.

## How to set it up?

1. Setup a tftp server and make sure that your switch can actually upload the file to the server.
2. Place this script along with a json configuration file. A sample is provided in this directoy. The `switch_type` parameter is required and should match with what's provided in the table in the previous section.
3. If using key based login to the switch, then put any string in the password field.
4. Call the script everyday using a cron job.

Login to every switch once manually from the machine where this script will be run from, or add the switches to the known_hosts file or disable that check.

