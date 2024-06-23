pipeline {
    agent any
    tools {
        gradle 'gradle-7.3'
    }
    environment {
        SONAR_TOKEN = credentials('jenkins-sonar-token')
        repository = "192.168.222.200:8083"
        imagename = "mygradleapp"
    }
    stages {
        stage('Checkout the project') {
            steps {
                git branch: 'main', url: 'https://github.com/Louis-2b/jenkins-gradle-project-1.git'
            }
        }
        stage('Build the package') {
            steps {
                script {
                    sh 'gradle clean build'
                }
            }
        }
        stage('Sonar Quality Check') {
            steps {
                script {
                    withSonarQubeEnv(installationName: 'sonar-latest') {
                        sh 'gradle sonarqube -Dsonar.token=$SONAR_TOKEN'
                    }
                    timeout(time: 1, unit: 'HOURS') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        stage('Building the Image Docker') {
            steps {
                script {
                    sh "docker build -t ${repository}/${imagename}:${BUILD_NUMBER} ."
                }
            }
        }
        stage('Uploading to Nexus') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jenkins-nexus-token', passwordVariable: 'PSW', usernameVariable: 'USER')]) {
                        sh "echo ${PSW} | docker login -u ${USER} --password-stdin ${repository}"
                        sh "docker push ${repository}/${imagename}:${BUILD_NUMBER}"
                    }
                }
            }
        }
    }
}
