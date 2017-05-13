From tomcat:7.0-jre7
MAINTAINER Danny Ho <hoyc.danny@gmail.com>
RUN $JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA -storepass changeit -keypass changeit -dname "CN=example.com,OU=,O=,L=,S=,C=SE"
RUN sed -i 's/<Service name="Catalina">/<Service name="Catalina">\n\n    <Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"\n        maxThreads="150" SSLEnabled="true" scheme="https" secure="true"\n        clientAuth="false" sslProtocol="TLS" \/>/' conf/server.xml
RUN apt-get update
RUN apt-get install curl wget git vim -y
RUN apt-get install software-properties-common -y
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl wget git vim nginx tomcat7 -y
RUN sed -i '42 i\location /tomcat { \
                proxy_pass https://127.0.0.1:8443/; \
        }' /etc/nginx/sites-available/default
RUN sed -i '121 a\service nginx restart' /usr/local/tomcat/bin/catalina.sh
