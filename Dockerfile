FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && \
    apt-get install -y apt-utils dialog && \
    apt-get install -y python3 python3-pip

COPY app/ /app
WORKDIR /app

RUN pip3 install flask

CMD ["python3", "app.py"]
