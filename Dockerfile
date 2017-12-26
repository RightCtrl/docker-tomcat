FROM rightctrl/centos
MAINTAINER RightCtrl <AI@RightCtrl.com>

# Install prepare infrastructure
RUN yum -y update && \
        yum -y install wget && \
        yum -y install tar
RUN yum -y install gcc gcc-c++ make flex bison gperf ruby \
openssl-devel freetype-devel fontconfig-devel libicu-devel sqlite-devel \
libpng-devel libjpeg-devel
RUN rpm -Uvh https://rpm.nodesource.com/pub_4.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
RUN yum install -y nodejs
RUN yum -y update
RUN npm install -g grunt-cli
RUN npm install -g grunt
#added fonts
RUN yum -y install google-*fonts
RUN yum -y -q reinstall glibc-common && locale -a
# Prepare environment
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java8
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz

RUN tar xzf jdk-8u151-linux-x64.tar.gz
RUN rm jdk*.tar.gz
RUN mv jdk* ${JAVA_HOME}

#COPY jdk1.8.0_144/* ${JAVA_HOME}/
#RUN cd /root && \
#    tar xzf jdk-8u144-linux-x64.tar.gz && \
#    rm jdk*.tar.gz && \
#    mv jdk* ${JAVA_HOME}


# Install Tomcat
#RUN wget http://192.168.11.109/sw/apache/tomcat/apache-tomcat-8.0.36.tar.gz && \
#RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz && \
RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.38/bin/apache-tomcat-8.0.38.tar.gz && \
        tar -xvf apache-tomcat-8.0.38.tar.gz && \
        rm apache-tomcat*.tar.gz && \
        mv apache-tomcat* ${CATALINA_HOME}
COPY server.xml ${CATALINA_HOME}/conf/server.xml
RUN chmod +x ${CATALINA_HOME}/bin/*sh
RUN rm -rf ${CATALINA_HOME}/webapps/*

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf "\n\
java.util.logging.FileHandler.level = FINE \n\
java.util.logging.FileHandler.formatter = java.util.logging.SimpleFormatter \n\
java.util.logging.FileHandler.pattern = ${CATALINA_HOME}/logs/catalina.%g.log \n\
java.util.logging.FileHandler.limit = 10000 \n\
java.util.logging.FileHandler.count = 15 \n\
\n" \
 >> ${CATALINA_HOME}/conf/logging.properties

RUN sed -i \
        -e 's/^handlers = .*/handlers = java.util.logging.FileHandler, 1catalina.org.apache.juli.AsyncFileHandler, 2localhost.org.apache.juli.AsyncFileHandler, 3manager.org.apache.juli.AsyncFileHandler, 4host-manager.org.apache.juli.AsyncFileHandler, java.util.logging.ConsoleHandler/1' \
        ${CATALINA_HOME}/conf/logging.properties


COPY node-webshot-master /node-webshot-master
COPY resolv.conf /resolv.conf
RUN printf "cp -rf /resolv.conf /etc/resolv.conf" >> /etc/rc.local
RUN chmod +x /etc/rc.local


CMD ["/etc/rc.local"]
EXPOSE 8080
CMD ["catalina.sh", "run"]

