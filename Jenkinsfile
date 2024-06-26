pipeline {
    agent any
    stages {
        stage('Checkout Jenkinsfile Repo') {
            steps {
                // This checks out the Jenkinsfile repository (assumes it's already configured in Jenkins)
                checkout scm
            }
        }

        stage('Checkout .NET Application Repo') {
            steps {
                // This checks out the .NET application code from a different repository
                git url: 'https://github.com/adamajammary/simple-web-app-mvc-dotnet.git'
            }
        }

        stage('Build') {
            steps {
                // Change directory to where the solution file is located
                dir('SimpleWebAppMVC') {
                    sh 'dotnet restore'
                    sh 'dotnet clean'
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
                        // Build and push the Docker image
                        docker.build("thicksy/simple-web-app-mvc-dotnet:latest", "-f /var/jenkins_home/workspace/staging@script/23d4a291a4a5f1c39dee74c655b7b7572abb73f881dc16603864f454499995cc/Dockerfile .").push()
                    }
                }
            }
        }
    
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f /var/jenkins_home/workspace/staging@script/23d4a291a4a5f1c39dee74c655b7b7572abb73f881dc16603864f454499995cc/Kubernetes/staging/app-deployment.yml --namespace=staging'
            }
        }
    }
}