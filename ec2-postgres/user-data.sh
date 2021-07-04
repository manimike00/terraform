#!/usr/bin/bash

apt update
apt install -y postgresql postgresql-contrib
mkdir /home/demo
useradd -m -s /usr/bin/bash -d /home/demo demo
su - postgres -c "createuser -s -i -d -r -l -w demo"
su - postgres -c "createdb demo"