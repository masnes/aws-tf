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
    exit 1
  ;;
esac

git pull --rebase
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "pre terraform $cmd"
terraform "$cmd" -auto-approve
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform $cmd run"
git pull --rebase
git push
