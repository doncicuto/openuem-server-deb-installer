#!/bin/bash

cwd=`pwd`
version="0.1.0"

# Create directory
mkdir -p ./openuem-server-$version-amd64/opt/openuem-server/bin/nats

# Cert-Manager
cd $HOME/OpenUEMProject/openuem-cert-manager && go build -o openuem-cert-manager
cd $cwd
cp $HOME/OpenUEMProject/openuem-cert-manager/openuem-cert-manager ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-cert-manager

# OCSP Responder
cd $HOME/OpenUEMProject/openuem-ocsp-responder/internal/service/linux/ && go build -o openuem-ocsp-responder
cd $cwd
cp $HOME/OpenUEMProject/openuem-ocsp-responder/internal/service/linux/openuem-ocsp-responder ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-ocsp-responder

# NATS service
# TODO - Download nats-server, uncompress, copy to /opt/openuem-server/bin/nats
cd $HOME/OpenUEMProject/openuem-nats-service/services/linux/ && go build -o openuem-nats-service
cd $cwd
cp $HOME/OpenUEMProject/openuem-nats-service/services/linux/openuem-nats-service ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-nats-service
cp $HOME/OpenUEMProject/openuem-nats-service/nats.tmpl ./openuem-server-$version-amd64/opt/openuem-server/bin/nats/nats.tmpl

# Console
cd $HOME/OpenUEMProject/openuem-console/internal/service/linux/ && go build -o openuem-console
cd $cwd
cp $HOME/OpenUEMProject/openuem-console/internal/service/linux/openuem-console ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-console
cp -rf $HOME/OpenUEMProject/openuem-console/assets ./openuem-server-$version-amd64/opt/openuem-server/bin/

# Agent Worker
cd $HOME/OpenUEMProject/openuem-worker/internal/service/agent-worker/linux && go build -o openuem-agent-worker
cd $cwd
cp $HOME/OpenUEMProject/openuem-worker/internal/service/agent-worker/linux/openuem-agent-worker ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-agent-worker

# Notification Worker
cd $HOME/OpenUEMProject/openuem-worker/internal/service/notification-worker/linux && go build -o openuem-notification-worker
cd $cwd
cp $HOME/OpenUEMProject/openuem-worker/internal/service/notification-worker/linux/openuem-notification-worker ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-notification-worker

# Cert-Manager Worker
cd $HOME/OpenUEMProject/openuem-worker/internal/service/cert-manager-worker/linux && go build -o openuem-cert-manager-worker
cd $cwd
cp $HOME/OpenUEMProject/openuem-worker/internal/service/cert-manager-worker/linux/openuem-cert-manager-worker ./openuem-server-$version-amd64/opt/openuem-server/bin/openuem-cert-manager-worker

# Generate package
dpkg-deb --build ./openuem-server-0.1.0-amd64