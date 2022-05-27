FROM mysql:5.6

ENV MYSQL_DATABASE wordpress
ENV MYSQL_ROOT_PASSWORD student
COPY wordpress.sql /docker-entrypoint-initdb.d/wordpress.sql

EXPOSE 3306
