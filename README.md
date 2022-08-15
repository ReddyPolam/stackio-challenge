# This is a candidate assessment assignment from stack.io

# Guideline

Welcome to our `Take Home Assingment`. We are going to provide you with a sequence of tasks to be executed:
* [Task 1](dockerize): Dockerize a simple golang webserver;
* [Task 2](kubernetes): Deploy that docker image to your local k8s cluster following the given spec
* [Task 3](terraform): Create a terraform module
* [Task 4](linux): Write down a shell script for further automation


FROM golang:1.17-alpine 
ENV GOPATH=/app
ENV PATH=$PATH:$GOPATH
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GO111MODULE=auto go build -o /server ./webserver/articlehandler/*.go

EXPOSE 8080
RUN chmod +x /server
 
CMD ["server"]

