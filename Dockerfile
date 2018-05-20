FROM centos:7

RUN yum -y install httpd && yum clean all
ADD . /var/www/html/
EXPOSE 80/tcp

CMD ["-D","FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
