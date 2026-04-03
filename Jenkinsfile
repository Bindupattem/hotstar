pipeline {
    agent any

    tools {
        maven 'my maven' // Maven tool from Jenkins configuration
        jdk 'jdk17'      // JDK for Maven build
    }

    environment {
        IMAGE_NAME = 'hotstarprojectt'        // Docker image name
        SONAR_PROJECT_KEY = 'sq' // SonarQube project key
        SONAR_PROJECT_NAME = 'sq'
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

        stage('SonarQube Analysis') {
            steps {
                // 'MySonarQube' = Jenkins SonarQube server configuration name
                withSonarQubeEnv('MySonarQube') {
                    sh """
                       mvn sonar:sonar \
                       -Dsonar.projectKey=${env.SONAR_PROJECT_KEY} \
                       -Dsonar.projectName=${env.SONAR_PROJECT_NAME}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                // Wait for SonarQube Quality Gate result
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
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
