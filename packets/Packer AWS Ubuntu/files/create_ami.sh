#!/usr/bin/env bash

set -eo pipefail;

run_aws_packer --packer_directory "$packer_directory" --ami_description "Ubuntu 18.04 AMI";

