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
# Builds a custom CentOS 6.5 ISO. see ../README.md and the comments in
# ../Makefile.common for more info.

ISO_IN := CentOS-6.6-x86_64-minimal.iso
ISO_OUT := centos-6.6-custom.iso
# CentOS 6 doesn't actually care about the disk label, but CentOS 7 does, so we
# include the option here as well:
ISO_LABEL := 'CentOS 6 x86_64'
MIRROR := http://mirror.us.leaseweb.net/centos/6.6/isos/x86_64

include ../Makefile.common
