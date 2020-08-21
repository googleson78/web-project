FROM haskell:8.8.3

# last ones are required by persistent-mysql
RUN apt-get update && apt-get install -y racket ssh nginx php-fpm mariadb-server libpcre3-dev libmariadbclient-dev php-mysqli

# install required racket testing libraries
RUN raco pkg install --auto quickcheck

# allow people to log in as root
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "root:asdf" | chpasswd


RUN service mysql start && echo "create database db; CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'asdf'; GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost'; FLUSH PRIVILEGES;" | mysql

COPY service/service-exe /var/www/assessment-service
COPY php/*.php /var/www/html/
COPY styles/*.css /var/www/html/styles/
COPY nginx/default /etc/nginx/sites-enabled/default

WORKDIR /var/www/

ENTRYPOINT service ssh start && service nginx start && service php7.3-fpm start && service mysql start && /var/www/assessment-service
