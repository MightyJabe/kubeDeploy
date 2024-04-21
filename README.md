.NET Core Application CI/CD Pipeline with Jenkins and Kubernetes


This project contains the necessary configurations to set up a Continuous Integration/Continuous Deployment (CI/CD) pipeline using Jenkins within a Kubernetes cluster. The pipeline builds, tests, and deploys a .NET Core web application.


Repository Structure
Kubernetes/: Kubernetes manifest files for the Jenkins service and the .NET Core application.
Dockerfile: The Dockerfile for building the .NET Core application image.
Jenkinsfile: Defines the Jenkins pipeline stages.


Prerequisites
A Kubernetes cluster
kubectl configured to communicate with your Kubernetes cluster
Docker installed on your local machine and Jenkins agent
Access to a container registry where you can push Docker images


Setup Instructions
Setting Up the Kubernetes Namespace
Create the devops namespace where Jenkins will reside:

kubectl apply -f Kubernetes/devops/devops-namespace.yml

Deploying Jenkins
Deploy Jenkins to the devops namespace:

kubectl apply -f Kubernetes/devops/jenkins-deployment.yml
kubectl apply -f Kubernetes/devops/jenkins-pvc.yml
kubectl apply -f Kubernetes/devops/jenkins-service.yml


Deploying the .NET Core Application
Deploy the .NET Core application to the desired namespace:

kubectl apply -f Kubernetes/staging/app-deployment.yml



Jenkins Pipeline
Set up a Jenkins job using the Jenkinsfile in this repository. The pipeline includes the following stages:

Checkout - Clones the repository.
Build - Restores dependencies and builds the .NET Core application.
Test - Runs tests defined in the project.
Docker Build and Push - Builds a Docker image for the application and pushes it to your container registry.
Deploy to Kubernetes - Applies the Kubernetes manifest to deploy/update the application in the cluster.


Accessing Jenkins
After deploying Jenkins, retrieve the NodePort assigned to Jenkins:

kubectl get service jenkins -n devops


Access Jenkins via http://<Cluster-IP>:<NodePort> in your browser. You will need to configure Jenkins with the necessary plugins and credentials to interact with your Git repository and Docker registry.
Alternatively, you can port-forward Jenkins to your local machine:

kubectl port-forward service/jenkins -n devops 8080:8080


Configuring Jenkins Credentials
Add your Docker registry credentials.
Add your Git credentials.
Set up a Kubernetes service account for Jenkins and add the kubeconfig file to the Jenkins credentials.

