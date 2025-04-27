# Usa uma imagem Python enxuta
FROM python:3.12-slim

# Variáveis de ambiente para evitar prompts no build
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Instala dependências do sistema (ex: para psycopg2 e gunicorn)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho
WORKDIR /TakanoOdontologia

# Copia os arquivos do projeto
COPY . .

# Instala o pipenv
RUN pip install --upgrade pip pipenv

# Instala dependências de produção
RUN pipenv install --deploy --ignore-pipfile

# Faz migrações e coleta os arquivos estáticos
RUN pipenv run python manage.py collectstatic --noinput
RUN pipenv run python manage.py migrate --noinput

# Expondo a porta 8000
EXPOSE 8000

# Comando de inicialização usando gunicorn
CMD ["pipenv", "run", "gunicorn", "TakanoOdontologia.wsgi:application", "--bind", "0.0.0.0:8000"]
