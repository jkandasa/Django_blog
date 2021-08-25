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
RUN python3 -m venv .env \
    && source .env/bin/activate \
    && pip install -r requirements.txt \
    && python manage.py collectstatic 

# final build
FROM nginx:1.21-alpine

# set environment variables
ENV BACKEND_URL="http://localhost:8000"

COPY --from=builder /app/staticfiles /var/www/static

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template


## add permissions
RUN chown -R nginx:nginx /var/www/static \
        && chmod -R 755 /var/www/static \
        && chown -R nginx:nginx /var/cache/nginx \
        && chown -R nginx:nginx /var/log/nginx \
        && chown -R nginx:nginx /etc/nginx/conf.d \
        && touch /var/run/nginx.pid \
        && chown -R nginx:nginx /var/run/nginx.pid

USER nginx
