# Daemon Demons

Daemon Demons repo contains Terraform code that builds AWS infrastructure, Jenkins (provisioned from an ansible playbook) in an EC2 Instance and an RDS instance.

It also contains an Ansible Playbook code that builds a K8 cluster within AWS and a private Docker Registry. It also builds a pipeline Jenkins job code that builds three apps: spring-petclinic, a static httpd webserver, and wordpress.

This code does not connect the apps to the RDS database.

## Pre-requisites

- Personal forked copy of the [github repo](https://github.com/ffeva/daemondemons.git).
- A github personal access token of scope admin:repo-hook with read and write access
- An AWS cloud account and credentials
- An S3 bucket with public access in AWS

## Choose your initial credentials

- Before building the infrastructure and the whole system, you have 2 options to run the code and have authentification rights: (1) to copy the public key details from the S3 bucket and secure the permissions of the key file locally on your device or (2) generate a new key-pair
- (1) Running the following code will copy the public key details from S3 bucket and reset permissions of the file where it is saved

```bash
chmod +x getKeyDetails.sh
./getKeyDetails.sh
```

- (2) Generate new ssh key with secured permissions already set using the Terraform code from the repo
- Edit the setvariables.sh script in order to set the AWS profile and region where you want to build the system.

```bash
chmod +x infrastructure/scripts/setvariables.sh
./infrastructure/scripts/setvariables.sh
cd /sshkey
terraform init
terraform plan
terraform apply -auto-approve
```

- To delete the key:

``` bash
terrafform destroy -yes
```

## Building AWS infrastructure, RDS and Jenkins

- Edit your AWS profile variables in the setvariables.sh script.
- Edit your infrastructure variables in variables.tf (RDS elements variables) and vars.tfvars files - make sure the S3 bucket name and SSH Key pair name matches the one you have pre-built in AWS

- In the terminal run:

```bash
chmod +x setvariables.sh
./setvariables.sh
terraform init
terraform plan -var-file=vars.tfvars
terraform apply -auto-approve -var-file=vars.tfvars
```

## A private docker registry with a DNS name
- This is an optional step! You can build your own private Docker Registry from scratch using the DockerRegistry ansible playbook from our repo or you can use the already built one on AWS (region = 'eu-west-2', profile = 'academy2'). If you choose to opt for the 2nd option than you can skip these steps
- This module allows you to supply your own ansible environment, which can be a completely separate directory in your own GIT repository. Set the ANSIBLEENV environment variable on your operating system to the location of your own environment. To create the correct environment for your own revision make sure you copy the environments/prod directory and then make your changes.
- It requires your AWS_DEFAULT_PROFILE, ANSIBLEENV environment variables to be set as well as an SSH private key filename (with path) (see example in setvariables.sh)

- You must change variables in the environments/prod/group_vars/all to set your region, VPCs, etc and your SSH public key in AWS environment.
- The private key is supplied as an argument to the create or delete scripts.
- The commands:
    - create - will create the Docker Registry and includes creating the instance, allocating an EIP to it, giving it a DNS name and provisioning it
    - delete - will delete the entire docker registry and all associated elements, including DNS records

- Create the DockerRegistry:

```bash
cd /DockerRegistry
chmod +x setvariables.sh
./setvariables.sh
chmod +x create
./create ~/your/ssh/private/key  
```
- Clean up: remove the DockerRegistry:

```bash
cd /DockerRegistry
chmod +x setvariables.sh
./setvariables.sh
chmod +x delete
./delete ~/your/ssh/private/key  
```

## Building the K8 cluster
- To create the correct environment for your own revision make sure you copy the environments/dev directory and then make your changes.
- It requires your AWS_DEFAULT_PROFILE, ANSIBLEENV environment variables to be set as well as an SSH private key filename (with path) (see example in setvariables.sh)

- You must change variables in the environments/dev/group_vars/all to set your region, VPCs, etc and your SSH public key in AWS environment. You should change these variables with the elements built in the infrastructure code. In this case the variables used are in dd/k8sClusterAdditions/environments/dev but you can set variables in dd/k8sClusterAdditions/environments/qa or in any directory.
- The private key is supplied as an argument to the create or destroyme scripts.
- The commands:
    - create - will create the Kubernetes Cluster and includes creating the controller and the 3 nodes, allocating EIPs to the controller and the master node, giving them DNS names and provisioning the whole cluster. It also builds an ELB.
    - destroyme - will delete the entire Kubernetes Cluster and all associated elements, including DNS records
    - runbook - will run one of the yaml files
    - the code is cloned from https://github.com/stevshil/ansible.git and slight changes were made for the ec2 role(in order to allocate EIPs to the controller and the master node); for more details on running the commands check the repository README.md file

- Create the Kubernetes Cluster :

```bash
cd /ansible/K8sCluster
chmod +x setvariables.sh
./setvariables.sh
chmod +x create
./create ~/your/ssh/private/key  
```
- Clean up: remove the Kubernetes Cluster:

```bash
cd /DockerRegistry
chmod +x setvariables.sh
./setvariables.sh
chmod +x destroyme
./destroyme ~/your/ssh/private/key  
```

- Once your cluster is built, edit the security group rules to allow all ports and all traffic access to the k8s cluster IPs. If you created a new Docker Registry allow all ports and all traffic access to its private IP as well.
- SSH into each node and run setkubeconfig.sh to copy the kube config into the home directory to enable the kubectl commands
- If you want to create users run the /k8sClusterAdditions/setusers.sh code after you ssh into the controller. Give user a name (=username). Then ssh into each of the node and run the /k8sClusterAdditions/user_kubeconfig.sh script to enable the kubectl commands to the users.

- add the daemon.json file into each node (worker1, worker2, master) in order to be able to access the Docker Registry. If you built a new docker registry you should modify the registry domain with the new one

```bash
sudo echo etc/docker/daemon.json > dd/k8sClusterAdditions/daemon.json
service docker restart
```

## Configure Jenkins

SHH into Jenkins then run:
```bash
sudo nano etc/docker/daemon.json
```
Add:
```bash
{
        "insecure-registries":
        [
                "172.31.0.0:5000",
                "dd-dockerreg.academy.grads.al-labs.co.uk:5000"
        ]
}
```

Access Jenkins at IP:8080 with the username: admin and password: secret123.

### Create credentials

Create the following Jenkins credentials:

- A gobal jenkins credential of kind ‘username with password’. The username should be your github username and the password should be your github personal access token.

- A gobal jenkins credential of kind 'Kubernetes configuration (kubeconfig)'. Give it an ID name and description. Choose the ‘enter directly’ kubeconfig option and paste your .kube/config file contents. To find these contents SSH into the controller:

```bash
cat ~/.kube/config
```

### Configure jenkins access to the github repo
- Under configure system, add a github server.
- Give it a name.
- Add a jenkins credential of kind ’secret text’.
- Paste your personal access token and write an ID and description.
- Select your secret from the dropdown.
- Ensure the ‘MANAGE HOOKS’ checkbox is checked.
- Save.

## Building the Pipeline

### Change Jenkinsfile variables
- Edit the three Jenkinsfiles.
- Edit the 'DOCKER_IMAGE_NAME' variable with your docker registry DNS name.
- Edit the 'KUBE_CONTROLLER_IP' variable with the host name set by your ingress rule for each canary deployment.

### Add Jenkin Jobs

- Add a multi branch pipeline job for each app.
- Under branch sources, create a Github branch source by selecting your github credentials from the drop down.
- Click ‘Repository Scan’ and in 'Owner', type in your Github username.
- Select the repo from the Repository dropdown.
- Remove the ‘Discover pull requests from origin’ and ‘discover pull requests from forks’  behaviours.
- Set the Build Configuration script path to the directory path of each app Jenkinsfile.
- Adjust triggers (optional).
- Save.
