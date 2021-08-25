#!/bin/sh

source .env/bin/activate # activate virtual environment
python manage.py makemigrations
python manage.py migrate

if [ ${CREATE_ADMIN} == true ]; then
    python manage.py shell -c \
        "from django.contrib.auth.models import User; User.objects.create_superuser('${ADMIN_USER:-admin}', '${ADMIN_EMAIL:-admin@example.com}', '${ADMIN_PASSWORD:-admin}')"
fi

exec gunicorn --bind 0.0.0.0:8000 mysite.wsgi
