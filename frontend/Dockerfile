FROM node:22.11.0-bullseye-slim

WORKDIR /app

COPY package.json .

COPY vite.config.ts .

COPY tsconfig.json .

RUN npm install

COPY . .

RUN npm run build

EXPOSE 5173

CMD [ "npm", "run", "dev"]
