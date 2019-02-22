data "template_file" "consul_server_template" {
  count = "${var.consul_servers}"

  template = "${join("\n", list(
    file("${path.module}/templates/shared/base.sh"),
    file("${path.module}/templates/server/consul_server.sh"),
    file("${path.module}/templates/shared/cleanup.sh"),
  ))}"

  vars {
    region = "${var.region}"

    kmskey        = "${aws_kms_key.vaultstackVaultKeys.id}"
    node_name     = "${var.namespace}-server-${count.index}"

    me_ca   = "${var.ca_cert_pem}"
    me_cert = "${element(tls_locally_signed_cert.consul_servers.*.cert_pem, count.index)}"
    me_key  = "${element(tls_private_key.consul_servers.*.private_key_pem, count.index)}"

    # Consul
    consul_url            = "${var.consul_url}"
    consul_gossip_key     = "${base64encode(random_id.consul_gossip_key.hex)}"
    consul_join_tag_key   = "ConsulJoin"
    consul_join_tag_value = "${local.consul_join_tag_value}"
    consul_master_token   = "${random_id.consul_master_token.hex}"
    consul_servers        = "${var.consul_servers}"
  }
}

# Gzip cloud-init config
data "template_cloudinit_config" "consul_cloudinit" {
  count = "${var.consul_servers}"

  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${element(data.template_file.consul_server_template.*.rendered, count.index)}"
  }
}

# Create the Consul cluster
resource "aws_instance" "consul_server" {
  count = "${var.consul_servers}"

  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type_server}"
  key_name      = "${aws_key_pair.vaultstack.id}"

  subnet_id              = "${element(aws_subnet.vaultstack.*.id, count.index)}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.vaultstack.id}"]

  tags {
    Name           = "${var.namespace}-server-${count.index}"
    owner          = "${var.owner}"
    created-by     = "${var.created-by}"
    sleep-at-night = "${var.sleep-at-night}"
    TTL            = "${var.TTL}"
    ConsulJoin     = "${local.consul_join_tag_value}"
  }

  user_data = "${element(data.template_cloudinit_config.consul_cloudinit.*.rendered, count.index)}"
}
