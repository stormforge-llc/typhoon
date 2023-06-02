resource "google_dns_record_set" "apiserver" {
  managed_zone = var.dns_zone_name
  name = format("%s.%s.", var.cluster_name, var.dns_zone)
  type = "A"
  ttl  = 300
  rrdatas = google_compute_instance.controllers.*.network_interface.0.access_config.0.nat_ip
}

resource "google_dns_record_set" "worker" {
  managed_zone = var.dns_zone_name
  name = format("%s-workers.%s.", var.cluster_name, var.dns_zone)
  type = "A"
  ttl  = 300
  rrdatas = module.workers.workers_external_ipv4_addresses
}
