#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker

docker pull 801195563235.dkr.ecr.ap-south-1.amazonaws.com/netflix-devops-app:latest

docker run -d -p 80:3000 801195563235.dkr.ecr.ap-south-1.amazonaws.com/netflix-devops-app:latest
