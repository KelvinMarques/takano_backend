ARG PYTHON_VERSION=3.12-slim

FROM python:${PYTHON_VERSION}

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies.
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /TakanoOdontologia

WORKDIR /TakanoOdontologia

RUN pip install pipenv
COPY Pipfile Pipfile.lock /TakanoOdontologia/
RUN pipenv install --deploy --system
COPY . /TakanoOdontologia

WORKDIR ./TakanoOdontologia
ENV SECRET_KEY "54iz1Ur506oRKzlRktAWmGLYvHG3oXe2ognJH1tczAYxJEmF4t"
RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn","--bind",":8000","--workers","2","TakanoOdontologia.wsgi"]
