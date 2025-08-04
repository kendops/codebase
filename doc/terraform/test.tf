### c1-versions.tf
# Terraform Block
terraform {
required_version = ">= 1.6" # which means any version equal & above
0.14 like 0.15, 0.16 etc and < 1.xx
required_providers {
aws = {
source = "hashicorp/aws"
version = ">= 5.0"
}

null = {
source = "hashicorp/null"
version = "~> 3.0"
}

}
}

# Provider Block
provider "aws" {
region = var.aws_region
profile = "default"
}
/*
Note-1: AWS Credentials Profile (profile = "default") configured on your local desktop terminal
$HOME/.aws/credentials
*/



### c2-generic-variables.tf
# Input Variables
# AWS Region
variable "aws_region" {
description = "Region in which AWS Resources to be created"
type = string
default = "us-east-1"
}
# Environment Variable
variable "environment" {
description = "Environment Variable used as a prefix"
type = string
default = "dev"
}
 
# Business Division
variable "business_divsion" {
	description = "Business Division in the large organization this Infrastructure belongs"
type = string
default = "SAP"
}



### c3-local-values.tf
# Define Local Values in Terraform
locals {
owners = var.business_divsion
environment = var.environment
name = "${var.business_divsion}-${var.environment}"
#name = "${local.owners}-${local.environment}"
common_tags = {
owners = local.owners
environment = local.environment
}
}

