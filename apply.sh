#!/bin/bash
set -e
git pull --rebase
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform apply run"
terraform apply -auto-approve
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform apply run"
git pull --rebase
git push
