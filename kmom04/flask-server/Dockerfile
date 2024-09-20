FROM debian:bullseye-slim

RUN apt update && \
    apt install -y \
        python3-pip \
        python3-dev \
        build-essential

WORKDIR /server

COPY app.py requirements.txt ./

RUN pip3 install -r requirements.txt

ENTRYPOINT [ "python3" ]

CMD [ "app.py" ]
