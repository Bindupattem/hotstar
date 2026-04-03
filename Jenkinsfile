pipeline {
    agent any

    tools {
        maven 'my maven' // exact Maven tool name from Global Tool Configuration
        jdk 'jdk17'      // add JDK for Maven build
    }

    environment {
        IMAGE_NAME = 'task4'
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
        withSonarQubeEnv('SonarQube') {
            sh '''
            mvn clean verify sonar:sonar \
            -Dsonar.projectKey=myapp \
            -Dsonar.host.url=http://13.127.242.127:8080 \
            -Dsonar.login=$SONAR_AUTH_TOKEN
            '''
        }
    }
}
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy to Nexus') {
            steps {
                withMaven(
                    globalMavenSettingsConfig: 'settings.xml',
                    jdk: 'jdk17',
                    maven: 'my maven',
                    traceability: true
                ) {
                    sh 'mvn deploy'
                }
            }
        }
    }
}
