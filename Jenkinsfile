pipeline {
    agent any

    stages {
        stage('Checkout Jenkinsfile Repo') {
            steps {
                // This checks out the Jenkinsfile repository (assumes it's already configured in Jenkins)
                checkout scm
            }
        stage('Checkout .NET Application Repo') {
            steps {
                // This checks out the .NET application code from a different repository
                git url: 'https://github.com/otheruser/dotnet-repo.git'

            }
        }
        stage('Build') {
            steps {
                sh 'dotnet restore'
                sh 'dotnet build --configuration Release'
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
                    docker.build('thicksy/dotnet-banking-app:${BUILD_ID}').push()
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
