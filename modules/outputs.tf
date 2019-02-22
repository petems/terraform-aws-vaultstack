output "ssh_for_consul_servers" {
  value = "${formatlist("ssh ubuntu@%s", aws_instance.consul_server.*.public_dns,)}"
}

output "vpc_id" {
  value = "${aws_vpc.vaultstack.id}"
}
