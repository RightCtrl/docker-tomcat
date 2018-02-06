FROM rightctrl/tomcat:8
MAINTAINER RightCtrl <support@RightCtrl.com>

RUN rpm -Uvh https://rpm.nodesource.com/pub_4.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
RUN yum install -y nodejs
RUN npm install -g grunt-cli
RUN npm install -g grunt

COPY node-webshot-master /node-webshot-master

#EXPOSE 8080 8443


#CMD ["/run.sh"]