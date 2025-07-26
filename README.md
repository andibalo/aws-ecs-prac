# Golang-React-Docker

This repository contains a boilerplate project that integrates Golang as the backend, React as the frontend, and Docker for containerization. This setup is ideal for developers looking to build scalable and maintainable web applications with modern technologies.

## CI/CD
This GitHub Actions workflow is designed to deploy both the Frontend (React app) and Backend to Amazon ECS (Elastic Container Service). It triggers the deployment process when specific Git tags (such as stg-fe-* for frontend and stg-be-* for backend) are pushed to the repository.

`actions/checkout`

Uses the `actions/checkout` action to clone the repository into the GitHub runner.

`docker/setup-buildx-action`

Uses the `docker/setup-buildx-action` to set up Docker Buildx to build images

**React Deployment**

React is deployed by building the react files into a static file which is then served by a web server like nginx. To pass environment variable we can do it during build time or runtime, in this case we do it during build time. To do it we need to create our environment variables in github actions, create a .env file in our github runner and append the env variables to it before building the image

## References

- **Github Actions Components**: https://docs.github.com/en/actions/get-started/understand-github-actions
- **Deploy To ECS from Github Actions**: https://docs.github.com/en/actions/how-tos/deploy/deploy-to-third-party-platforms/amazon-elastic-container-service
- **Push Image To ECR from Github Actions**: https://github.com/aws-actions/amazon-ecr-login
- **Github Actions Environment**: https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments#creating-an-environment
- **React Inject Env Variables (Buildtime vs Runtime)**: https://pamalsahan.medium.com/dockerizing-a-react-application-injecting-environment-variables-at-build-vs-run-time-d74b6796fe38

## Features

- **Golang Backend**: A robust and efficient backend using Golang.
- **React Frontend**: A dynamic and responsive frontend using React.
- **Docker Integration**: Seamless containerization and orchestration using Docker.
- **Modular Architecture**: Clear separation of backend and frontend code for better maintainability.
- **Hot Reload**: Support for hot reloading in development mode.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Docker and Docker Compose installed on your machine.
- Node.js and npm (for frontend development).
- Go (Golang) installed on your machine.

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/thesaltree/Golang-React-Docker.git
cd Golang-React-Docker
```

### Running the Project

You can run the entire project using Docker Compose.

#### Build and start the containers:

```
docker-compose up --build
```

This command will build the Docker images and start the containers for both the Golang backend and React frontend.

#### Access the application:

Backend: http://localhost:8080 

Frontend: http://localhost:3000

### Development

#### Backend

To develop the backend locally without Docker, follow these steps:

- Navigate to the backend directory:
```
cd backend
```
- Install dependencies and run the server:
```
go mod tidy
go run main.go
```
The backend server will be available at http://localhost:8080.

#### Frontend

To develop the frontend locally without Docker, follow these steps:

- Navigate to the frontend directory:
```
cd frontend
```
- Install dependencies and start the development server:
```
npm install
npm start
```
The frontend server will be available at http://localhost:3000.

### Project Structure

```
.
├── backend             # Golang backend code
│   ├── main.go
│   ├── handlers
│   └── ...
├── frontend            # React frontend code
│   ├── public
│   ├── src
│   └── ...
├── docker-compose.yml  # Docker Compose configuration
└── README.md           # Project documentation
```

### Contributing
Contributions are welcome! Please fork the repository and create a pull request with your changes. Make sure to follow the coding standards and include relevant tests.

### License
This project is licensed under the MIT License - see the LICENSE file for details.


