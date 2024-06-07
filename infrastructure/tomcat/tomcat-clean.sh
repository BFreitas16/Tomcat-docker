#!/bin/bash

cd /home/vagrant/infrastructure/tomcat/
docker compose down
docker image rm bfreitas/tomcat:1.0
docker system prune -a -f
