FROM python:3.6-alpine as builder
# set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apk add --no-cache \
    mariadb-dev \
    gcc \
    python3-dev \
    musl-dev

COPY . /app
WORKDIR /app
RUN python3 -m venv .env && \
    source .env/bin/activate && \
    pip install -r requirements.txt && \
    python manage.py collectstatic 


# final container image
FROM nginx:1.21-alpine

# set environment variables
ENV BACKEND_URL="http://localhost:8000"

COPY --from=builder /app/staticfiles /var/www/static

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template

## to support running as an arbitrary user, directories and files
RUN touch /var/run/nginx.pid && \
    chgrp -R 0 \
        /var/www/static \
        /var/cache/nginx \
        /var/log/nginx \
        /etc/nginx/conf.d \
        /var/run/nginx.pid && \
    chmod -R g=u \
        /var/www/static \
        /var/cache/nginx \
        /var/log/nginx \
        /etc/nginx/conf.d \
        /var/run/nginx.pid

EXPOSE 8080

USER 1001

CMD ["nginx", "-g", "daemon off;"]
