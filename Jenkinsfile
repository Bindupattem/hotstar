pipeline {
    agent any

    tools {
        maven 'my maven' // exact Maven tool name from Global Tool Configuration
    }

    environment {
        IMAGE_NAME = 'task4' // only literals allowed here
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
                sh 'docker run -d --name cont1 -p 8076:8080 myimg2'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-cred-id', 
                                                 usernameVariable: 'DOCKER_USER', 
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker tag myimg2:latest $DOCKER_USER/$IMAGE_NAME:latest'
                    sh 'docker push $DOCKER_USER/$IMAGE_NAME:latest'
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                withMaven(
                    globalMavenSettingsConfig: 'settings.xml', // Jenkins-managed Maven settings
                    jdk: 'jdk17',
                    maven: 'my maven',
                    traceability: true
                ) {
                    sh 'mvn deploy'
                }
            }
        }
    } // end of stages
} // end of pipeline
