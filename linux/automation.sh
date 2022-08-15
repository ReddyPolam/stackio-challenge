#!/usr/bin/env bash


VERSION=$(echo $RANDOM | md5sum | head -c 5; echo;)
docker build --rm --no-cache ../dockerize/. -t sirireddy/gowebserver:$VERSION  

LATEST=$IMAGE:`docker images | grep $IMAGE | awk '{print $2}'`
cp script.yaml new-app.yaml 
sed -i "s,MY_NEW_IMAGE,sirireddy/gowebserver:$VERSION," new-app.yaml
minikube start
eval $(minikube docker-env)
minikube kubectl create namespace gowebserver
minikube kubectl -- apply -f new-app.yaml -n gowebserver
