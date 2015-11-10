FROM node:4.2.2

RUN npm install -g webpack

RUN mkdir /mnt/webpack
WORKDIR /mnt/webpack
COPY ./package.json package.json
RUN npm install

COPY . /mnt/webpack
VOLUME /mnt/webpack/dist

EXPOSE 8666
