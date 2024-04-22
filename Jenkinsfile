pipeline {
    agent any
    stages {
        stage('Checkout Jenkinsfile Repo') {
            steps {
                // This checks out the Jenkinsfile repository to the 'jenkins-repo' directory
                dir('jenkins-repo'){
                    checkout scm
                }
            }
        }

        stage('Checkout .NET Application Repo') {
            steps {
                // This checks out the .NET application code from a different repository to the 'dotnet-app' directory
                dir('dotnet-app') {
                    git url: 'https://github.com/adamajammary/simple-web-app-mvc-dotnet.git'
                }
            }
        }

        stage('Build') {
            steps {
                // Change directory to where the solution file is located
                dir('SimpleWebAppMVC') {
                    sh 'dotnet restore'
                    sh 'dotnet build --configuration Release'
                }
            }
        }

        stage('Test') {
            steps {
                sh 'dotnet test'
            }
        }

        stage('Docker Build and Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Login to Docker registry
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        // Assuming the Dockerfile is in the 'jenkins-repo' directory and the .NET app context is in 'dotnet-app'
                        dir('jenkins-repo') {
                            // Build and push the Docker image
                            // The path to the Dockerfile is relative to the current directory, so just 'Dockerfile' suffices
                            // The '.' at the end specifies the build context, which is the current directory ('jenkins-repo')
                            docker.build("thicksy/simple-web-app-mvc-dotnet:latest", "-f Dockerfile ../dotnet-app").push()
                        }
                    }
                }
            }
        }
    
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f app-deployment.yml --namespace=staging'
            }
        }
    }
}