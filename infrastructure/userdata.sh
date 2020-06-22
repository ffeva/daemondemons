#!/bin/bash -xv

yum -y install git python-pip
pip install ansible
aws s3 cp s3://trio-s3-bucket/ddKey.pem /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
cat >/root/.ssh/config <<_END
Host *
  StrictHostKeyChecking no
_END
chmod 600 /root/.ssh/config
cd /root
git clone git@bitbucket.org:FFot/dd.git
cd dd
git checkout silviana
cd git-jenkins
ansible-playbook -i environments/local localcreate.yml
