FROM python:3.9

WORKDIR /server

COPY ./requirements.txt /server/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /server/requirements.txt

COPY ./app /server/app

ENV PYTHONPATH="${PYTHONPATH}:/server/app"

EXPOSE 8000

CMD ["fastapi", "run", "app/main.py", "--port", "8000"]
