FROM node:4.2.2

RUN npm install -g webpack

COPY package.json /mnt/webpack/package.json
WORKDIR /mnt/webpack
RUN npm install

COPY . /mnt/webpack

EXPOSE 8666
