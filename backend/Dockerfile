FROM node:16-alpine
WORKDIR /usr/src/app
COPY . .
RUN npm ci --only=production
EXPOSE 8080
# ENV NODE_ENV=production
CMD [ "npm" "start ]