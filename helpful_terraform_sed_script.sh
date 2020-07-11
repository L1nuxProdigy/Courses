#!/bin/bash
echo "This program requires 2 arguments"
echo "1. path to the tf file you want to alter"

if [ -z "$1" ]
then
    echo "You did not specified a path."
    echo "Terminating"
    exit
fi

tf_file=$(ls $1 | grep .tf$)
echo $1/$tf_file

sed -i 's/variable "vpc_id_main" {default = ""}/variable "vpc_id_main" {default = "DESIRED_VPC_ID"}/g' $1/$tf_file
sed -i 's/variable "subnet_id_main" {default = ""}/variable "subnet_id_main" {default = "DESIRED_MAIN_SUBNET"}/g' $1/$tf_file
sed -i 's/variable "subnet_secondary" {default = ""}/variable "subnet_secondary" {default = "DESIRED_SECOND_SUBNET"}/g' $1/$tf_file
sed -i 's/variable "aws_keypair_name" {default = ""}/variable "aws_keypair_name" {default = "DESIRED_KEY"}/g' $1/$tf_file
sed -i 's/IP_TO_ENTER/THE_ACTUAL_IP/g' $1/$tf_file