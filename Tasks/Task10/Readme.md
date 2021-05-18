# Bash Script to checks pod is running in MiniKube environment.

- `#!/bin/bash`
- #User has to give the pod name as input
- `echo "Enter name of pods you want to check"`

- #Pod name to be stores in variable "name"
- `read name`

- #command to the status of pods
- `kubectl  describe pods $name  | grep ^Status: | head -1 | awk '{print $1}{print $2}' | tr -d '\n'`
- `echo "  :--bashing into minikube is done "`

- #storing pods status in "status" variable
- ``status=`kubectl  describe pods $name  | grep ^Status: | head -1 | awk '{print $2}' | tr -d '\n'``

- #storing name of pods in "Name" variable
- ``Name=`kubectl  describe pods $name  | grep ^Name: | head -1 | awk '{print $2}' | tr -d '\n'``

- #storing namespace in which pod is running in "Namespace" variable
- ``Namespace=`kubectl  describe pods $name  | grep ^Namespace: | head -1 | awk '{print $2}' | tr -d '\n'``

- `if [ $status == "Running" ]`
- `then`
  -   `printf "Name:$Name \nNamespace:$Namespace\n"`
- `else`
  -   `echo "waiting for pods to be ready\n"`
- `fi`


![image](https://user-images.githubusercontent.com/24701958/118659591-14ea9100-b80b-11eb-8061-f197e6cddc99.png)

![image](https://user-images.githubusercontent.com/24701958/118660125-87f40780-b80b-11eb-9229-182ec15dc28d.png)

