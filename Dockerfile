# Use official Node image for building
FROM node:lts-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy backend code
COPY . .

# Expose backend server port (adjust based on your application)
EXPOSE 5000

# Start the Node.js backend server (adjust command based on your entry point)
CMD [ "node", "server.js" ]
