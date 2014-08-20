# Copyright 2014 Massachusetts Open Cloud Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the
# License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an "AS
# IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied.  See the License for the specific language
# governing permissions and limitations under the License.
#
# ---
#
# Builds a custom CentOS 7.0 ISO. see ../README.md and the comments in
# ../Makefile.common for more info.

ISO_IN := CentOS-7.0-1406-x86_64-Minimal.iso
ISO_OUT := centos-7.0-1406-custom.iso
# The value of the iso's label is important for CentOS 7; the system will use it
# to try to find the root filesystem. As such, the value must be the same as for
# the original media:
ISO_LABEL := 'CentOS 7 x86_64'
MIRROR := http://mirror.us.leaseweb.net/centos/7.0.1406/isos/x86_64

include ../Makefile.common
