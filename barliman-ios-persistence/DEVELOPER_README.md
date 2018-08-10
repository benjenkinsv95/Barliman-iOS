# Local Development
## Prerequisite
Node.js

## Run
Then startup the website with 
```
npm install && \
npm start
```

# Deployment
## Note
We will be deploying this under barliman.ben-jenkins.com:3000

## Prerequisite
Install Docker

## Build and Push to Docker Hub
```
  docker image build -t ios-barliman-persistence . && \
  docker tag ios-barliman-persistence benjenkinsv95/ios-barliman-persistence && \
  docker push benjenkinsv95/ios-barliman-persistence
```



## Run Docker Image (from Docker hub)
On the production machine

### Prerequisites
This application requires [the following prerequisites](https://github.com/benjenkinsv95/personal-website/blob/master/docker_nginx_prerequisites.md) so that it can be hosted with a domain name using a secure HTTPS encryption.

### Run App in Production
Finally, run the application from DockerHub. Pulls down a fresh copy and specifies what the domain name should be.
```
docker pull benjenkinsv95/ios-barliman-persistence && \
docker run -d \
-e VIRTUAL_HOST=ios-barliman-persistence.ben-jenkins.com \
-e LETSENCRYPT_HOST=ios-barliman-persistence.ben-jenkins.com \
-e LETSENCRYPT_EMAIL=benjenkinsv95@gmail.com \
benjenkinsv95/ios-barliman-persistence
```