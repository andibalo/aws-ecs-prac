# Golang-React-Docker

This repository contains a boilerplate project that integrates Golang as the backend, React as the frontend, and Docker for containerization. This setup is ideal for developers looking to build scalable and maintainable web applications with modern technologies.

## Architecture
Overview
<img width="1172" height="616" alt="image" src="https://github.com/user-attachments/assets/4d0420d6-c13d-49b1-a3ea-2d571f88d4da" />

Security Group
<img width="1134" height="536" alt="image" src="https://github.com/user-attachments/assets/634d465c-322d-435d-98d1-a0fcf0a5af1e" />

## Setting up OpenVPN
Setting up OpenVPN to access resources in private subnet

GitHub: https://github.com/kylemanna/docker-openvpn 

**Running OpenVPN in an EC2 instance**
1. Start an EC2 instance
2. SSH to your EC2 instance
```
ssh -i "andibalo.pem" ubuntu@21.33.123.123
```

3. Install Docker. Ref: https://docs.docker.com/engine/install/ubuntu/
4. Run the commands below
OpenVPN Configuration
```
docker volume create openvpn-data
docker run -v openvpn-data:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$(curl -s http://checkip.amazonaws.com):1194
docker run -v openvpn-data:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki
docker run -v openvpn-data:/etc/openvpn -d -p 1194:1194/udp --name openvpn --cap-add=NET_ADMIN kylemanna/openvpn
docker update --restart unless-stopped openvpn
```

**Generate OpenVPN Client Certificate**
1. SSH to your EC2 instance
```
ssh -i "andibalo.pem" ubuntu@21.33.123.123
```

2. Switch to root user
```
sudo su
```

3. Set the OpenVPN data directory:
```
OVPN_DATA=openvpn-data
```

4. Generate a new client certificate (replace <CLIENTNAME> with the actual username):
```
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full <CLIENTNAME> nopass
```
Note: You will be prompted to enter the OpenVPN password.

5. Export the generated .ovpn configuration file to the /tmp directory (replace <CLIENTNAME> with the actual username):
```
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient <CLIENTNAME> > /tmp/<CLIENTNAME>.ovpn
```

6. Copy the .ovpn file to your local machine and import it to your OpenVPN client
```
scp -i andibalo.pem ubuntu@21.33.123.123:/tmp/andibalo-twotier.ovpn C:/some_file
```

**Revoke Access**

Revoke OpenVPN Client Certificate

1. Switch to root user:
```
sudo su
```

2. Set the OpenVPN data directory:
```
OVPN_DATA=openvpn-data
```

3.Remove client certificate (replace <CLIENTNAME> with the actual username):
```
docker run --rm -it -v $OVPN_DATA:/etc/openvpn kylemanna/openvpn ovpn_revokeclient <CLIENTNAME> remove
```
Note: You will be prompted to enter the OpenVPN password.

## Infra Step By Step
1. Create VPC with the public/private subnets
2. Create security groups
3. Create ECR repository
4. Create RDS database
5. Setup OpenVPN EC2 instance 
6. Register domain with route 53 create https certificate using ACM. 
    - If you use domain from external provider like hostinger then make sure you create CAA records for amazon in your DNS panel to create http certificate with ACM.
7. Create Target group for FE and BE -> Create ALB
    - Ensure target group type is IP Address
    - ALB will have two listeners HTTP and HTTPS. Add rule in each where if host header is api.domain.com then redirect to BE target group
8. Create Cluster -> Create Task Definition (FE and BE) -> Create Service (FE and BE)
    - When creating cluster choose wheter Fargate/EC2 or both
    - After creating task definition, download as json for based task deinition to be used in CI/CD pipeline
    - When creating service, use existing load balancer
    - Destination of target group of type IP address will be automatically updated with the private ip address of the created task.
9. Add CNAME record for example `api.andisandbox.my.id` that will point to ALB DNS

## CI/CD
This GitHub Actions workflow is designed to deploy both the Frontend (React app) and Backend to Amazon ECS (Elastic Container Service). It triggers the deployment process when specific Git tags (such as stg-fe-* for frontend and stg-be-* for backend) are pushed to the repository.

`actions/checkout`

Uses the `actions/checkout` action to clone the repository into the GitHub runner.

`docker/setup-buildx-action`

Uses the `docker/setup-buildx-action` to set up Docker Buildx to build images

`aws-actions/amazon-ecs-render-task-definition@v1`

Updates a task definition json we provide with a new image uri that will be deployed. Ensure you provide task definition json file path by either comitting it to repo or download in the pipeline.

**React Deployment**

React is deployed by building the react files into a static file which is then served by a web server like nginx. To pass environment variable we can do it during build time or runtime, in this case we do it during build time. To do it we need to create our environment variables in github actions, create a .env file in our github runner and append the env variables to it before building the image

## References

- **Github Actions Components**: https://docs.github.com/en/actions/get-started/understand-github-actions
- **Deploy To ECS from Github Actions**: https://docs.github.com/en/actions/how-tos/deploy/deploy-to-third-party-platforms/amazon-elastic-container-service
- **Push Image To ECR from Github Actions**: https://github.com/aws-actions/amazon-ecr-login
- **Github Actions Deploy Task Definition**: https://github.com/aws-actions/amazon-ecs-deploy-task-definition
- **Github Actions Render Task Definition**: https://github.com/aws-actions/amazon-ecs-render-task-definition
- **Github Actions Environment**: https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments#creating-an-environment
- **React Inject Env Variables (Buildtime vs Runtime)**: https://pamalsahan.medium.com/dockerizing-a-react-application-injecting-environment-variables-at-build-vs-run-time-d74b6796fe38
- **Install Docker in EC2 Instance**: https://docs.docker.com/engine/install/ubuntu/

## Troubleshooting Notes
**1. Successfully deployed task definition but my service is not updating**

If you are only running one instance check your minimum healthy task config. If it is 100% change it to 0%, ref: https://github.com/aws-actions/amazon-ecs-deploy-task-definition/issues/417. Also ensure you pass the correct service and cluster name values during the task definition deployment step. 

**2. Target in my target group is unhealthy**

Ensure you set the correct health check endpoint for the target group. My backend target group endpoint was set to / but it has no / endpoint hence it will be marked as unhealty.

**3. Cannot generate ceritfiate in AWS using domain from external provider like hostinger**

Add CAA records for amazon to your DNS config. Ref: https://stackoverflow.com/questions/56174816/how-to-validade-a-aws-certificate-with-hostinger-domain

## To Do Next
- [ ] Move backend to private subnet
- [ ] Integrate cloudfront CDN
- [ ] Integrate golang migrate to CI/CD pipeline
- [ ] Use terraform
- [ ] Integrate hashicorp vault

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


