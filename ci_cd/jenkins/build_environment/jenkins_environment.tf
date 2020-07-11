##################################################################################
# VARIABLES
##################################################################################

### AMI Vars ###
variable "ubuntu_image_18-04" {default = "ami-0d359437d1756caa8"}

### VPC Vars ###
variable "vpc_id_main" {default = ""}
variable "subnet_id_main" {default = ""}
variable "subnet_secondary" {default = ""}

### Machine Vars ###
variable "aws_keypair_name" {default = ""}
variable "machine_type" {default = "t2.medium"}

### Machines Configurations Scripts ###
variable "jenkins_master" {}
variable "jenkins_node_1" {}

### Miscellaneous ###
variable "created_by_tag" {default = "l1nuxprodigy"}
variable "deployment_method_tag" {default = "Terraform"}
variable "description_tag" {default = "Simple Jenkins Environment"}

##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
	region     = "eu-central-1"
	profile    = "default"
}

##################################################################################
# SECURITY GROUPS
##################################################################################

data "aws_vpc" "vpc_id_main" {
  id = var.vpc_id_main
}

resource "aws_security_group" "JENKINS_MASTER_SG" {
	name        = "${var.description_tag} LAB"
	description = "${var.description_tag} LAB"
	vpc_id      = var.vpc_id_main


	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "TCP"
		cidr_blocks = ["IP_TO_ENTER/32"]
		description = "HTTPS"
	}
	ingress {
		from_port       = 8080
		to_port         = 8080
		protocol        = "TCP"
		cidr_blocks     = [data.aws_vpc.vpc_id_main.cidr_block,"IP_TO_ENTER/32"]
		description     = "HTTP"
	}
	  
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
	
	tags = {
		CreatedBy        = var.created_by_tag
		DeploymentMethod = var.deployment_method_tag
		Description      = var.description_tag
	}
}

resource "aws_security_group" "JENKINS_SLAVE_SG" {
	name        = "${var.description_tag} Remote Machine"
	description = "${var.description_tag} Remote Machine"
	vpc_id      = var.vpc_id_main


	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "TCP"
		cidr_blocks = ["IP_TO_ENTER/32"]
		description = "HTTPS"
	}
	  
	egress {
		from_port       = 0
		to_port         = 0
		protocol        = "-1"
		cidr_blocks     = ["0.0.0.0/0"]
	}
	
	tags = {
		CreatedBy        = var.created_by_tag
		DeploymentMethod = var.deployment_method_tag
		Description      = var.description_tag
	}
}

##################################################################################
# EC2 Resources
##################################################################################

resource "aws_instance" "JENKINS_MASTER" {
	ami                    = var.ubuntu_image_18-04
	instance_type          = var.machine_type
	key_name               = var.aws_keypair_name
	subnet_id              = var.subnet_id_main
	vpc_security_group_ids = [aws_security_group.JENKINS_MASTER_SG.id]

	tags = {
		Name             = "Jenkins Master"
		OS               = "Ubuntu 18.04"
		CreatedBy        = var.created_by_tag
		DeploymentMethod = var.deployment_method_tag
		Description      = var.description_tag
	}
	
	user_data = file(var.jenkins_master)
}

resource "aws_instance" "JENKINS_SLAVE_1" {
	ami                    = var.ubuntu_image_18-04
	instance_type          = var.machine_type
	key_name               = var.aws_keypair_name
	subnet_id              = var.subnet_id_main
	vpc_security_group_ids = [aws_security_group.JENKINS_SLAVE_SG.id]

	tags = {
		Name             = "Jenkins Node 1"
		OS               = "Ubuntu 18.04"
		CreatedBy        = var.created_by_tag
		DeploymentMethod = var.deployment_method_tag
		Description      = var.description_tag
	}
	
	user_data = file(var.jenkins_node_1)
}

##################################################################################
# OUTPUT
##################################################################################

output "SSH_JENKINS_MASTER" {
	value = ["ssh -i ~/.ssh/${var.aws_keypair_name}.pem ubuntu@${aws_instance.JENKINS_MASTER.public_ip}", "its ID is: ${aws_instance.JENKINS_MASTER.id}"]
}

output "SSH_REMOTE_MACHINE" {
	value = ["ssh -i ~/.ssh/${var.aws_keypair_name}.pem ubuntu@${aws_instance.JENKINS_SLAVE_1.public_ip}"]
}
