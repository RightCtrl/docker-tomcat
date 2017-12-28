# docker-tomcat8-snapshot
#docker-compose.yml
```
version: '2'
services:
  tomcatSnapshot:
    image: rightctrl/tomcat:snapshot
    ports:
     - "8080:8080"
    mem_limit: 3052m
    cpuset: 0,1
    volumes:
     - ./webapps:/opt/tomcat/webapps
     - ./logs:/opt/tomcat/logs
     - ./aws:/root/.aws
    ulimits:
     nproc: 65535
     core: 0
     nofile:
      soft: 20000
      hard: 40000
    restart: always
    environment:
       CATALINA_OPTS: "$CATALINA_OPTS   -Dfile.encoding=UTF-8 -Djavax.servlet.request.encoding=UTF-8"
```
