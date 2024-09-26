FROM node:18

WORKDIR /server

COPY index.js maze.js router.js package*.json ./

COPY maps/*.json ./maps/

EXPOSE 1337

CMD ["node", "index.js"]
