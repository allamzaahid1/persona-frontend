FROM node:20-alpine as build
WORKDIR /app

#ARG REACT_APP_SERVER_URL
#ENV REACT_APP_SERVER_URL=$REACT_APP_SERVER_URL

COPY package*.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx:1-alpine
WORKDIR /usr/share/nginx/html

RUN rm -rf *
COPY --from=build /app/dist .
COPY ./env.js .
COPY ./generate.config.js.sh .
COPY ./docker-entrypoint.sh .
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN chmod +x docker-entrypoint.sh generate.config.js.sh

EXPOSE 80

ENTRYPOINT ["./docker-entrypoint.sh"]