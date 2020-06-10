FROM haskell:8.8.3

RUN apt-get update
RUN apt-get install -y nginx php-fpm mariadb-server libpcre3-dev libmariadbclient-dev
# last ones are required by persistent-mysql
RUN service mysql start && echo 'create database db' | mysql

COPY service/service-exe /var/www/assessment-service
COPY php/*.php /var/www/html/
COPY nginx/default /etc/nginx/sites-enabled/default

WORKDIR /var/www/

ENTRYPOINT service nginx start && service php7.3-fpm start && service mysql start && /var/www/assessment-service
