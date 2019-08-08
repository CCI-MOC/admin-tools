"""This script will logon to a switch and copy the running configuraion file to a tftp server"""

import json
import pexpect
import logging
import logging.handlers
from datetime import datetime


def setup_logging(name, log_file):
    """Setup logger with some custom formatting"""
    formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                  datefmt='%Y-%m-%d %H:%M:%S')
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    handler = logging.handlers.RotatingFileHandler(
        log_file, mode="a", maxBytes=5 * 2**20)
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    return logger


def backup_config(hostname, username, password, switch_type):
    """Run the copy config command on a switch"""
    console = pexpect.spawn("ssh {}@{}".format(username, hostname))
    alternatives = ["Permission denied",
                    "Connection reset by peer\r\r\n", "[Pp]assword:*"]
    outcome = console.expect(alternatives)
    if outcome == 0:
        logger.error("Permission denied for " + hostname)
        console.kill()
        return
    elif outcome == 1:
        logger.error("Connection reset by: {}".format(hostname))
        logger.error("console.before: " + console.before)
        logger.error("console.after:" + console.after)
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

    command = commands[switch_type] + \
        "_{}_{}".format(hostname, datetime.now().strftime("%a"))

    console.sendline(command)
    console.expect("#", timeout=400)

    console.sendline('exit')
    alternatives = [pexpect.EOF, '>']
    if console.expect(alternatives):
        console.sendline('exit')
    console.close()


def main():
    """Main main"""
    for switch in config["switches"]:
        try:
            backup_config(switch["hostname"], switch["username"],
                          switch["password"], switch["switch_type"])
        except pexpect.exceptions.TIMEOUT as e:
            logger.error("\nHost {} timedout".format(switch["hostname"]))
            logger.exception(e)
        except pexpect.exceptions.EOF as e:
            logger.error("\nFailed to connect to {}".format(
                switch["hostname"]))
            logger.exception(e)


if __name__ == "__main__":
    with open('config.json') as config_file:
        config = json.load(config_file)

    tftp_server = config["tftp_server"]

    commands = {
        "vdx6740": "copy running-config tftp://@{}/config".format(tftp_server),
        "nexus6000": "copy running-config tftp://{}/config".format(tftp_server),
        "icx6610": "copy running-config tftp {} config".format(tftp_server),
        "ibm_rack": "copy running-config tftp address {} filename config".format(tftp_server)
    }

    log_file = "/var/log/switch_backups.log"
    logger = setup_logging(__name__, log_file)
    main()
