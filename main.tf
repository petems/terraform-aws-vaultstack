// If you wish to create the tls_root_certs, you can fetch the data from the local directory
data "terraform_remote_state" "tls_terraform_certs" {
  backend = "local"

  config {
    path = "${path.module}/tls_certificates/terraform.tfstate"
  }
}

// If you've created them outside of Terraform: - WIP
// data "local_file" "cert" {
//   filename = "${path.module}/tls.cert"
// }

provider "aws" {
  version = ">= 1.20.0"
  region  = "${var.primary_region}"
}

module "primarycluster" {
  source = "./modules"

  owner                = "${var.owner}"
  region               = "${var.primary_region}"
  public_key           = "${var.public_key}"
  consul_servers              = "${var.consul_servers}"
  vault_servers              = "${var.vault_servers}"
  consul_url           = "${var.consul_url}"
  vault_url            = "${var.vault_url}"
  created-by           = "${var.created-by}"
  sleep-at-night       = "${var.sleep-at-night}"
  TTL                  = "${var.TTL}"
  vpc_cidr_block       = "${var.vpc_cidr_block}"
  cidr_blocks          = "${var.cidr_blocks}"
  instance_type_server = "${var.instance_type_server}"

  ca_key_algorithm    = "${data.terraform_remote_state.tls_terraform_certs.ca_key_algorithm}"
  ca_private_key_pem  = "${data.terraform_remote_state.tls_terraform_certs.ca_private_key_pem}"
  ca_cert_pem         = "${data.terraform_remote_state.tls_terraform_certs.ca_cert_pem}"

  // If creating outside of Terraform - WIP
  // ca_key_algorithm    = "${data.local_file.cert.ca_key_algorithm}"
  // ca_private_key_pem  = "${data.local_file.cert.ca_private_key_pem}"
  // ca_cert_pem         = "${data.local_file.cert.ca_cert_pem}"

}
