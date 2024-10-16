FROM ubuntu:24.04

RUN apt update && \
    apt install -y curl jq

WORKDIR /client

COPY ./bthloggen.bash /client/bthloggen.bash

COPY ./src /client/src

CMD [ "bash" ]
