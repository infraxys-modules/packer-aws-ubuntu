echo "packer_directory 2: $packer_directory"
run_aws_packer --packer_directory "$packer_directory" --ami_description "Ubuntu 18.04 AMI";

