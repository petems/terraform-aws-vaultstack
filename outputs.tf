output "primary_ssh_for_servers" {
  value = ["${module.primarycluster.ssh_for_consul_servers}"]
}
