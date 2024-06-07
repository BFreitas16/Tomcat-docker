FROM centos:7 AS base
RUN yum update -y && yum install -y wget unzip

FROM base AS base-tomcat
RUN useradd -U -m -d /opt/tomcat tomcat
RUN mkdir -p /opt/tomcat && chown -R tomcat /opt/tomcat

FROM base-tomcat AS tomcat8-5
RUN yum install -y java-1.8.0-openjdk-devel

RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.100/bin/apache-tomcat-8.5.100.zip -O /tmp/apache-tomcat-8.5.100.zip
RUN unzip /tmp/apache-tomcat-8.5.100.zip -d /opt/tomcat
RUN chmod +x /opt/tomcat/apache-tomcat-8.5.100/bin/*.sh

RUN wget https://tomcat.apache.org/tomcat-8.5-doc/appdev/sample/sample.war -O /opt/tomcat/apache-tomcat-8.5.100/webapps/sample.war

USER tomcat

CMD ["/opt/tomcat/apache-tomcat-8.5.100/bin/catalina.sh", "run"]
