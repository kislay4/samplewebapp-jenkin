## HELM chart to publish container (created earlier) into MiniKube environment.

- `helm create mychart`
- `helm install example ./mychart --set service.type=NodePort`

- Get the application URL by running these commands:
  - export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services example-mychart)
  - export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  - echo http://$NODE_IP:$NODE_PORT
  
![image](https://user-images.githubusercontent.com/24701958/118665921-5fbad780-b810-11eb-8870-95221ed2cb92.png)
![image](https://user-images.githubusercontent.com/24701958/118666740-07380a00-b811-11eb-8c77-2d2532de63c6.png)
![image](https://user-images.githubusercontent.com/24701958/118667006-3fd7e380-b811-11eb-9ea6-a5e754f5a404.png)



