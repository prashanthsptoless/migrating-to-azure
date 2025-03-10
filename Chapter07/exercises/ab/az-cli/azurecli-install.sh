#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
#---------------------------------------------------------------------------------------------

#
# Bash script to install the Azure CLI
#
INSTALL_SCRIPT_URL="https://azurecliprod.blob.core.windows.net/install.py"
INSTALL_SCRIPT_SHA256=7419f49b066015d863f398198c4ac5ad026f5aa3705e898b552e4e03fc352552
_TTY=/dev/tty

install_script=$(mktemp -t azure_cli_install_tmp_XXXXXX) || exit
#echo "Downloading Azure CLI install script from $INSTALL_SCRIPT_URL to $install_script."
curl -# $INSTALL_SCRIPT_URL > $install_script || exit
if command -v sha256sum >/dev/null 2>&1
then
  echo "$INSTALL_SCRIPT_SHA256  $install_script" | sha256sum -c - || exit
elif command -v shasum >/dev/null 2>&1
then
  echo "$INSTALL_SCRIPT_SHA256  $install_script" | shasum -a 256 -c - || exit
fi
if ! command -v python >/dev/null 2>&1
then
  echo "ERROR: Python not found. 'command -v python' returned failure."
  echo "If python is available on the system, add it to PATH. For example 'sudo ln -s /usr/bin/python3 /usr/bin/python'"
  exit 1
fi
chmod 775 $install_script
echo "Running install script."
$install_script < $_TTY
