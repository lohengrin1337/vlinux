FROM ubuntu:24.04

RUN apt update && \
    apt install -y curl

WORKDIR /client

COPY mazerunner.bash .

ENTRYPOINT [ "bash" ]
