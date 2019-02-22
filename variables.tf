variable "namespace" {
  default = "vaultstack"
}

variable "hostname" {
  description = "VM hostname. Used for local hostname, DNS, and storage-related names."
  default     = "vaultstack"
}

variable "region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}

variable "primary_region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}

variable "secondary_region" {
  description = "The region to create resources."
  default     = "eu-west-2"
}

variable "consul_servers" {
  description = "The number of consul servers."
  default     = "5"
}

variable "vault_servers" {
  description = "The number of vault servers."
  default     = "3"
}

variable "total_servers" {
  description = "The number of vault servers."
  default     = "8"
}

variable "consul_url" {
  description = "The url to download Consul."
  default     = "https://releases.hashicorp.com/consul/1.4.2/consul_1.4.2_linux_amd64.zip"
}

variable "vault_url" {
  description = "The url to download vault."
  default     = "https://releases.hashicorp.com/vault/1.0.3/vault_1.0.3_linux_amd64.zip"
}

variable "owner" {
  description = "IAM user responsible for lifecycle of cloud resources used for training"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
  default     = "Terraform"
}

variable "sleep-at-night" {
  description = "Tag used by reaper to identify resources that can be shutdown at night"
  default     = true
}

variable "TTL" {
  description = "Hours after which resource expires, used by reaper. Do not use any unit. -1 is infinite."
  default     = "240"
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "instance_type_server" {
  description = "The type(size) of data servers (consul, vault, etc)."
  default     = "r4.large"
}
