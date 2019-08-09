"""This script will logon to a switch and copy the running configuraion file to a tftp server"""

import json
import logging
import logging.handlers
import tarfile
import os
from datetime import datetime
import pexpect


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


def run_command(hostname, username, password, command):
    """Run command on a switch"""

    # 1. Begin login process
    console = pexpect.spawn("ssh {}@{}".format(username, hostname))
    alternatives = ["Permission denied",
                    "Connection reset by peer\r\r\n", "[Pp]assword:*"]
    outcome = console.expect(alternatives)
    if outcome == 0:
        logger.error("Permission denied for %s", hostname)
        console.close()
        return
    elif outcome == 1:
        logger.error("Connection reset by: %s", hostname)
        logger.error("console.before: %s", console.before)
        logger.error("console.after: %s", console.after)
        console.close()
        return
    elif outcome == 2:
        console.sendline(password)

    alternatives = [">", "(ibmnos-cli/iscli):*", "#"]
    outcome = console.expect(alternatives)

    if outcome == 0:
        console.sendline("enable")
        console.expect("#")

    if outcome == 1:
        console.sendline("iscli")
        console.sendline()
        console.sendline("enable")
        console.expect("#")

    # 2. Successful login. Attempt to run the command now
    console.sendline(command)
    console.expect("#", timeout=400)

    # 3. Logout process begins.
    console.sendline('exit')
    alternatives = [pexpect.EOF, '>']
    if console.expect(alternatives):
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
            else:
                command = commands[switch_type].format(tftp_server, filename)
                run_command(hostname, username, password, command)
        except pexpect.exceptions.TIMEOUT as error:
            logger.error("\nHost %s timed out", hostname)
            logger.exception(error)
        except pexpect.exceptions.EOF as error:
            logger.error("\nFailed to connect to %s", hostname)
            logger.exception(error)


if __name__ == "__main__":
    with open('config.json') as config_file:
        CONFIG = json.load(config_file)

    LOG_FILE = "/var/log/switch_backups.log"
    logger = setup_logging(__name__, LOG_FILE)
    main()
