FROM ubuntu:24.04

RUN apt update && \
    apt install -y curl jq

WORKDIR /client

COPY mazerunner.bash .

COPY src ./src

ENTRYPOINT [ "bash" ]

# CMD [ "mazerunner.bash", "loop" ]
