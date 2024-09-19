FROM postman/newman:5.3-alpine

# Update the package repository
RUN apk update

# Install extra packages
RUN apk add --no-cache curl
RUN apk add --no-cache zip
RUN apk add --no-cache iputils

# Update the base image
RUN apk upgrade

# Remove installation cache
RUN rm -rf /var/cache/apk/*

# Install node module globally
RUN npm install -g newman-reporter-csvallinone

# Set environment variable
ENV NODE_PATH=/usr/local/lib/node_modules

# Set working directory
WORKDIR /etc/newman

# Switch to root user
USER root

# Set DNS explicitly using sed command
COPY resolv.conf /etc/resolv.conf


# Set entry point
ENTRYPOINT ["newman"]
