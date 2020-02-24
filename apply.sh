#!/bin/bash
set -e

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

set -x
git pull --rebase
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "pre terraform $cmd"
terraform "$cmd" -auto-approve
git add ./terraform.tfstate ./simple-aws.tf
git commit -m "terraform $cmd run"
git pull --rebase
git push
