pipeline {
    agent any
    stages {
        // This stage will checkout the code from github repository.
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'githubcred', url: 'https://github.com/kislay4/samplewebapp-jenkin.git']]])
            }
        }
        // This stage will build the application using maven build tool.
        stage('build code') {
            steps {
                script {
                    sh returnStatus: true, script: 'mvn clean package'
                }
            }
        }
        // This stage builds Docker images from a Dockerfile.
        stage('Building dockerfile') {
            steps {
                script {
                    container = docker.build("kislay4/${env.JOB_BASE_NAME}")
                }
            }
        }
        // This stage will go inside particular container and interacts or do some query.
      stage('Testing Inside conatiner ') {
          steps {
              script {
            container.inside {
             sh 'ls /usr/local/tomcat/webapps/'
             sh 'hostname'
            }
            }
            }    
        }
      
    }
}
