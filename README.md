
# Building a Multi-Tier MERN Application with Docker and Version Control

### Vedansh Kamdar 
### 21BCP259
### Division 4 Group 8

This blog post guides you through creating a multi-tier MERN (MongoDB, Express.js, React, Node.js) application with Docker for containerization and version control using Git and GitHub. We'll build separate Docker images for the frontend and backend, allowing for independent scaling and deployment.

## Tech Stack

- **Frontend:** React.js
- **Backend:** Node.js, Express.js
- **Database:** MongoDB
- **Containerization:** Docker
- **Version Control:** Git, GitHub

## Directory Structure


```bash
  todo-app/
├── backend/
│   ├── Dockerfile
│   └── server.js (and other backend code)
├── frontend/
│   ├── package.json
│   ├── public/ (for static assets)
│   └── src/ (React components)
│   └── Dockerfile
├── docker-compose.yml
└── README.md  (Blog)
```

## Prerequisites:

- Docker installed (https://www.docker.com/products/docker-desktop/)
- Node.js and npm installed (https://nodejs.org/en)
- Git installed (https://git-scm.com/downloads)
- A GitHub account (https://github.com/join)

## 1. Setting up the project

- Create a new directory named ```todo-app```
- Inside this directory, create subdirectories for the frontend (```frontend```), backend (```backend```), and a ```docker-compose.yml``` file for configuring multi-container setup.

## 2. Building the frontend

#### a. Initialize React App:

```
cd frontend
npx create-react-app .
```

#### b. Develop your React frontend for the to-do list application (not covered in detail here).

#### c. Create a ```Dockerfile``` for the frontend:

```
# Use official Node image for building
FROM node:lts-alpine

# Set working directory
WORKDIR /app

# Copy package.json and lock file
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy remaining frontend code
COPY . .

# Expose React development server port (default 3000)
EXPOSE 3000

# Start the React development server
CMD [ "npm", "start" ]

```

#### Explanation of the ```Dockerfile```:

- **FROM node:lts-alpine:** This line specifies the base image to use for building the Docker container. In this case, it uses the official Node.js image with the LTS (Long Term Support) version based on Alpine Linux, which is a lightweight Linux distribution.
- **WORKDIR /app:** Sets the working directory inside the container to /app. This is the directory where all subsequent commands will be executed.
- **COPY package.json ./:** Copies the package.json and package-lock.json (if present) files from the host machine to the /app directory inside the container. These files are necessary for installing dependencies.
- **RUN npm install:** Runs the npm install command inside the container to install all the dependencies specified in the package.json file. This step ensures that all required Node.js modules are installed before copying the rest of the application code.
- **COPY . .:** Copies the remaining frontend code from the host machine to the /app directory inside the container. This includes all the source code files and assets required for the React application.
- **EXPOSE 3000:** Exposes port 3000 on the container. This line informs Docker that the container will be listening on port 3000, which is the default port for a React development server.
- **CMD ["npm", "start"]:** Specifies the default command to run when the container starts. In this case, it starts the React development server using the npm start command.

## 3. Building the Backend:

#### a. Initialize a Node.js project:

```
cd ../backend
npm init -y
```

#### b. Install dependencies:

```
npm install express mongoose
```

#### d. Develop your backend server using Express and Mongoose for connecting to MongoDB (not covered in detail here). Make sure to set up the MongoDB connection string as an environment variable.

#### d. Create a ```dockerfile``` for the backend:

```
# Use official Node image for building
FROM node:lts-alpine

# Set working directory
WORKDIR /app

# Copy package.json and lock file
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy backend code
COPY . .

# Expose backend server port (adjust based on your application)
EXPOSE 5000  # Assuming your server runs on port 5000

# Start the Node.js backend server
CMD [ "node", "server.js" ]
```

#### Explanation of the backend ```Dockerfile```:

- **FROM node:lts-alpine:** This line specifies the base image to use for building the Docker container. It uses the official Node.js image with the LTS (Long Term Support) version based on Alpine Linux, which is a lightweight Linux distribution.
- **WORKDIR /app:** Sets the working directory inside the container to /app. This is where all subsequent commands will be executed.
- **COPY package.json ./:** Copies the package.json and package-lock.json (if present) files from the host machine to the /app directory inside the container. These files are necessary for installing dependencies.
- **RUN npm install:** Executes the npm install command inside the container to install all the dependencies specified in the package.json file. This step ensures that all required Node.js modules are installed before copying the rest of the application code.
- **COPY . .:** Copies the remaining backend code from the host machine to the /app directory inside the container. This includes all the source code files and assets required for the Node.js backend server.
- **EXPOSE 5000:** Exposes port 5000 on the container. This line informs Docker that the container will be listening on port 5000, which is the default port for the Node.js backend server.
- **CMD ["node", "server.js"]:** Specifies the default command to run when the container starts. In this case, it starts the Node.js backend server by executing the server.js file using the node command.

## 4. Setting Up Multi-Container with Docker Compose:

Create a file named ```docker-compose.yml``` in the root directory (```todo-app```):

```
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"  # Map frontend container port to host port 3000
    volumes:
      - ./frontend:/app  # Mount frontend code directory as a volume

  backend:
    build: ./backend
    ports:
      - "5000:5000"  # Map backend container port to host port 5000
    environment:
      MONGO_URI: mongodb://your_mongodb_connection_string  # Replace with actual URI
    volumes:
      - ./backend:/app  # Mount backend code directory as a volume

# Uncomment the following section if using a separate MongoDB container
# mongodb:
#   image: mongo:latest
#   ports:
#     - "27017:27017"
```

## 5. Building and Running the Application:

To build the Docker containers:
```
docker-compose build
```
To start the docker containers
```
docker-compose up
```

## 6. Pushing to Dockerhub

- Firstly if you are using dockerhub for the first time then create an account and followed by that create a new repository when the image of your project will be pushed.

- Secondly tag your image with the name of your Docker Hub repository:

To tag your image, you can use the following command:

```
docker tag <image-name> <yourusername>/<repository-name>:<tag-name>
```

For example, to tag an image named ```my-image``` with the name of your Docker Hub repository ```my-repo```, you would use the following command:
```
docker tag my-image my-username/my-repo:latest
```

Push the image to Docker Hub.

To push the image to Docker Hub, you can use the following command:

```
docker push <username>/<repository-name>:<tag-name>
```
For example, to push the image named ```my-image``` to your Docker Hub repository ```my-repo```, you would use the following command:
```
docker push my-username/my-repo:latest
```

## 7. Version Control with Git and github

To manage your code effectively and enable collaboration, this project leverages Git for version control and GitHub for remote storage. Here's a basic workflow:

- Initialize Git repository:
```
git init
```
- Add all files
```
git add .
```
- Commit changes with a descriptive message
```
git commit -m "Initial commit: MERN todo application"
```
- Create a Remote Repository on GitHub
- Link Your Local Repository to the Remote Repository:

```
git remote add origin <your_remote_repository_url>
```
- Push local commits to Github
```
git push origin main  # Replace "main" with your branch name if different
```
By following these steps, you'll have a version-controlled copy of your project on GitHub, enabling easy collaboration, tracking changes, and reverting to previous versions if needed.

## Conclusion

This blog has guided you through building a **MERN todo application with Docker** for containerization and Git for version control. By following these steps, you've created a well-structured and scalable application with independent frontend and backend deployments.

## Key Takeaways:

- You learned how to structure a MERN application with separate frontend and backend directories.
- You created Dockerfiles for both frontend and backend to build containerized images.
- You utilized Docker Compose to manage multi-container deployments.
- You implemented version control with Git for code management and collaboration (consider adding instructions on pushing the code to GitHub).

