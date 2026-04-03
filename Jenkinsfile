pipeline {
    agent any

    tools {
        maven 'my maven' // Maven tool configured in Jenkins
        jdk 'jdk17'      // JDK for Maven build
    }

    environment {
        SONAR_PROJECT_KEY = 'myapp'        // SonarQube project key
        SONAR_PROJECT_NAME = 'myapp'       // SonarQube project name
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
                // 'MySonarQube' is the Jenkins SonarQube server name
                withSonarQubeEnv('MySonarQube') {
                    sh """
                       mvn sonar:sonar \
                       -Dsonar.projectKey=${env.SONAR_PROJECT_KEY} \
                       -Dsonar.projectName=${env.SONAR_PROJECT_NAME} \
                       -Dsonar.host.url=$SONAR_HOST_URL \
                       -Dsonar.login=$SONAR_AUTH_TOKEN
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                // Wait for SonarQube quality gate result
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}
