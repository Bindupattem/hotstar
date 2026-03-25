pipeline {
    agent any

    tools {
        maven 'Maven 3.9.4' // replace with your exact Maven tool name
    }

    environment {
        DOCKER_USER = credentials('docker-hub-cred-id').username
        DOCKER_PASS = credentials('docker-hub-cred-id').password
        IMAGE_NAME  = 'task4'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Bindupattem/hotstar.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t myimg2 .'
            }
        }

        stage('Docker Run') {
            steps {
                sh 'docker rm -f cont1 || echo "container not found"'
                sh 'docker run -d --name cont1 -p 8076:80 myimg2'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                sh 'docker tag myimg2:latest $DOCKER_USER/$IMAGE_NAME:latest'
                sh 'docker push $DOCKER_USER/$IMAGE_NAME:latest'
            }
        }
    }
}
