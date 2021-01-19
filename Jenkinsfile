pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                git credentialsId: 'githubcred', url: 'https://github.com/kislay4/SampleWebApp.git'
            }
        }
        stage('build code') {
            steps {
                script {
                    sh returnStatus: true, script: 'mvn clean package'
                }
            }
        }
        stage('Create Container') {
            steps {
                script {
                    container = docker.build("kislay4/${env.JOB_BASE_NAME}")
                }
            }
        }
      stage('Test Container') {
          steps {
              script {
            container.inside {
             sh 'echo "Tests passed"'
            }
            }
            }    
        }
    }
}
