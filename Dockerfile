FROM node:14-slim as build

### STAGE 1: Build ###
WORKDIR /usr/src/app
COPY package.json package-lock.json ./

RUN npm install

COPY . .

ARG PROFILE
ENV PROFILE $PROFILE

RUN echo "Environment: ${PROFILE}"
RUN npm run build-${PROFILE}

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine

COPY --from=build /usr/src/app/dist/dockerApp/ /usr/share/nginx/html
COPY  ./resources/nginx/nginx.conf /etc/nginx/conf.d/default.conf
ENTRYPOINT  ["nginx", "-g", "daemon off;"]
