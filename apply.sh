#!/bin/bash
git pull --rebase
terraform apply -auto-approve
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform apply run"
git pull --rebase
git push
