data "google_compute_zones" "all" {
  region = var.region
}

locals {
  zones = data.google_compute_zones.all.names

  workers_ipv4_public = google_compute_instance_from_template.workers.*.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_instance_template" "worker" {
  name_prefix  = "${var.name}-worker-"
  description  = "${var.name} worker instance template"
  machine_type = var.machine_type

  metadata = {
    user-data = data.ct_config.worker.rendered
  }

  scheduling {
    provisioning_model = var.preemptible ? "SPOT" : "STANDARD"
    preemptible        = var.preemptible
    automatic_restart  = var.preemptible ? false : true
    # Spot instances with termination action DELETE cannot be used with MIGs
    instance_termination_action = var.preemptible ? "STOP" : null
  }

  disk {
    auto_delete  = true
    boot         = true
    source_image = data.google_compute_image.fedora-coreos.self_link
    disk_size_gb = var.disk_size
  }

  network_interface {
    network = var.network
    # Ephemeral external IP
    access_config {}
  }

  can_ip_forward = true
  tags           = ["worker", "${var.cluster_name}-worker", "${var.name}-worker"]

  guest_accelerator {
    count = var.accelerator_count
    type  = var.accelerator_type
  }

  lifecycle {
    ignore_changes = [
      disk[0].source_image
    ]
    # To update an Instance Template, Terraform should replace the existing resource
    create_before_destroy = true
  }
}

resource "google_compute_instance_from_template" "workers" {
  count = var.worker_count

  name = "${var.cluster_name}-worker-${count.index}"
  # use a zone in the region and wrap around (e.g. controllers > zones)
  zone         = element(local.zones, count.index)
  source_instance_template = google_compute_instance_template.worker.self_link
}

# Fedora CoreOS worker
data "ct_config" "worker" {
  content = templatefile("${path.module}/butane/worker.yaml", {
    kubeconfig             = indent(10, var.kubeconfig)
    ssh_authorized_key     = var.ssh_authorized_key
    cluster_dns_service_ip = cidrhost(var.service_cidr, 10)
    cluster_domain_suffix  = var.cluster_domain_suffix
    node_labels            = join(",", var.node_labels)
    node_taints            = join(",", var.node_taints)
  })
  strict   = true
  snippets = var.snippets
}
