FROM node:10-alpine
RUN mkdir -p /home/node/app/node_modules
WORKDIR /home/node/app
COPY package*.json /home/node/app
RUN npm install
COPY . .
EXPOSE 8080
EXPOSE 5432
CMD [ "node", "index.js" ]
