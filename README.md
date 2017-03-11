# Dockerized plantuml server

Dockerized plantuml server to run plantuml in a container. For details how to user plantuml-server see https://github.com/plantuml/plantuml-server

This docker image differs to the one at the source repository since the server distrubimtion and jetty runtime are created at build time instead of execution time. 

## Run

You start the plantuml server as follow:
```
docker run -p 8080:8080 --name plantuml npalm/plantuml-server
```

## Build
You can build and run localally as follow:
```
docker build -t plantuml . && docker run -p 8080:8080 plantuml
```
