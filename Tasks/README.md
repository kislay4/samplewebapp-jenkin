DevOps Usecase Explanation
-----------------------------
## Task1: Install MiniKube, Helm, Kubectl and Docker

### Minikube
- azureuser@devopstest:~$ minikube version
- minikube version: v1.19.0
- commit: 15cede53bdc5fe242228853e737333b09d4336b5

### Helm

- azureuser@devopstest:~$ helm version
- version.BuildInfo{Version:"v3.5.4", GitCommit:"1b5edb69df3d3a08df77c9902dc17af864ff05d1", GitTreeState:"clean", GoVersion:"go1.15.11"}

### Kubectl

- azureuser@devopstest:~$ kubectl version
- Client Version: version.Info{Major:"1", Minor:"21", GitVersion:"v1.21.0", GitCommit:"cb303e613a121a29364f75cc67d3d580833a7479", GitTreeState:"clean", BuildDate:"2021-04-08T16:31:21Z", GoVersion:"go1.16.1", Compiler:"gc", Platform:"linux/amd64"}
- Server Version: version.Info{Major:"1", Minor:"20", GitVersion:"v1.20.2", GitCommit:"faecb196815e248d3ecfb03c680a4507229c2a56", GitTreeState:"clean", BuildDate:"2021-01-13T13:20:00Z", GoVersion:"go1.15.5", Compiler:"gc", Platform:"linux/amd64"}

### Docker

- azureuser@devopstest:~$ docker -v
- Docker version 20.10.6, build 370c289

_______________________________________________________________________

## Task2:Create a GitRepo (in your own account) that creates a basic web app (in a language of your choosing)

https://github.com/kislay4/samplewebapp-jenkin

______________________________________________________________________

## Task3: Create a Docker file that exposes the basic web app

#It will pull tomcat:8.0-alpine image & initializes a new build stage and sets the Base Image for subsequent instructions.
FROM tomcat:8.0-alpine

#sets the Author field of the generated images.
LABEL maintainer="kislay4@gmail.com"

#Copy files from the local storage to a destination in the Docker image.
ADD target/SampleWebApp-0.0.1.war /usr/local/tomcat/webapps/

#Instructing container to listens on the specified network ports at runtime.
EXPOSE 8080

#It is executed to start the Tomcat server.
CMD ["catalina.sh", "run"]

______________________________________________________________________
## Task4:Create a DockerHub account so you can publish a Docker Image to it.

https://hub.docker.com/repository/docker/kislay4/usecase1

______________________________________________________________________

## Task5:Create a Jenkinsfile in your GitHub repo (use your own account) with two Jenkinsfiles.
-  Pipeline Jenkinsfile - Builds your Dockerfile and publishes it to your DockerHub account
- DSL Jenkinsfile - This task needs to start your Docker container created in the Pipeline and send one command to interact with the container (provide Evidence that it runs and is serving the webpage built)


- jenkinsfile1:

- pipeline {
- //Setting up the environment for Azure Auth.
   -  environment {
   - registryCredential = 'docker-login'
   -  AZURE_SUBSCRIPTION_ID= credentials('subscriptionid')
    - AZURE_TENANT_ID= credentials('tenantid')
   - AZURE_STORAGE_ACCOUNT= credentials('myStorageAccount')
   - }
    - agent any
   - stages {
	- // This stage will checkout the code from github repository.
    -    stage('Checkout Code') {
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
            post {
         success {
           withCredentials([usernamePassword(credentialsId: 'azuresp', 
                          passwordVariable: 'AZURE_CLIENT_SECRET', 
                          usernameVariable: 'AZURE_CLIENT_ID')]) {
             sh '''
            
              - ls
              - # Login to Azure with ServicePrincipal
              - az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID
			  
              # Set default subscription
              az account set --subscription $AZURE_SUBSCRIPTION_ID
			  
              # Execute upload to Azure
              az storage container create --account-name $AZURE_STORAGE_ACCOUNT --name $JOB_NAME --auth-mode login
              az storage blob upload-batch --destination ${JOB_NAME} --source target --auth-mode login
			  
              # Logout from Azure
              az logout
             '''
           }
         }
       }
         }
	- // This stage builds Docker images from a Dockerfile
    -     stage('Building Dockerfile') {
      -      steps {
       -         script {
        -            container = docker.build("kislay4/${env.JOB_BASE_NAME}")
                }
            }
        }
    // This stage will push the new created image to docker hub repository. 
      stage('Publish Image to Dockerhub') {
          steps {
              script {
                  docker.withRegistry( '', registryCredential ) {
            container.push('latest')
                  }
              }
            }    
        }
    }
}


Jenkinsfile:


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



- `docker run -it --rm -p 8888:8080 kislay4/usecase2`
- `http://<ip of machine>:8888/SampleWebApp-0.0.1/`

______________________________________________________________________


## Task6:Use a Public Helm chart to deploy the Jenkins Chart onto the MiniKube instance on your environment.4

- `helm install jenkins stable/jenkins`
WARNING: This chart is deprecated
NAME: jenkins
LAST DEPLOYED: Mon May 17 03:49:55 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
NOTES:

* The Jenkins chart is deprecated. Future development has been moved to https://github.com/jenkinsci/helm-charts

- 1. Get your 'admin' user password by running:
 -  printf $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
- 2. Get the Jenkins URL to visit by running these commands in the same shell:
  - export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=jenkins" -o jsonpath="{.items[0].metadata.name}")
  - echo http://127.0.0.1:8080
  - kubectl --namespace default port-forward $POD_NAME 8888:8080

- 3. Login with the password from step 1 and the username: admin

- 4. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http:///configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos

azureuser@devopstest:~$ kubectl get all -n default
NAME                                  READY   STATUS    RESTARTS   AGE
pod/example-mychart-b45d64746-tqwbr   1/1     Running   2          25h
pod/jenkins-0                         2/2     Running   3          23h

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
service/example-mychart   NodePort    10.109.56.153   <none>        80:32707/TCP   25h
service/jenkins           ClusterIP   10.110.22.179   <none>        8080/TCP       23h
service/jenkins-agent     ClusterIP   10.99.143.13    <none>        50000/TCP      23h
service/kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP        38h

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/example-mychart   1/1     1            1           25h

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/example-mychart-b45d64746   1         1         1       25h

NAME                       READY   AGE
statefulset.apps/jenkins   1/1     23h


______________________________________________________________________

## Task7:Write an ARM template to deploy (Use your own Azure account):
- An Azure StorageAccount with a blob container (include any requires resources)
- Configure this storage account to host a static webpage.
- Deploy the ARM template via the CLI (Show the commands)

{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",

    //Defining required parameters for storageAccount.json

    "parameters": {
        "location": {
            "value": "eastus"
        },
        "storageAccounts_name": {
            "value": "createdbyarm2"
        },
        "accountType": {
            "value": "Standard_LRS"
        },
        "tierType": {
            "value": "Standard"
        },
        "kind": {
            "value": "StorageV2"
        },
        "networkAclsBypass": {
            "value": "AzureServices"
        },
        "networkAclsDefaultAction": {
            "value": "Allow"
        },
        "supportsHttpsTrafficOnly": {
            "value": true
        },
        "keyType": {
            "value": "Account"
        },
        "enabledValue": {
            "value": true
        },
        "accessTier": {
            "value": "Hot"
        },
        "isBlobSoftDeleteEnabled": {
            "value": false
        },
        "isdenyEncryptionScopeOverrideEnabled": {
            "value": false
        },
        
        "publicAccess": {
            "value": "None"
        },
        "containerName1": {
            "value": "$web"
        },
        "containerName2": {
            "value": "dummy"
        }

    }
    }





{
    
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
        //Defined which type of value parameter will accept from storageAccount.parameters.json(string/boolean)
        "parameters": {
        "storageAccounts_name": {
            "type": "String"
        },
        "location": {
            "type": "String"
        },
        "accountType": {
            "type": "string"
        },
        "tierType": {
            "type": "string"
        },
        "kind": {
            "type": "string"
        },
        "networkAclsBypass": {
            "type": "string"
        },
        "networkAclsDefaultAction": {
            "type": "string"
        },
        "supportsHttpsTrafficOnly": {
            "type": "bool"
        },
        
        "keyType": {
            "type": "string"
        },
        "enabledValue": {
            "type": "bool"
        },
        "accessTier": {
            "type": "string"
        },
         "isBlobSoftDeleteEnabled": {
            "type": "bool"
        },
        
        "isdenyEncryptionScopeOverrideEnabled": {
            "type": "bool"
        },
        "publicAccess": {
            "type": "string"
        },
        "containerName1": {
            "type": "string"
        },
        "containerName2": {
            "type": "string"
        }

    },
    "variables": {},
    "resources": [
        {
            // storage account creation in Azure Storage
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2021-02-01",
            "name": "[parameters('storageAccounts_name')]",
            "location": "[parameters('location')]",
            "sku": {
                "name": "[parameters('accountType')]",
                "tier": "[parameters('tierType')]"
            },
            "kind": "[parameters('kind')]",
            "properties": {
                "networkAcls": {
                    "bypass": "[parameters('networkAclsBypass')]",
                    "virtualNetworkRules": [],
                    "ipRules": [],
                    "defaultAction": "[parameters('networkAclsDefaultAction')]"
                },
                "supportsHttpsTrafficOnly": "[parameters('supportsHttpsTrafficOnly')]",
                "encryption": {
                    "services": {
                       
                        "blob": {
                            "keyType":"[parameters('keyType')]",
                            "enabled": "[parameters('enabledValue')]"
                        }
                    },
                    "keySource": "Microsoft.Storage"
                },
                "accessTier": "[parameters('accessTier')]"
            }
        },
        {
            //Blobservice creation in Storage Account of Azure
            "type": "Microsoft.Storage/storageAccounts/blobServices",
            "apiVersion": "2021-02-01",
            "name": "[concat(parameters('storageAccounts_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_name'))]"
            ],
            "sku": {
                "name": "[parameters('accountType')]",
                "tier": "[parameters('tierType')]"
            },
            "properties": {
                "cors": {
                    "corsRules": []
                },
                "deleteRetentionPolicy": {
                    "enabled": "[parameters('isBlobSoftDeleteEnabled')]"
                }
            }
        },
        {
            //container creates inside blobservice of storage account.
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2021-02-01",
            "name": "[concat(parameters('storageAccounts_name'), '/default/$web')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_name'))]"
            ],
            "properties": {
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": "[parameters('isdenyEncryptionScopeOverrideEnabled')]",
               
                "publicAccess": "[parameters('publicAccess')]"
            }
        },
        
        
        {
            //container creates inside blobservice of storage account.
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2021-02-01",
            "name": "[concat(parameters('storageAccounts_name'), '/default/dummy')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_name'))]"
            ],
            "properties": {
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": "[parameters('isdenyEncryptionScopeOverrideEnabled')]",
                "publicAccess": "[parameters('publicAccess')]"
            }
        
        }
    ]
}


- `az deployment group create --resource-group DevOps_Test --template-file storageAccount.json --parameters storageAccount.parameters.json`

______________________________________________________________________


## Task8:In Jenkins add a step to the pipeline Jenkinsfile created to publish the webpage to the Azure storage account

pipeline {
//Setting up the environment for Azure Auth.
    environment {
    registryCredential = 'docker-login'
    AZURE_SUBSCRIPTION_ID= credentials('subscriptionid')
    AZURE_TENANT_ID= credentials('tenantid')
    AZURE_STORAGE_ACCOUNT= credentials('myStorageAccount')
    }
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
            post {
        success {
          withCredentials([usernamePassword(credentialsId: 'azuresp', 
                          passwordVariable: 'AZURE_CLIENT_SECRET', 
                          usernameVariable: 'AZURE_CLIENT_ID')]) {
            sh '''
            
              ls
              # Login to Azure with ServicePrincipal
              az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID
			  
              # Set default subscription
              az account set --subscription $AZURE_SUBSCRIPTION_ID
			  
              # Execute upload to Azure
              az storage container create --account-name $AZURE_STORAGE_ACCOUNT --name $JOB_NAME --auth-mode login
              az storage blob upload-batch --destination ${JOB_NAME} --source target --auth-mode login
			  
              # Logout from Azure
              az logout
            '''
          }
        }
      }
        }
	// This stage builds Docker images from a Dockerfile
        stage('Building Dockerfile') {
            steps {
                script {
                    container = docker.build("kislay4/${env.JOB_BASE_NAME}")
                }
            }
        }
    // This stage will push the new created image to docker hub repository. 
      stage('Publish Image to Dockerhub') {
          steps {
              script {
                  docker.withRegistry( '', registryCredential ) {
            container.push('latest')
                  }
              }
            }    
        }
    }
}





______________________________________________________________________

## Task9:Build a basic HELM chart (from scratch) to publish your container (created in the earlier steps) into your MiniKube environment

- Usecase2 container tomcat one******************************

- helm create mychart
- helm install example ./mychart --set service.type=NodePort

- Get the application URL by running these commands:
  - export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services example-mychart)
  - export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  - echo http://$NODE_IP:$NODE_PORT
  
  - curl http://192.168.99.100:32511

- azureuser@devopstest:~$ kubectl get all -n default
- NAME                                  READY   STATUS    RESTARTS   AGE
- pod/example-mychart-b45d64746-8whg2   1/1     Running   0          102m

- NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
- service/example-mychart   NodePort    10.98.69.202   <none>        80:32511/TCP   102m
- service/kubernetes        ClusterIP   10.96.0.1      <none>        443/TCP        113m

- NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
- deployment.apps/example-mychart   1/1     1            1           102m

- NAME                                        DESIRED   CURRENT   READY   AGE
- replicaset.apps/example-mychart-b45d64746   1         1         1       102m


______________________________________________________________________

## Task10:Write a script in PowerShell or Bash that checks your pod is running in your MiniKube environment and prints out the Pod Name and Namespace.

- #!/bin/bash
- #User has to give the pod name as input
- echo "Enter name of pods you want to check"

- #Pod name to be stores in variable "name"
- read name

- #command to the status of pods
- kubectl  describe pods $name  | grep ^Status: | head -1 | awk '{print $1}{print $2}' | tr -d '\n'
- echo "  :--bashing into minikube is done "

- #storing pods status in "status" variable
- status=`kubectl  describe pods $name  | grep ^Status: | head -1 | awk '{print $2}' | tr -d '\n'`

- #storing name of pods in "Name" variable
- Name=`kubectl  describe pods $name  | grep ^Name: | head -1 | awk '{print $2}' | tr -d '\n'`

- #storing namespace in which pod is running in "Namespace" variable
- Namespace=`kubectl  describe pods $name  | grep ^Namespace: | head -1 | awk '{print $2}' | tr -d '\n'`

- if [ $status == "Running" ]
- then
  -   printf "Name:$Name \nNamespace:$Namespace\n"
- else
  -   echo "waiting for pods to be ready\n"
- fi


-----------------------------------------

- O/P:

- azureuser@devopstest:~$ kubectl get pods
- NAME                              READY   STATUS    RESTARTS   AGE
- example-mychart-b45d64746-tqwbr   1/1     Running   2          25h
- jenkins-0                         2/2     Running   3          24h
- azureuser@devopstest:~$ bash podscheck.sh
- Enter name of pods you want to check
- jenkins
- Status:Running  :--bashing into minikube is done
- Name:jenkins-0
- Namespace:default



______________________________________________________________________

## Task11:Write a readme file for this repo that provides information to build, test and deploy the web app created.

Sample Web App
====================
This repository contains sample web application. 

### Packaging Type
After Build step it will generate SampleWebApp-0.0.1-SNAPSHOT.war inside target folder

### Build
Run `mvn clean install` to build SampleWebApp.

### Test
Run `mvn test` to perform unit testing for SampleWebApp.

### Deploy
Run `mvn deploy` to deploy SampleWebApp.

### Screenshots for reference
![image](https://user-images.githubusercontent.com/24701958/105182139-b4945d00-5b52-11eb-8f51-5fa26091eb5d.png)
![image](https://user-images.githubusercontent.com/24701958/105182354-f1605400-5b52-11eb-9428-7dc6a7a20a36.png)

![image](https://user-images.githubusercontent.com/24701958/105182550-2a002d80-5b53-11eb-9505-733e5dc080ee.png)
![image](https://user-images.githubusercontent.com/24701958/105183039-bdd1f980-5b53-11eb-87f5-e113e5376cfc.png)








