#!/bin/bash

cwd=`pwd`
version="0.1.0"

# Create directory
mkdir -p ./openuem-server_${version}_amd64/opt/openuem-server/bin/nats

# Copy templates
cp -rf ./templates/DEBIAN ./openuem-server_${version}_amd64/
cp -rf ./templates/etc ./openuem-server_${version}_amd64/

# Replace version
sed -i "s/OPENUEM_VERSION/${version}/g" ./openuem-server_${version}_amd64/DEBIAN/postinst
sed -i "s/OPENUEM_VERSION/${version}/g" ./openuem-server_${version}_amd64/DEBIAN/control

# Cert-Manager
cd $HOME/OpenUEMProject/openuem-cert-manager && git pull && git submodule update --remote && go build -o openuem-cert-manager
cd $cwd
cp $HOME/OpenUEMProject/openuem-cert-manager/openuem-cert-manager ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-cert-manager

# OCSP Responder
cd $HOME/OpenUEMProject/openuem-ocsp-responder && git pull && git submodule update --remote 
cd $HOME/OpenUEMProject/openuem-ocsp-responder/internal/service/linux/ && go build -o openuem-ocsp-responder
cd $cwd
cp $HOME/OpenUEMProject/openuem-ocsp-responder/internal/service/linux/openuem-ocsp-responder ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-ocsp-responder

# NATS service
cd $HOME/OpenUEMProject/openuem-nats-service && git pull && git submodule update --remote
cd $HOME/OpenUEMProject/openuem-nats-service/internal/service/linux/ && go build -o openuem-nats-service
cd $cwd
cp $HOME/OpenUEMProject/openuem-nats-service/nats.tmpl ./openuem-server_${version}_amd64/opt/openuem-server/bin/nats/nats.tmpl
cp $HOME/OpenUEMProject/openuem-nats-service/internal/service/linux/openuem-nats-service ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-nats-service

# Console
cd $HOME/OpenUEMProject/openuem-console/ && git pull && git submodule update --remote
cd $HOME/OpenUEMProject/openuem-console/internal/service/linux/ && go build -o openuem-console
cd $cwd
cp $HOME/OpenUEMProject/openuem-console/internal/service/linux/openuem-console ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-console
cp -rf $HOME/OpenUEMProject/openuem-console/assets ./openuem-server_${version}_amd64/opt/openuem-server/bin/

# Agent Worker
cd $HOME/OpenUEMProject/openuem-worker && git pull && git submodule update --remote 
cd $HOME/OpenUEMProject/openuem-worker/internal/service/agent-worker/linux && go build -o openuem-agent-worker
cd $cwd
cp $HOME/OpenUEMProject/openuem-worker/internal/service/agent-worker/linux/openuem-agent-worker ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-agent-worker

# Notification Worker
cd $HOME/OpenUEMProject/openuem-worker/internal/service/notification-worker/linux && go build -o openuem-notification-worker
cd $cwd
cp $HOME/OpenUEMProject/openuem-worker/internal/service/notification-worker/linux/openuem-notification-worker ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-notification-worker

# Cert-Manager Worker
cd $HOME/OpenUEMProject/openuem-worker/internal/service/cert-manager-worker/linux && go build -o openuem-cert-manager-worker
cd $cwd
cp $HOME/OpenUEMProject/openuem-worker/internal/service/cert-manager-worker/linux/openuem-cert-manager-worker ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-cert-manager-worker

# Server Updater
cd $HOME/OpenUEMProject/openuem-server-updater/ && git pull && git submodule update --remote
cd $HOME/OpenUEMProject/openuem-server-updater/internal/service/linux/ && go build -o openuem-server-updater
cd $cwd
cp $HOME/OpenUEMProject/openuem-server-updater/internal/service/linux/openuem-server-updater ./openuem-server_${version}_amd64/opt/openuem-server/bin/openuem-server-updater

# Generate package
dpkg-deb --build "./openuem-server_${version}_amd64"

# Copy file to apt
cp "./openuem-server_${version}_amd64.deb" "$HOME/OpenUEMProject/openuem-apt-repo/pool/main/"

# Scan Packages
cd "$HOME/OpenUEMProject/openuem-apt-repo"
dpkg-scanpackages -m --arch amd64 pool/ > dists/stable/main/binary-amd64/Packages
cat dists/stable/main/binary-amd64/Packages | gzip -9 > dists/stable/main/binary-amd64/Packages.gz

# Generate Release
cd "$HOME/OpenUEMProject/openuem-apt-repo/dists/stable"
$HOME/OpenUEMProject/openuem-server-deb-installer/generate-release.sh > Release

# Sign Release and create InRelease
cat Release | gpg --default-key openuem -abs > ./Release.gpg
cat Release | gpg --default-key openuem -abs --clearsign > ./InRelease
