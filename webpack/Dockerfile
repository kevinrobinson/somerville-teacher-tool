FROM node:4.2.2

RUN npm install -g webpack

COPY ./package.json /mnt/webpack/package.json
RUN npm install

COPY . /mnt/webpack
VOLUME /mnt/webpack/dist

EXPOSE 8666
