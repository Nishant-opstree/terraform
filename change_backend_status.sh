#!/bin/bash

infrastructure_branch="$1"
backend_status=`cat backend_status | awk '/s3_backend_configured/{print $2}'`
if [ "$backend_status" == false ]
then
	terraform init
	terraform apply -auto-approve
	sudo rm terraform_backend_setup.tf
	sed -i "/s3_backend_configured/s/false/true/" backend_status
	backend_data="""terraform {\n
    backend "s3"  {\n
        bucket = "nishant-terraform-state-bucket-test"\n
	key            = "global/s3/terraform.tfstate"\n
        region         = "ap-south-2"\n
    }\n
}\n
	"""
	echo -e "$backend_data" | cat - main.tf > temp && mv temp main.tf
	rm terraform.*
	git add .
	git push origin test_master

fi
git checkout "$infrastructure_branch"
git checkout test_master
git merge "$infrastructure_branch"
