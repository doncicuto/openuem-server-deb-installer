# OpenUEM - Server Debian/Ubuntu Installer

Repository containing the OpenUEM Server installer for Debian/Ubunu systems

## Server Components

The installer will ask to select which components wants to be installed (all of them or a selection):

- OpenUEM Web Console
- OpenUEM NATS
- OpenUEM Agent Worker
- OpenUEM Notification Worker
- OpenUEM Cert-Manager Worker

The installer will ask for the database access information. It will be asked for:

- Host
- Port (default 5432)
- User
- Password
- Database

The installer will offer to generate the required digital certificates. The database is required and must be running.
