# OpenUEM - Server Debian/Ubuntu Installer

Repository containing the OpenUEM Server installer for Debian/Ubunu systems

## How to create the .deb package

./create-installer.sh

## How to debug scripts

use `set -x` at the beginning of the scripts

### TODO

- Allow user to go back to previous step
- Sandboxing all OpenUEM services (sudo systemd-analyze security openuem-console.service --no-pager to check current OK status)
