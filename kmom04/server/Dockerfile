FROM node:18

WORKDIR /server

COPY package*.json index.js ./

RUN npm install

ENTRYPOINT ["npm"]

CMD ["start"]
