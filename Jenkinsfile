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
                withSonarQubeEnv('SonarQube') { // replace 'SonarQube' with your SonarQube server name in Jenkins
                    sh 'mvn sonar:sonar'
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
