# Application Installation
This folder contains scenrio and its installation process.

## Prerequisites
- A system running Ubuntu 18.04 Bionic Beaver or Ubuntu 20.04
- A user account with sudo privileges

## Minikube Installation on Ubuntu 18.02
### Steps To Install
- Update System and Install Required Packages
- Before installing any software, you need to update and upgrade the system you are working on. To do so, run the commands:
- `sudo apt-get update -y`
- `sudo apt-get upgrade -y`
- `sudo apt-get install apt-transport-https`

-  To install VirtualBox on Ubuntu, run the command:
  - `sudo apt install virtualbox virtualbox-ext-pack`

- Install Minikube
With VirtualBox set up, move on to installing Minikube on your Ubuntu system.
- First, download the latest Minikube using the curl command:
- `curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb`

- Install with dpkg
- `sudo dpkg -i minikube_latest_amd64.deb`
- Finally, verify you have successfully installed Minikube by checking the version of the software:
- `minikube version`

- The output should display the version number of the software as below:

- `azureuser@devopstest:~$ minikube version
minikube version: v1.19.0
commit: 15cede53bdc5fe242228853e737333b09d4336b5`

## Kubectl Installation on Ubuntu 18.02
### Steps To Install
- To deploy and manage clusters, you need to install kubectl, the official command-line tool for Kubernetes
- Download kubectl with the following command:
- `curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl`


-  Make the binary executable by typing:
  - chmod +x ./kubectl

- Then, move the binary into your path with the command:
- `sudo mv ./kubectl /usr/local/bin/kubectl`

- Verify the installation by checking the version of your kubectl instance:

- `azureuser@devopstest:~$ kubectl version --short
Client Version: v1.21.0
Server Version: v1.20.2
`
## Helm 3 Installation on Ubuntu 18.02
### Prerequisites
- A running Kubernetes cluster.
- The Kubernetes cluster API endpoint should be reachable from the machine you are running helm.
- Authenticate the cluster using kubectl and it should have cluster-admin permissions.
### Steps To Install
- Download the latest helm 3 installation script.
- `curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3`

-  Add execute permissions to the downloaded script.
  - `chmod 700 get_helm.sh`

- Execute the installation script.
- `./get_helm.sh`

- Validate helm installtion by executing the helm command.

- `azureuser@devopstest:~$ helm version
version.BuildInfo{Version:"v3.5.4", GitCommit:"1b5edb69df3d3a08df77c9902dc17af864ff05d1", GitTreeState:"clean", GoVersion:"go1.15.11"}`


## Docker Installation on Ubuntu 18.02
### Prerequisites
- One Ubuntu 18.04 server set up by following the Ubuntu 18.04 initial server setup guide, including a sudo non-root user and a firewall.
- An account on Docker Hub if you wish to create your own images and push them to Docker Hub.
### Steps To Install
- First, update your existing list of packages::
- `sudo apt update`
- Next, install a few prerequisite packages which let apt use packages over HTTPS:

- `sudo apt install apt-transport-https ca-certificates curl software-properties-common`
- Then add the GPG key for the official Docker repository to your system:

- `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
- Add the Docker repository to APT sources:
- `sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"`
- Next, update the package database with the Docker packages from the newly added repo:
- `sudo apt update`

- Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:

- `apt-cache policy docker-ce`

- Finally, install Docker:
- `sudo apt install docker-ce`

- The output should display the version number of the software as below:

- `azureuser@devopstest:~$ docker -v
Docker version 20.10.6, build 370c289`