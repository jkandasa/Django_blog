#!/bin/sh

# create network for this setup
docker network create --driver bridge mysite-nw

# create volume for mysql
docker volume create mysql-data


# run mysql container
docker run \
    --name mysql \
    --detach \
    --network mysite-nw \
    --volume mysql-data:/var/lib/mysql \
    --user 1001:1001 \
    --env MYSQL_DATABASE=mysite \
    --env MYSQL_USER=admin \
    --env MYSQL_PASSWORD=admin \
    --env MYSQL_ROOT_PASSWORD=admin \
    --restart unless-stopped \
    mysql:5.6

# run backend server
docker run \
    --name backend \
    --detach \
    --network mysite-nw \
    --env MYSQL_DATABASE="mysite" \
    --env MYSQL_USER="admin" \
    --env MYSQL_PASSWORD="admin" \
    --env MYSQL_HOST="mysql" \
    --env MYSQL_PORT="3306" \
    --env CREATE_ADMIN="true" \
    --env ADMIN_USER="admin" \
    --env ADMIN_PASSWORD="admin" \
    --restart unless-stopped \
    quay.io/jkandasa/django-blog-backend:master

# run frontend server
docker run \
    --name frontend \
    --detach \
    --network mysite-nw \
    --env BACKEND_URL="http://backend:8000" \
    --publish 8080:8080 \
    --restart unless-stopped \
    quay.io/jkandasa/django-blog-frontend:master
