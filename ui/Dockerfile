# Pull base image.
FROM node:4.2.2

RUN npm install -g webpack
RUN npm install webpack-dev-server -g

COPY . /mnt/ui
WORKDIR /mnt/ui
# RUN npm install
# VOLUME /mnt/ui/dist

EXPOSE 8666

CMD ["npm", "run", "develop"]