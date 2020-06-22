cd jenkinsjobs/
aws s3 cp s3://trio-s3-bucket/management/terraform.tfstate terraform.tfstate
terraform init
terraform plan
terraform apply -auto-approve
