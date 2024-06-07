#!/bin/bash

cd /home/vagrant/infrastructure/tomcat/
docker build . -t bfreitas/tomcat:1.0
docker-compose up -d
