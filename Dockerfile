FROM node:18.16

WORKDIR /opt/notes-app

COPY package.json package-lock.json ./

RUN npm install --legacy-peer-deps

COPY . .

ENTRYPOINT [ "npm", "run" ]
CMD [ "start" ]
