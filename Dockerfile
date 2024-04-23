# Use official Node image for building
FROM node:lts-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy remaining frontend code
COPY . .

# Expose React development server port (default 3000)
EXPOSE 3000

# Start the React development server (adjust command if using Create React App)
CMD [ "npm", "start" ]
