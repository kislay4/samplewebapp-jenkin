pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'githubcred', url: 'https://github.com/kislay4/samplewebapp-jenkin.git']]])
            }
        }
        stage('build code') {
            steps {
                script {
                    sh returnStatus: true, script: 'mvn clean package'
                }
            }
        }
        stage('Building dockerfile') {
            steps {
                script {
                    container = docker.build("kislay4/${env.JOB_BASE_NAME}")
                }
            }
        }
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
      stage('Checking WebApp Deployment using Curl') {
            steps {
                script {
                    sh 'curl http://localhost:8888/SampleWebApp-0.0.1/'
                }
            }
        }
      
    }
}
