FROM ubuntu:24.04

RUN apt update && \
    apt install -y curl

WORKDIR /client

COPY client.bash .

ENTRYPOINT [ "bash" ]

# CMD [ "client.bash" ]
