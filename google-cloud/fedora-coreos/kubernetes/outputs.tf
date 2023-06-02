output "kubeconfig-admin" {
  value     = module.bootstrap.kubeconfig-admin
  sensitive = true
}
output "kubeconfig-admin-ca-cert" {
  value = module.bootstrap.kubeconfig-admin-ca-cert
}
output "kubeconfig-admin-kubelet-cert" {
  value = module.bootstrap.kubeconfig-admin-kubelet-cert
  sensitive = true
}
output "kubeconfig-admin-kubelet-key" {
  value = module.bootstrap.kubeconfig-admin-kubelet-key
  sensitive = true
}
output "kubeconfig-admin-server" {
  value = module.bootstrap.kubeconfig-admin-server
}

# Outputs for worker pools

output "network_name" {
  value = google_compute_network.network.name
}

output "kubeconfig" {
  value     = module.bootstrap.kubeconfig-kubelet
  sensitive = true
}

# Outputs for custom firewalling

output "network_self_link" {
  value = google_compute_network.network.self_link
}

# Outputs for load balancing

output "worker_ips" {
  description = "Worker external IPv4 addresses"
  value       = module.workers.workers_external_ipv4_addresses
}

# Outputs for debug

output "assets_dist" {
  value     = module.bootstrap.assets_dist
  sensitive = true
}

