#!/bin/bash
set -ex

usage() {
  echo $0 "[apply|destroy]"
}


case $1 in
  apply)
    cmd="apply"
  ;;
  destroy)
    cmd="destroy"
  ;;
  *)
    usage
  ;;
esac

git pull --rebase
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform apply run"
terraform apply -auto-approve
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform apply run"
git pull --rebase
git push
