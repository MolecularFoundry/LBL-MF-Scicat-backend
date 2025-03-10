# gives a docker image below 200 MB
FROM node:16-alpine
RUN apk update && apk upgrade && apk add --no-cache git openldap-clients

ENV NODE_ENV "production"
ENV PORT 3000
EXPOSE 3000

# Prepare app directory
WORKDIR /home/node/app
COPY package*.json /home/node/app/
COPY .snyk /home/node/app/

# set up local user to avoid running as root
RUN chown -R node:node /home/node/app
USER node

# Install our packages
RUN npm ci --only=production

# Copy the rest of our application, node_modules is ignored via .dockerignore
COPY --chown=node:node . /home/node/app

# Start the app
CMD ["node", "."]
