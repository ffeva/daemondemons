#!/bin/bash
aws s3 cp s3://daemonndemons/ddKey.pem /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
cat >/root/.ssh/config <<_END
Host *
  StrictHostKeyChecking no
_END
chmod 600 /root/.ssh/config
