## Public Helm chart to deploy the Jenkins Chart onto the MiniKube instance.
- `helm install jenkins stable/jenkins`

- NAME: jenkins
- LAST DEPLOYED: Mon May 17 03:49:55 2021
- NAMESPACE: default
- STATUS: deployed
- REVISION: 1
- NOTES:
1. Get your 'admin' user password by running:
  printf $(kubectl get secret --namespace default jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
2. Get the Jenkins URL to visit by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=jenkins" -o jsonpath="{.items[0].metadata.name}")
  echo http://127.0.0.1:8080
  kubectl --namespace default port-forward $POD_NAME 8080:8080

3. Login with the password from step 1 and the username: admin

4. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http:///configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos


- `azureuser@devopstest:~$ export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=jenkins" -o jsonpath="{.items[0].metadata.name}")`
- `azureuser@devopstest:~$  kubectl --namespace default port-forward $POD_NAME 8080:8080`
- `Forwarding from 127.0.0.1:8080 -> 8080`
- `Forwarding from [::1]:8080 -> 8080`
- `Handling connection for 8080`

![image](https://user-images.githubusercontent.com/24701958/118648878-7d804080-b800-11eb-86ac-9ccde98fa9d0.png)

