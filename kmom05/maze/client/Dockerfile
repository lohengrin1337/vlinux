FROM ubuntu:24.04

RUN apt update && \
    apt install -y curl jq

WORKDIR /client

COPY mazerunner.bash core.bash utils.bash variables.bash ./

ENTRYPOINT [ "bash" ]
