FROM centos:7.8.2003
MAINTAINER nelsonwei

ARG MODULE_URL

RUN yum -y update && \
    yum -y install httpd && \
    yum -y install tree && \
    yum -y install multitail && \
    yum clean all && \
    mv $(curl --insecure --silent ${MODULE_URL} | \
    tar xzvf - --wildcards "*.so" | head -1) /etc/httpd/modules/mod_dispatcher.so && \
    chown root:root /etc/httpd/modules/mod_dispatcher.so
    chown apache:apache /mnt/var/www/html

EXPOSE 80

RUN mkdir -p /mnt/var/www/author && \
    mkdir -p /mnt/var/www/html && \
    mkdir -p /mnt/var/www/default && \
    chown -R apache:apache /mnt/var/www

WORKDIR /etc/httpd
CMD [ "-D", "FOREGROUND" ]
ENTRYPOINT [ "/usr/sbin/httpd" ]