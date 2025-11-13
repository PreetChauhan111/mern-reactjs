FROM node:18-alpine AS build

# Declare build time variables

ARG REACT_APP_NODE_ENV
ARG REACT_APP_SERVER_BASE_URL

# Set Default values for environment variables

ENV REACT_APP_NODE_ENV=$REACT_APP_NODE_ENV
ENV REACT_APP_SERVER_BASE_URL=$REACT_APP_SERVER_BASE_URL

#Build React app

WORKDIR /app

COPY package.json .
RUN npm install

COPY . .
RUN npm run build

# Serve with nginx

FROM nginx:alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
