provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "vm_ubuntu" {
  name         = "avaliacao-aula-8"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Configuração de IP externo
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa_github.pub")}"
  }
}

resource "google_compute_firewall" "allow_http_inbound" {
  name    = "allow-http-in"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
}