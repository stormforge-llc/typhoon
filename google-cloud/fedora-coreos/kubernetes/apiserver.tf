resource "google_dns_record_set" "apiserver" {
  managed_zone = var.dns_zone_name
  name = format("%s.%s.", var.cluster_name, var.dns_zone)
  type = "A"
  ttl  = 300
  rrdatas = google_compute_instance.controllers.*.network_interface.0.access_config.0.nat_ip
}
