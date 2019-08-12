"""This script will logon to a switch and copy the running configuraion file to a tftp server"""

import json
import logging
import logging.handlers
import tarfile
from datetime import datetime
import pexpect


class ConnectionDenied(Exception):
    """Error indicating that permission was denied when trying to ssh"""


class ConnectionFailed(Exception):
    """Error indicating that a connection could not be established due to
    connectivity/network issues"""


def setup_logging(name, logfile):
    """Setup logger with some custom formatting"""
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                  datefmt='%Y-%m-%d %H:%M:%S')
    new_logger = logging.getLogger(name)
    new_logger.setLevel(logging.DEBUG)
    handler = logging.handlers.RotatingFileHandler(
        logfile, mode="a", maxBytes=5 * 2**20)
    handler.setFormatter(formatter)
    new_logger.addHandler(handler)
    return new_logger


def login(hostname, username, password):
    """Login to the switch and return the console with the prompt at `#`"""
    try_again = True
    alternatives = [r'[\r\n]+.+#',
                    "Permission denied",
                    "[Pp]assword: *",
                    ">",
                    "(ibmnos-cli/iscli):*",
                    "Connection reset by peer\r\r\n"]

    console = pexpect.spawn("ssh {}@{}".format(username, hostname))
    outcome = console.expect(alternatives, timeout=60)
    while outcome:

        if outcome == 1:
            console.close()
            raise ConnectionDenied("Permission denied")

        elif outcome == 2:
            console.sendline(password)

        elif outcome == 3:
            console.sendline("enable")

        elif outcome == 4:
            console.sendline("iscli")
            console.sendline()

        elif outcome == 5 and try_again:
            console = pexpect.spawn("ssh {}@{}".format(username, hostname))
            try_again = False

        elif outcome == 5 and not try_again:
            console.close()
            raise ConnectionFailed("connectivity/network issue")

        outcome = console.expect(alternatives, timeout=60)

    return console


def run_commands(console, commands):
    """Run commands on a switch using console"""
    for command in commands:
        console.sendline(command)
        console.expect("#", timeout=400)


def logout(console):
    """Logout of the switch"""
    console.sendline('exit')
    alternatives = [pexpect.EOF, '>']
    if console.expect(alternatives, timeout=60):
        console.sendline('exit')
    console.close()


def backup_cumulus(hostname, username, password, filename):
    """This method is for the cumulus switch because it's weird in the way
    it works"""
    files = """'/etc/network/interfaces /etc/cumulus/ports.conf /etc/frr/daemons /etc/frr/frr.conf' /tmp/"""
    console = pexpect.spawn("scp {}@{}:{}".format(username, hostname, files))
    console.expect("[Pp]assword:*")
    console.sendline(password)

    archive_name = "/var/lib/tftpboot/" + filename + ".gz"

    archive = tarfile.open(archive_name, "w:gz")
    archive.add("/tmp/interfaces")
    archive.add("/tmp/ports.conf")
    archive.add("/tmp/daemons")
    archive.add("/tmp/frr.conf")
    archive.close()


def main():
    """Main man"""

    tftp_server = CONFIG["tftp_server"]

    commands = {
        "vdx6740": "copy running-config tftp://@{}/{}",
        "nexus6000": "copy running-config tftp://{}/{} vrf management",
        "icx6610": "copy running-config tftp {} {}",
        "ibm_rack": "copy running-config tftp address {} filename {}",
    }

    for switch in CONFIG["switches"]:
        hostname = switch["hostname"]
        username = switch["username"]
        password = switch["password"]
        switch_type = switch["switch_type"]

        filename = "config" + \
            "_{}_{}".format(hostname, datetime.now().strftime("%a"))

        try:

            if switch_type == "cumulus":
                backup_cumulus(hostname, username, password, filename)

            elif switch_type == "mellanox":
                console = login(hostname, username, password)
                mlx_commands = ["config terminal",
                                "configuration text file rconfig delete",
                                "configuration text generate active running save rconfig",
                                "configuration text file rconfig upload tftp://{}/{}".format(
                                    tftp_server, filename),
                                "exit"]
                run_commands(console, mlx_commands)
                logout(console)

            else:
                console = login(hostname, username, password)
                command = commands[switch_type].format(tftp_server, filename)
                run_commands(console, [command])
                logout(console)
        except pexpect.exceptions.TIMEOUT as error:
            logger.error("\nHost %s timed out", hostname)
            logger.exception(error)
        except pexpect.exceptions.EOF as error:
            logger.error("\nFailed to connect to %s", hostname)
            logger.exception(error)
        except ConnectionDenied:
            logger.error("Permission denied for %s", hostname)
        except ConnectionFailed:
            logger.error("Connection reset by: %s", hostname)


if __name__ == "__main__":
    with open('config.json') as config_file:
        CONFIG = json.load(config_file)

    LOG_FILE = "/var/log/switch_backups.log"
    logger = setup_logging(__name__, LOG_FILE)
    main()
