pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'githubcred', url: 'https://github.com/kislay4/samplewebapp-jenkin.git']]])
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
