# Base image (no DockerHub)
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    python3 python3-pip

WORKDIR /app

COPY app/ /app/

RUN pip3 install flask

CMD ["python3", "app.py"]

