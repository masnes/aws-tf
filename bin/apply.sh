#!/bin/bash
set -e

usage() {
  echo $0 "[apply|destroy]"
}


case $1 in
  a*)
    cmd="apply"
  ;;
  d*)
    cmd="destroy"
  ;;
  *)
    usage
    exit 1
  ;;
esac

set -x
git add terraform.tfstate simple-aws.tf
git commit -m "pre terraform $cmd" || true
set +e
git stash push
git pull --rebase
git stash pop
set -e
terraform "$cmd" -auto-approve
git add terraform.tfstate simple-aws.tf
git commit -m "terraform $cmd run" || true
set +e
git stash push
git pull --rebase
git stash pop
set -e
git push
