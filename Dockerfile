FROM node:latest as build-deps
WORKDIR /opt/vue-2048
COPY package.json yarn.lock ./
RUN yarn
COPY ./ ./
RUN yarn build

FROM nginx:1.12-alpine
COPY --from=build-deps /opt/vue-2048/dist  /usr/share/nginx/html/
