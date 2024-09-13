FROM ubuntu:24.04

RUN apt update && \
    apt install -y bsdmainutils

WORKDIR /kmom02

COPY ./commands.bash .

RUN chmod +x ./*.bash

ENTRYPOINT [ "bash", "/kmom02/commands.bash" ]

CMD ["all"]
