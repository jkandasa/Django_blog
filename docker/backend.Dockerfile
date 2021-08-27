FROM python:3.6-alpine as builder
# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache mariadb-dev \
    && apk add --virtual build-deps gcc python3-dev musl-dev

COPY . /app
WORKDIR /app
RUN python3 -m venv .env \
    && source .env/bin/activate \
    && pip install -r requirements.txt


# final container image
FROM python:3.6-alpine

# set environment variables
ENV MYSQL_DATABASE="mysite" \
    MYSQL_USER="admin" \
    MYSQL_PASSWORD="admin" \
    MYSQL_HOST="mysql" \
    MYSQL_PORT="3306" \
    CREATE_ADMIN="true" \
    ADMIN_USER="admin" \
    ADMIN_PASSWORD="admin" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache mariadb-connector-c-dev

EXPOSE 8000

COPY --from=builder /app /app

RUN chmod +x /app/entrypoint.sh

## to support running as an arbitrary user, directories and files
RUN chgrp -R 0 /app && \
    chmod -R g=u /app

USER 1001

WORKDIR /app

CMD [ "/app/entrypoint.sh" ]
