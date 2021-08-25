#!/bin/sh

source .env/bin/activate # activate virtual environment
python manage.py makemigrations
python manage.py migrate

python manage.py shell -c \
    "from django.contrib.auth.models import User; User.objects.create_superuser('${ADMIN_USER:-admin}', '${ADMIN_EMAIL:-admin@example.com}', '${ADMIN_PASSWORD:-admin}')"

gunicorn --bind 0.0.0.0:8000 mysite.wsgi
