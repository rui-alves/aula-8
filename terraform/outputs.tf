output "vm_ip" {
  value = google_compute_instance.vm_ubuntu.network_interface[0].access_config[0].nat_ip
}
