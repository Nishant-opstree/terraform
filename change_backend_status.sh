#!/bin/bash

infrastructure_branch="$1"
backend_status=`cat backend_status | awk '/s3_backend_configured/{print $2}'`
if [ "$backend_status" == false ]
then
	terraform init
	terraform apply -auto-approve
	sudo rm terraform_backend_setup.tf
	sed -i "/s3_backend_configured/s/false/true/" backend_status
	backend_data='''terraform {
    backend "s3"  {
        bucket = "nishant-terraform-state-bucket-test-6"
		key    = "global/s3/terraform.tfstate"
        region = "ap-south-1"
    }
}
	'''
	echo -e "$backend_data" | cat - main.tf > temp && mv temp main.tf
	echo ".terraform/*" > .gitignore
	echo "terraform.*" >> .gitignore
	git add .
	git commit -m "upload"
	git push origin test_master

fi
git checkout "$infrastructure_branch"
git checkout test_master
git merge "$infrastructure_branch"
