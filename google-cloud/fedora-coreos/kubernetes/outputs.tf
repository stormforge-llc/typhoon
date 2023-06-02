output "kubeconfig-admin" {
  value     = module.bootstrap.kubeconfig-admin
  sensitive = true
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

