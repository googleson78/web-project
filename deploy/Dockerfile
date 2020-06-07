FROM haskell:8.8.3

RUN apt-get update
RUN apt-get install -y nginx mariadb-server libpcre3-dev libmariadbclient-dev
# required by persistent-mysql
RUN service mysql start && echo 'create database db' | mysql

COPY assessment-service /var/www/assessment-service

EXPOSE 3000

WORKDIR /var/www/

ENTRYPOINT service mysql start && /var/www/assessment-service
