## HELM chart to publish container (created earlier) into MiniKube environment.

### Helm Chart for my image kislay4/usecase1 where sample-web-app is deployed inside tomcat.
- `helm create sample-web-app`

![image](https://user-images.githubusercontent.com/24701958/118752668-2a9a9d80-b881-11eb-9daf-d9ced722c195.png)
![image](https://user-images.githubusercontent.com/24701958/118753022-bf9d9680-b881-11eb-90ac-466cc58bd121.png)

- `helm install tomcat ./sample-web-app`

![image](https://user-images.githubusercontent.com/24701958/118752206-49e4fb00-b880-11eb-9b8d-7c110d7bf26d.png)
![image](https://user-images.githubusercontent.com/24701958/118752402-a8aa7480-b880-11eb-9b72-de04cdb712d2.png)


### Helm Chart for Nginix
 
 - `helm create mychart`

 - `helm install example ./mychart --set service.type=NodePort`

- Get the application URL by running these commands:
  - export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services example-mychart)
  - export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
  - echo http://$NODE_IP:$NODE_PORT


![image](https://user-images.githubusercontent.com/24701958/118665921-5fbad780-b810-11eb-8870-95221ed2cb92.png)
![image](https://user-images.githubusercontent.com/24701958/118666740-07380a00-b811-11eb-8c77-2d2532de63c6.png)
![image](https://user-images.githubusercontent.com/24701958/118667006-3fd7e380-b811-11eb-9ea6-a5e754f5a404.png)



