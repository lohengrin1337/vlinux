FROM node:18

WORKDIR /server

COPY package*.json ./

RUN npm install

COPY index.js .

ENTRYPOINT ["npm"]

CMD ["start"]
