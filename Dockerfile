FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
	&& apt-get install -y build-essential libpq-dev curl \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies
COPY requirements/common.txt /app/requirements.txt
RUN pip install --upgrade pip && pip install -r /app/requirements.txt

# Copy project
COPY . /app

# Ensure entrypoint is executable
RUN chmod +x /app/entrypoint.sh || true

ENV PORT 8000

EXPOSE 8000

# Entrypoint will run migrations, collectstatic and then exec the provided CMD
CMD ["/app/entrypoint.sh", "gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
